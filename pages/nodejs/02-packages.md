---
layout: section
---

<Eyebrow>Part 2</Eyebrow>

# Packages & Managers

Where reusable code lives, the tools that fetch it, and the mechanics that make installs reproducible.

---

# Packages & the registry

<div class="grid grid-cols-2 gap-6 pt-2">

<div>

A **package** is a reusable bundle of JavaScript with a `package.json` describing it. It might be a library (React), a CLI tool (Slidev), or both.

The **npm registry** (`registry.npmjs.org`) is the central server where packages are published and downloaded from. Run by npm Inc. (owned by GitHub / Microsoft).

<div class="pt-2">

It hosts **over 3 million** packages — analogous to PyPI for Python or Maven Central for Java.

</div>

</div>

<div>

<Callout type="warning" title="The name 'npm' is overloaded">
"npm" refers to <em>both</em> this registry <em>and</em> one specific client tool that talks to it. Endless confusion comes from this single overlap — when someone says "npm", ask which one they mean.
</Callout>

<div class="pt-2">

<Callout type="note">
A registry stores packages. A <em>package manager</em> downloads them. The next slides are all about the managers.
</Callout>

</div>

</div>

</div>

---

# The package managers

Tools that read your `package.json`, fetch dependencies from the registry, and put them in `node_modules/`. Same job, three implementations.

| Tool     | Created          | Key idea                                              |
| -------- | ---------------- | ----------------------------------------------------- |
| **npm**  | 2010             | The original — ships with Node                        |
| **yarn** | 2016 · Facebook  | Introduced lockfiles and parallel installs            |
| **pnpm** | 2017             | One global store on disk, hard-linked into projects   |

<div class="pt-4">

<Callout type="note">
All three read the same <code>package.json</code> and download from the same registry. Each writes its <em>own</em> lockfile, and they are not interchangeable — committing more than one lockfile to a repo is a smell.
</Callout>

</div>

---

# What makes pnpm different

<div class="grid grid-cols-2 gap-6 pt-2">

<div>

**Disk-efficient.** pnpm stores every package version **once globally** on disk, then hard-links it into each project. If 10 projects use React 18, you have *one* copy on disk, not ten.

**Strict.** A package can only import what it explicitly declares as a dependency. This prevents a whole category of "works on my machine" bugs caused by accidental access to transitive dependencies.

</div>

<div>

<Callout type="tip" title="This deck uses pnpm">
Note <code>pnpm-lock.yaml</code> and <code>pnpm-workspace.yaml</code> in this repo. Choosing pnpm signals "we want disk savings and strictness."
</Callout>

<Callout type="note">
A contributor <em>could</em> still run <code>npm</code> or <code>yarn</code> by ignoring the lockfile — and risk slightly different installed versions. The lockfile is the contract; honor it.
</Callout>

</div>

</div>

---

# Corepack: the manager *of* managers

How do you guarantee everyone on a team uses the *same* package manager, at the *same* version, with no global installs? **Corepack.**

- It comes with recent versions of Node and is a **shim**: when you type `pnpm install`, you're really invoking Corepack's `pnpm` shim.
- The shim reads the `packageManager` field in `package.json` and downloads/runs that exact version on the fly (cached after first use):

```json
{ "packageManager": "pnpm@9.1.0" }
```

<div v-click class="pt-3">

<Callout type="tip" title="Mental model">
Corepack is to <strong>package managers</strong> what <strong>nvm</strong> is to <strong>Node itself</strong> — both are version managers, just for different layers.
</Callout>

</div>

<div v-click class="pt-1">

<Callout type="warning" title="Check your Node version">
Corepack is disabled by default — enable it once with <code>corepack enable</code>. Its long-term bundling with Node has been debated, so confirm <code>corepack</code> is available (or install it) for the Node version you run.
</Callout>

</div>

---

# Dependency mechanics: semver

`package.json` records *ranges*, not exact versions. The range prefix decides how much can change on the next install.

<div class="pt-2">

- `^1.2.3` → `1.2.3` or any newer **1.x** (minor + patch updates)
- `~1.2.3` → `1.2.3` or any newer **1.2.x** (patch updates only)
- `1.2.3` → **exactly** that version, nothing else

</div>

<div v-click class="pt-5">

<Callout type="warning" title="Why two installs can differ">
The <code>^</code> is why <code>npm install</code> a week apart can give different results — a new compatible version was published in between. That's precisely why <strong>lockfiles</strong> exist.
</Callout>

</div>

---
layout: multicolumns
---

# The rest of the mechanics

The supporting cast you'll meet in every Node project.

<template #col1>

<ColHead>node_modules/</ColHead>

The folder where dependencies get installed. Famously huge — the "heaviest object in the universe" meme. You never commit it.

<ColHead class="pt-4">Lockfile</ColHead>

Records the *exact* version of every transitive dependency, so installs are reproducible across machines and time. **Always commit it.**

</template>

<template #col2>

<ColHead>dependencies vs devDependencies</ColHead>

`devDependencies` (build tools, test frameworks) are **not** installed when someone uses your package as a library. Runtime needs go in `dependencies`.

<ColHead class="pt-4">Monorepo / workspaces</ColHead>

One repo with multiple interdependent packages. All three managers support it — `pnpm-workspace.yaml` in this repo is a workspace config.

</template>

<template #col3>

<ColHead>npx / pnpm dlx</ColHead>

Run a package **once** without installing it permanently:

```bash
npx create-vite my-app
pnpm dlx create-vite my-app
```

Great for scaffolding tools you'll use exactly once.

</template>

<!--
This is the cheat-sheet slide for Part 2 — dense on purpose. The multicolumns layout
counts the filled #col slots (three here) and picks a 3-column grid automatically.
-->
