---
layout: section
---

<Eyebrow>Part 3</Eyebrow>

# Tooling & Frameworks

How source becomes something a browser can run — and the libraries that shape the app itself.

---

# Bundlers: many files → a few

Browsers want a handful of optimized files, but you write dozens of small modules plus dependencies. A **bundler** combines and optimizes them.

<div class="grid grid-cols-2 gap-4 pt-4">

<FeatureCard title="webpack" icon="i-carbon-box">
The old guard. Hugely configurable, powered a generation of apps.
</FeatureCard>

<FeatureCard title="Rollup" icon="i-carbon-tree-view">
Library-focused, produces clean output. The basis of many other tools.
</FeatureCard>

<FeatureCard title="esbuild" icon="i-carbon-lightning">
Extremely fast, written in Go.
</FeatureCard>

<FeatureCard title="Vite" icon="i-carbon-flash-filled">
The modern default — built on esbuild + Rollup. <strong>Slidev runs on Vite.</strong>
</FeatureCard>

</div>

<Callout type="tip">
When something surprises you in Slidev, the cause is often inherited from Vite, not Slidev itself.
</Callout>

---
layout: multicolumns
---

# The supporting toolchain

Three more tool categories sit between your source and a shippable app.

<template #col1>

<ColHead>Transpilers</ColHead>

Convert newer / non-standard JS (TypeScript, JSX, ES2024) into older JS browsers understand.

<Chips>Babel, swc, esbuild</Chips>

<div class="pt-1 text-sm opacity-75">

Babel is the classic; swc (Rust) and esbuild (Go) are the fast newcomers.

</div>

</template>

<template #col2>

<ColHead>Lint &amp; format</ColHead>

Two *separate* jobs, often confused:

- **ESLint** — catches bugs and questionable patterns.
- **Prettier** — only formats; opinions about spacing, not logic.

</template>

<template #col3>

<ColHead>Test runners</ColHead>

Run your tests and report results.

<Chips>Vitest, Jest, Mocha, node --test</Chips>

<div class="pt-1 text-sm opacity-75">

Vitest is Vite-integrated and modern; Jest is still huge; Node now has a built-in runner.

</div>

</template>

---

# Frontend frameworks

The UI layer. All produce HTML/DOM, but with different mental models.

<div class="grid grid-cols-3 gap-4 pt-4">

<FeatureCard title="React" icon="i-carbon-logo-react">
2013, Facebook. The dominant UI library. Components in JSX. Minimal by design — you assemble routing and data fetching yourself.
</FeatureCard>

<FeatureCard title="Vue" icon="i-carbon-cube">
More template-oriented, gentle learning curve. <strong>Slidev is built on Vue</strong> — which is why slides can embed Vue components.
</FeatureCard>

<FeatureCard title="Svelte" icon="i-carbon-magic-wand">
Compiler-based — compiles components away at build time, so little runtime framework code ships.
</FeatureCard>

</div>

<Callout type="note">
<strong>Solid</strong>, <strong>Preact</strong>, and <strong>Lit</strong> fill smaller niches with different trade-offs. The big two by sheer usage are React and Vue.
</Callout>

---

# Meta-frameworks

Frameworks give you components. **Meta-frameworks** sit on top and add routing, server-side rendering, and file-based pages — the scaffolding of a real app.

<div class="grid grid-cols-2 gap-4 pt-4">

<FeatureCard title="Next.js" icon="i-carbon-application" row>
On React — by far the biggest meta-framework.
</FeatureCard>

<FeatureCard title="Nuxt" icon="i-carbon-cube" row>
On Vue.
</FeatureCard>

<FeatureCard title="SvelteKit" icon="i-carbon-magic-wand" row>
On Svelte.
</FeatureCard>

<FeatureCard title="Astro" icon="i-carbon-string-text" row>
Multi-framework — mix React, Vue, and Svelte in one site.
</FeatureCard>

</div>

<Callout type="tip">
<strong>Slidev itself is a meta-framework</strong> — a Vite + Vue app specialized for presentations. You've been looking at one this whole time.
</Callout>

---

# Backend frameworks

On the server, frameworks handle HTTP routing, middleware, and request/response plumbing.

<div class="grid grid-cols-2 gap-6 pt-4">

<div>

<FeatureCard title="Express" icon="i-carbon-tree-view-alt">
The classic minimal HTTP framework. Still everywhere, still the reference most others are measured against.
</FeatureCard>

</div>

<div>

<ColHead>The alternatives</ColHead>

<Chips>Fastify, Koa, Hono, NestJS</Chips>

<div class="pt-2 text-sm opacity-80">

Different trade-offs: **Fastify** for speed, **Koa** for a lean modern core, **Hono** for edge runtimes, **NestJS** for opinionated structure.

</div>

</div>

</div>

<Callout type="note">
The same language runs both ends. The frontend frameworks above and these backend ones are all just npm packages — fetched by the managers from Part 2.
</Callout>
