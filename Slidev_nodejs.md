---
theme: default
title: The Node.js Ecosystem
titleTemplate: '%s · The Node.js Ecosystem'
info: |
  ## The Node.js Ecosystem — a guided tour
  A beginner-to-advanced tour of JavaScript, Node, package managers, tooling,
  frameworks, and the runtime — built with Slidev.
author: Slidev Tutorial
transition: slide-left
mdc: true
lineNumbers: true
layout: cover
---

# The Node.js Ecosystem

A guided tour — from the language and the runtime to package managers, tooling, frameworks, and how every piece connects

<div class="pt-12 opacity-70 text-sm">
  Press <KeyCap>Space</KeyCap> to begin &nbsp;·&nbsp; <KeyCap>o</KeyCap> for the slide overview
</div>

<!--
This deck uses a portable component toolkit (Callout, FeatureCard, Chips, KeyCap)
and the section / multicolumns layouts, auto-imported at the project level from
components/, layouts/, and styles/.
-->

---
layout: default
---

# What you'll learn

The Node.js ecosystem is a tower of layers — a language, a runtime, a registry, the tools that talk to it, and the frameworks built on top. This tour climbs that tower in four tracks.

<div class="grid grid-cols-2 gap-4 pt-4">

<FeatureCard title="1 · Foundations" icon="i-carbon-application" row>
JavaScript, ECMAScript, V8, Node.js, TypeScript, and the CommonJS-vs-ESM split.
</FeatureCard>

<FeatureCard title="2 · Packages & Managers" icon="i-carbon-box" row>
The npm registry, npm / yarn / pnpm, Corepack, lockfiles, semver, and workspaces.
</FeatureCard>

<FeatureCard title="3 · Tooling & Frameworks" icon="i-carbon-tools" row>
Bundlers, transpilers, linters, test runners, and the frontend / backend frameworks.
</FeatureCard>

<FeatureCard title="4 · Runtime & Deep Dives" icon="i-carbon-flow" row>
The event loop, env & config, plus deep dives on ESM-vs-CJS and the event loop.
</FeatureCard>

</div>

<div class="pt-5">

<Callout type="tip">
Every layer rests on the one above it. The next three slides sketch the whole map in plain terms — so every piece you meet afterward already has a place to land.
</Callout>

</div>

---

# Start with two ideas

<div class="grid grid-cols-2 gap-8 pt-4 items-center">

<div>

```mermaid {scale: 0.9}
flowchart TD
  L["<b>The language</b><br/><span style='font-size:0.8em;opacity:0.75'>JavaScript</span>"]
  R["<b>The runtime</b><br/><span style='font-size:0.8em;opacity:0.75'>Node.js</span>"]
  L --> R
```

</div>

<div>

Before everything else, the ecosystem rests on **two pieces**: a *language* to write in, and a *runtime* to execute it.

You write **JavaScript** — a set of rules for writing programs. **Node.js** is a program that reads JavaScript and runs it.

Every other tool in this tour exists to make that pairing more productive.

</div>

</div>

---

# Add where the code comes from

<div class="grid grid-cols-2 gap-8 pt-2 items-center">

<div>

```mermaid {scale: 0.6}
flowchart TD
  L["The language<br/><span style='font-size:0.8em;opacity:0.75'>JavaScript</span>"] --> R["The runtime<br/><span style='font-size:0.8em;opacity:0.75'>Node.js</span>"]
  R --> Reg["The registry<br/><span style='font-size:0.8em;opacity:0.75'>npm.org —<br/>a global store of reusable code</span>"]
  Reg --> Mgr["A package manager<br/><span style='font-size:0.8em;opacity:0.75'>npm / yarn / pnpm —<br/>downloads from the registry</span>"]
  Mgr --> Mod["node_modules + lockfile<br/><span style='font-size:0.8em;opacity:0.75'>your project's downloaded code</span>"]
```

</div>

<div>

Real projects build on the work of others. The **registry** is the warehouse. A **package manager** is the truck that brings what you asked for into your project's `node_modules/` folder.

The **lockfile** is the receipt — it records exactly which versions arrived, so the same install gives the same result on every machine.

<Callout type="note">
This is where most of <em>your</em> code lives too — published as a package, or sitting next to your <code>package.json</code>.
</Callout>

</div>

</div>

---

# Add what turns source into an app

<div class="grid grid-cols-2 gap-8 pt-2 items-center">

<div>

```mermaid {scale: 0.45}
flowchart TD
  L["JavaScript"] --> R["Node.js"]
  R --> Reg["npm.org<br/><span style='font-size:0.85em;opacity:0.7'>registry</span>"]
  Reg --> Mgr["npm / yarn / pnpm<br/><span style='font-size:0.85em;opacity:0.7'>package manager</span>"]
  Mgr --> Mod["node_modules + lockfile"]
  Mod --> Build["Vite / webpack / esbuild<br/><span style='font-size:0.85em;opacity:0.7'>build tools</span>"]
  Build --> Fw["React / Vue / Svelte<br/><span style='font-size:0.85em;opacity:0.7'>framework</span>"]
  Fw --> App["Your app<br/><span style='font-size:0.85em;opacity:0.7'>e.g. Slidev sits here</span>"]
```

</div>

<div>

That's the full tower.

**Build tools** combine your code with its dependencies into something a browser can load.

A **framework** is the largest of those dependencies — the skeleton your app hangs on.

**Your app** is the last layer. Slidev (this deck) sits exactly there.

<Callout type="tip">
The remaining slides zoom in on each box and name the trade-offs. You'll see this map again at the end as a single picture.
</Callout>

</div>

</div>

---
src: ./pages/nodejs/01-foundations.md
---

---
src: ./pages/nodejs/02-packages.md
---

---
src: ./pages/nodejs/03-tooling.md
---

---
src: ./pages/nodejs/04-runtime.md
---
