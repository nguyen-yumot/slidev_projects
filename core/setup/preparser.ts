// Slidev preparser extension (auto-loaded from this addon's setup/preparser.ts in
// dev, build, AND export). It makes one front-matter `title` drive the export filename
// on every path, with no per-deck `titleTemplate`/`exportFilename` noise:
//
//   • exportFilename — the /export print dialog uses `exportFilename || slidesTitle`
//     (pages/export.vue), so setting it pins the name to the resolved title and
//     bypasses titleTemplate entirely; it also names `slidev build --download` output.
//   • titleTemplate '%s' — overrides Slidev's default "%s - Slidev", so the "- Slidev"
//     suffix never appears on the browser tab or any print filename, system-wide.
//
// transformSlide receives the headmatter slide's frontmatter by reference; mutating it
// flows into the deck headmatter → configs. `??=` lets an explicit deck value still win,
// and `applied` keeps the change to the entry's first (headmatter) slide.

import { resolveDeckName, toExportFilename } from './deck-name.mjs'

export default function ({ filepath }: { filepath: string }) {
  const name = toExportFilename(resolveDeckName(filepath))
  let applied = false
  return [
    {
      transformSlide(_content: string, frontmatter: any) {
        if (!applied) {
          applied = true
          frontmatter.exportFilename ??= name
          frontmatter.titleTemplate ??= '%s'
        }
        return undefined
      },
    },
  ]
}
