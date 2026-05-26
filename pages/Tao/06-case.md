---
layout: section
---

<Eyebrow>Part 6</Eyebrow>

# Case Scenario

The architecture, in practice — a Risk Decision Intelligence Hub for a freight forwarder.

---

# Illustrating with a case scenario

To show the architecture in practice, we walk through a **virtual case scenario** — illustrative, not a deployed system — modeled on a realistic logistics operation.

<div class="pt-6">

<FeatureCard title="What the case demonstrates" icon="i-carbon-flow-data" row>
How the three layers, the agents, and the bridge protocols <strong>come together to support real decisions</strong>.
</FeatureCard>

</div>

<div class="pt-6">

<Callout type="tip">
Next: the setting — a <strong>Multi-Agent Risk Decision Intelligence Hub (DIH).</strong>
</Callout>

</div>

---

# Risk Decision Intelligence Hub

The setting for the case scenario.

<div class="pt-2">

| | |
| --- | --- |
| **Domain**       | Mid-to-large third-party logistics / freight forwarder |
| **Challenge**    | Thousands of active shipments; hundreds of risk events daily; complex task planning |
| **Limit today**  | Traditional DSS can't autonomously coordinate responses across operational domains |
| **Goal**         | One unified risk picture, with the right level of automation per decision type |
| **System**       | Multi-Agent Risk Decision Intelligence Hub (**DIH**) |

</div>

---

# Risk detection process

In this scenario, the multi-agent system can:

<div class="grid grid-cols-3 gap-3 pt-3 text-sm">

<FeatureCard title="Detect risks" icon="i-carbon-warning-square" compact>
Tariff, regulatory, financial, weather, human operational errors.
</FeatureCard>

<FeatureCard title="Prioritize actions" icon="i-carbon-chart-bar" compact>
Rank by <strong>severity</strong> and <strong>business impact</strong>, not arrival time.
</FeatureCard>

<FeatureCard title="Support decisions" icon="i-carbon-decision-tree" compact>
Surface to the right human — or act within policy, autonomously.
</FeatureCard>

</div>

<div class="pt-3 flex justify-center">

```mermaid {scale: 0.5}
flowchart LR
  S["Shipment SHP-20491<br/><span style='font-size:0.85em;opacity:0.75'>Shanghai → Hamburg<br/>$85,000 Medical Device</span>"]
  PR["Political Risk<br/><span style='font-size:0.85em;opacity:0.75'>Tariff change detected</span>"]
  RR["Regulatory Risk<br/><span style='font-size:0.85em;opacity:0.75'>Missing certificate of origin</span>"]
  FR["Finance Risk<br/><span style='font-size:0.85em;opacity:0.75'>Currency volatility +8% cost</span>"]
  WR["Weather Risk<br/><span style='font-size:0.85em;opacity:0.75'>Typhoon forming near port</span>"]
  HE["Human Error<br/><span style='font-size:0.85em;opacity:0.75'>PO/Invoice quantity mismatch</span>"]
  O["Decision Intelligence Hub<br/>Orchestrator<br/><span style='font-size:0.85em;opacity:0.75'>What do we do?</span>"]
  S --> PR --> O
  S --> RR --> O
  S --> FR --> O
  S --> WR --> O
  S --> HE --> O
```

</div>

---

# Scope: why focus on risk detection?

Agents in logistics can do far more — route optimization, carrier selection, customer communication, demand forecasting, and more.

<div class="grid grid-cols-2 gap-4 pt-6">

<FeatureCard title="Each task could have its own architecture" icon="i-carbon-template">
Built the same way, with the same three layers and bridge protocols.
</FeatureCard>

<FeatureCard title="Multiple architectures can run together" icon="i-carbon-collaborate">
Across one operation — composed, not collapsed into a single agent.
</FeatureCard>

</div>

<div class="pt-6">

<Callout type="note">
This research demonstrates <strong>one</strong> — Risk Detection — end to end. The same approach generalizes to the others.
</Callout>

</div>

---
zoom: 0.98
---

# DIH — the 8 agent teams

The DIH partitions the work into eight specialized teams, each owning a slice of the risk surface.

<div class="pt-3 flex justify-center">

```mermaid {scale: 0.42}
flowchart TB
  O["DIH Orchestrator<br/><span style='font-size:0.85em;opacity:0.75'>Coordinates · Ranks · Prevents conflicts</span>"]
  T1["Political &amp; Trade Risk<br/><span style='font-size:0.85em;opacity:0.75'>Tariffs · Sanctions · Port risk</span>"]
  T2["Regulation &amp; Compliance<br/><span style='font-size:0.85em;opacity:0.75'>Customs · HS codes · Incoterms</span>"]
  T3["Finance &amp; Tax Risk<br/><span style='font-size:0.85em;opacity:0.75'>Landed cost · VAT · Currency</span>"]
  T4["Weather &amp; Disaster Risk<br/><span style='font-size:0.85em;opacity:0.75'>Storms · Rerouting · Recovery</span>"]
  T5["Human Error Detection<br/><span style='font-size:0.85em;opacity:0.75'>Mismatches · Anomalies</span>"]
  T6["Planning &amp; Optimization<br/><span style='font-size:0.85em;opacity:0.75'>Routes · Carriers · Simulation</span>"]
  T7["Customer Communication<br/><span style='font-size:0.85em;opacity:0.75'>ETA · Apology · Recovery</span>"]
  O --> T1
  O --> T2
  O --> T3
  O --> T4
  O --> T5
  O --> T6
  O --> T7
```

</div>

<div class="pt-2">

<Callout type="tip">
Seven specialist teams under the <strong>Orchestrator</strong> — eight roles in total, one per risk surface from the DIH background slide.
</Callout>

</div>

---
layout: multicolumns
---

# DIH — the 4-layer context architecture

Four context layers feed each agent's <strong>Context Pack</strong>.

<template #col1>

<ColHead tone="accent">Layer 1 — Permanent</ColHead>

Business context that rarely changes.

<div class="pt-2 text-sm">

- Policy
- Network
- Products
- Contracts

</div>

</template>

<template #col2>

<ColHead tone="tip">Layer 2 — Shipment</ColHead>

Specific to the shipment in flight.

<div class="pt-2 text-sm">

- Origin · destination
- Cargo
- Carrier
- Timeline

</div>

</template>

<template #col3>

<ColHead tone="note">Layer 3 — Live external</ColHead>

The world, right now.

<div class="pt-2 text-sm">

- Tariffs
- Weather
- Sanctions
- Exchange rates

</div>

</template>

<template #col4>

<ColHead tone="try">Layer 4 — Memory</ColHead>

Past lessons the agent can apply.

<div class="pt-2 text-sm">

- Past incidents
- Agent patterns
- Learned behaviors

</div>

<div class="pt-3">

→ **Agent Context Pack**

</div>

</template>

---

# DIH — context layers feeding the pack

The four layers stack into a single **Agent Context Pack** that the agent reasons over.

<div class="pt-2 flex justify-center">

```mermaid {scale: 0.55}
flowchart TB
  L1["Layer 1 — Permanent Business Context<br/><span style='font-size:0.85em;opacity:0.75'>Policy · Network · Products · Contracts</span>"]
  L2["Layer 2 — Shipment-Specific Context<br/><span style='font-size:0.85em;opacity:0.75'>Origin · Destination · Cargo · Carrier · Timeline</span>"]
  L3["Layer 3 — Live External Context<br/><span style='font-size:0.85em;opacity:0.75'>Tariffs · Weather · Sanctions · Exchange rates</span>"]
  L4["Layer 4 — Historical Memory<br/><span style='font-size:0.85em;opacity:0.75'>Past incidents · Agent patterns · Learned behaviors</span>"]
  P["Agent Context Pack"]
  L1 --> L2 --> L3 --> L4 --> P
```

</div>
