# From Classic to Agentic DSS — v5

> Built on `Slides_revised_v4.md` (refined, presentation-ready). v5 adds the actual **Response to Comments** answer (Slide 3) and recategorizes the **Tool-Use Loop** examples by tool-use type — APIs · code · search (Slide 9). 29 slides.

---

## Slide 1 — Title

# From Classic to Agentic DSS
### A Conceptual Model for Autonomous Decision-Making in Logistics

Tao Zixian · 24-9001-501-10
Supervisor: Professor Nguyen Phuc Huu
Final Defense · May 31, 2026

---

## Slide 2 — Agenda

1. **The Problem** — what DSS is, and where traditional DSS falls short
2. **Research Objectives & Schedule**
3. **Foundations** — agents, the tool-use loop, runtime, and context
4. **From One Agent to Many** — single- vs. multi-agent, and why layering
5. **Proposed Architecture** — a 3-layer Agentic DSS for logistics
6. **Case Scenario** — the Risk Decision Intelligence Hub
7. **Outcomes & PoC** — realizing the blueprint in Claude Code

🎤 *Speaker note: one sentence per item — "we move from the problem, to the building blocks, to a proposed architecture, and finally a working proof of concept."*

---

## Slide 3 — Response to Comments

> **Prior comment:** *The research range is too broad.*

**Response:** My research focuses on **AI agents for logistics SMEs** — not logistics in general.

---

## Slide 4 — What is DSS?

**Decision Support System (DSS)** — an information system that supports organizational decision-making, especially for **semi-structured and unstructured problems** where no fixed procedure gives the answer.

🎤 *Speaker note: anchor the audience — DSS is a decades-old IS concept; the thesis asks what happens when agentic AI enters it.*

---

## Slide 5 — Why Traditional DSS Falls Short

A traditional DSS is fundamentally **reactive and rule-bound**:

- **Passive** — waits to be asked; never acts on its own
- **Static** — fixed rules that don't adapt to new situations
- **Shallow reasoning** — can't plan or reason across multiple steps
- **Isolated** — siloed from the other systems and data it would need

> These four gaps are exactly what an **agentic** approach is meant to close.

---

## Slide 6 — Research Objectives

1. **Understand** the role evolution from classic to agentic DSS
2. **Design** a conceptual architecture for an agentic DSS
3. **Develop** a conceptual framework for Agentic DSS in SMEs' logistics

---

## Slide 7 — Research Schedule

Timeline of research activities (bars mark active periods):

| Research Item | Oct '24 | Nov | Dec | Jan '25 | Feb | Mar | Apr | May | Jun | Jul | Aug |
| --- | :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: |
| Research Proposal Development | ▓ | ▓ |  |  |  |  |  |  |  |  |  |
| Research Presentation |  | ▓ |  |  |  |  |  |  |  |  |  |
| Literature Review |  | ▓ | ▓ | ▓ |  |  |  |  |  |  |  |
| Conceptual Modeling |  |  | ▓ | ▓ | ▓ | ▓ |  |  |  |  |  |
| Prototype Development |  |  |  |  | ▓ | ▓ | ▓ |  |  |  |  |
| Interim Presentation |  |  |  |  |  |  | ▓ |  |  |  |  |
| Thesis Completion |  |  |  |  |  |  | ▓ | ▓ | ▓ |  |  |
| Final Defense |  |  |  |  |  |  |  | ▓ |  |  |  |
| Final Correction & Submission |  |  |  |  |  |  |  |  | ▓ | ▓ | ▓ |

⚠️ TODO: the ▓ bars are reconstructed from the deck's filled cells — confirm each period against your actual `.pptx`.

---

## Slide 8 — What are AI Agents?

**Agentic AI** — systems that go beyond answering, and can autonomously:

- **Reason** through a problem
- **Plan** a sequence of steps
- **Manage memory** (short- and long-term)
- **Integrate tools** to act on the world

*[Diagram: LLM AI Agent → Planning (decompose · self-reflect) · Memory (short-term · long-term) · Tool use (APIs · code · search)]*

🎤 *Speaker note: contrast directly with Slide 5 — each capability answers one of the four traditional-DSS gaps.*

---

## Slide 9 — Tool-Use Loop

**Tool** — an executable function or external capability the agent can request.

Each example maps to one of the three tool-use types — **APIs · code · search**:

| Example | What the agent does | Tool-use type |
| --- | --- | :-: |
| **Database** | Query records (shipments, orders, inventory) | search + code |
| **ERP access** | Look up or update enterprise records (orders, invoices) | search + code |
| **Web search** | Retrieve public information (news, regulations) | search |
| **Weather API** | Call a live service for real-time conditions | APIs |

*[Diagram: Human → LLM → Tool Call → Tool → Feedback → LLM …]*

> Every agent runs the same loop: **LLM → tool call → feedback → LLM → …** until it reaches a final answer.

---

## Slide 10 — Tool-Use Loop: Context Accumulation

Each turn's tool call and its feedback **accumulate into the running context** — one turn's output becomes the next turn's history.

*[Diagram: Turn 1 (System Message · Human · Tool call · Feedback) → LLM → Turn 2 (… growing stack …) → LLM → …]*

🎤 *Speaker note: this is the setup for context engineering — point out the stack visibly growing each turn.*

---

## Slide 11 — Runtime Architecture

Three distinct roles — **who does what:**

| Component | What it is | What it does |
| --- | --- | --- |
| **Runtime** | The host program (script, CLI, web server) | Owns the loop, prompts the LLM, **executes** tools, returns results |
| **LLM** | A function the runtime calls | Reads context and **emits a request** — `tool_use(name, args)`; decides *what*, runs nothing |
| **Tool** | An external function / API | Runs **only** when the runtime invokes it; returns a raw result |

> Key point: a "tool call" is **just a request**. The LLM never touches the tool — the **runtime is the broker** that performs the real call and hands the result back.

*[Diagram: sequence — User → LLM → Runtime → Tool → raw result → tool feedback → LLM → final answer or next tool_use]*

---

## Slide 12 — From Agents to Context: Why Context Engineering?

Two facts from the last slides:

- The tool-use loop **accumulates** context every turn (Slide 10).
- The runtime decides **what the LLM sees** on each call (Slide 11).

So an agent is only as good as **what's in its context** — and the context window is finite. **What we include, and what we leave out, becomes the central design problem.**

> That is why this research turns next to **Context Engineering.**

---

## Slide 13 — Context Engineering

**What is context?** Everything the LLM sees on a given turn:

- system prompt and instructions
- prior messages and tool results
- documents retrieved from memory or the web
- available tool definitions

> Context is the model's **working memory** — everything inside the context window, nothing outside.

*[Diagram: Context → Instructions (System Prompt · Few-shot · Policies) · Knowledge (Facts · Documents · Vector Retrieval · Memory) · Tools (APIs · Tool Feedback)]*

---

## Slide 14 — Context Engineering: Why It Matters

**Context Engineering** — the art and science of filling the context window with *just the right* information for the next step.

- The window is **limited** by cost and latency, so it must be curated.
- **Tools** pull in real-time information on demand — letting the agent act on the *right* information instead of stale or missing data.

*[Diagram: AI Agent — Context/Memory + Task Goals → LLM Reasoning Engine → Planning Module → Execution Layer → External APIs/Tools (Search API · Database · Code Interpreter · Business Systems)]*

⚠️ TODO: give this slide a distinct visual — v3 reused Slide 13's image.

---

## Slide 15 — Single-Agent Architecture

*[Diagram: single-agent runtime]*

A single agent works — but hits limits as tasks grow:

- **Specialization** — one agent can't be expert at everything
- **Coordination** — no way to divide and sequence work
- **Orchestration** — no higher-level control of the whole job

> These limits motivate **multiple** agents.

---

## Slide 16 — Multi-Agent Architecture

*[Diagram: multi-agent architecture]*

| Multi-agent gives us | But introduces challenges |
| --- | --- |
| Better scalability | Context synchronization |
| Parallel processing | Coordination overhead |
| Specialized reasoning | Shared-state conflicts |
| Flexible orchestration | |

🎤 *Speaker note: be honest about the trade-offs — the challenges column is what the layered architecture and protocols address.*

---

## Slide 17 — From Multi-Agent to Multi-Layer: Why a Layered Architecture?

Multi-agent and multi-layer answer **different, complementary** questions:

- **Multi-agent** → *who does the work* — specialized agents collaborating.
- **Layering** → *how the system is organized* — separating **people**, **agent brains**, and the **enterprise systems** they act on.

A multi-agent system still needs layers to:

- keep agents **decoupled** from the systems they touch,
- **integrate** with existing logistics systems (WMS / TMS / ERP),
- give the bridge protocols (**MCP**, **A2A**) a clear place to live.

> The proposed design is therefore **multi-agent *within* a layered structure.**

---

## Slide 18 — Proposed Architecture of Agentic DSS in Logistics

**Three layers:**

| Layer | Contains |
| --- | --- |
| **People & Application** | Customers · Managers · Operator consoles |
| **Agent Brain** | LLMs · Memory systems · Policies & constraints |
| **System** | WMS · TMS · ERP |

**Bridge protocols:**

- **MCP (Model Context Protocol)** — tool/resource access for LLMs
- **A2A (Agent-to-Agent)** — cross-system inter-agent messaging

---

## Slide 19 — Illustrating with a Case Scenario

To show the architecture in practice, we walk through a **virtual case scenario** — illustrative, not a deployed system — modeled on a realistic logistics operation.

It shows how the three layers, the agents, and the bridge protocols **come together to support real decisions.**

> Next: the setting — a **Multi-Agent Risk Decision Intelligence Hub (DIH).**

---

## Slide 20 — Case Scenario: Risk Decision Intelligence Hub

**Background**

| | |
| --- | --- |
| **Domain** | Mid-to-large third-party logistics / freight forwarder |
| **Challenge** | Thousands of active shipments; hundreds of risk events daily; complex task planning |
| **Limit today** | Traditional DSS can't autonomously coordinate responses across operational domains |
| **Goal** | One unified risk picture, with the right level of automation per decision type |
| **System** | Multi-Agent Risk Decision Intelligence Hub (DIH) |

---

## Slide 21 — Case Scenario: Risk Detection Process

*[Diagram: risk detection process]*

In this scenario, the multi-agent system can:

- **Detect risks** — tariff, regulatory, financial, weather, human operational errors…
- **Prioritize actions** — rank events by severity and business impact
- **Support decisions** — surface options to the right human or act within policy

---

## Slide 22 — Scope: Why Focus on Risk Detection

Agents in logistics can do far more than risk detection — route optimization, carrier selection, customer communication, demand forecasting, and more.

- Each task could have its **own agent architecture**, built the same way.
- Multiple architectures could even **run together** across one operation.

> This research demonstrates **one** — **Risk Detection** — end to end. The same approach generalizes to the others.

---

## Slide 23 — DIH: The 8 Agent Teams

*[Diagram: org chart of the 8 agent teams]*

🎤 *Speaker note: don't read all eight — name two or three and point out they map to the operational domains from Slide 20.*

---

## Slide 24 — DIH: The 4-Layer Context Architecture

*[Diagram: four context layers feeding an Agent Context Pack]*

- **Layer 1 — Permanent Business Context:** policy · network · products · contracts
- **Layer 2 — Shipment-Specific Context:** origin · destination · cargo · carrier · timeline
- **Layer 3 — Live External Context:** tariffs · weather · sanctions · exchange rates
- **Layer 4 — Historical Memory:** past incidents · agent patterns · learned behaviors
- **→ Agent Context Pack**

🎤 *Speaker note: this is context engineering (Slides 13–14) made concrete inside the Agent Brain layer of Slide 18.*

---

## Slide 25 — Expected Outcomes

1. A **conceptual framework** for Agentic DSS in logistics
2. An **architecture blueprint** and a **PoC prototype**
3. **Strategic insights** for logistics decision systems

---

## Slide 26 — From Blueprint to Prototype

How do we show the blueprint is **buildable**, not just conceptual?

The next slides realize the proposed architecture in a concrete stack — **Claude Code** — delivering on the second expected outcome:

> *"An architecture blueprint and PoC prototype."*

Each part of the DIH architecture maps onto a real Claude Code primitive.

---

## Slide 27 — PoC Implementation: Claude Code Stack

Claude Code's primitives map directly onto the DIH architecture:

| Primitive | Role in the DIH |
| --- | --- |
| **Sub-agents** | One Claude Code sub-agent per DIH team |
| **Skills** | Reusable workflows (e.g. `classify-tariff-event`, `draft-customer-apology`) |
| **MCPs** | Live connections to external systems (WMS, TMS, Weather API, Currency Feed) |
| **Plugins** | Optional capability extensions |
| **Hooks** | Safety enforcement before any autonomous action |

*[Diagram: Claude Code stack]*

---

## Slide 28 — Claude Code File Structure

*[Diagram: Claude Code file/directory structure]*

🎤 *Speaker note: tie each folder back to a primitive on Slide 27 — this is the blueprint as actual files.*

---

## Slide 29 — Q & A

# Thank You — Q & A

Tao Zixian · From Classic to Agentic DSS
