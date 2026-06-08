<!--
  Base-path image fixer (toolkit-wide).

  Decks reference public assets with root-absolute paths, e.g.
  `<img src="/statistics/foo.svg">` or `![](/tutorial/logo.png)`. Those work under
  `pnpm dev` (base "/") but 404 when a deck is deployed under a sub-path such as
  `/slidev_projects/statistics/` (GitHub Pages project sites), because the browser
  requests the path verbatim while the file actually lives under the deploy base.

  This global layer runs on every slide and rewrites any root-absolute image URL to
  include the build's base (`import.meta.env.BASE_URL`), so images resolve both in dev
  and when published — with no per-deck edits. It is a no-op when base is "/".

  Covered: <img src>, inline `background-image: url(/...)` (used by image layouts).
  Already-based, protocol (http//, //), and data: URLs are left untouched (idempotent).
-->
<script setup lang="ts">
import { onMounted } from 'vue'

const base = import.meta.env.BASE_URL || '/'
const prefix = base.replace(/\/$/, '') // base without trailing slash

function fix(url: string): string {
  if (!url.startsWith('/') || url.startsWith('//')) return url // not root-absolute
  if (url.startsWith(base)) return url                          // already based
  return prefix + url
}

function fixEl(el: Element) {
  if (el instanceof HTMLImageElement) {
    const raw = el.getAttribute('src')
    if (raw) {
      const fixed = fix(raw)
      if (fixed !== raw) el.setAttribute('src', fixed)
    }
  }
  const style = (el as HTMLElement).style
  if (style?.backgroundImage?.includes('url(')) {
    const fixed = style.backgroundImage.replace(
      /url\((['"]?)(\/[^)'"]+)\1\)/g,
      (_m, q, p) => `url(${q}${fix(p)}${q})`,
    )
    if (fixed !== style.backgroundImage) style.backgroundImage = fixed
  }
}

function sweep(root: ParentNode) {
  if (root instanceof Element) fixEl(root)
  root.querySelectorAll?.('img, [style*="background-image"]').forEach(fixEl)
}

onMounted(() => {
  // No-op at the domain root (e.g. `pnpm dev`, base "/"). Install exactly one
  // observer per page even if this global layer ever mounts more than once —
  // the flag lives on `document`, not on the per-instance setup scope. The
  // observer runs for the whole presentation session, so it needs no teardown.
  const doc = document as unknown as { __deckBaseFixer?: boolean }
  if (base === '/' || doc.__deckBaseFixer) return
  doc.__deckBaseFixer = true

  sweep(document)
  new MutationObserver((mutations) => {
    for (const m of mutations) {
      if (m.type === 'attributes' && m.target instanceof Element) fixEl(m.target)
      m.addedNodes.forEach((n) => { if (n instanceof Element) sweep(n) })
    }
  }).observe(document.body, {
    childList: true,
    subtree: true,
    attributes: true,
    attributeFilter: ['src', 'style'],
  })
})
</script>

<template>
  <span data-deck-base-fixer aria-hidden="true" style="display: none" />
</template>
