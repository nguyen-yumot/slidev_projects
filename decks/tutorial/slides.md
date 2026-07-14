---
theme: default
addons: ['deck-core', 'deck-variant-glass']
title: Slidev Tutorial — Beginner to Advanced
info: |
  ## Slidev Tutorial
  An interactive, beginner-to-advanced guide to Slidev — built with Slidev itself.
author: Slidev Tutorial
transition: slide-left
mdc: true
lineNumbers: true
layout: cover
---

# Slidev Tutorial

From your first slide to advanced mastery — a hands-on guide, built with Slidev itself

<div class="pt-12 opacity-70 text-sm">
  Press <KeyCap>Space</KeyCap> to begin &nbsp;·&nbsp; <KeyCap>o</KeyCap> for the slide overview
</div>

<!--
Welcome. This deck teaches Slidev using Slidev — every feature you read about is
running live on the slide in front of you. Press Space to move forward.
-->

---
layout: default
---

# What you'll learn

This tutorial is one continuous path, split into four tracks. Every feature is demonstrated live on the slide that explains it.

<div class="grid grid-cols-2 gap-4 pt-4 wyl-cards">

<Link to="part-1">

<FeatureCard title="1 · Beginner" icon="i-carbon-rocket" row interactive>
Install Slidev, write Markdown, master the built-in layouts.
</FeatureCard>

</Link>

<Link to="part-2">

<FeatureCard title="2 · Intermediate" icon="i-carbon-code" row interactive>
Click animations, live code, diagrams, math, icons, and media.
</FeatureCard>

</Link>

<Link to="part-3">

<FeatureCard title="3 · Advanced" icon="i-carbon-tools" row interactive>
Custom layouts and components, theming, exporting, cheat sheet.
</FeatureCard>

</Link>

<Link to="part-4">

<FeatureCard title="4 · Toolkit" icon="i-carbon-cube" row interactive>
The deck's own component library — and how to grow your own.
</FeatureCard>

</Link>

</div>

<style>
/* Each "What you'll learn" card is a clickable jump target: strip the default
   link styling — accent colour, and Slidev's dashed border-bottom "underline"
   (client styles/layouts-base.css) — so only the card's own styling shows. */
.slidev-layout .wyl-cards a {
  display: block;
  height: 100%;
  text-decoration: none;
  color: inherit;
  border: none;
}
</style>

<div class="pt-5">

<Callout type="tip">
The whole tutorial <strong>is</strong> a Slidev deck. Press <KeyCap>o</KeyCap> at any time to see every slide at once and jump around — handy as a reference later.
</Callout>

</div>

---
src: ./pages/01-beginner.md
---

---
src: ./pages/02-intermediate.md
---

---
src: ./pages/03-advanced.md
---

---
src: ./pages/04-toolkit.md
---
