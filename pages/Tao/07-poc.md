---
layout: section
---

<Eyebrow>Part 7</Eyebrow>

# Outcomes & PoC

What the research delivers — and how the blueprint becomes a working stack in Claude Code.

---

# Expected outcomes

<div class="grid grid-cols-3 gap-4 pt-6">

<FeatureCard title="1 · Conceptual framework" icon="i-carbon-blockchain">
A framework for <strong>Agentic DSS in logistics</strong>.
</FeatureCard>

<FeatureCard title="2 · Architecture & PoC" icon="i-carbon-rocket">
An <strong>architecture blueprint</strong> and a <strong>PoC prototype</strong>.
</FeatureCard>

<FeatureCard title="3 · Strategic insights" icon="i-carbon-idea">
For logistics decision systems and the SMEs that adopt them.
</FeatureCard>

</div>

---

# From blueprint to prototype

How do we show the blueprint is **buildable**, not just conceptual?

<div class="pt-6">

<FeatureCard title="Realize the blueprint in a real stack" icon="i-carbon-build-tool" row>
The next slides realize the proposed architecture in <strong>Claude Code</strong> — delivering on the second expected outcome:
</FeatureCard>

</div>

<div class="pt-6">

<Callout type="tip">
<em>"An architecture blueprint and PoC prototype."</em> Each part of the DIH architecture maps onto a real Claude Code primitive.
</Callout>

</div>

---
zoom: 0.95
---

# PoC implementation — Claude Code stack

Claude Code's primitives map directly onto the DIH architecture.

<div class="grid grid-cols-2 gap-4 pt-2">

<div class="text-sm">

| Primitive       | Role in the DIH                                                                |
| --------------- | ------------------------------------------------------------------------------ |
| **Sub-agents** | One Claude Code sub-agent per DIH team                                          |
| **Skills**     | Reusable workflows — e.g. `classify-tariff-event`, `draft-customer-apology`     |
| **MCPs**       | Live connections to external systems — WMS, TMS, Weather API, Currency Feed    |
| **Plugins**    | Optional capability extensions                                                  |
| **Hooks**      | Safety enforcement before any autonomous action                                 |

</div>

<div class="flex justify-center">

```mermaid {scale: 0.55}
flowchart TB
  CC["Claude Code"]
  SK["Skills"]
  MC["MCPs"]
  PL["Plugins"]
  SA["Sub-agents"]
  CC --> SK
  CC --> MC
  CC --> PL
  CC --> SA
```

</div>

</div>

<div class="pt-2">

<Callout type="note">
The mapping is one-to-one on purpose — each abstract role in the architecture has a concrete file or feature that implements it.
</Callout>

</div>

---
layout: multicolumns
---

# Claude Code file structure

The blueprint as actual files — each folder corresponds to a primitive on the previous slide.

<template #col1>

<ColHead tone="accent">`.claude/agents/`</ColHead>

One file per DIH team — the **Sub-agents**.

<div class="pt-2 text-xs opacity-80">

`tariff.md`, `weather.md`, `finance.md`, …

</div>

<ColHead class="pt-4" tone="tip">`.claude/skills/`</ColHead>

Reusable workflows — the **Skills**.

<div class="pt-2 text-xs opacity-80">

`classify-tariff-event/`, `draft-customer-apology/`

</div>

</template>

<template #col2>

<ColHead tone="note">`.mcp.json`</ColHead>

External system connections — the **MCPs**.

<div class="pt-2 text-xs opacity-80">

WMS · TMS · weather · currency feeds

</div>

<ColHead class="pt-4" tone="try">`.claude/plugins/`</ColHead>

Optional extensions — the **Plugins**.

</template>

<template #col3>

<ColHead tone="warning">`.claude/hooks/`</ColHead>

Safety enforcement — the **Hooks**.

<div class="pt-2 text-xs opacity-80">

Pre-tool checks · approval gates · audit trails

</div>

<ColHead class="pt-4">`CLAUDE.md`</ColHead>

Top-level policy, conventions, and the system prompt for the whole DIH.

</template>

---

# Claude Code file structure — the tree

The blueprint as actual files — each box is a real path in the PoC repo.

<div class="pt-2 flex justify-center">

```mermaid {scale: 0.45}
flowchart LR
  ROOT["trade-inc/"]
  CMD["CLAUDE.md<br/><span style='font-size:0.85em;opacity:0.75'>(Constitution)</span>"]
  MCP[".mcp.json<br/><span style='font-size:0.85em;opacity:0.75'>(Live data connections)</span>"]
  CLD[".claude/"]
  SCH["schemas/<br/><span style='font-size:0.85em;opacity:0.75'>(Output contracts)</span>"]
  KN["knowledge/<br/><span style='font-size:0.85em;opacity:0.75'>(Curated patterns)</span>"]
  AG["agents/<br/><span style='font-size:0.85em;opacity:0.75'>(8 specialist subagents)</span>"]
  SK["skills/<br/><span style='font-size:0.85em;opacity:0.75'>(6 reusable workflows)</span>"]
  RL["rules/<br/><span style='font-size:0.85em;opacity:0.75'>(Modular governance)</span>"]
  HK["hooks/<br/><span style='font-size:0.85em;opacity:0.75'>(Safety enforcement)</span>"]
  AM["agent-memory/<br/><span style='font-size:0.85em;opacity:0.75'>(Learned patterns)</span>"]
  ROOT --> CMD
  ROOT --> MCP
  ROOT --> CLD
  ROOT --> SCH
  ROOT --> KN
  CMD --> AG
  MCP --> AG
  MCP --> SK
  CLD --> RL
  SCH --> HK
  KN --> AM
```

</div>
