# Slidev deck toolkit

A [Slidev](https://sli.dev) workspace with a reusable component toolkit baked in. Each presentation is a self-contained folder under **`decks/`**; every deck shares one **`core/`** toolkit (components, layouts, styles) and picks a **look** — `flat` (default), `glass`, `minimal`, or `print` — by changing a single line. Two reference decks ship with it: `decks/template/` shows every toolkit piece, and `decks/tutorial/` is a beginner-to-advanced guide to Slidev.

> **New here?** Do sections **1 → 2 → 3** in order and you'll have a deck running and (optionally) published. Everything after that is reference you can dip into when you need it. Grey **▸ "…"** toggles hide deeper background — open them only if you're curious or stuck.

## Contents

**Get going**
1. [Install the tools (one-time setup)](#1-install-the-tools-one-time-setup)
2. [Quick start](#2-quick-start)
3. [Everyday commands](#3-everyday-commands)
4. [Make your own deck](#4-make-your-own-deck)
5. [Publish online (GitHub Pages)](#5-publish-online-github-pages)

**Reference**
6. [Components and layouts](#6-components-and-layouts)
7. [Looks (change the design)](#7-looks-change-the-design)
8. [Project structure](#8-project-structure)
9. [What gets committed (the whitelist)](#9-what-gets-committed-the-whitelist)
10. [Editing and other topics](#10-editing-and-other-topics)
11. [Reusing this toolkit elsewhere](#11-reusing-this-toolkit-elsewhere)

---

## 1. Install the tools (one-time setup)

You need three free tools: **Git** (to download the project), **Node.js** (to run it), and **pnpm** (the package manager). Pick your operating system below and copy each line into a terminal.

### macOS

macOS installs everything through **Homebrew**, a package manager. If you've never used it, install Homebrew first:

```bash
# 1. Install Homebrew (skip if you already have it — check with: brew --version)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

When it finishes, Homebrew prints a short **"Next steps"** section with one or two `echo …` / `eval …` lines — **run those lines** so your terminal can find the `brew` command (they add it to your `PATH`). Then close and reopen the terminal, and continue:

```bash
# 2. Install Git + Node.js with Homebrew
brew install git node

# 3. Install pnpm (npm comes bundled with Node)
npm install -g pnpm
```

### Windows

Windows 10/11 ship with **winget**. In **PowerShell**:

```powershell
winget install Git.Git OpenJS.NodeJS   # Git + Node.js — then close and reopen PowerShell
npm install -g pnpm                     # pnpm
```

### Linux (Debian / Ubuntu)

The version of Node in Ubuntu's default repos is often too old, so install Node 20 from [NodeSource](https://github.com/nodesource/distributions):

```bash
sudo apt update && sudo apt install -y git curl
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs
npm install -g pnpm
```

### Check it worked

Run these three — each should print a version number:

```bash
git --version     # any recent version
node --version    # must be v20.12 or newer (Slidev v52 needs it)
pnpm --version    # any version = installed OK
```

If a command says "not found," reopen your terminal and try again; if it still fails, that tool didn't install — repeat its step above.

## 2. Quick start

With the tools installed, download the project and start a deck:

```bash
git clone https://github.com/nguyen-yumot/slidev_projects.git
cd slidev_projects
pnpm install          # one-time: downloads dependencies and links the toolkit
pnpm dev:template     # open the starter deck
```

`git clone` **creates** the `slidev_projects` folder for you — don't make it yourself. After `pnpm dev:template` starts, it prints a link like `http://localhost:3030` — open it in your browser. Edits to the deck's Markdown reload instantly. Press <kbd>o</kbd> for a slide overview; speaker view is at `/presenter`. Stop the server with <kbd>Ctrl</kbd>+<kbd>C</kbd>.

To run a different deck, pass its entry file (`decks/<name>/slides.md`):

| Deck | What it is | Run it with |
| --- | --- | --- |
| `decks/template/` | Starter that shows every toolkit component | `pnpm dev:template` |
| `decks/tutorial/` | Beginner-to-advanced guide to Slidev | `pnpm dev decks/tutorial/slides.md` |

Every folder under `decks/` is one presentation: its entry is always `slides.md`, with section files in `pages/` and images in `public/` beside it.

## 3. Everyday commands

Each command takes a deck's entry file, `decks/<name>/slides.md`:

```bash
pnpm dev    decks/<name>/slides.md    # 1. edit live in the browser (hot reload)
pnpm build  decks/<name>/slides.md    # 2. build a static website into the deck's dist/
pnpm export decks/<name>/slides.md    # 3. export to PDF (add --format pptx or png for others)
bash scripts/deploy.sh                # 4. publish ALL listed decks online — see section 5
```

Quick examples:

```bash
pnpm dev    decks/tutorial/slides.md    # serve the tutorial deck
pnpm export decks/tutorial/slides.md    # save the tutorial deck as a PDF
```

<details>
<summary>▸ Where output lands, and PDF export details</summary>

Slidev treats each deck's own folder as its project root, so a bare `pnpm build` writes to `decks/<name>/dist/`. To put the output elsewhere, pass an **absolute** `--out` path — `scripts/deploy.sh` does this to collect every deck under one repo-root `dist/`.

`pnpm export` (PDF) uses `playwright-chromium`, a dependency that `pnpm install` already downloaded — you just need its browser once: `pnpm exec playwright install chromium`. No browser installed? Use the in-browser exporter instead: run `pnpm dev …`, open `http://localhost:3030/export`, and print — it needs nothing extra.

Sub-path hosting (e.g. a deck living at `example.com/tutorial/`) needs a matching base path: `pnpm build decks/tutorial/slides.md --base /tutorial/`.
</details>

## 4. Make your own deck

Copy the starter, give it a title, and run it:

```bash
cp -R decks/template decks/my-deck              # copy the starter
# → edit decks/my-deck/slides.md: set the `title:` and write your slides
pnpm dev decks/my-deck/slides.md                # run it
```

Keep the two headmatter lines the starter already has — `theme: default` and an `addons:` line:

```yaml
addons: ['deck-core', 'deck-variant-glass']   # the glass look — or ['deck-core'] for flat
```

⚠️ **Without an `addons:` line the deck gets no toolkit** — no components, no styling. See [section 7](#7-looks-change-the-design) for the other looks.

Your new deck runs immediately, but it is **not saved to Git by default** (the repo only tracks the toolkit and the two reference decks — see [section 9](#9-what-gets-committed-the-whitelist)). That's intentional: draft as many private decks as you like. To commit one, [track it](#track-a-new-deck). Split a long deck into `pages/` files and pull each in with `src:` — see [section 10](#10-editing-and-other-topics).

## 5. Publish online (GitHub Pages)

Turn your decks into links anyone can open — no install, no account needed. **One command does it all:**

```bash
bash scripts/deploy.sh        # (same as: pnpm deploy:pages)
```

It builds every listed deck, exports each to PDF, makes a landing page, and pushes the result to a special `gh-pages` branch. **You never edit or commit that branch yourself** — the script owns it.

### First-time setup

**a. Choose which decks to publish.** Open [`scripts/deploy.sh`](scripts/deploy.sh) and edit the `DECKS=(…)` list near the top — one deck folder name per line. Only listed decks are published.

**b. Install the PDF browser** (once). The deploy renders each deck to a downloadable PDF using a headless browser:

```bash
pnpm exec playwright install chromium
```

**c. Preview locally first** (optional, recommended):

```bash
pnpm preview:pages        # builds everything without publishing
npx serve .preview        # then open the printed http://localhost:3000/… link
```

**d. Publish:**

```bash
bash scripts/deploy.sh
```

**e. Turn on GitHub Pages** (once). On GitHub: **Settings → Pages → Build and deployment → Source** → choose **"Deploy from a branch"** → branch **`gh-pages`**, folder **`/ (root)`** → **Save**.

**f. Open your links.** After ~1 minute the decks are live (the command also prints these URLs):

```
https://<owner>.github.io/<repo>/             ← landing page, links every deck
https://<owner>.github.io/<repo>/tutorial/    ← one deck
```

**To update later:** just run `bash scripts/deploy.sh` again. Steps a, b, and e are one-time only.

<details>
<summary>▸ Saving source vs. updating the site (important!)</summary>

Saving your work and updating the website are **two separate actions** — doing one never does the other:

| | Your source code | The live website |
| --- | --- | --- |
| **Lives on** | the `master` branch | the `gh-pages` branch (auto-generated) |
| **Update with** | `git add` / `commit` / `push` | `bash scripts/deploy.sh` |
| **Holds** | your `.md` files, README, scripts | the built HTML + PDFs |
| **Edit by hand?** | yes | no — overwritten each deploy |

So `git push` saves your source but does **not** change the live slides, and `bash scripts/deploy.sh` updates the live slides but does **not** commit your source. Do either, both, or neither. Note: a [gitignored deck](#9-what-gets-committed-the-whitelist)'s `.md` never reaches GitHub, so for those decks `bash scripts/deploy.sh` is the *only* way the slides get online (as built HTML + PDF).

**Privacy:** your `.md` source is never pushed, but a published deck's rendered slides and presenter notes are visible to anyone with the link — don't put secrets in decks or notes.
</details>

<details>
<summary>▸ PDF downloads for viewers</summary>

Every published deck is exported to PDF at deploy time, so viewers can save a copy. Each deck offers it two ways: a **PDF** link beside the deck on the landing page, and a **Download PDF** button in the deck's own toolbar (bottom-left, appears on hover).

This needs the `playwright-chromium` browser from step **b**; if it's missing, the deploy stops with instructions. PDF export adds time to each deploy (it renders every slide). The file is named after the deck's front-matter `title` (falling back to its first `# heading`, then the folder name) — the same name everywhere, so all paths agree. The `DECKS` list only *chooses* which decks to publish; it never sets titles.
</details>

<details>
<summary>▸ Published but don't see your change?</summary>

It's almost always your **browser cache**, not a failed deploy. GitHub Pages tells browsers to cache each page for ~10 minutes, so you may keep seeing the old version briefly. The site itself updates within a minute or two.

To see it right away: **hard-refresh** (<kbd>Cmd/Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>R</kbd>), open the link in a private window, or add a throwaway `?v=2` to the URL. To check what GitHub is *actually* serving (independent of your browser): `git ls-remote --heads origin gh-pages` — the commit hash changes on a successful push.
</details>

<details>
<summary>▸ If publishing fails ("unable to create temporary file")</summary>

The deploy reuses a cached clone of `gh-pages` under `node_modules/.cache/gh-pages/`. If a previous run was interrupted, the **publish** step can fail (the **build still succeeds**, so `dist/` is complete) with:

```
unable to create temporary file: Invalid argument
fatal: adding files failed
```

Clear the stale cache, then re-publish the already-built `dist/` — no rebuild needed:

```bash
pnpm exec gh-pages-clean                                          # wipe the cached clone (don't rm -rf it)
pnpm exec gh-pages -d dist --dotfiles --no-history -b gh-pages    # push dist/ to gh-pages
```

Confirm it landed with `git ls-remote --heads origin gh-pages` — the commit hash should change.
</details>

<details>
<summary>▸ How the deploy works (background)</summary>

- **`scripts/deploy.sh`** lets one command do everything: build every deck in `DECKS`, export each to PDF, generate the landing page, and push only the compiled output to `gh-pages`. Without it you'd build and deploy each deck by hand.
- **Image paths are fixed automatically.** On GitHub Pages each deck lives under a `/<repo>/<name>/` sub-path, but decks reference images from the web root (e.g. `/chart.svg` for `decks/<name>/public/chart.svg`). The toolkit (`core/global-bottom.vue`) rewrites those paths at runtime, so images that work in `pnpm dev` also work once published — no edits needed.
- The viewer-side `?print` route is deliberately **not** used — it's unreliable under GitHub Pages' sub-path routing, so the deploy pre-renders real PDF files instead.
</details>

---

## 6. Components and layouts

Components are auto-imported — use them directly in any slide.

| Component | What it does |
| --- | --- |
| `<Callout type="tip\|warning\|note\|try\|blank" title="…">` | Coloured advice box with a Carbon icon. `blank` drops the icon and label for a plain highlight. |
| `<FeatureCard title="…" icon="i-carbon-grid" row>` | Titled card for overviews; `row` puts icon + title inline. |
| `<KeyCap>o</KeyCap>` / `<KeyCaps>Space,→</KeyCaps>` | Render keys as keyboard caps. |
| `<Chip>cover</Chip>` / `<Chips>a, b, c</Chips>` | Monospace pills. |
| `<Eyebrow>Part 3</Eyebrow>` | Uppercase tag above a title. |
| `<ColHead>Heading</ColHead>` | Column heading inside `multicolumns`. |
| `<Tex>\sigma^2</Tex>` | Inline math (KaTeX) that works even inside the tags above. |

**Layouts** (set per slide via the `layout:` headmatter key):

- **`section`** — full-bleed gradient divider for the start of a part.
- **`multicolumns`** — up to four named columns (`#col1`–`#col4`); the grid width adapts to how many you fill.

> **Code blocks inside a Callout/FeatureCard** work, but need a **blank line** above and below the fence (or use the `::Callout{…}` block form) — without the blank lines the code fence is silently dropped. Long lines scroll within the box instead of clipping.

<details>
<summary>▸ Icons, and how the styling is organised</summary>

Icons use the [Carbon](https://icones.js.org/collection/carbon) set — write them as `i-carbon-<name>` (e.g. `i-carbon-idea`). ⚠️ A misspelled icon name renders as a **silent empty box** with no error, so copy names from the icon browser.

The look is driven by `--deck-*` CSS variables in a **palette** file: `core/styles/palette-flat.css` (the default) or a variant under `variants/*/styles/`. Shared structural rules live in `core/styles/base.css`. To re-skin, switch the palette via `addons:` (next section) rather than editing components.
</details>

## 7. Looks (change the design)

Change one line in a deck's headmatter to reskin the whole thing:

```yaml
theme: default
addons: ['deck-core']                         # flat    — teal, opaque, system fonts (default)
addons: ['deck-core', 'deck-variant-glass']   # glass   — translucent, blur, web fonts
addons: ['deck-core', 'deck-variant-minimal'] # minimal — flat's teal, every heavy effect stripped
addons: ['deck-core', 'deck-variant-print']   # print   — monochrome paper, black on white
```

| Look | Style | Best for |
| --- | --- | --- |
| `flat` | Teal accents, opaque surfaces, subtle shadows | Default on-screen presenting |
| `glass` | Glassmorphism — translucency, blur, web fonts | Showpiece decks from the browser |
| `minimal` | Flat's teal with **zero** shadows/blur/gradients | Big decks whose PDFs must open instantly |
| `print` | Monochrome paper — ink on white, hairlines | Handouts and print-first PDFs |

- **List `'deck-core'` first**, then a variant after it (the variant overrides core's default look). These are package names — don't use `'@/core'` paths.
- **Core is shared:** fixing a component in `core/` updates every look at once.

<details>
<summary>▸ Why all four looks export fast PDFs</summary>

Two things make a big exported deck slow to view (pages opening blank, filling in gradually): **effects** (backdrop blur, blend modes, alpha gradients — these become transparency groups, soft masks, and per-pixel PostScript shadings in the PDF) and **fonts** (system fonts like San Francisco and Google variable fonts can't be subset-embedded by Chromium, so every glyph ships as a slow Type 3 outline).

- `minimal` and `print` are built lean: opaque flat colours and static web fonts everywhere — screen and PDF are identical.
- `flat` and `glass` keep full effects on screen but swap in cheap equivalents **only under print media** (`@media print`, which is what PDF export uses): precomposited fills, gradient dividers without grain/glow, no blur, and static fonts. Exported pages look nearly identical, minus subtle texture.
</details>

<details>
<summary>▸ Add a new look</summary>

Add `variants/<name>/`: copy a palette file (e.g. `palette-flat.css`), change the values, add a 2-line `styles/index.ts` and a minimal `package.json` named `deck-variant-<name>`, add `"deck-variant-<name>": "workspace:*"` to the root `package.json`, run `pnpm install`, then use `addons: ['deck-core', 'deck-variant-<name>']`.
</details>

## 8. Project structure

```
package.json            Workspace + scripts (dev / build / export / preview:pages / deploy:pages)
pnpm-workspace.yaml     Declares core/ and variants/* as workspace packages
scripts/deploy.sh       Build + publish the listed decks to GitHub Pages
scripts/export-pdf.mjs  Headless PDF exporter the deploy uses

core/                   Shared toolkit, package `deck-core` (loaded by every deck via addons:)
  components/           Vue components (Callout, FeatureCard, Chips, KeyCap, Tex…)
  layouts/              section (divider) + multicolumns (dense reference)
  setup/                preparser.ts (PDF filename = deck title) + deck-name.mjs (deploy helper)
  styles/               base.css (structure) + palette-flat.css (default look)
  global-bottom.vue     Runtime image-path fix for sub-path hosting
variants/               Look variants — palette-only, packages `deck-variant-*`
  glass/  minimal/  print/

decks/                  One folder per presentation — slides.md (entry) + pages/ + public/
  template/             Starter deck (pnpm dev:template)
  tutorial/             Beginner-to-advanced Slidev guide
```

Present on disk but **gitignored** (not committed): every other deck under `decks/` — your own presentations — plus `node_modules/`, `dist/`, `.preview/`, and `.claude/`.

## 9. What gets committed (the whitelist)

`.gitignore` ignores **everything** by default, then re-includes only the toolkit, the two reference decks, and the config. So anything you add — a new deck, a scratch file — is ignored automatically unless you opt it in. This keeps the repo a clean toolkit even while you draft decks alongside it.

### Track a new deck

A new deck runs the moment you create it, but Git won't see it until you whitelist it. To commit `decks/AAA/`, **append** one line to the end of `.gitignore` (it must come *after* the `/decks/*` rule):

```gitignore
!/decks/AAA/
```

One folder = one line; everything inside it (slides.md, pages/, public/, data/) comes along.

<details>
<summary>▸ How the whitelist is written</summary>

```gitignore
/*                       # ignore every top-level entry...
!/core/                  # ...then re-include the toolkit...
!/variants/
!/package.json           # ...the config...
!/pnpm-lock.yaml
!/pnpm-workspace.yaml
!/README.md
!/decks/                 # ...and selected decks (one folder each):
/decks/*                 #    ignore every deck...
!/decks/template/        #    ...except the starter...
!/decks/tutorial/        #    ...and the tutorial.
!/scripts/               # ...and the deploy script + its helper:
/scripts/*
!/scripts/deploy.sh
!/scripts/export-pdf.mjs
node_modules/            # junk to keep out even inside tracked folders
```

A re-include only works if its parent directory is re-included first (git won't descend otherwise) — which is why `!/decks/AAA/` works: `decks/` itself is already re-included above.
</details>

## 10. Editing and other topics

Decks are plain Markdown — edit a deck's `slides.md` or its `pages/*.md` and the dev server hot-reloads. Split a large deck into `pages/` files and pull each section in with `src:`:

```yaml
---
src: ./pages/your-section.md
---
```

Drop new layouts in `core/layouts/` and new components in `core/components/` — both are auto-imported.

<details>
<summary>▸ Japanese (CJK) fonts</summary>

For a Japanese deck, set platform CJK fonts in the deck's headmatter so text renders crisply:

```yaml
fonts:
  sans: "Hiragino Kaku Gothic ProN, Yu Gothic, sans-serif"
  serif: "Hiragino Mincho ProN, Yu Mincho, serif"
  local: "Hiragino Kaku Gothic ProN, Yu Gothic, Hiragino Mincho ProN, Yu Mincho"
```
</details>

<details>
<summary>▸ Convert an existing Markdown file into a deck (with Claude Code)</summary>

Have a plain Markdown file you want turned into a deck? In Claude Code, the `slidev-deck-authoring` skill (in `.claude/skills/`) knows the conventions. Paste a prompt like this, swapping in your filename:

```text
Convert AAA.md into a Slidev deck using this repo's toolkit and conventions:
- create decks/AAA/ with its entry at decks/AAA/slides.md (headmatter with
  theme: default + addons: ['deck-core', 'deck-variant-glass'], cover + one
  src: block per section)
- split the sections into decks/AAA/pages/01-….md, 02-….md, …
- copy any images under decks/AAA/public/, mirroring their source subfolders,
  and reference each from the web root as /… — never a ./public or relative path
- open each part with a `layout: section` divider and use the toolkit components
  (Callout, FeatureCard, KeyCaps, multicolumns) where they help
- leave the original AAA.md untouched
```

Converted decks are gitignored by default — [track them](#track-a-new-deck) to commit.
</details>

## 11. Reusing this toolkit elsewhere

The components, layouts, and design tokens are portable. Three ways to reuse them, in order of effort.

<details>
<summary>▸ Option 1 — Copy the folders (fastest)</summary>

Copy `core/` (and any `variants/` you want) into a fresh Slidev project, then point your deck at them:

```bash
pnpm create slidev my-talk && cd my-talk
cp -R /path/to/this-repo/core     ./core
cp -R /path/to/this-repo/variants ./variants
pnpm add katex          # the <Tex> component renders with KaTeX
pnpm install && pnpm dev
```

In the new deck's headmatter:

```yaml
theme: default
addons: ['@/core', '@/variants/glass']  # or ['@/core'] for the flat look
mdc: true
```

The `@/` path form works *there* because the scaffolded `slides.md` sits at the project root next to `core/`. In *this* repo the decks live under `decks/`, which is why they use the package names `deck-core` / `deck-variant-*` instead.
</details>

<details>
<summary>▸ Option 2 — Use this repo as a template</summary>

Best when you want every new deck to start identical.

1. On GitHub: this repo → **Settings → General → Template repository** (check the box).
2. `gh repo create my-talk --template <you>/<this-repo> --public --clone && cd my-talk`
3. Copy `decks/template/` to a new folder, rewrite its `slides.md`, then `pnpm install && pnpm dev decks/<name>/slides.md`.
</details>

<details>
<summary>▸ Option 3 — Publish as a Slidev addon</summary>

To share across repos, publish each of `core/` and `variants/*` as an npm package (`slidev-addon-…`) with a `slidev.defaults` block — see [sli.dev/guide/write-addon](https://sli.dev/guide/write-addon) — then opt in by name from any deck:

```yaml
addons:
  - your-core-addon
  - your-glass-addon
```

**Where to start:** Option 1 for your next deck. If you reach for the same pieces a third time, promote them to Option 3.
</details>

---

Built with [Slidev](https://sli.dev) v52.
