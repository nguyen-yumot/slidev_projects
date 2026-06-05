---
layout: section
---

<Eyebrow>Part 3</Eyebrow>

# Advanced

Make Slidev your own — custom layouts and components, theming, and an efficiency workflow.

<!-- Content slides for the advanced track. -->

---

# Components in slides

Because slides are Vue, you can drop **components** straight into Markdown. Slidev ships many built-in ones:

<div class="flex flex-wrap gap-2 pt-1 pb-2">
  <div class="deck-chip">&lt;Toc /&gt;</div>
  <div class="deck-chip">&lt;Link /&gt;</div>
  <div class="deck-chip">&lt;Tweet /&gt;</div>
  <div class="deck-chip">&lt;Youtube /&gt;</div>
  <div class="deck-chip">&lt;SlideCurrentNo /&gt;</div>
</div>

<div class="grid grid-cols-2 gap-6 pt-2 text-sm">

<div>

**`<Link>`** — in-deck navigation
```md
<Link to="2">jump to overview</Link>
```
<div class="pt-1 text-base"><Link to="2">jump to overview</Link></div>

</div>

<div>

**`<Youtube>`** — embed a video by ID
```md
<Youtube id="xuCn8ux2gbs"
  width="280" height="158" />
```
<div class="pt-1">
<Youtube id="xuCn8ux2gbs" width="280" height="158" />
</div>

</div>

</div>

---

# Write your own component

Drop a `.vue` file into `components/` and Slidev auto-imports it — use it by filename, no `import` needed.

```vue
<!-- components/Badge.vue -->
<template>
  <span class="badge"><slot /></span>
</template>
```

<Callout type="tip">
Every <code>Callout</code>, <code>FeatureCard</code>, and <code>KeyCap</code> you've seen in this tutorial is a custom component living in <code>components/</code>.
</Callout>

---

# Custom layouts

A layout is just a Vue component with a `<slot />` for the slide body. Put it in `layouts/`, then select it with `layout:`.

```vue
<!-- layouts/section.vue -->
<template>
  <div class="section">
    <slot />
  </div>
</template>
```

<Callout type="tip">
The teal divider slides between each part of this tutorial use the deck's own <code>section</code> layout.
</Callout>

---

# The setup/ directory

Files in `setup/` configure Slidev with code — no need to touch its internals:

<div class="flex flex-col gap-2 pt-3 text-lg">
  <div><code>setup/main.ts</code> &nbsp;—&nbsp; extend the Vue app with plugins or components</div>
  <div><code>setup/shiki.ts</code> &nbsp;—&nbsp; customise the code highlighter</div>
  <div><code>setup/katex.ts</code> &nbsp;—&nbsp; add your own LaTeX macros</div>
</div>

Each file exports a `define*` helper that Slidev calls at the right moment.

---

# Styling with UnoCSS

Slidev bundles **UnoCSS** — atomic utility classes you apply right inside your Markdown. One class name = one CSS rule, so the styling lives on the element instead of in a separate file.

<div class="grid grid-cols-2 gap-6 pt-3 text-sm">

<div>

<ColHead>The old way — write CSS</ColHead>

```css
.title {
  padding-top: 1rem;
  font-size: 1.25rem;
  font-weight: 700;
}
```
```html
<div class="title">Hello</div>
```

</div>

<div>

<ColHead>With UnoCSS — class names only</ColHead>

```html
<div class="pt-4 text-xl font-bold">
  Hello
</div>
```

</div>

</div>

<div class="pt-4 text-center text-sm opacity-70">
You've seen these all tutorial long — <code>grid</code>, <code>flex</code>, <code>pt-4</code>, <code>text-lg</code>, <code>gap-3</code>. The next two slides are your reference for the ones you'll reach for most.
</div>

---

# UnoCSS: spacing and layout

<div class="grid grid-cols-2 gap-6 pt-2 text-sm">

<div>

<ColHead>Spacing</ColHead>

- `p-4` — padding on all sides
- `pt-2 pb-4 pl-3 pr-3` — one side each
- `m-4` — margin (same idea)
- `gap-3` — space between grid/flex children

```md
<div class="p-3 bg-slate-100">A padded box</div>
```

<div class="p-3 bg-slate-100 text-xs">A padded box</div>

</div>

<div>

<ColHead>Layout</ColHead>

- `flex` — make children sit in a row
- `grid grid-cols-2` — two-column grid
- `items-center` — vertical centering
- `justify-center` — horizontal centering

```md
<div class="grid grid-cols-2 gap-4">
  <div>Left</div>
  <div>Right</div>
</div>
```

<div class="grid grid-cols-2 gap-4 text-xs bg-slate-100 p-2 mt-1">
  <div>Left</div>
  <div>Right</div>
</div>

</div>

</div>

::Callout{type="note"}
Numbers are 4-pixel steps: `p-1` = 4px, `p-4` = 16px, `p-8` = 32px.
::

---

# Padding vs margin — the box model

**Padding** is space *inside* a box, around its content. **Margin** is space *outside*, pushing neighbours away.

<div class="grid grid-cols-2 gap-6 pt-2 text-sm">

<div>

<ColHead>padding — inner space</ColHead>

```
┌──────────────────────┐  ← border / edge
│   ←   padding  →     │
│  ┌────────────────┐  │
│↕ │    content     │↕ │
│  └────────────────┘  │
│                      │
└──────────────────────┘
```

- Pushes content **inward** from the edge.
- Background colour **fills** the padding.
- UnoCSS: `p-3`, `pt-3`, `px-4` …

</div>

<div>

<ColHead>margin — outer space</ColHead>

```
┌─────── box A ──────┐
│                    │
└────────────────────┘
       ↕ margin
┌─────── box B ──────┐
│                    │
└────────────────────┘
```

- Pushes **other elements** away.
- Always **transparent** — no background.
- UnoCSS: `m-3`, `mt-3`, `-mt-12` (negative *pulls* in).

</div>

</div>

<Callout type="tip">
Mental model: <strong>padding</strong> = breathing room <em>inside</em>; <strong>margin</strong> = gap to neighbours <em>outside</em>; <strong>border</strong> = the line between them.
</Callout>

---

# Flex, grid, and centring

Three primitives that lay out almost every slide.

<div class="grid grid-cols-3 gap-4 pt-2 text-sm">

<div>

<ColHead>flex</ColHead>

Children sit side-by-side in a **row**.

```md
<div class="flex gap-2">
  <div>A</div><div>B</div><div>C</div>
</div>
```

<div class="flex gap-2 bg-slate-100 p-2 mt-1 text-xs">
  <div class="bg-white px-2">A</div>
  <div class="bg-white px-2">B</div>
  <div class="bg-white px-2">C</div>
</div>

</div>

<div>

<ColHead>grid</ColHead>

Children fill **equal cells** in fixed columns.

```md
<div class="grid grid-cols-3 gap-2">
  <div>A</div><div>B</div><div>C</div>
</div>
```

<div class="grid grid-cols-3 gap-2 bg-slate-100 p-2 mt-1 text-xs">
  <div class="bg-white px-2">A</div>
  <div class="bg-white px-2">B</div>
  <div class="bg-white px-2">C</div>
</div>

</div>

<div>

<ColHead>items-center</ColHead>

**Vertically aligns** children of differing height.

```md
<div class="flex items-center gap-2">
  <div>tall<br>tall</div>
  <div>short</div>
</div>
```

<div class="flex items-center gap-2 bg-slate-100 p-2 mt-1 text-xs">
  <div class="bg-white px-2">tall<br>tall</div>
  <div class="bg-white px-2">short</div>
</div>

</div>

</div>

<Callout type="tip">
Pair <code>items-center</code> with <code>justify-center</code> on a <code>flex</code> container — that's <em>perfect</em> centring, vertical and horizontal.
</Callout>

---

# UnoCSS: typography and colour

<div class="grid grid-cols-2 gap-6 pt-2 text-sm">

<div>

<ColHead>Typography</ColHead>

- `text-sm` / `text-base` / `text-lg` / `text-xl` / `text-2xl`
- `font-bold` — heavier weight
- `text-center` — centred text
- `leading-tight` — tighter line height

```md
<div class="text-xl font-bold text-center">
  Big, bold, centred
</div>
```

<div class="text-xl font-bold text-center pt-1">Big, bold, centred</div>

</div>

<div>

<ColHead>Colour</ColHead>

- `text-teal-500` — text colour
- `bg-slate-100` — background colour
- `opacity-60` — fade an element

Colours palette: `a name + a shade` from `50` to `900`.

```md
<div class="text-teal-500 bg-slate-100 opacity-80">
  Teal on slate, slightly faded
</div>
```

<div class="text-teal-500 bg-slate-100 opacity-80 px-2 py-1 text-xs">Teal on slate, slightly faded</div>

</div>

</div>

<Callout type="tip">
Hover any class in the live playground at <strong>unocss.dev/interactive</strong> to see the exact CSS it emits.
</Callout>

---

# UnoCSS: the naming pattern

Every spacing class is built from the same three pieces — read once, then write the rest from memory.

<div class="grid grid-cols-2 gap-6 pt-2 text-sm">

<div>

<ColHead>Anatomy of a class</ColHead>

<div class="font-mono pt-2 pb-1" style="font-size: 1.2rem; letter-spacing: 0.05em;">
<span class="opacity-50">-</span><span class="text-teal-500">m</span><span class="text-amber-500">t</span><span class="opacity-50">-</span><span class="text-violet-500">12</span>
</div>

- <span class="opacity-50">**-**</span> &nbsp; optional — makes the value negative
- <span class="text-teal-500">**m**</span> &nbsp; **p** padding · **m** margin
- <span class="text-amber-500">**t**</span> &nbsp; side: **t b l r**, **x** (l+r), **y** (t+b), or none
- <span class="text-violet-500">**12**</span> &nbsp; step on the 0.25rem scale

</div>

<div>

<ColHead>The step scale</ColHead>

Each step adds **0.25rem** (≈ 4px), so the number stays small even at large sizes.

| step | rem      | px   |
| ---- | -------- | ---- |
| `1`  | 0.25rem  | 4px  |
| `3`  | 0.75rem  | 12px |
| `4`  | 1rem     | 16px |

</div>

</div>

<Callout type="tip">
A negative margin like <code>-mt-16</code> <em>pulls</em> the next element upward — the trick for closing a gap left by a scaled-down card above.
</Callout>

---

# When a slide overflows

Slidev slides are **fixed-size canvases** (1280×720), not scrollable pages. When content runs past the edge, you have two clean options.

<div class="grid grid-cols-2 gap-6 pt-2 text-sm">

<div>

<ColHead>1 · Shrink the whole slide</ColHead>

Add `zoom` to the slide's frontmatter:

```yaml
---
zoom: 0.85
---
```

`0.7`–`0.95` is the sweet spot when content is just slightly too tall. Preferable for a talk — the audience never sees a scrollbar.

</div>

<div>

<ColHead>2 · Scroll inside the slide</ColHead>

Wrap the overflowing region:

```html
<div class="h-full overflow-y-auto">
  …long content…
</div>
```

Or scope scroll to one block with a fixed cap:

```html
<div class="max-h-80 overflow-y-auto">…</div>
```

</div>

</div>

<div class="pt-3 text-sm opacity-80">
Need to shrink a <em>single</em> element instead of the slide? Reach for <code>transform scale-80 origin-top</code> — same idea as <code>zoom</code>, but localised.
</div>

<Callout type="note">
For a defence or conference deck, reach for <code>zoom:</code> first. A scrollbar mid-slide tends to surprise the audience.
</Callout>

---

# Scoped slide styles

Need real CSS? Add a `<style>` block — it is scoped to **this slide only**:

<div class="demo-box">
This box is styled by a &lt;style&gt; block living on this very slide.
</div>

```md
<style>
.demo-box { background: teal; color: white; }
</style>
```

<style>
.demo-box {
  margin: 1.4rem 0;
  padding: 1.1rem 1.3rem;
  border-radius: 14px;
  background: linear-gradient(120deg, #1e6e8c, #2b90b6);
  color: #fff;
  font-weight: 600;
}
</style>

---

# The global context

Every slide can read Slidev's reactive state inside `{{ }}` expressions:

<div class="text-2xl pt-3 pb-2">
You are on slide <strong>{{ $page }}</strong> of <strong>{{ $nav.total }}</strong>.
</div>

<div class="flex flex-col gap-1 pt-2 text-lg">
  <div><code>$page</code> &nbsp;—&nbsp; the current slide number</div>
  <div><code>$clicks</code> &nbsp;—&nbsp; clicks made on this slide</div>
  <div><code>$nav</code> &nbsp;—&nbsp; navigate, count slides, jump around</div>
  <div><code>$frontmatter</code> &nbsp;—&nbsp; this slide's frontmatter</div>
</div>

---

# MDC: Markdown Components

With `mdc: true` in the headmatter, Markdown gets more expressive.

Add attributes inline — this word is [accented]{.text-teal-500 .font-bold} using MDC syntax:

```md
This word is [accented]{.text-teal-500 .font-bold} using MDC syntax.
```

Components also gain a block form, opened and closed with `::name::` fences — shown on the next two slides.

---

# MDC in practice

Mix and match these in any Markdown slide:

<div class="grid grid-cols-2 gap-x-6 gap-y-5 pt-3 text-sm">

<div>

**Coloured span**
```md
[teal]{.text-teal-500}
```
→ [teal]{.text-teal-500}

</div>

<div>

**Heading with classes**
```md
## Section {.text-teal-500}
```
<div class="pt-1">

## Section {.text-teal-500}

</div>

</div>

<div>

**Link with classes**
```md
[sli.dev](https://sli.dev){.font-bold}
```
→ [sli.dev](https://sli.dev){.font-bold}

</div>

<div>

**Click-revealed list**
```md
::v-clicks
- First click reveals me
- Second click reveals me
::
```
→ items appear one per click

</div>

</div>

---

# Block components: Callout & FeatureCard

`::Component:: … ::` blocks parse their body as Markdown — lists, links, and code all work inside:

<div class="grid grid-cols-2 gap-x-6 gap-y-2 pt-1 text-xs">

<div>

**Source:**

````md
::Callout{type="tip"}
You can write a **Callout** in pure
Markdown — no Vue tags needed.

- bullets work
- inline `code` works
- so do [links](https://sli.dev) and **bold**
::
````

</div>

<div>

**Renders as:**

::Callout{type="tip"}
You can write a **Callout** in pure Markdown — no Vue tags needed.

- bullets work
- inline `code` works
- so do [links](https://sli.dev) and **bold**
::

</div>

<div>

````md
::FeatureCard{title="Fast" icon="i-carbon-rocket"
  row}
Boots in under a second.
::
````

</div>

<div class="self-start">

::FeatureCard{title="Fast" icon="i-carbon-rocket" row}
Boots in under a second.
::

</div>

</div>

<div class="text-xs pt-1">
<Callout type="note">
Reach for MDC when the content inside a component is still Markdown. Reach for plain HTML/JSX when it isn't.
</Callout>
</div>

---

# Themes

A **theme** restyles your whole deck. Switch with a single line of headmatter:

```md
---
theme: seriph
---
```

Slidev installs the theme for you on the next run. Browse the gallery at **sli.dev/resources/theme-gallery**, or build your own from a custom layout set.

---

# Addons

**Addons** bundle features — components, layouts, behaviours — to share across decks:

```md
---
addons:
  - slidev-addon-tldraw
---
```

Where a *theme* changes how the deck **looks**, an *addon* changes what it can **do**.

---

# Presenter mode

A dedicated view for speaking: the current slide, a preview of the next one, your notes, and a timer — all at once.

<Callout type="try">
Run the dev server and open <code>localhost:3030/presenter</code>, or click the presenter icon in the navigation bar.
</Callout>

Write notes as an HTML comment at the end of a slide, and they appear here beside it.

---

# Draw, annotate, and appear

Slidev has a built-in **drawing toolbar** — sketch on your slides while presenting, and the annotations are saved with the deck.

<Callout type="try">
Hover the navigation bar, click the pen icon to open the drawing tools, then sketch right on this slide.
</Callout>

You can also show your **camera** in a corner and **record** the talk — both from that same navigation bar.

---

# Exporting your deck

Turn the deck into a shareable file:

<div class="flex flex-col gap-2 pt-2 text-lg">
  <div><code>slidev export</code> &nbsp;—&nbsp; a PDF</div>
  <div><code>slidev export --format pptx</code> &nbsp;—&nbsp; a PowerPoint file</div>
  <div><code>slidev export --format png</code> &nbsp;—&nbsp; one image per slide</div>
</div>

<Callout type="note">
Exporting needs the <code>playwright-chromium</code> package — Slidev prompts you to install it the first time.
</Callout>

---

# Deploying as a website

`slidev build` produces a static site in `dist/` that you can host anywhere:

```bash
slidev build
```

Drop the `dist/` folder onto Netlify, Vercel, or GitHub Pages. For a sub-path URL, set the base path:

```bash
slidev build --base /my-talk/
```

---
layout: two-cols
---

# Efficiency cheat sheet

<ColHead>While presenting</ColHead>

<div class="flex flex-col gap-2 pt-3 text-lg">
  <div><KeyCap>Space</KeyCap> next &nbsp;·&nbsp; <KeyCap>←</KeyCap> back</div>
  <div><KeyCap>o</KeyCap> overview &nbsp;·&nbsp; <KeyCap>g</KeyCap> go to slide</div>
  <div><KeyCap>f</KeyCap> fullscreen &nbsp;·&nbsp; <KeyCap>d</KeyCap> dark mode</div>
  <div>Pen icon in the nav bar — draw</div>
</div>

::right::

<div class="pl-8 pt-14">

<ColHead>While building</ColHead>

<div class="flex flex-col gap-2 pt-3 text-lg">
  <div>Edit Markdown — hot reload is instant</div>
  <div><code>/presenter</code> — the speaker view</div>
  <div><code>components/</code> — your components</div>
  <div><code>layouts/</code> — your layouts</div>
  <div><code>slidev export</code> — PDF</div>
  <div><code>slidev build</code> — static site</div>
</div>

</div>

---

# Common Carbon icons

A pocket reference. Use any of these as a component (<code>&lt;carbon-rocket /&gt;</code>) or a UnoCSS class (<code>i-carbon-rocket</code>). Browse the full set at [icones.js.org](https://icones.js.org/collection/carbon).

<div class="grid grid-cols-8 gap-x-4 gap-y-4 pt-4 text-center text-[0.72rem]" style="color: var(--deck-fg)">

<div><div class="i-carbon-rocket text-3xl mx-auto" style="color: var(--deck-accent)"></div>rocket</div>
<div><div class="i-carbon-code text-3xl mx-auto" style="color: var(--deck-accent)"></div>code</div>
<div><div class="i-carbon-tools text-3xl mx-auto" style="color: var(--deck-accent)"></div>tools</div>
<div><div class="i-carbon-idea text-3xl mx-auto" style="color: var(--deck-accent)"></div>idea</div>
<div><div class="i-carbon-edit text-3xl mx-auto" style="color: var(--deck-accent)"></div>edit</div>
<div><div class="i-carbon-pen text-3xl mx-auto" style="color: var(--deck-accent)"></div>pen</div>
<div><div class="i-carbon-search text-3xl mx-auto" style="color: var(--deck-accent)"></div>search</div>
<div><div class="i-carbon-settings text-3xl mx-auto" style="color: var(--deck-accent)"></div>settings</div>

<div><div class="i-carbon-chart-line text-3xl mx-auto" style="color: var(--deck-accent)"></div>chart-line</div>
<div><div class="i-carbon-dashboard text-3xl mx-auto" style="color: var(--deck-accent)"></div>dashboard</div>
<div><div class="i-carbon-analytics text-3xl mx-auto" style="color: var(--deck-accent)"></div>analytics</div>
<div><div class="i-carbon-data-base text-3xl mx-auto" style="color: var(--deck-accent)"></div>data-base</div>
<div><div class="i-carbon-cloud text-3xl mx-auto" style="color: var(--deck-accent)"></div>cloud</div>
<div><div class="i-carbon-api text-3xl mx-auto" style="color: var(--deck-accent)"></div>api</div>
<div><div class="i-carbon-document text-3xl mx-auto" style="color: var(--deck-accent)"></div>document</div>
<div><div class="i-carbon-folder text-3xl mx-auto" style="color: var(--deck-accent)"></div>folder</div>

<div><div class="i-carbon-email text-3xl mx-auto" style="color: var(--deck-accent)"></div>email</div>
<div><div class="i-carbon-chat text-3xl mx-auto" style="color: var(--deck-accent)"></div>chat</div>
<div><div class="i-carbon-notification text-3xl mx-auto" style="color: var(--deck-accent)"></div>notification</div>
<div><div class="i-carbon-user-avatar text-3xl mx-auto" style="color: var(--deck-accent)"></div>user-avatar</div>
<div><div class="i-carbon-group text-3xl mx-auto" style="color: var(--deck-accent)"></div>group</div>
<div><div class="i-carbon-calendar text-3xl mx-auto" style="color: var(--deck-accent)"></div>calendar</div>
<div><div class="i-carbon-time text-3xl mx-auto" style="color: var(--deck-accent)"></div>time</div>
<div><div class="i-carbon-light text-3xl mx-auto" style="color: var(--deck-accent)"></div>light</div>

<div><div class="i-carbon-checkmark text-3xl mx-auto" style="color: var(--deck-accent)"></div>checkmark</div>
<div><div class="i-carbon-close text-3xl mx-auto" style="color: var(--deck-accent)"></div>close</div>
<div><div class="i-carbon-warning text-3xl mx-auto" style="color: var(--deck-accent)"></div>warning</div>
<div><div class="i-carbon-information text-3xl mx-auto" style="color: var(--deck-accent)"></div>information</div>
<div><div class="i-carbon-favorite text-3xl mx-auto" style="color: var(--deck-accent)"></div>favorite</div>
<div><div class="i-carbon-star text-3xl mx-auto" style="color: var(--deck-accent)"></div>star</div>
<div><div class="i-carbon-download text-3xl mx-auto" style="color: var(--deck-accent)"></div>download</div>
<div><div class="i-carbon-share text-3xl mx-auto" style="color: var(--deck-accent)"></div>share</div>

</div>
