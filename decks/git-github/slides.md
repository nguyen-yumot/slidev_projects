---
theme: default
addons: ['deck-core', 'deck-variant-print']
title: Git & GitHub for Beginners
info: |
  ## Git & GitHub for Beginners
  A hands-on, beginner-to-advanced path through version control: what Git is,
  how GitHub fits in, and the daily workflow that keeps your code (and your
  AI experiments) safe. Built with Slidev.
author: Nguyen Huu Phuc
transition: slide-left
mdc: true
lineNumbers: true
layout: cover
---

# Git & GitHub for Beginners

From your first commit to branches, Pull Requests, and a safety net for the AI era, all in one hands-on path

<div class="pt-12 opacity-70 text-sm">
  Press <KeyCap>Space</KeyCap> to begin &nbsp;·&nbsp; <KeyCap>o</KeyCap> for the slide overview
</div>

<!--
Welcome. This deck is a self-contained, beginner-friendly course in Git and GitHub:
what version control is, the four places your code lives, the everyday commands, and
the branches, Pull Requests, and safety nets that let you experiment without fear,
especially when an AI agent is writing the code. Press Space to begin.
-->

---
layout: default
---

# What you'll learn

One continuous path, in eight short stops, each building on the one before it.

<div class="grid grid-cols-2 gap-x-12 gap-y-5 pt-5 text-lg">

<div class="flex items-baseline gap-3 col-span-2 pb-3 mb-1 border-b border-black/10 dark:border-white/10">
  <span class="font-mono text-sm opacity-40">0</span>
  <span><span class="font-semibold">Get set up</span> <span class="opacity-55 text-sm">· install Git + a GitHub account</span></span>
</div>

<div class="flex items-baseline gap-3">
  <span class="font-mono text-sm opacity-40">01</span>
  <span><span class="font-semibold">Fundamentals</span> <span class="opacity-55 text-sm">· Git vs. GitHub</span></span>
</div>

<div class="flex items-baseline gap-3">
  <span class="font-mono text-sm opacity-40">02</span>
  <span><span class="font-semibold">The four locations</span> <span class="opacity-55 text-sm">· where code lives</span></span>
</div>

<div class="flex items-baseline gap-3">
  <span class="font-mono text-sm opacity-40">03</span>
  <span><span class="font-semibold">The local workflow</span> <span class="opacity-55 text-sm">· init → add → commit</span></span>
</div>

<div class="flex items-baseline gap-3">
  <span class="font-mono text-sm opacity-40">04</span>
  <span><span class="font-semibold">GitHub &amp; syncing</span> <span class="opacity-55 text-sm">· push, pull, fetch</span></span>
</div>

<div class="flex items-baseline gap-3">
  <span class="font-mono text-sm opacity-40">05</span>
  <span><span class="font-semibold">Branching &amp; PRs</span> <span class="opacity-55 text-sm">· merge &amp; review</span></span>
</div>

<div class="flex items-baseline gap-3">
  <span class="font-mono text-sm opacity-40">06</span>
  <span><span class="font-semibold">Safety nets</span> <span class="opacity-55 text-sm">· undo anything</span></span>
</div>

<div class="flex items-baseline gap-3">
  <span class="font-mono text-sm opacity-40">07</span>
  <span><span class="font-semibold">Setup &amp; security</span> <span class="opacity-55 text-sm">· SSH &amp; secrets</span></span>
</div>

<div class="flex items-baseline gap-3">
  <span class="font-mono text-sm opacity-40">08</span>
  <span><span class="font-semibold">Best practices &amp; tools</span> <span class="opacity-55 text-sm">· habits &amp; cheat-sheet</span></span>
</div>

</div>

<div class="pt-10">

<Callout type="tip">
Every command is shown running on the slide that explains it. Press <KeyCap>o</KeyCap> any time to see all slides at once and jump around, handy as a reference later.
</Callout>

</div>

<!--
Presenter note: this is the map of the whole talk. Each numbered stop is one section
file. You don't have to memorise it. Slide `o` brings this overview back any time.
-->

---
layout: default
---

# The whole map, at a glance

Eight stops in one picture, the path from the fundamentals out to the tools that build on them.

<div class="flex justify-center pt-3">
<img :src="'/mind-map-light.svg'" alt="Mind map: a central 'Git & GitHub' hub branching to the deck's eight sections (Fundamentals, the four locations, the local workflow, GitHub & syncing, branching & PRs, safety nets, setup & security, and best practices & tools), each labelled with its key commands and concepts." class="block dark:hidden w-full" style="max-width: 920px;" />
<img :src="'/mind-map-dark.svg'" alt="" aria-hidden="true" class="hidden dark:block w-full" style="max-width: 920px;" />
</div>

<!--
Presenter note: the overview. Each branch is one section of this deck, and we walk them
left to right. Press o any time to jump straight to the section you need.
-->

---
src: ./pages/00-glossary.md
---

---
src: ./pages/01-fundamentals.md
---

---
src: ./pages/02-locations.md
---

---
src: ./pages/02b-getting-started.md
---

---
src: ./pages/02c-first-sync.md
---

---
src: ./pages/03-local-workflow.md
---

---
src: ./pages/04-github-syncing.md
---

---
src: ./pages/05-branching-prs.md
---

---
src: ./pages/06-safety-nets.md
---

---
src: ./pages/07-setup-security.md
---

---
src: ./pages/08-best-practices-tools.md
---
