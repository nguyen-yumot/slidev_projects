# Slidev deck toolkit

A [Slidev](https://sli.dev) workspace with a small, reusable component toolkit baked in. The toolkit is a shared **`core/`** (components, layouts, structural styles + the default *flat* palette) plus look **variants** under `variants/` (`glass`, `minimal`, `print`); a deck opts in through its `addons:` frontmatter and switches looks by changing that one line — see [Looks](#looks). Each presentation is a self-contained folder under **`decks/`**. Two reference decks ship with it: `decks/template/` walks through every toolkit piece, and `decks/tutorial/` is a beginner-to-advanced guide to Slidev itself.

The repo is **scoped to the toolkit**: git tracks the toolkit, the two reference decks, and the config — and ignores everything else by default. You can author as many of your own decks as you like; they run locally but won't be committed unless you opt them in. See [What gets committed](#what-gets-committed-the-whitelist).

## Quick start

```bash
pnpm install                       # one-time: install dependencies (links the toolkit packages)
pnpm dev:template                  # run the starter deck (decks/template/)
pnpm dev decks/tutorial/slides.md  # run a specific deck — pass its entry file
```

The dev server prints `http://localhost:3030`. Speaker view is at `/presenter`; press <kbd>o</kbd> for the slide overview.

### Available decks

Every folder under `decks/` is one presentation; its entry file is always `decks/<name>/slides.md`, with section files in `pages/` and assets in `public/` beside it. Two are tracked in the repo:

| Deck | What it is | Run it with |
| --- | --- | --- |
| `decks/template/` | Starter walk-through of the component toolkit | `pnpm dev:template` |
| `decks/tutorial/` | Beginner-to-advanced guide to Slidev itself | `pnpm dev decks/tutorial/slides.md` |

To add another deck, copy the starter — `cp -R decks/template decks/your-deck` — set the headmatter `title`, and run `pnpm dev decks/your-deck/slides.md`. In its headmatter keep `theme: default` and `addons: ['deck-core', 'deck-variant-glass']` (or `['deck-core']` for the flat look) — **without an `addons:` line the deck gets no toolkit** (no components, no styling). It runs immediately, but is **gitignored by default** — opt it in if you want it committed ([details below](#tracking-a-new-deck)). Split sections out into the deck's `pages/` and pull each in via the `src:` frontmatter key — see [Editing](#editing).

## Prerequisites

- [Node.js](https://nodejs.org) 20.12 or newer (required by Slidev v52)
- [pnpm](https://pnpm.io) — `npm install -g pnpm`

## Commands

Every command takes a deck's entry file (`decks/<name>/slides.md`).

```bash
pnpm dev decks/<name>/slides.md                            # live deck at localhost:3030, hot reload
pnpm build decks/<name>/slides.md                          # static SPA in the deck's own dist/
pnpm build decks/tutorial/slides.md --base /tutorial/      # sub-path hosting
pnpm export decks/<name>/slides.md                         # PDF (also --format pptx | png)
```

Paths resolve relative to the deck (Slidev treats the entry file's folder as the project root), so a bare `pnpm build` writes to `decks/<name>/dist/`; pass an **absolute** `--out` to put it elsewhere — `scripts/deploy.sh` does exactly that to collect every deck under the repo-root `dist/`.

Examples:

```bash
pnpm dev decks/tutorial/slides.md     # serve the tutorial deck
pnpm build decks/tutorial/slides.md   # build the tutorial deck to decks/tutorial/dist/
pnpm export decks/tutorial/slides.md  # export the tutorial deck to PDF
```

CLI export (`pnpm export`) uses `playwright-chromium`, a tracked dev dependency that `pnpm install` already brings in — just install its browser once with `pnpm exec playwright install chromium`. Without the browser, use the in-browser exporter at `localhost:3030/export`, which needs nothing extra.

## Publish decks online (GitHub Pages)

Publish your decks as links anyone can open — no install, no account. Only the compiled output is pushed to a `gh-pages` branch; your `.md` source stays on your machine. Follow these steps in order.

**1. Choose which decks to publish.** Edit the `DECKS` list at the top of [`scripts/deploy.sh`](scripts/deploy.sh) — add or remove deck folder names (each entry is a `decks/<name>/` folder). Only the listed decks are published.

**2. Install dependencies** (first time only). The second command installs the browser that the deploy uses to export each deck to PDF (see [PDF downloads](#pdf-downloads-for-viewers)):

```bash
pnpm install                            # includes playwright-chromium (a tracked dev dependency)
pnpm exec playwright install chromium   # one-time: the headless browser used for PDF export
```

**3. Preview locally** (optional):

```bash
pnpm preview:pages
npx serve .preview        # then open http://localhost:3000/<repo>/
```

**4. Publish** — builds the listed decks and pushes them to the `gh-pages` branch:

```bash
pnpm deploy:pages
```

**5. Turn on GitHub Pages** (first time only). On GitHub, open **Settings → Pages → Build and deployment → Source**, choose **"Deploy from a branch"**, then branch **`gh-pages`** and folder **`/ (root)`**, and Save.

**6. Open your links.** After about a minute the decks are live (owner and repo are taken from your git remote; `pnpm deploy:pages` also prints the URLs):

```
https://<owner>.github.io/<repo>/             # landing page, links every deck
https://<owner>.github.io/<repo>/tutorial/    # an individual deck
https://<owner>.github.io/<repo>/statistics/
```

**To update later**, repeat steps 1 and 4 — step 5 is one-time.

> **Public vs private.** Your `.md` source is never pushed, but a published deck's rendered slides and presenter notes are visible to anyone with the link — don't put secrets in decks or notes.

### PDF downloads for viewers

Every published deck is exported to PDF at deploy time, so viewers can save a copy with no install and no browser fiddling. Each deck offers it two ways:

- a **PDF** link beside the deck on the landing page, and
- a **Download PDF** button inside the deck's own toolbar (bottom-left on hover).

This needs the `playwright-chromium` browser from step 2; if it's missing, `pnpm deploy:pages` stops with instructions. PDF export adds time to each deploy (it renders every slide). The file is named after the deck's front-matter `title` (falling back to its first `# heading`, then the deck's folder name) — the same name you get from `pnpm dev` → `/export` and the in-deck Download button, so every path agrees. The `DECKS` list only *chooses* which decks to publish; it never sets titles. (Viewer-side `?print` is **not** used — it's unreliable under GitHub Pages' sub-path routing.)

**How this works (background):**

- **`scripts/deploy.sh`** lets a single command do everything publishing needs: build every deck in the `DECKS` list, export each to PDF, generate the landing page, and push only the compiled output to `gh-pages`. Without it you would have to build and deploy each deck by hand.
- **Image paths are fixed automatically.** On GitHub Pages each deck lives under a `/<repo>/<name>/` sub-path, but decks reference their public images from the web root (e.g. `/chart.svg` for `decks/<name>/public/chart.svg`). The toolkit (`core/global-bottom.vue`) rewrites those paths to include the sub-path at runtime, so images that work in `pnpm dev` also work once published — no edits needed.

## Toolkit reference

Components are auto-imported — use them directly in any slide.

| Component | What it does |
| --- | --- |
| `<Callout type="tip\|warning\|note\|try\|blank" title="…">` | Coloured advice box with a Carbon icon. `blank` drops the icon and label for a plain neutral highlight. |
| `<FeatureCard title="…" icon="i-carbon-grid" row>` | Titled card for overviews; `row` puts icon + title inline. |
| `<KeyCap>o</KeyCap>` / `<KeyCaps>Space,→</KeyCaps>` | Render keys as keyboard caps. |
| `<Chip>cover</Chip>` / `<Chips>a, b, c</Chips>` | Monospace pills. |
| `<Eyebrow>Part 3</Eyebrow>` | Uppercase tag above a title. |
| `<ColHead>Heading</ColHead>` | Column heading inside `multicolumns`. |

**Code blocks inside a Callout/FeatureCard** are supported: write them with the `::Callout{…}` block form, or the `<Callout>…</Callout>` form with a **blank line** around the code (without the blank lines the fence is silently dropped). Long lines scroll within the box instead of clipping.

Layouts (set per slide via `layout:`):

- **`section`** — full-bleed gradient divider for the start of a part.
- **`multicolumns`** — up to four named columns (`#col1`–`#col4`); the grid width adapts to how many slots you fill.

The look is driven by `--deck-*` CSS variables defined in a **palette** file — `core/styles/palette-flat.css` (the flat default) or a variant's palette under `variants/*/styles/` (`palette-glass.css`, `palette-minimal.css`, `palette-print.css`). The shared structural rules live in `core/styles/base.css`. To re-skin, switch the palette via `addons:` (below) rather than editing components.

## Looks

The toolkit ships one shared **core** and one or more **look variants**, wired as Slidev addons via pnpm **workspace packages** (`core/` and `variants/*` are linked into the root `node_modules`, so any deck at any folder depth loads them by name). A deck picks its look in frontmatter — change the one line to reskin the whole deck:

```yaml
theme: default
addons: ['deck-core']                         # flat (the default look — teal, opaque, system fonts)
addons: ['deck-core', 'deck-variant-glass']   # glass (translucent, blur, web fonts, ocean section)
addons: ['deck-core', 'deck-variant-minimal'] # minimal (flat's teal, every heavy effect stripped)
addons: ['deck-core', 'deck-variant-print']   # print (monochrome paper — black on white, hairlines)
```

| Look | Style | When to use |
| --- | --- | --- |
| `flat` | Teal accents, opaque surfaces, subtle shadows, grain-textured section divider | Default for on-screen presenting |
| `glass` | Glassmorphism — translucency, backdrop blur, web fonts, ocean section | Showpiece decks presented from the browser |
| `minimal` | Flat's teal palette with **zero** shadows/blur/gradients/transparency | Large decks whose exported PDFs must open instantly |
| `print` | Monochrome paper — ink on white, grayscale callouts, hairline borders | Handout-style decks and print-first PDFs |

**All four looks export fast PDFs.** Two things make a big exported deck slow to view (pages opening blank, filling in gradually, re-rendering when you page back): **effects** — backdrop blur, blend modes, alpha gradients and translucent fills become transparency groups, soft masks, and per-pixel PostScript shadings in the PDF — and **fonts** — system fonts (macOS San Francisco) and Google-served variable fonts (multi-weight requests for Inter, Roboto, JetBrains Mono…) can't be subset-embedded by Chromium, so every glyph ships as a slow Type 3 outline font. The looks handle this differently:

- `minimal` and `print` are built lean: only opaque flat colours and static web fonts (Lato + IBM Plex Mono) everywhere — screen and PDF are the same.
- `flat` and `glass` keep their full effects on screen and swap in cheap equivalents **only under print media** (`@media print` blocks in their palettes, which is what PDF export renders with): precomposited opaque fills, gradient dividers without the grain/glow texture, no backdrop blur, and static fonts (flat's PDFs use Inter in place of San Francisco; glass requests its own fonts one weight per `@import`, which makes Google serve static files). The exported pages look almost identical, minus the subtle texture effects.

- **List `'deck-core'` first**, then a variant after it — the variant overrides core's default palette tokens. These are package names, not paths; don't use `'@/core'` (the `@/` prefix resolves to the deck's own folder, not the repo root, and fails from inside `decks/`).
- **Core is shared and never duplicated** — fixing a component or adding a feature in `core/` applies to every look at once.
- **Add a new look** = add `variants/<name>/`: copy a palette file (e.g. `palette-flat.css`), change the values, add a 2-line `styles/index.ts` and a minimal `package.json` named `deck-variant-<name>`, add `"deck-variant-<name>": "workspace:*"` to the root `package.json` and `pnpm install`, then `addons: ['deck-core', 'deck-variant-<name>']`.

## Project structure

```
.gitignore              Whitelist — tracks only the items below (see "What gets committed")
CLAUDE.md               Scope rules for AI-assisted editing (template vs decks)
package.json            Workspace + scripts (dev / build / export / preview:pages / deploy:pages)
pnpm-lock.yaml
pnpm-workspace.yaml     Declares core/ and variants/* as workspace packages
scripts/deploy.sh       Build + publish the listed decks to GitHub Pages (pnpm deploy:pages)
scripts/export-pdf.mjs  Headless PDF exporter the deploy uses (drives the /export page)

core/                   Shared toolkit addon, package `deck-core` (loaded by every deck via addons:)
  components/           Custom Vue components (Callout, FeatureCard, Chips, KeyCap, Tex…)
  layouts/              Custom layouts — section (divider), multicolumns (dense reference)
  setup/                preparser.ts (PDF filename = deck title) + deck-name.mjs (deploy helper)
  styles/               base.css (structural) + palette-flat.css (default look) + index.ts
  global-bottom.vue     Runtime base-path image fix (for sub-path hosting; see Publish)
variants/               Look variants — palette-only addons, packages `deck-variant-*`
  glass/                Glassmorphism palette (styles/palette-glass.css)
  minimal/              Fast-PDF flat palette — zero effects (styles/palette-minimal.css)
  print/                Monochrome paper palette (styles/palette-print.css)

decks/                  One folder per presentation — slides.md (entry) + pages/ + public/
  template/             Starter deck — exercises every toolkit piece (pnpm dev:template)
    slides.md
    pages/example.md
  tutorial/             Beginner-to-advanced Slidev guide — a worked example of the toolkit
    slides.md
    pages/              Its section files (01-beginner … 04-toolkit)
    public/             Its two demo assets (layout-demo.svg, slidev-logo.png)
```

Present on disk but **gitignored** (not committed): every other folder under `decks/` — your own presentations, each with its `slides.md`, `pages/`, `public/`, and optional `data/` — plus `node_modules/`, `dist/`, `.preview/` (the local preview staged by `pnpm preview:pages`), and `.claude/` (the authoring skill).

## What gets committed (the whitelist)

`.gitignore` ignores **everything** by default, then re-includes only the toolkit, the two reference decks, and the config. The mechanism is a whitelist:

```gitignore
/*                       # ignore every top-level entry...
!/core/                  # ...then re-include the toolkit (shared core + look variants)...
!/variants/
!/.gitignore             # ...the config...
!/package.json
!/pnpm-lock.yaml
!/pnpm-workspace.yaml
!/README.md
!/CLAUDE.md
!/decks/                 # ...and selected decks (one folder each):
/decks/*                 #    ignore every deck...
!/decks/template/        #    ...except the starter...
!/decks/tutorial/        #    ...and the tutorial.
/decks/tutorial/public/* #    (inside it, keep just the two demo assets)
!/decks/tutorial/public/layout-demo.svg
!/decks/tutorial/public/slidev-logo.png
!/scripts/               # ...and the deploy script + its helpers (other scripts stay ignored):
/scripts/*
!/scripts/deploy.sh
!/scripts/export-pdf.mjs
node_modules/            # junk to keep out even inside tracked folders
```

Anything you add whose name isn't on that list — a new deck folder, a scratch file — is ignored automatically, now and in the future. This keeps the repo a clean toolkit even while you draft decks alongside it.

### Tracking a new deck

A new deck runs the moment you create it, but `git status` won't see it until you whitelist it. To commit `decks/AAA/` (entry, sections, and assets in one go), **append** one line to the end of `.gitignore` (order matters — a re-include must come *after* the `/decks/*` rule that ignores it):

```gitignore
!/decks/AAA/
```

That re-include works because `decks/` itself is already re-included (`!/decks/` + `/decks/*` in the whitelist above) — git won't descend into a directory unless its parent is re-included first. One folder = one line; everything inside it (slides.md, pages/, public/, data/) comes along.

## Editing

Decks are plain Markdown — edit a deck's `slides.md` or its `pages/*.md` and the dev server hot-reloads. Split a large deck into files under its `pages/` and pull each section in with the `src:` frontmatter key:

```yaml
---
src: ./pages/your-section.md
---
```

Drop new layouts in `core/layouts/` and new components in `core/components/` — both are auto-imported from the `core` addon.

### Japanese (CJK) fonts

For a Japanese deck, set platform CJK fonts in the deck's headmatter so text renders crisply:

```yaml
fonts:
  sans: "Hiragino Kaku Gothic ProN, Yu Gothic, sans-serif"
  serif: "Hiragino Mincho ProN, Yu Mincho, serif"
  local: "Hiragino Kaku Gothic ProN, Yu Gothic, Hiragino Mincho ProN, Yu Mincho"
```

## Convert an existing Markdown file into a deck

Have a plain Markdown file you want turned into a deck in this repo's format? In Claude Code, the `slidev-deck-authoring` skill (in `.claude/skills/`) knows the conventions. Paste a prompt like this, swapping in your filename:

```text
Convert AAA.md into a Slidev deck using this repo's toolkit and conventions:
- create the folder decks/AAA/ with its entry at decks/AAA/slides.md (headmatter with
  `theme: default` + `addons: ['deck-core', 'deck-variant-glass']`, then cover + one
  src: block per section)
- split the sections into decks/AAA/pages/01-….md, 02-….md, …
- copy any images/assets under decks/AAA/public/, mirroring their original subfolder
  structure (so files in different source folders never collide), and reference each
  from the web root as /… — never a ./public or relative path
- open each part with a `layout: section` divider and use the toolkit components
  (Callout, FeatureCard, KeyCaps, multicolumns) instead of flat Markdown where it helps
- leave the original AAA.md untouched
```

The result lands alongside the existing decks:

```
AAA.md                        original source (left as-is)
decks/AAA/slides.md           new deck entry — run it with `pnpm dev decks/AAA/slides.md`
decks/AAA/pages/01-….md       section files pulled in via src:
decks/AAA/public/…            assets, mirroring source folders, referenced as /… in slides
```

Converted decks are **gitignored by default** — whitelist them as shown in [Tracking a new deck](#tracking-a-new-deck) if you want them committed. The skill itself lives under `.claude/`, which is also gitignored, so it's available locally but doesn't ship with a clone.

## Reusing this toolkit elsewhere

The shared components, the `section` / `multicolumns` layouts, and the design tokens are written to be portable. Three ways to reuse them, in order of effort.

### Option 1 — Copy the folders (fastest)

Copy the `core/` folder (and any `variants/` you want) into a fresh Slidev project, then point your deck at them with `addons:`.

```bash
# 1. scaffold a new deck
pnpm create slidev my-talk
cd my-talk

# 2. copy the toolkit from this repo
cp -R /path/to/this-repo/core     ./core
cp -R /path/to/this-repo/variants ./variants

# 3. the <Tex> component renders with KaTeX
pnpm add katex

# 4. install and run
pnpm install
pnpm dev
```

In the new deck's headmatter, load the toolkit and set the keys it expects:

```yaml
theme: default
addons: ['@/core', '@/variants/glass']  # or ['@/core'] for the flat look
mdc: true
transition: slide-left
lineNumbers: true
```

(The `@/` path form works *there* because the scaffolded `slides.md` sits at the project root, right next to the copied `core/` — `@/` resolves relative to the entry file's folder. In this repo the decks live under `decks/`, which is why they use the package names `deck-core` / `deck-variant-*` instead.)

### Option 2 — Use this repo as a template

Best when you want every new deck to start identical.

1. On GitHub, open this repo → **Settings → General → Template repository** (check the box).
2. Create a deck from the template and clone it:

   ```bash
   gh repo create my-talk --template <you>/<this-repo> --public --clone
   cd my-talk
   ```

3. Copy `decks/template/` to a new folder, rewrite its `slides.md` (and add files under its `pages/`), then `pnpm install && pnpm dev decks/<name>/slides.md`.

### Option 3 — Publish as a Slidev addon

This repo already uses the addon model **locally** — `core/` and each `variants/*` are Slidev addons, linked as pnpm workspace packages and referenced by name (`deck-core`, `deck-variant-glass`, …). To share them across repos, publish each as an npm package (`slidev-addon-…`) with a `slidev.defaults` block — see [sli.dev/guide/write-addon](https://sli.dev/guide/write-addon) — then opt in by name from any deck's headmatter:

```yaml
addons:
  - your-core-addon
  - your-glass-addon
```

**Where to start:** Option 1 for your next deck. If you reach for the same pieces a third time, promote them to Option 3 — by then you'll know what genuinely belongs in the addon.

Built with [Slidev](https://sli.dev) v52.
