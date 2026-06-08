#!/usr/bin/env node
// Export a Slidev deck to a complete, non-blank PDF by automating Slidev's BROWSER
// exporter — the same `/export` page you reach manually via `pnpm dev` → open /export →
// print. We drive it headlessly so the deploy can do it unattended.
//
//   node scripts/export-pdf.mjs <deckFile> <outputPdf> [--with-clicks]
//
// Why not `slidev export` / `slidev build --download`? Both use Slidev's CLI exporter,
// which renders every slide into ONE giant browser surface (height = slideHeight × N) and
// prints once. On this workspace's larger decks that surface is clipped by Chromium and the
// capture races the SPA render — so the PDF comes out truncated or entirely blank (verified
// by size/pixels, not page count: a 106-page PDF can be 106 blank pages at ~30 KB).
//
// The `/export` page instead lays out each slide as its own print block and relies on the
// browser's NATIVE print pagination (no single-surface limit). Playwright's `page.pdf()` is
// the programmatic form of that same print path, so it reproduces the good manual result.
//
// `/export` only exists on the dev server (config `browserExporter` defaults to "dev"), so
// this script spins up a dev server, drives it, and tears it down.

import { spawn } from 'node:child_process'
import { once } from 'node:events'
import http from 'node:http'
import net from 'node:net'
import { chromium } from 'playwright-chromium'

// Slidev's dev server binds to `localhost`, which on this machine resolves to IPv6 ::1
// before IPv4 127.0.0.1. Use the hostname everywhere so Node and Chromium resolve to
// whichever interface the server actually bound (the IPv6 dev-server gotcha).
const HOST = 'localhost'

const [, , deckFile, outputPdf, ...rest] = process.argv
if (!deckFile || !outputPdf) {
  console.error('usage: node scripts/export-pdf.mjs <deckFile> <outputPdf> [--with-clicks]')
  process.exit(2)
}
const withClicks = rest.includes('--with-clicks')

// A free ephemeral port.
async function freePort() {
  const srv = net.createServer()
  srv.listen(0)
  await once(srv, 'listening')
  const { port } = srv.address()
  await new Promise(res => srv.close(res))
  return port
}

// Resolve once the dev server actually answers HTTP on localhost:<port> (any status —
// even a 404 means it's up and routing). `abort()` returns an Error if the server process
// died first, so we fail fast instead of polling a dead port for the full timeout.
async function waitForServer(port, abort, timeoutMs = 60000) {
  const deadline = Date.now() + timeoutMs
  while (Date.now() < deadline) {
    const dead = abort()
    if (dead) throw dead
    const ok = await new Promise((resolve) => {
      const req = http.get({ host: HOST, port, path: '/', timeout: 2000 }, (res) => {
        res.resume()
        resolve(true)
      })
      req.once('error', () => resolve(false))
      req.once('timeout', () => { req.destroy(); resolve(false) })
    })
    if (ok) return
    await new Promise(r => setTimeout(r, 250))
  }
  throw new Error(`dev server did not come up on ${HOST}:${port} within ${timeoutMs}ms`)
}

async function main() {
  const port = await freePort()
  const server = spawn(
    'pnpm',
    ['exec', 'slidev', deckFile, '--port', String(port)],
    { stdio: ['ignore', 'inherit', 'inherit'], detached: true },
  )
  // Track an early death so we (a) don't let an unhandled 'error' event crash the process,
  // and (b) abort the readiness wait immediately if the server exits before it's up.
  let serverDown = null
  server.on('error', e => serverDown ??= e)               // e.g. pnpm/slidev not found
  server.on('exit', (code, sig) => serverDown ??= new Error(`dev server exited before ready (code ${code}, signal ${sig})`))

  let browser
  try {
    await waitForServer(port, () => serverDown)
    browser = await chromium.launch()
    // A NORMAL viewport — the key difference from the CLI exporter. Native print pagination
    // (page.pdf) then handles any number of slides without the giant-surface clip.
    const page = await browser.newPage({ viewport: { width: 1280, height: 720 } })

    const url = `http://${HOST}:${port}/export${withClicks ? '?print=clicks' : ''}`
    // NOT networkidle: a live <Youtube> iframe never lets it settle. We wait on concrete
    // render signals instead.
    await page.goto(url, { waitUntil: 'domcontentloaded', timeout: 60000 })

    // Wait for the export layout, then for every slide's loading spinner to detach.
    await page.locator('#export-content').waitFor({ state: 'attached', timeout: 60000 })
    await page.waitForFunction(
      () => document.querySelectorAll('.slidev-slide-loading').length === 0,
      undefined,
      { timeout: 120000 },
    )
    await page.evaluate(() => document.fonts.ready.then(() => {}))
    // export.vue uses a 1s initial settle; give a little more for KaTeX/Shiki/Mermaid paint.
    await page.waitForTimeout(2000)

    const printed = await page.locator('.print-slide-container').count()
    if (printed === 0) throw new Error('no .print-slide-container rendered — export page is blank')

    await page.pdf({
      path: outputPdf,
      printBackground: true,
      preferCSSPageSize: true, // honour Slidev's @page (slide size) + per-slide page breaks
    })
    console.log(`  ✓ browser-exported ${printed} print blocks → ${outputPdf}`)
  } finally {
    if (browser) await browser.close().catch(() => {})
    // Kill the whole dev-server process group (detached → negative PID) to avoid zombies
    // and EADDRINUSE on the next deck.
    try { process.kill(-server.pid, 'SIGTERM') } catch {}
  }
}

main().then(
  () => process.exit(0),
  (err) => { console.error(`export-pdf.mjs: ${err.message}`); process.exit(1) },
)
