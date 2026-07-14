// Slidev preparser extension (auto-loaded from this addon's setup/preparser.ts in
// dev, build, AND export). It makes one front-matter `title` drive the export filename
// on every path, with no per-deck `titleTemplate`/`exportFilename` noise:
//
//   • exportFilename — the /export print dialog uses `exportFilename || slidesTitle`
//     (pages/export.vue), so setting it pins the name to the resolved title and
//     bypasses titleTemplate entirely; it also names any `slidev export` output.
//   • titleTemplate '%s' — overrides Slidev's default "%s - Slidev", so the "- Slidev"
//     suffix never appears on the browser tab or any print filename, system-wide.
//   • download (deploy build only) — a STRING pointing the in-deck "Download PDF"
//     button at the PDF scripts/deploy.sh writes, so the button shows WITHOUT Slidev
//     rendering a throwaway build-time PDF (its build export runs only for download
//     true/"true"/"auto"; a string is skipped). Gated on the DECK_DOWNLOAD_NAME env
//     var deploy.sh sets, so `pnpm dev` stays button-free (no link to a missing file).
//
// transformSlide receives the headmatter slide's frontmatter by reference; mutating it
// flows into the deck headmatter → configs. `??=` lets an explicit deck value still win,
// and `applied` keeps the change to the entry's first (headmatter) slide.

import { resolveDeckName, toExportFilename } from './deck-name.mjs'

export default function ({ filepath }: { filepath: string }) {
  const name = toExportFilename(resolveDeckName(filepath))
  // Present ONLY during a deploy build (deploy.sh exports DECK_DOWNLOAD_NAME =
  // "<title>.pdf"). Wiring it into a STRING `download` makes Slidev show the in-deck
  // Download button and link it to that file, while skipping its own build-time PDF
  // export (which runs only for download true/"true"/"auto"). Left unset by `pnpm dev`.
  const downloadName = process.env.DECK_DOWNLOAD_NAME
  let applied = false
  return [
    {
      transformSlide(_content: string, frontmatter: any) {
        if (!applied) {
          applied = true
          frontmatter.exportFilename ??= name
          frontmatter.titleTemplate ??= '%s'
          if (downloadName) frontmatter.download ??= downloadName
        }
        return undefined
      },
    },
  ]
}
