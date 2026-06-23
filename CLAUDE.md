# Slidev workspace — scope rules

This repo holds **one shared template** and **many independent presentations**. They are
different kinds of work; never mix them in one edit unless the user explicitly asks.

## What is what

| Scope | Files | Edit when the request mentions… |
|---|---|---|
| **Template** | `core/` (components, layouts, base styles, setup) and `variants/` (looks: glass/minimal/print; flat lives in core) | the template, toolkit, a component (Callout, FeatureCard, KeyCap, Chip, Eyebrow, ColHead, Tex), a layout, design tokens (`--deck-*`), a look/palette |
| **One presentation** | exactly one `decks/<name>/` folder: its `slides.md` (entry), `pages/` (sections), `public/` (assets), `data/` (figure pipelines) | that deck by name or topic (statistics, tutorial, nodejs, im, Tao, …) |
| **Infrastructure** | `scripts/deploy.sh`, `scripts/export-pdf.mjs`, root `package.json`, `pnpm-workspace.yaml`, `.gitignore` | building, exporting PDFs, publishing to GitHub Pages |

Rules:

- A deck edit stays inside that one `decks/<name>/` folder. Never touch sibling decks.
- A template edit (`core/`, `variants/`) affects **every** deck — make sure that is what
  the user wants before changing shared components or tokens.
- If the request is ambiguous about which deck — or deck vs. template — **ask first**.
- Decks other than `template` and `tutorial` are private: gitignored on purpose, never
  force-add them.

## How decks load the template

`core/` and `variants/*` are pnpm **workspace packages** (`deck-core`, `deck-variant-glass`,
`deck-variant-minimal`, `deck-variant-print`), linked into the root `node_modules`. A deck
loads them by package name in its headmatter — this works from any folder depth:

```yaml
addons: ['deck-core', 'deck-variant-glass']   # glass look — or ['deck-core'] for flat
```

Do **not** use `'@/core'` or relative paths in `addons:` — `@/` resolves to the deck's own
folder (where the entry file sits), not the repo root.

Each deck's `public/` is served at `/` for that deck (Slidev serves `<entry dir>/public`),
so asset refs are `/figure.svg`, not `/<deck>/figure.svg`. Section includes are
`src: ./pages/01-foo.md`.

## Commands

```bash
pnpm dev decks/<name>/slides.md     # run one deck (open via localhost, not 127.0.0.1)
pnpm dev:template                   # run the starter deck
bash scripts/deploy.sh --no-publish # build all public decks + PDFs into dist/, stage preview
bash scripts/deploy.sh              # same + publish to GitHub Pages
```

## New deck

Copy the starter: `cp -R decks/template decks/<name>`, then set the headmatter `title`
(it becomes the exported PDF filename and the landing-page card), write sections under
`pages/`, drop assets in `public/`. Add the folder name to `DECKS=()` in
`scripts/deploy.sh` only if it should be published.
