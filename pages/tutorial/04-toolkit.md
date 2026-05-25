---
layout: section
---

<Eyebrow>Part 4</Eyebrow>

# Toolkit

The deck's own component library — what it is, and how to grow your own.

<!-- Content slides for the toolkit track. -->

---

# Why a deck has a toolkit

When the same small pattern appears on several slides, give it a name. This deck does:

<div class="grid grid-cols-2 gap-4 pt-3">

<FeatureCard title="Components" icon="i-carbon-cube">
Drop a <code>.vue</code> file in <code>components/</code> — Slidev auto-imports it. Use it by filename, anywhere in your Markdown.
</FeatureCard>

<FeatureCard title="Layouts" icon="i-carbon-template">
Drop a <code>.vue</code> file in <code>layouts/</code> — select it per slide with <code>layout:</code>.
</FeatureCard>

</div>

---

# `<Chip>` — a labelled pill

A monospace pill for naming layouts, features, keys — anything you want to call out without a full sentence.

<div class="flex flex-wrap gap-2 pt-3 pb-1">
  <Chip>default</Chip>
  <Chip>cover</Chip>
  <Chip>center</Chip>
  <Chip>two-cols</Chip>
  <Chip>image-right</Chip>
  <Chip>fact</Chip>
</div>

```md
<div class="flex flex-wrap gap-2">
  <Chip>default</Chip>
  <Chip>cover</Chip>
  <Chip>center</Chip>
</div>
```

<Callout type="note">
<code>&lt;Chip&gt;</code> only styles itself — wrapping a row of them in <code>flex flex-wrap gap-2</code> is the parent's job. Same idea as <code>&lt;KeyCap&gt;</code>. For a comma-separated row, reach for <code>&lt;Chips&gt;</code>.
</Callout>

---

# `<Chips>` — pills from a comma-separated list

Put your labels in the slot, separated by commas. Chips renders one `<Chip>` per item — the plural of `<Chip>`, already laid out in a wrapping row:

<div class="pt-3 pb-1">
  <Chips>default, cover, center, two-cols, image-right, fact</Chips>
</div>

```md
<Chips>default, cover, center</Chips>
```

<Callout type="tip">
<code>&lt;Chip&gt;</code> is the single pill; <code>&lt;Chips&gt;</code> is the comma-list shorthand. Same relationship as <code>&lt;KeyCap&gt;</code> and <code>&lt;KeyCaps&gt;</code>.
</Callout>

---

# `<KeyCaps>` — keycaps from a comma-separated list

Put your keys in the slot, separated by commas. KeyCaps renders one keycap per key — the plural of `<KeyCap>`. Whatever label you want goes right after the tag:

<div class="grid grid-cols-2 gap-x-10 gap-y-3 pt-4">
  <div><KeyCaps>o</KeyCaps> Slide overview</div>
  <div><KeyCaps>f</KeyCaps> Toggle fullscreen</div>
  <div><KeyCaps>Space,→</KeyCaps> Next animation or slide</div>
  <div><KeyCaps>d</KeyCaps> Toggle dark mode</div>
</div>

```md
<KeyCaps>o</KeyCaps> Slide overview
<KeyCaps>Space,→</KeyCaps> Next animation or slide
```

<Callout type="tip">
For a single key, <code>&lt;KeyCaps&gt;o&lt;/KeyCaps&gt;</code> and <code>&lt;KeyCap&gt;o&lt;/KeyCap&gt;</code> are equivalent. KeyCaps earns its keep when the list has more than one.
</Callout>

---
layout: multicolumns
---

# `layouts/multicolumns.vue` — this slide is using it

A four-column reference layout. Define `#col1`–`#col4`; the layout counts the filled ones and picks the grid. Two columns? It draws two. Four? It draws four.

<template #col1>

<ColHead>Define</ColHead>

```md
---
layout: multicolumns
---

# Heading

<template #col1>...</template>
<template #col2>...</template>
```

</template>

<template #col2>

<ColHead>Navigate</ColHead>

<div class="flex flex-col gap-1.5 pt-1">
  <div><KeyCaps>o</KeyCaps> Overview</div>
  <div><KeyCaps>f</KeyCaps> Fullscreen</div>
  <div><KeyCaps>d</KeyCaps> Dark mode</div>
</div>

</template>

<template #col3>

<ColHead>Style</ColHead>

- `--deck-accent` — accent colour
- `--deck-accent-deep` — gradient deep
- `--deck-radius` — corner radius
- Carbon icons via `i-carbon-*`

</template>

<template #col4>

<ColHead>Compose</ColHead>

<Chips class="pt-1">Chip, Chips, KeyCaps, Callout, FeatureCard</Chips>

</template>

---

# Build your own

When a pattern shows up three times, name it. The recipe is short:

<div class="grid grid-cols-2 gap-6 pt-3">

<FeatureCard title="A component" icon="i-carbon-cube">
Add a <code>.vue</code> file to <code>components/</code>. Use it by filename anywhere in your Markdown — Slidev auto-imports it.
</FeatureCard>

<FeatureCard title="A layout" icon="i-carbon-template">
Add a <code>.vue</code> file with a <code>&lt;slot /&gt;</code> to <code>layouts/</code>. Select it on a slide with the <code>layout:</code> frontmatter key.
</FeatureCard>

</div>

<Callout type="try">
Open <code>components/Chip.vue</code> as a starting template — a header comment, a slot, and a handful of CSS rules. Copy it, rename it, and you have your own.
</Callout>

---
layout: center
class: text-center
---

# You have a toolkit now

Three new pieces, all extracted from patterns that were already in this deck.

<div class="pt-6 opacity-70 text-sm">
Reach for them on the next slide you write — or grow your own.
</div>

---
layout: center
class: text-center
---

# You've mastered Slidev

From your first `---` separator to custom layouts, live code, and a deployed site.

<div class="flex gap-8 justify-center pt-6 text-lg">
  <a href="https://sli.dev" target="_blank">Documentation</a>
  <a href="https://sli.dev/resources/theme-gallery" target="_blank">Themes</a>
  <a href="https://sli.dev/resources/showcases" target="_blank">Showcases</a>
</div>

<div class="pt-10 opacity-60 text-sm">
Now go build something worth presenting.
</div>
