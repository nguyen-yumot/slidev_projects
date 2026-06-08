# Slidev deck toolkit

A [Slidev](https://sli.dev) workspace with a small, reusable component toolkit baked in. The
toolkit is a shared **`core/`** (components, layouts, structural styles + the default *flat*
palette) plus look **variants** under `variants/` (e.g. `glass`); a deck opts in through its
`addons:` frontmatter and switches looks by changing that one line — see
[Looks](#looks-flat-vs-glass). Two reference decks ship with it: `slides.md` walks through
every toolkit piece, and `Slidev_tutorial.md` is a beginner-to-advanced guide to Slidev itself.

The repo is **scoped to the toolkit**: git tracks the toolkit, the two reference decks, and the
config — and ignores everything else by default. You can author as many of your own decks as you
like; they run locally but won't be committed unless you opt them in. See
[What gets committed](#what-gets-committed-the-whitelist).

## Quick start

```bash
pnpm install                  # one-time: install dependencies
pnpm dev                      # run the default deck (slides.md)
pnpm dev Slidev_tutorial.md   # run a specific deck — pass its filename
```

The dev server prints `http://localhost:3030`. Speaker view is at `/presenter`; press
<kbd>o</kbd> for the slide overview.

### Available decks

Any `.md` file at the repo root is a runnable deck. Two are tracked in the repo:

| File | What it is | Run it with |
| --- | --- | --- |
| `slides.md` | Template walk-through of the component toolkit (default deck) | `pnpm dev` |
| `Slidev_tutorial.md` | Beginner-to-advanced guide to Slidev itself | `pnpm dev Slidev_tutorial.md` |

To add another deck, drop a new `Slidev_your-deck.md` at the repo root and run
`pnpm dev Slidev_your-deck.md`. In its headmatter set `theme: default` and
`addons: ['@/core', '@/variants/glass']` (or `['@/core']` for the flat look) — **without an
`addons:` line the deck gets no toolkit** (no components, no styling). It runs immediately, but
is **gitignored by default** — opt it in if you want it committed
([details below](#tracking-a-new-deck)). Split sections out into `pages/` and pull each in via
the `src:` frontmatter key — see [Editing](#editing).

## Prerequisites

- [Node.js](https://nodejs.org) 20.12 or newer (required by Slidev v52)
- [pnpm](https://pnpm.io) — `npm install -g pnpm`

## Commands

Every command takes an optional deck filename. Omit it to act on `slides.md`.

```bash
pnpm dev [file.md]                            # live deck at localhost:3030, hot reload
pnpm build [file.md]                          # static SPA in dist/
pnpm build Slidev_tutorial.md --base /tutorial/  # sub-path hosting
pnpm export [file.md]                         # PDF (also --format pptx | png)
```

Examples:

```bash
pnpm dev Slidev_tutorial.md     # serve the tutorial deck
pnpm build Slidev_tutorial.md   # build the tutorial deck to dist/
pnpm export Slidev_tutorial.md  # export the tutorial deck to PDF
```

CLI export (`pnpm export`) needs Slidev's optional `playwright-chromium`, which this repo doesn't
bundle — add it with `pnpm add -D playwright-chromium && pnpm exec playwright install chromium`.
Without it, use the in-browser exporter at `localhost:3030/export`, which needs nothing extra.

## Publish decks online (GitHub Pages)

Publish your decks as links anyone can open — no install, no account. Only the compiled output
is pushed to a `gh-pages` branch; your `.md` source stays on your machine. Follow these steps in
order.

**1. Choose which decks to publish.** Edit the `DECKS` list at the top of
[`scripts/deploy.sh`](scripts/deploy.sh) — add or remove deck filenames. Only the listed decks
are published.

**2. Install dependencies** (first time only):

```bash
pnpm install
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

**5. Turn on GitHub Pages** (first time only). On GitHub, open **Settings → Pages → Build and
deployment → Source**, choose **"Deploy from a branch"**, then branch **`gh-pages`** and folder
**`/ (root)`**, and Save.

**6. Open your links.** After about a minute the decks are live (owner and repo are taken from
your git remote; `pnpm deploy:pages` also prints the URLs):

```
https://<owner>.github.io/<repo>/             # landing page, links every deck
https://<owner>.github.io/<repo>/tutorial/    # an individual deck
https://<owner>.github.io/<repo>/statistics/
```

**To update later**, repeat steps 1 and 4 — step 5 is one-time.

> **Public vs private.** Your `.md` source is never pushed, but a published deck's rendered slides
> and presenter notes are visible to anyone with the link — don't put secrets in decks or notes.

**How this works (background):**

- **`scripts/deploy.sh`** lets a single command do everything publishing needs: build every deck
  in the `DECKS` list, generate the landing page, and push only the compiled output to `gh-pages`.
  Without it you would have to build and deploy each deck by hand.
- **Image paths are fixed automatically.** On GitHub Pages each deck lives under a
  `/<repo>/<name>/` sub-path, but decks reference public images from the web root (e.g.
  `/statistics/chart.svg`). The toolkit (`core/global-bottom.vue`) rewrites those paths to include
  the sub-path at runtime, so images that work in `pnpm dev` also work once published — no edits
  needed.

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

**Code blocks inside a Callout/FeatureCard** are supported: write them with the `::Callout{…}`
block form, or the `<Callout>…</Callout>` form with a **blank line** around the code (without the
blank lines the fence is silently dropped). Long lines scroll within the box instead of clipping.

Layouts (set per slide via `layout:`):

- **`section`** — full-bleed gradient divider for the start of a part.
- **`multicolumns`** — up to four named columns (`#col1`–`#col4`); the grid width adapts to how
  many slots you fill.

The look is driven by `--deck-*` CSS variables defined in a **palette** file —
`core/styles/palette-flat.css` (the flat default) or `variants/glass/styles/palette-glass.css`
(glass). The shared structural rules live in `core/styles/base.css`. To re-skin, switch the
palette via `addons:` (below) rather than editing components.

## Looks (flat vs glass)

The toolkit ships one shared **core** and one or more **look variants**, wired as Slidev local
addons. A deck picks its look in frontmatter — change the one line to reskin the whole deck:

```yaml
theme: default
addons: ['@/core']                    # flat (the default look — teal, opaque, system fonts)
addons: ['@/core', '@/variants/glass'] # glass (translucent, blur, web fonts, ocean section)
```

- **List `'@/core'` first**, then a variant after it — the variant overrides core's default
  palette tokens. Use the `@/` prefix (resolves to the project root); a `./core` path resolves
  one level too high and fails.
- **Core is shared and never duplicated** — fixing a component or adding a feature in `core/`
  applies to every look at once.
- **Add a new look** = add `variants/<name>/`: copy a palette file (e.g. `palette-flat.css`),
  change the values, add a 2-line `styles/index.ts` and a minimal `package.json`, then
  `addons: ['@/core', '@/variants/<name>']`.

## Project structure

```
.gitignore              Whitelist — tracks only the items below (see "What gets committed")
package.json            Workspace + scripts (dev / build / export / preview:pages / deploy:pages)
pnpm-lock.yaml
pnpm-workspace.yaml
scripts/deploy.sh       Build + publish the listed decks to GitHub Pages (pnpm deploy:pages)

core/                   Shared toolkit addon (loaded by every deck via addons:)
  components/           Custom Vue components (Callout, FeatureCard, Chips, KeyCap, Tex…)
  layouts/              Custom layouts — section (divider), multicolumns (dense reference)
  styles/               base.css (structural) + palette-flat.css (default look) + index.ts
  global-bottom.vue     Runtime base-path image fix (for sub-path hosting; see Publish)
variants/               Look variants — palette-only addons
  glass/                Glassmorphism palette (styles/palette-glass.css)

slides.md               Template demo deck (default entry) — exercises every toolkit piece
pages/example.md        The section slides.md imports via src:
Slidev_tutorial.md      Beginner-to-advanced Slidev guide — a worked example of the toolkit
pages/tutorial/         Its section files (01-beginner … 04-toolkit)
```

Present on disk but **gitignored** (not committed): any other `Slidev_*.md` deck, its
`pages/<name>/` sections and `public/<name>/` assets, plus `node_modules/`, `dist/`, `.preview/`
(the local preview staged by `pnpm preview:pages`), and `.claude/` (the authoring skill).

## What gets committed (the whitelist)

`.gitignore` ignores **everything** by default, then re-includes only the toolkit, the two
reference decks, and the config. The mechanism is a whitelist:

```gitignore
/*                       # ignore every top-level entry...
!/core/                  # ...then re-include the toolkit (shared core + look variants)...
!/variants/
!/.gitignore             # ...the config + reference decks...
!/package.json
!/pnpm-lock.yaml
!/pnpm-workspace.yaml
!/README.md
!/slides.md
!/Slidev_tutorial.md
!/pages/                 # ...and selected content under pages/:
/pages/*                 #    ignore everything in pages/...
!/pages/example.md       #    ...except the demo section...
!/pages/tutorial/        #    ...and the tutorial deck's sections.
!/scripts/               # ...and the deploy script (other scripts stay ignored):
/scripts/*
!/scripts/deploy.sh
```

Anything you add whose name isn't on that list — a new deck, an asset folder, a scratch file — is
ignored automatically, now and in the future. This keeps the repo a clean toolkit even while you
draft decks alongside it.

### Tracking a new deck

A new deck runs the moment you create it, but `git status` won't see it until you whitelist it.
To commit `Slidev_AAA.md` along with its sections and assets, **append** these lines to the end
of `.gitignore` (order matters — a re-include must come *after* the `/*` and `/dir/*` rules that
ignore it):

```gitignore
!/Slidev_AAA.md
!/pages/AAA/
!/public/                # re-include public/ so git descends into it...
/public/*                #   ...ignore everything in it...
!/public/AAA/            #   ...except this deck's assets.
```

The `!dir/` → `/dir/*` → `!/dir/keep/` three-step is needed whenever you keep one subfolder out
of an otherwise-ignored directory — git won't re-include a file unless its parent dir is
re-included first. The `!/public/` + `/public/*` pair is only needed the first time; later decks
just add their own `!/public/BBB/`. (`pages/` already has this pair, so a new deck there needs
only `!/pages/AAA/`.)

## Editing

Decks are plain Markdown — edit any `.md` at the repo root and the dev server hot-reloads.
Split a large deck into files under `pages/` and pull each section in with the `src:`
frontmatter key:

```yaml
---
src: ./pages/your-section.md
---
```

Drop new layouts in `core/layouts/` and new components in `core/components/` — both are
auto-imported from the `core` addon.

### Japanese (CJK) fonts

For a Japanese deck, set platform CJK fonts in the deck's headmatter so text renders crisply:

```yaml
fonts:
  sans: "Hiragino Kaku Gothic ProN, Yu Gothic, sans-serif"
  serif: "Hiragino Mincho ProN, Yu Mincho, serif"
  local: "Hiragino Kaku Gothic ProN, Yu Gothic, Hiragino Mincho ProN, Yu Mincho"
```

## Convert an existing Markdown file into a deck

Have a plain Markdown file you want turned into a deck in this repo's format? In Claude Code,
the `slidev-deck-authoring` skill (in `.claude/skills/`) knows the conventions. Paste a prompt
like this, swapping in your filename:

```text
Convert AAA.md into a Slidev deck using this repo's toolkit and conventions:
- create Slidev_AAA.md at the repo root (headmatter with `theme: default` +
  `addons: ['@/core', '@/variants/glass']`, then cover + one src: block per section)
- split the sections into pages/AAA/01-….md, 02-….md, …
- copy any images/assets under public/AAA/, mirroring their original subfolder structure
  (so files in different source folders never collide), and reference each from the web
  root as /AAA/… — never a ./public or relative path
- open each part with a `layout: section` divider and use the toolkit components
  (Callout, FeatureCard, KeyCaps, multicolumns) instead of flat Markdown where it helps
- leave the original AAA.md untouched
```

The result lands alongside the existing decks:

```
AAA.md                  original source (left as-is)
Slidev_AAA.md           new root deck — run it with `pnpm dev Slidev_AAA.md`
pages/AAA/01-….md       section files pulled in via src:
public/AAA/…            assets, mirroring source folders, referenced as /AAA/… in slides
```

Converted decks are **gitignored by default** — whitelist them as shown in
[Tracking a new deck](#tracking-a-new-deck) if you want them committed. The skill itself lives
under `.claude/`, which is also gitignored, so it's available locally but doesn't ship with a
clone.

## Reusing this toolkit elsewhere

The shared components, the `section` / `multicolumns` layouts, and the design tokens are written
to be portable. Three ways to reuse them, in order of effort.

### Option 1 — Copy the folders (fastest)

Copy the `core/` folder (and any `variants/` you want) into a fresh Slidev project, then point
your deck at them with `addons:`.

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

### Option 2 — Use this repo as a template

Best when you want every new deck to start identical.

1. On GitHub, open this repo → **Settings → General → Template repository** (check the box).
2. Create a deck from the template and clone it:

   ```bash
   gh repo create my-talk --template <you>/<this-repo> --public --clone
   cd my-talk
   ```

3. Rewrite `slides.md` (and add files under `pages/`), then `pnpm install && pnpm dev`.

### Option 3 — Publish as a Slidev addon

This repo already uses the addon model **locally** — `core/` and each `variants/*` are Slidev
addons, referenced by path (`@/core`). To share them across repos, publish each as an npm
package (`slidev-addon-…`) with a `slidev.defaults` block — see
[sli.dev/guide/write-addon](https://sli.dev/guide/write-addon) — then opt in by name from any
deck's headmatter:

```yaml
addons:
  - your-core-addon
  - your-glass-addon
```

**Where to start:** Option 1 for your next deck. If you reach for the same pieces a third time,
promote them to Option 3 — by then you'll know what genuinely belongs in the addon.

Built with [Slidev](https://sli.dev) v52.
