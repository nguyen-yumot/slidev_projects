// The single rule for a deck's export name, shared by the @/core preparser
// (setup/preparser.ts, runs in dev + build + export) and scripts/deploy.sh.
//
// Resolve order — front-matter `title` → first `# H1` → the markdown filename:
//   1. `title:` in the leading `---…---` headmatter (quotes stripped), if non-empty.
//   2. else the first `# Heading` in the body.
//   3. else the filename stem, e.g. `Slidev_tutorial.md` → "Slidev_tutorial".
//
// This name is the landing-page card title (verbatim) and — after toExportFilename()
// makes it filesystem-safe — the PDF filename everywhere (the in-deck Download button,
// the /export print dialog, `slidev build --download`, and the landing-page PDF link),
// so `pnpm dev` and a published deck always agree.
//
//   import { resolveDeckName, toExportFilename } from '@/core/setup/deck-name.mjs'
//   node core/setup/deck-name.mjs <deckFile>           // prints the display title
//   node core/setup/deck-name.mjs <deckFile> --file    // prints the filesystem-safe stem

import { readFileSync } from 'node:fs'
import { basename } from 'node:path'
import { pathToFileURL } from 'node:url'

const RE_FRONTMATTER = /^---\r?\n([\s\S]*?)\r?\n---/   // leading headmatter block only
const RE_TITLE = /^title:[ \t]*(.+?)[ \t]*$/m          // top-level `title:` inside it
const RE_H1 = /^#[ \t]+(.+?)[ \t]*$/m                  // first `# Heading` in the body
const RE_QUOTED = /^(['"])([\s\S]*)\1$/                // a fully single/double-quoted scalar

// utf-8 read keeps em-dashes / Japanese titles intact on any locale.
export function resolveDeckName(filepath) {
  const src = readFileSync(filepath, 'utf8')

  const fm = src.match(RE_FRONTMATTER)
  if (fm) {
    const m = fm[1].match(RE_TITLE)
    if (m) {
      const raw = m[1].trim()
      const title = (raw.match(RE_QUOTED)?.[2] ?? raw).trim()
      if (title) return title
    }
  }

  const body = fm ? src.slice(fm[0].length) : src
  const h1 = body.match(RE_H1)
  if (h1) return h1[1].trim()

  return basename(filepath).replace(/\.md$/i, '')
}

// Make a resolved name safe as a single PDF filename. `/` and `\` are path separators —
// a title like "TCP/IP" would otherwise scatter the PDF into a subfolder and break the
// landing-page link — so collapse runs of them to a single "-". Everything else (spaces,
// colons, em-dashes, "&", non-ASCII) is fine on the Linux deploy host + URL-encoding.
export function toExportFilename(name) {
  return name.replace(/[/\\]+/g, '-')
}

// CLI: print the name (no trailing newline) so deploy.sh can capture it — the display
// title by default, or the filesystem-safe stem with --file.
// pathToFileURL handles paths with spaces / special chars (this repo lives under @uv).
if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  const args = process.argv.slice(2)
  const asFile = args.includes('--file')
  const file = args.find(a => a !== '--file')
  if (!file) {
    console.error('usage: node core/setup/deck-name.mjs <deckFile> [--file]')
    process.exit(2)
  }
  const name = resolveDeckName(file)
  process.stdout.write(asFile ? toExportFilename(name) : name)
}
