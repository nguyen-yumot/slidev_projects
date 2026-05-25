---
theme: default
title: Slidev Deck Template
info: |
  A Slidev starter with a portable component toolkit.
  Replace this example deck with your own content.
transition: slide-left
mdc: true
lineNumbers: true
layout: cover
---

# Slidev Deck Template

A starting point with a reusable component toolkit — replace these slides with your own

<div class="pt-12 opacity-70 text-sm">
  Press <KeyCap>Space</KeyCap> to begin &nbsp;·&nbsp; <KeyCap>o</KeyCap> for the slide overview
</div>

<!--
This is the template's example deck. It exercises every toolkit piece so you can see
them rendered. Delete these slides and write your own — the components, layouts, and
styles are auto-imported at the project level from components/, layouts/, and styles/.
-->

---
layout: default
---

# Components at a glance

<div class="grid grid-cols-2 gap-4 pt-4">

<FeatureCard title="Callout" icon="i-carbon-chat" row>
Coloured advice boxes — <code>type</code> of tip, warning, note, or try.
</FeatureCard>

<FeatureCard title="FeatureCard" icon="i-carbon-grid" row>
Titled cards for overviews, with an optional icon. (You're looking at four.)
</FeatureCard>

<FeatureCard title="KeyCap / KeyCaps" icon="i-carbon-keyboard" row>
Render keys as caps: <KeyCap>o</KeyCap> and <KeyCaps>Space,→</KeyCaps>.
</FeatureCard>

<FeatureCard title="Chip / Chips" icon="i-carbon-tag" row>
Monospace pills: <Chips>default, cover, center</Chips>.
</FeatureCard>

</div>

<div class="pt-5">

<Callout type="tip">
Edit any <code>.md</code> and the dev server hot-reloads. Set a per-slide layout with the <code>layout:</code> frontmatter key.
</Callout>

</div>

---
layout: section
---

<Eyebrow>Section divider</Eyebrow>

# Open a new part with "layout: section"

A full-bleed gradient divider to mark the start of a track.

---
layout: multicolumns
---

# Dense reference with `layout: multicolumns`

<template #col1>
<ColHead>Navigate</ColHead>

<KeyCaps>Space,→</KeyCaps> next
<KeyCap>o</KeyCap> overview
</template>

<template #col2>
<ColHead>Present</ColHead>

<KeyCap>f</KeyCap> fullscreen
<KeyCap>g</KeyCap> go to slide
</template>

<template #col3>
<ColHead>Theme</ColHead>

Override <code>--deck-accent</code> and friends in <code>styles/</code>.
</template>

---
src: ./pages/example.md
---
