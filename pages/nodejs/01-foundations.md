---
layout: section
---

<Eyebrow>Part 1</Eyebrow>

# Foundations

The language and the runtime — what JavaScript is, where it runs, and the ideas everything else builds on.

---

# Three words people use interchangeably

They are not the same thing. Keeping them straight makes the rest of the ecosystem click.

<div class="grid grid-cols-3 gap-4 pt-6">

<FeatureCard title="Language" icon="i-carbon-code">
<strong>JavaScript</strong> — the rules of the language itself: syntax, types, <code>async/await</code>. A specification, not a program.
</FeatureCard>

<FeatureCard title="Engine" icon="i-carbon-gears">
<strong>V8</strong> — the C++ program that actually <em>runs</em> JavaScript. Reads your code, executes it.
</FeatureCard>

<FeatureCard title="Runtime" icon="i-carbon-bare-metal-server">
<strong>Node.js</strong> — an engine <em>plus</em> the libraries that let JS touch files, networks, and the OS.
</FeatureCard>

</div>

<Callout type="tip">
A language is a set of rules. An engine runs code written in that language. A runtime is an engine bundled with everything else a real program needs.
</Callout>

<!--
This distinction is the spine of the whole deck. Almost every confusion downstream
("is npm the registry or the tool?", "why does my import fail in Node but work in the
browser?") traces back to blurring language / engine / runtime.
-->

---

# JavaScript & ECMAScript

<div class="grid grid-cols-2 gap-6 pt-2">

<div>

**JavaScript** was created in 1995 to make web pages interactive. For its first decade it lived only inside browsers.

**ECMAScript** is the official *standard* that defines the language. New editions add features:

<Chips>ES2015 / ES6, ES2020, ES2022, ES2024</Chips>

<div class="pt-3">

`class`, `async/await`, optional chaining `?.`, top-level `await` — each arrived in a numbered edition.

</div>

</div>

<div>

<Callout type="note" title="So which name is right?">
"JavaScript" and "ECMAScript" are practically synonyms. ECMAScript is the formal name of the standard; JavaScript is the language that implements it.
</Callout>

<Callout type="note" title="Why editions matter">
A feature only works where the engine supports that edition. This is exactly the gap transpilers (Part 3) exist to close.
</Callout>

</div>

</div>

---

# From browser to everywhere: V8 → Node.js

<div class="pt-2">

- **JavaScript** is the language.
- **V8** is Google's high-performance engine, written in C++. It lives inside Chrome and is what actually *executes* your JS.
- **Node.js** is V8 *extracted from the browser* and bundled with libraries for OS-level work: filesystem, network, processes, child shells.

</div>

<div v-click class="pt-6">

<Callout type="tip" title="The 2009 unlock">
Ryan Dahl took V8 out of Chrome and gave it OS bindings. Suddenly JavaScript could run servers, CLIs, and build tools — anything outside a browser. That move is why this deck, a build tool, and your backend can all be JavaScript.
</Callout>

</div>

---

# TypeScript: JavaScript with a type system

**TypeScript** is a *superset* of JavaScript — every valid JS file is already valid TypeScript. It adds static types, then compiles down to plain JS before running.

```ts {all|1|2-4|6}
// Types are checked at build time, then erased.
function greet(name: string): string {
  return `Hello, ${name}`
}

greet(42)   // ✗ compile error: number is not a string
```

<div class="grid grid-cols-2 gap-4 pt-4">
<Callout type="note">
The browser and Node never see the types — they run the compiled JavaScript. Types are a <em>development-time</em> safety net.
</Callout>
<Callout type="tip">
Most serious Node projects today are written in TypeScript. The tooling (Part 3) handles the compile step for you.
</Callout>
</div>

---
layout: two-cols
---

# Two module systems

Node grew up with one way to share code, then the standard arrived with another. Both are still everywhere — and mixing them is a classic source of pain.

**CommonJS** — Node's original. Synchronous, still everywhere in legacy code.

```js
// CommonJS
const fs = require('node:fs')
module.exports = { greet }
```

::right::

<div class="pl-8 pt-14">

**ESM** (ECMAScript Modules) — the modern standard, also used in browsers.

```js
// ESM
import fs from 'node:fs'
export { greet }
```

<Callout type="note" title="This project is ESM">
The <code>"type": "module"</code> field in <code>package.json</code> (this Slidev deck has it) tells Node to treat <code>.js</code> files as ESM.
</Callout>

<div class="pt-2 text-sm opacity-75">

The interop sharp edges get their own deep dive in Part 4.

</div>

</div>

---

# The newcomers: Deno & Bun

Node has been the default runtime for 15 years. Two younger runtimes challenge it — both run JavaScript, but rethink the toolchain around it.

<div class="grid grid-cols-2 gap-4 pt-4">

<FeatureCard title="Deno" icon="i-carbon-sailboat-coastal">
From Node's original creator. Secure-by-default, TypeScript built in, web-standard APIs. A clean-slate take on the same problem.
</FeatureCard>

<FeatureCard title="Bun" icon="i-carbon-flash">
A faster drop-in Node replacement with a bundled package manager and test runner. Gaining traction for its speed.
</FeatureCard>

</div>

<Callout type="note">
You can build a career on Node alone — but knowing these exist explains a lot of 2020s tooling conversations. The <em>concepts</em> in this deck (packages, bundling, the event loop) carry over to all three.
</Callout>

<!--
Don't oversell the alternatives. The point is awareness, not migration. Node + its
ecosystem is still where the overwhelming majority of jobs and libraries live.
-->
