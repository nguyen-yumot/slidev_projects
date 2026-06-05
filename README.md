# Slidev deck toolkit

A [Slidev](https://sli.dev) workspace with a small, reusable component toolkit baked in. The
`components/`, `layouts/`, and `styles/` folders are auto-imported at the project level, so they
apply to any deck you add to the repo. Two reference decks ship with it: `slides.md` walks through
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
`pnpm dev Slidev_your-deck.md`. It runs immediately, but is **gitignored by default** — opt it
in if you want it committed ([details below](#tracking-a-new-deck)). Split sections out into
`pages/` and pull each in via the `src:` frontmatter key — see [Editing](#editing).

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

The look is driven by CSS variables in `styles/tutorial.css` (`--deck-accent`, `--deck-tip`,
`--deck-warning`, `--deck-note`, `--deck-try`, `--deck-radius`). Override any of them in `styles/`.

## Project structure

```
.gitignore              Whitelist — tracks only the items below (see "What gets committed")
package.json            Workspace + scripts (dev / build / export)
pnpm-lock.yaml
pnpm-workspace.yaml

components/             Custom Vue components — auto-imported (Callout, FeatureCard, Chips, KeyCap…)
layouts/                Custom layouts — section (divider), multicolumns (dense reference)
styles/                 Global design tokens (--deck-*) and cross-slide tweaks

slides.md               Template demo deck (default entry) — exercises every toolkit piece
pages/example.md        The section slides.md imports via src:
Slidev_tutorial.md      Beginner-to-advanced Slidev guide — a worked example of the toolkit
pages/tutorial/         Its section files (01-beginner … 04-toolkit)
```

Present on disk but **gitignored** (not committed): any other `Slidev_*.md` deck, its
`pages/<name>/` sections and `public/<name>/` assets, plus `node_modules/`, `dist*/`, and
`.claude/` (the authoring skill).

## What gets committed (the whitelist)

`.gitignore` ignores **everything** by default, then re-includes only the toolkit, the two
reference decks, and the config. The mechanism is a whitelist:

```gitignore
/*                       # ignore every top-level entry...
!/components/            # ...then re-include the toolkit folders...
!/layouts/
!/styles/
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

Drop new layouts in `layouts/` and new components in `components/` — both are auto-imported.

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
- create Slidev_AAA.md at the repo root (headmatter + cover + one src: block per section)
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

Drop the three folders into a fresh Slidev project. Slidev auto-imports all of them.

```bash
# 1. scaffold a new deck
pnpm create slidev my-talk
cd my-talk

# 2. copy the portable folders from this repo
cp -R /path/to/this-repo/components ./components
cp -R /path/to/this-repo/layouts    ./layouts
cp -R /path/to/this-repo/styles     ./styles

# 3. install and run
pnpm install
pnpm dev
```

In the new deck's headmatter, add the keys the toolkit expects, then use the components straight
away:

```yaml
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

The canonical path. One package, many decks — see the addon-based sibling of this repo, or
[sli.dev/guide/write-addon](https://sli.dev/guide/write-addon). Move `components/`, `layouts/`,
and `styles/` into a package with a `slidev.defaults` block, then opt in from any deck's
headmatter:

```yaml
addons:
  - your-addon-name
```

**Where to start:** Option 1 for your next deck. If you reach for the same pieces a third time,
promote them to Option 3 — by then you'll know what genuinely belongs in the addon.

Built with [Slidev](https://sli.dev) v52.
