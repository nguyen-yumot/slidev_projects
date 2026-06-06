---
layout: section
---

<Eyebrow>Part 1</Eyebrow>

# Beginner

Slidev fundamentals — from an empty folder to your first polished, running deck.

---

# What is Slidev?

**Slidev** (slide + dev) is a presentation tool made for developers. You write your whole deck in a Markdown file, and Slidev renders it as a real web page powered by Vue and Vite.

<div class="grid grid-cols-2 gap-4 pt-4">

<FeatureCard title="Markdown-first" icon="i-carbon-edit">
Your deck is plain text — fast to write, easy to diff, and friendly to version control.
</FeatureCard>

<FeatureCard title="Web-powered" icon="i-carbon-application-web">
Slides are HTML. Anything the web can do, your slide can do — including this tutorial.
</FeatureCard>

</div>

<Callout type="tip">
You are reading a Slidev deck right now. Every feature in this tutorial runs live on the slide that explains it.
</Callout>

<!--
Presenter note: Slidev is open source and developer-focused. The core idea is
"presentations as code" — your slides live alongside your work, in your editor.
-->

---

# Installing pnpm

Slidev's docs use **pnpm** — a fast, disk-efficient package manager. Pick the line that matches your OS:

```bash
# macOS (Homebrew)
brew install pnpm

# macOS / Linux (install script)
curl -fsSL https://get.pnpm.io/install.sh | sh -

# Windows (PowerShell)
iwr https://get.pnpm.io/install.ps1 -useb | iex

# Already have Node 18+? Enable the bundled version
corepack enable
```

Restart your terminal, then check it works with `pnpm --version`.

<Callout type="note">
Prefer <code>npm</code> or <code>yarn</code>? They work too — swap <code>pnpm</code> for <code>npm</code> or <code>yarn</code> in any command in this tutorial.
</Callout>

---

# Install and run

Scaffold a new project, then start the dev server:

```bash
# create a new deck — you'll be asked for a folder name
pnpm create slidev

# move into the project, then start it
pnpm dev
```

Slidev opens at **localhost:3030** with instant hot-reload: edit the Markdown, and the slide updates as you type.

<Callout type="tip">
If <code>pnpm</code> isn't found, see the previous slide to install it.
</Callout>

---

# One file is your whole deck

A Slidev deck lives in a single `slides.md`. Slides are separated by `---` on its own line:

```md
# First slide

Hello there!

---

# Second slide

Welcome 👋
```

Three dashes, and you're on the next slide. That simple rule is the entire structure of a deck.

---

# Headmatter vs. frontmatter

Both use `---`, but they do different jobs. The **first** block configures the whole deck. **Every later** block configures only its own slide.

```md
---
theme: default      # headmatter — applies to the whole deck
title: My Talk
---

# Opening slide

---
layout: center      # frontmatter — applies to THIS slide only
---

# A centered slide
```

<div class="grid grid-cols-2 gap-4 pt-2">
<Callout type="note" title="Headmatter">
The very first <code>---</code> block. Theme, title, fonts, transitions.
</Callout>
<Callout type="note" title="Frontmatter">
Any later <code>---</code> block. Layout, classes, per-slide options.
</Callout>
</div>

---
layout: two-cols
---

# Plain Markdown

Headings, **bold**, *italic*, lists, `inline code`, [links](https://sli.dev), blockquotes, and tables — all the Markdown you already know works on a slide.

The source on the left renders as the slide on the right.

```md
## A heading

- A bullet point
- With **bold** and `code`

> A short blockquote
```

::right::

<div class="pl-8 pt-20">

## A heading

- A bullet point
- With **bold** and `code`

> A short blockquote

</div>

---

# Layouts: a frame for each slide

A **layout** decides how a slide is arranged. Set it with the `layout:` frontmatter key — otherwise you get the `default` layout.

<div class="grid grid-cols-3 gap-3 pt-4 text-center text-sm">
  <div class="deck-chip">default</div>
  <div class="deck-chip">cover</div>
  <div class="deck-chip">center</div>
  <div class="deck-chip">two-cols</div>
  <div class="deck-chip">image-right</div>
  <div class="deck-chip">image-left</div>
  <div class="deck-chip">fact</div>
  <div class="deck-chip">quote</div>
  <div class="deck-chip">section</div>
</div>

The next few slides each *use* one of these layouts, so you see exactly what it does.

---
layout: center
class: text-center
---

# This slide uses `layout: center`

Content sits in the middle of the screen — perfect for a single statement or a section break.

---
layout: two-cols
---

# `layout: two-cols`

The slide body fills the **left** column.

Add a `::right::` marker, and everything after it flows into the **right** column.

::right::

<div class="pl-8 pt-14">

```md
---
layout: two-cols
---

# Left side

content here

::right::

# Right side

content here
```

</div>

---
layout: image-right
image: /tutorial/slidev-logo.png
---

# Picture beside content

The `image-right` layout puts an image on one side and your words on the other. Choose the picture with the `image:` key:

```md
---
layout: image-right
image: /tutorial/slidev-logo.png
---
```

Use `layout: image-left` to flip the image to the other side.

---
layout: fact
---

# 1

The number of files you need to start a Slidev deck — your `slides.md`.

---
layout: quote
---

# "The best deck is the one you can edit like code."

The Slidev philosophy

---

# Speaker notes

End any slide with an HTML comment. It never appears on the slide itself — only in **presenter mode**, where you can read it while you talk.

```md
# My slide

The content the audience sees

<!-- A private note, just for you, the speaker. -->
```

<Callout type="tip">
Open presenter mode at <code>localhost:3030/presenter</code>, or click the presenter icon in the navigation bar.
</Callout>

<!--
This slide has a real speaker note — and this is it. In presenter mode you would
see this text beside the slide. Try it: run the deck and open /presenter.
-->

---

# Getting around your deck

<div class="grid grid-cols-2 gap-x-10 gap-y-3 pt-2 text-lg">

<div><KeyCap>Space</KeyCap> / <KeyCap>→</KeyCap> &nbsp; Next animation or slide</div>
<div><KeyCap>←</KeyCap> &nbsp; Go back</div>
<div><KeyCap>o</KeyCap> &nbsp; Slide overview — see them all</div>
<div><KeyCap>f</KeyCap> &nbsp; Toggle fullscreen</div>
<div><KeyCap>d</KeyCap> &nbsp; Toggle dark mode</div>
<div><KeyCap>g</KeyCap> &nbsp; Jump to a slide by number</div>

</div>

<Callout type="tip">
Hover the bottom-left corner of any slide to reveal a navigation bar with the same controls.
</Callout>

---

# The navigation bar

Hover the bottom-left corner of any slide. A toolbar appears, grouped by purpose — most buttons also have a keyboard shortcut.

<div class="grid grid-cols-2 gap-x-10 gap-y-2 pt-3 text-sm items-start">

<div>

<ColHead>Navigate</ColHead>

<div class="flex items-center gap-3 pt-1"><span class="i-carbon-maximize inline-block text-lg"></span> Fullscreen <KeyCap>f</KeyCap></div>
<div class="flex items-center gap-3"><span class="inline-flex items-center"><span class="i-carbon-arrow-left inline-block text-lg"></span><span class="i-carbon-arrow-right inline-block text-lg"></span></span> Previous / next slide</div>
<div class="flex items-center gap-3"><span class="i-carbon-apps inline-block text-lg"></span> Slide overview <KeyCap>o</KeyCap></div>
<div class="flex items-center gap-3"><span class="i-carbon-sun inline-block text-lg"></span> Toggle light / dark <KeyCap>d</KeyCap></div>

<ColHead class="pt-4">Capture &amp; annotate</ColHead>

<div class="flex items-center gap-3 pt-1"><span class="i-carbon-user-avatar inline-block text-lg"></span> Camera overlay in a corner</div>
<div class="flex items-center gap-3"><span class="i-carbon-video inline-block text-lg"></span> Screen recording</div>
<div class="flex items-center gap-3"><span class="i-carbon-pen inline-block text-lg"></span> Drawing tools — annotate live</div>

</div>

<div>

<ColHead>Modes &amp; export</ColHead>

<div class="flex items-center gap-3 pt-1"><span class="i-carbon-user-speaker inline-block text-lg"></span> Enter presenter mode</div>
<div class="flex items-center gap-3"><span class="i-carbon-text-annotation-toggle inline-block text-lg"></span> Toggle editor <span class="opacity-50 text-xs">· dev only</span></div>
<div class="flex items-center gap-3"><span class="i-carbon-document-pdf inline-block text-lg"></span> Browser exporter / PDF</div>
<div class="flex items-center gap-3"><span class="i-carbon-information inline-block text-lg"></span> Info dialog</div>

<ColHead class="pt-4">Connect &amp; settings</ColHead>

<div class="flex items-center gap-3 pt-1"><span class="inline-flex items-center"><span class="i-ph-arrow-up-bold inline-block text-lg text-green-600"></span><span class="i-ph-arrow-down-bold inline-block text-lg opacity-40"></span></span> Presenter sync status</div>
<div class="flex items-center gap-3"><span class="i-carbon-settings-adjust inline-block text-lg"></span> More options menu</div>
<div class="flex items-center gap-3"><span class="deck-chip">{{ $page }}/{{ $nav.total }}</span> Click to jump to a slide</div>

</div>

</div>

<div class="pt-6">

<Callout type="tip">
The bar adapts to context: recording controls disappear in presenter mode, and the green sync arrows light up only when a presenter session is connected.
</Callout>

</div>

---
layout: center
class: text-center
---

# You can build a deck now

Install Slidev, write Markdown, pick a layout, and present. That's a complete workflow.

Next: make those slides **interactive**.
