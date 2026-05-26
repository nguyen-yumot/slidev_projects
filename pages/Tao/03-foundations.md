---
layout: section
---

<Eyebrow>Part 3</Eyebrow>

# Foundations

Agents, the tool-use loop, the runtime that drives it, and the context the model actually sees.

---
zoom: 0.9
---

# What are AI agents?

**Agentic AI** — systems that go beyond answering, and can autonomously act.

<div class="grid grid-cols-2 gap-3 pt-3 text-sm" transform scale-80 origin-top>

<FeatureCard title="Reason" icon="i-carbon-thinking" compact>
Work through a problem step by step.
</FeatureCard>

<FeatureCard title="Plan" icon="i-carbon-flow" compact>
Decompose and sequence the steps needed.
</FeatureCard>

<FeatureCard title="Manage memory" icon="i-carbon-data-base" compact>
Hold short- and long-term state across turns.
</FeatureCard>

<FeatureCard title="Integrate tools" icon="i-carbon-tool-kit" compact>
Reach out — APIs, code, and search — to act on the world.
</FeatureCard>

</div>

<div class="-mt-12 flex justify-center">

```mermaid {scale: 0.9}
flowchart TB
  A(("LLM AI Agent"))
  P["Planning<br/><span style='font-size:0.85em;opacity:0.75'>decompose · self-reflect</span>"]
  M["Memory<br/><span style='font-size:0.85em;opacity:0.75'>short-term · long-term</span>"]
  T["Tool use<br/><span style='font-size:0.85em;opacity:0.75'>APIs · code · search</span>"]
  A --- P
  A --- M
  A --- T
```

</div>

---

# Tool-use loop

A **tool** is an executable function or external capability the agent can request. Every example maps to one of three tool-use types — <Chips>APIs, code, search</Chips>

<div class="pt-2 text-sm" transform scale-80 origin-top>

| Example         | What the agent does                              | Tool-use type    |
| --------------- | ------------------------------------------------ | :--------------: |
| **Database**    | Query records (shipments, orders, inventory)     | search + code    |
| **ERP access**  | Look up or update enterprise records             | search + code    |
| **Web search**  | Retrieve public information (news, regulations)  | search           |
| **Weather API** | Call a live service for real-time conditions     | APIs             |

</div>

<div class="-mt-10 pt-3 flex justify-center">

```mermaid {scale: 0.9}
flowchart LR
  H[Human] --> L[LLM]
  L -- "Tool Call" --> T[Tool]
  T -- "Feedback" --> L
```

</div>

<div class="pt-2">

<Callout type="note">
Every agent runs the same loop: <strong>LLM → tool call → feedback → LLM → …</strong> until it reaches a final answer.
</Callout>

</div>

---

# Tool-use loop: context accumulation

Each turn's tool call and its feedback **accumulate into the running context** — one turn's output becomes the next turn's history.

<div class="pt-4 flex justify-center">

```mermaid {scale: 0.75}
flowchart LR
  T1["Turn 1<br/><span style='font-size:0.8em;opacity:0.75'>system · human · tool call · feedback</span>"] --> LLM1[LLM]
  LLM1 --> T2["Turn 2<br/><span style='font-size:0.8em;opacity:0.75'>… growing stack …</span>"]
  T2 --> LLM2[LLM]
  LLM2 --> T3["Turn 3<br/><span style='font-size:0.8em;opacity:0.75'>…</span>"]
```

</div>

<div class="pt-2">

<Callout type="warning" title="The stack grows every turn">
The context window is finite. What we keep, drop, or summarize is the central design problem — picked up on the next slide.
</Callout>

</div>

---

# Runtime architecture

Three distinct roles — **who actually does what.**

<div class="pt-2 text-sm">

| Component   | What it is                                  | What it does                                                                       |
| ----------- | ------------------------------------------- | ---------------------------------------------------------------------------------- |
| **Runtime** | The host program (script, CLI, web server) | Owns the loop, prompts the LLM, **executes** tools, returns results                |
| **LLM**     | A function the runtime calls               | Reads context and **emits a request** — `tool_use(name, args)`; decides *what*     |
| **Tool**    | An external function / API                 | Runs **only** when the runtime invokes it; returns a raw result                    |

</div>

<div class="pt-3 flex justify-center">

```mermaid {scale: 0.55}
sequenceDiagram
  participant U as User
  participant L as LLM
  participant R as Runtime
  participant T as Tool
  U->>L: user message
  L->>R: tool_use(name, args)
  R->>T: run function
  T-->>R: raw result
  R-->>L: tool feedback
  L-->>U: final answer or next tool_use
```

</div>

<div class="pt-2">

<Callout type="tip" title="A tool call is just a request">
The LLM never touches the tool. The <strong>runtime is the broker</strong> that performs the real call and hands the result back.
</Callout>

</div>

---

# From agents to context: why context engineering?

Two facts from the last slides combine into a single design problem.

<div class="grid grid-cols-2 gap-4 pt-4">

<FeatureCard title="The loop accumulates" icon="i-carbon-stacked-scrolling-1">
Every turn adds to the context stack — system prompt, prior tool calls, feedback, intermediate reasoning.
</FeatureCard>

<FeatureCard title="The runtime curates" icon="i-carbon-filter">
The runtime decides <strong>what the LLM sees</strong> on each call — what to include, summarize, or drop.
</FeatureCard>

</div>

<div class="pt-6">

<Callout type="note">
An agent is only as good as <strong>what's in its context</strong> — and the window is finite. <em>What we include and what we leave out</em> becomes the central design problem.
</Callout>

</div>

---

# Context engineering

**What is context?** Everything the LLM sees on a given turn.

<div class="grid grid-cols-3 gap-3 pt-3 text-sm">

<FeatureCard title="Instructions" icon="i-carbon-document" compact>
System prompt · few-shot examples · policies.
</FeatureCard>

<FeatureCard title="Knowledge" icon="i-carbon-data-base" compact>
Facts · retrieved documents · vector memory.
</FeatureCard>

<FeatureCard title="Tools" icon="i-carbon-api" compact>
Available tool definitions · tool feedback so far.
</FeatureCard>

</div>

<div class="pt-3 flex justify-center">

```mermaid {scale: 0.55}
flowchart TB
  C(("Context"))
  I["Instructions<br/><span style='font-size:0.85em;opacity:0.75'>System Prompt · Few-shot · Policies</span>"]
  K["Knowledge<br/><span style='font-size:0.85em;opacity:0.75'>Facts · Documents · Vector Retrieval · Memory</span>"]
  T["Tools<br/><span style='font-size:0.85em;opacity:0.75'>APIs · Tool Feedback</span>"]
  C --- I
  C --- K
  C --- T
```

</div>

<div class="pt-2">

<Callout type="tip">
Context is the model's <strong>working memory</strong> — everything inside the window, nothing outside.
</Callout>

</div>

---

# Why context engineering matters

**Context Engineering** — the art and science of filling the context window with *just the right* information for the next step.

<div class="grid grid-cols-2 gap-4 pt-6">

<FeatureCard title="The window is finite" icon="i-carbon-cut" tone="warning">
Cost and latency cap what fits. Curation isn't optional — it's the design constraint.
</FeatureCard>

<FeatureCard title="Tools pull in fresh data" icon="i-carbon-renew" tone="tip">
APIs, search, and code let the agent act on <strong>the right information</strong> on demand — instead of stale or missing data.
</FeatureCard>

</div>

<div class="pt-6">

<Callout type="note">
Context engineering is what makes the agent's reasoning <em>relevant</em>. Architecture choices in later sections all bend toward serving this single constraint.
</Callout>

</div>
