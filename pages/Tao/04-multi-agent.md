---
layout: section
---

<Eyebrow>Part 4</Eyebrow>

# From One Agent to Many

Single- vs. multi-agent — and why a layered structure follows.

---

# Single-agent architecture

A single agent works — but hits limits as tasks grow.

<div class="grid grid-cols-3 gap-3 pt-3 text-sm">

<FeatureCard title="Specialization" icon="i-carbon-user-profile" tone="warning" compact>
One agent can't be expert at everything.
</FeatureCard>

<FeatureCard title="Coordination" icon="i-carbon-collaborate" tone="warning" compact>
No way to divide and sequence parallel work.
</FeatureCard>

<FeatureCard title="Orchestration" icon="i-carbon-flow-modeler" tone="warning" compact>
No higher-level control of the whole job.
</FeatureCard>

</div>

<div class="pt-3 flex justify-center">

```mermaid {scale: 0.5}
flowchart TB
  U[User]
  subgraph AGENT["AI Agent"]
    direction TB
    CM["Context / Memory"]
    LRE["LLM Reasoning Engine"]
    TG["Task Goals"]
    PM["Planning Module"]
    EX["Execution Layer"]
    CM --> LRE
    LRE --> PM
    TG --> PM
    PM --> EX
  end
  U --> LRE
  subgraph EXT["External APIs / Tools"]
    direction LR
    S["Search API"]
    DB["Database"]
    CI["Code Interpreter"]
    BS["Business Systems"]
  end
  EX <--> S
  EX <--> DB
  EX <--> CI
  EX <--> BS
```

</div>

---

# Multi-agent architecture

Specialized agents collaborating — power and friction in equal measure.

<div class="grid grid-cols-2 gap-4 pt-2">

<div class="text-sm">

| Multi-agent gives us       | But introduces challenges     |
| -------------------------- | ----------------------------- |
| Better scalability         | Context synchronization       |
| Parallel processing        | Coordination overhead         |
| Specialized reasoning      | Shared-state conflicts        |
| Flexible orchestration     | —                             |

</div>

<div class="flex justify-center">

```mermaid {scale: 0.42}
flowchart TB
  U[User]
  subgraph ORC["Orchestrator Agent"]
    direction LR
    OL["LLM"]
    OM["Memory"]
  end
  subgraph EXP["Expert Agent Teams"]
    direction TB
    FA["Forecasting Agent"]
    PA["Planning Agent"]
    IA["Inventory Agent"]
    RA["Risk Agent"]
    TA["Transportation Agent"]
  end
  subgraph GUA["Guardian Agent"]
    direction LR
    PG["Policy Guardian"]
    SG["Safety Guardian"]
  end
  subgraph TLS["Tools / APIs"]
    direction LR
    DB["Database"]
    AP["API"]
    ES["Enterprise Systems"]
  end
  U --> ORC
  ORC --> EXP
  ORC --> GUA
  EXP --> TLS
  GUA --> TLS
```

</div>

</div>

<div class="pt-2">

<Callout type="warning">
The challenges column is exactly what the next slide's <strong>layered architecture</strong> — and the bridge protocols later — are designed to absorb.
</Callout>

</div>

---
zoom: 0.98
---

# From multi-agent to multi-layer

Multi-agent and multi-layer answer **different, complementary** questions.

<div class="grid grid-cols-2 gap-4 pt-4">

<FeatureCard title="Multi-agent → who does the work" icon="i-carbon-group">
Specialized agents collaborating across tasks.
</FeatureCard>

<FeatureCard title="Layering → how the system is organized" icon="i-carbon-stack">
Separating <strong>people</strong>, <strong>agent brains</strong>, and the <strong>enterprise systems</strong> they act on.
</FeatureCard>

</div>

<div class="pt-4">

A multi-agent system still needs layers to:

- keep agents **decoupled** from the systems they touch,
- **integrate** with existing logistics systems (WMS / TMS / ERP),
- give the bridge protocols (**MCP**, **A2A**) a clear place to live.

</div>

<div class="pt-2">

<Callout type="tip">
The proposed design is therefore <strong>multi-agent <em>within</em> a layered structure.</strong>
</Callout>

</div>
