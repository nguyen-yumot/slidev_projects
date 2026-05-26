---
name: slidev-deck-authoring
description: >-
  Author and edit Slidev presentation decks in this repo using its custom toolkit —
  the auto-imported components (Callout, FeatureCard, KeyCap/KeyCaps, Chip/Chips,
  Eyebrow, ColHead), the section and multicolumns layouts, and the --deck-* design
  tokens. Use this whenever the user wants to create, add, edit, restyle, or convert slides,
  a deck, a presentation, or a talk in this Slidev workspace — including turning an existing
  plain Markdown file into a Slidev deck (e.g. AAA.md into Slidev_AAA.md, with sections under
  pages/ and assets in public/); when they ask to add a slide or section, split a deck into
  pages/, open a part with a divider, lay out columns, or drop in a callout/feature
  card/keycap; or when they reference slides.md, a *.md deck at the repo root, or files under
  pages/. Prefer this over the generic pptx skill — output
  here is Slidev Markdown, not PowerPoint.
---

# Authoring Slidev decks with this repo's toolkit

This repo is a Slidev workspace with a portable design system baked in. A deck is plain
Markdown; the polish comes from custom Vue components, two layouts, and a set of CSS design
tokens that Slidev **auto-imports** from `components/`, `layouts/`, and `styles/`. Your job
is to write decks that lean on that toolkit instead of reinventing styling per slide — that
is what keeps every deck on-brand and lets a theme change propagate everywhere at once.

The single most important habit: **reach for a component or token before writing raw HTML or
hardcoding a color.** If you find yourself typing a hex code or a `<div style="...">`, stop
and check whether a component or a `--deck-*` variable already covers it.

## Anatomy of a deck

A deck is one `.md` file at the repo root (`slides.md` is the default). Slides are separated
by `---` on their own line. The first block is the **headmatter** (deck-wide config); every
later `---` block is per-slide **frontmatter**.

```yaml
---
theme: default
title: My Talk
transition: slide-left
mdc: true          # REQUIRED for the component attribute syntax below — don't drop it
lineNumbers: true
layout: cover      # layout of the FIRST slide
---

# My Talk

Subtitle line

<!-- speaker notes go in an HTML comment at the end of a slide -->
```

`mdc: true` matters: it enables Markdown Components syntax so you can pass bare attributes
like `<FeatureCard row>` and write Markdown *inside* a component's slot. Without it the
components still render but the ergonomics degrade. Every deck here assumes it.

Per-slide frontmatter picks a layout and other options:

```markdown
---
layout: section
---

content for this slide
```

### Splitting a big deck across `pages/`

Keep long decks readable by moving each section into its own file under `pages/` and pulling
it in from the root deck with the `src:` key. The root file becomes a table of contents:

```markdown
---
src: ./pages/01-intro.md
---
```

The imported file is just more slides (`---`-separated), and it inherits the deck's headmatter.
Look at `pages/nodejs/` and `pages/tutorial/` for real multi-file examples.

## Converting an existing Markdown file into a deck

When the user hands you a plain Markdown file (e.g. `AAA.md`) and asks to turn it into a deck,
follow this repo's naming and placement conventions so the result sits alongside the existing
decks instead of inventing a new structure:

- **Root deck file** → `Slidev_<Name>.md` at the repo root, where `<Name>` is the source's base
  name. So `AAA.md` becomes `Slidev_AAA.md`. (The existing `Slidev_nodejs.md` and
  `Slidev_tutorial.md` follow this; `slides.md` is just the template default.) Leave the original
  `AAA.md` untouched unless the user says otherwise.
- **Section files** → split the content into `pages/<Name>/` with numbered files, e.g.
  `pages/AAA/01-intro.md`, `pages/AAA/02-….md`. The root `Slidev_AAA.md` then holds the
  headmatter, the cover slide, and one `src:` block per section — it becomes the table of
  contents. Mirror the layout of `pages/nodejs/` and `pages/tutorial/`.
- **Assets** (images, diagrams, fonts) → copy the source's files under a per-deck namespace
  `public/<Name>/` (so `AAA.md`'s assets live in `public/AAA/`) and reference them from the
  **web root**, not a relative path: a file saved as `public/AAA/cover.png` is written in a
  slide as `![alt](/AAA/cover.png)` or `image: /AAA/cover.png`. Slidev serves `public/` at `/`,
  which is why the leading-slash root path works and a `./public/...` path does not. The
  per-deck namespace keeps one converted deck's assets from clashing with another's.

  When the source's images are **scattered across several folders**, do not flatten them into one
  directory — same-named files (`chapter1/image.png`, `chapter2/image.png`) would collide and
  silently overwrite. **Mirror the original subfolder structure** under `public/<Name>/` and
  rewrite each reference to the matching web-root path. Remember the source references are
  relative to the *original* file's location, so every one must be rewritten — moving the prose
  into `pages/<Name>/` changes the directory depth and breaks the old relative paths regardless.

  ```
  AAA.md references:           copy to:                       rewrite reference to:
    ./cover.png            →   public/AAA/cover.png        →    /AAA/cover.png
    ./figures/a.png        →   public/AAA/figures/a.png    →    /AAA/figures/a.png
    chapter1/image.png     →   public/AAA/chapter1/image.png →  /AAA/chapter1/image.png
    ../shared/logo.svg     →   public/AAA/shared/logo.svg  →    /AAA/shared/logo.svg
  ```

  Pick the namespace folder once and apply it to every asset; after rewriting, grep the new deck
  for any leftover relative image paths (`](./`, `](../`, `src="./`) to confirm none were missed.

Conversion approach: read the source headings to find natural section breaks, map each top-level
section to one file under `pages/<Name>/`, then rewrite the prose into slides (one idea per
slide). Replace flat Markdown with toolkit components where it improves the slide — turn an
aside into a `<Callout>`, a feature list into a `<FeatureCard>` grid, a keyboard/shortcut table
into `multicolumns` with `<KeyCaps>`, and open each section with a `layout: section` divider.
Don't just paste the original text onto slides; that's the difference between a converted file
and a deck. Finish by running `pnpm dev Slidev_<Name>.md` to confirm it renders.

```
AAA.md                      ← original source (left as-is)
Slidev_AAA.md               ← new root deck: headmatter + cover + src: blocks
pages/AAA/01-intro.md       ← section files pulled in via src:
pages/AAA/02-….md
public/AAA/…                ← assets (mirror source subfolders), referenced as /AAA/… in slides
```

## The component toolkit

All components are auto-imported — use them directly in any slide, no import line. Each
component's `.vue` file opens with a usage comment and its full prop list; **read the source
when you need a prop you don't see here** (e.g. `components/Callout.vue`). Quick reference:

| Component | Purpose | Common usage |
| --- | --- | --- |
| `<Callout>` | Colored advice box with icon | `<Callout type="tip\|warning\|note\|try" title="…">body</Callout>` — also `size`, `tone`, `compact` |
| `<FeatureCard>` | Titled card for overview grids | `<FeatureCard title="…" icon="i-carbon-grid" row>body</FeatureCard>` — also `tone`, `elevation`, `display` |
| `<KeyCap>` | One keyboard key | `<KeyCap>o</KeyCap>`, `<KeyCap tone="accent">Cmd</KeyCap>` |
| `<KeyCaps>` | A comma-list of keys | `<KeyCaps>Space,→</KeyCaps>`, `<KeyCaps joiner="+">Cmd,K</KeyCaps>` |
| `<Chip>` | One monospace pill | `<Chip tone="accent">v2</Chip>` |
| `<Chips>` | A comma-list of pills | `<Chips>default, cover, center</Chips>` |
| `<Eyebrow>` | Uppercase tag above a title | `<Eyebrow>Part 3 · Advanced</Eyebrow>` |
| `<ColHead>` | Column heading inside multicolumns | `<ColHead>Navigate</ColHead>`, `<ColHead tone="tip">` |

Notes that save you grief:
- The `<Foo>`/`<Foos>` pairs are singular/plural. `<KeyCaps>`/`<Chips>` split a comma-separated
  slot and lay the items out for you — use them instead of hand-writing several `<KeyCap>`s.
- Tones (`tip`, `warning`, `note`, `try`, `accent`) map to the matching `--deck-*` color, so a
  `tip` callout and a `tip` chip read as the same semantic. Stay consistent with that meaning.
- Icons use the Carbon set via UnoCSS classes, e.g. `icon="i-carbon-rocket"`. Browse names at
  https://icones.js.org (Carbon collection). `@iconify-json/carbon` is already installed.

### Whitespace gotcha (MDC)

When you wrap a component in a `<div>` for spacing or grid layout, leave a **blank line**
between the opening `<div>` and the Markdown/component inside it, or Markdown won't render:

```markdown
<div class="grid grid-cols-2 gap-4 pt-4">

<FeatureCard title="A" icon="i-carbon-grid" row>Body text.</FeatureCard>

<FeatureCard title="B" icon="i-carbon-idea" row>Body text.</FeatureCard>

</div>
```

UnoCSS utility classes (`grid`, `pt-4`, `opacity-70`, …) are available for this kind of
lightweight layout — prefer them over inline `style=` for spacing and grids.

## The layouts

Set with `layout:` in a slide's frontmatter.

**`section`** — a full-bleed dark ocean-gradient divider for opening a new part. Pair it with
an `<Eyebrow>`, an `# h1`, and a one-line description:

```markdown
---
layout: section
---

<Eyebrow>Part 2 · Tooling</Eyebrow>

# Build, lint, test

One sentence framing the section.
```

**`multicolumns`** — up to four named columns for dense reference slides. The default slot
(usually an `# h1`) sits above the columns; fill `#col1`–`#col4` with `<template>` blocks. The
layout counts how many you fill and sizes the grid to match, so just use as many as you need:

```markdown
---
layout: multicolumns
---

# Keyboard reference

<template #col1>
<ColHead>Navigate</ColHead>

<KeyCaps>Space,→</KeyCaps> next
<KeyCap>o</KeyCap> overview
</template>

<template #col2>
<ColHead>Present</ColHead>

<KeyCap>f</KeyCap> fullscreen
</template>
```

Slidev's own built-in layouts are also available when these two don't fit — the decks in this
repo use `cover`, `default`, `center`, `two-cols`, `image-right`, `fact`, and `quote`.

## Styling: tokens, not hex codes

The whole look is defined as CSS custom properties in `styles/tutorial.css` — accent, semantic
alert colors, surfaces, borders, radii, spacing, shadows, blur, and the font stack, with full
light and `.dark` variants. Components reference these variables rather than hardcoded values.

- To **restyle a deck or rebrand**, override the `--deck-*` variables (e.g. `--deck-accent`)
  rather than editing component internals. A handful of variable overrides re-skins everything.
- When you add custom CSS, use the existing tokens (`var(--deck-accent)`, `var(--deck-radius-md)`,
  `var(--deck-text-muted)`, `var(--deck-shadow-md)`, …) so it tracks the theme and dark mode for
  free. Read the `:root` block in `styles/tutorial.css` for the full list before inventing a value.
- The `.deck-eyebrow` and `.deck-chip` classes also exist as global CSS for raw-Markdown use, but
  prefer the `<Eyebrow>` / `<Chip>` components in new slides.

## Running and checking your work

```bash
pnpm dev [file.md]      # live deck at localhost:3030, hot reload (omit file → slides.md)
pnpm build [file.md]    # static SPA in dist/
pnpm export [file.md]   # PDF (needs playwright-chromium; see README) or use /export in-browser
```

After writing slides, it's worth starting `pnpm dev <file>` to confirm the deck compiles and the
components render — a malformed `<template #colN>` or a missing blank line is easiest to catch live.

## Workflow checklist

1. Decide: new root deck, or a new section file under `pages/` pulled in via `src:`?
2. New deck → write headmatter with `mdc: true`; first slide usually `layout: cover`.
3. Draft slides one idea each; open each major part with a `layout: section` divider.
4. Use toolkit components for callouts, cards, keys, chips; use `multicolumns` for dense reference.
5. Keep blank lines inside wrapper `<div>`s; use UnoCSS utilities and `--deck-*` tokens, not hex.
6. Read a component's `.vue` source when you need a prop not listed above — they're self-documented.
7. Run `pnpm dev <file>` to verify it renders.
