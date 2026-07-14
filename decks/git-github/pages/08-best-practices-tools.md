---
layout: section
---

<Eyebrow>Part 8</Eyebrow>

# Best practices & tools

Good habits, the wider ecosystem, and a one-screen cheat-sheet to keep.

---

# Best practices that pay off

Four habits that separate tidy repos from messy ones.

<div class="grid grid-cols-2 gap-4 pt-3">

<FeatureCard title="Commit small and often" icon="i-carbon-checkmark-outline" row>
Each commit, one logical change. Easy to read, easy to roll back.
</FeatureCard>

<FeatureCard title="Write clear messages" icon="i-carbon-edit" row>
Present tense, says what changed and why. Future-you will thank you.
</FeatureCard>

<FeatureCard title="Protect main" icon="i-carbon-security" row>
Keep <code>main</code> stable and deployable. Do real work on branches and PRs.
</FeatureCard>

<FeatureCard title="Pull before you push" icon="i-carbon-renew" row>
Sync the team's latest first to avoid needless conflicts.
</FeatureCard>

</div>

---

# Git for students: why bother

It pays off far beyond one class project.

<div class="grid grid-cols-3 gap-3 pt-3">

<FeatureCard title="Group projects" icon="i-carbon-group">
Each person works on their own branch and merges through a Pull Request. No overwriting.
</FeatureCard>

<FeatureCard title="Survive a bad week" icon="i-carbon-data-backup">
Laptop dies before a deadline? If it's on GitHub, pull it onto any computer in minutes.
</FeatureCard>

<FeatureCard title="A hiring portfolio" icon="i-carbon-portfolio">
Recruiters open your GitHub. A clean public repo proves you can do the work.
</FeatureCard>

<FeatureCard title="Free student tools" icon="i-carbon-education">
The Student Developer Pack: free Copilot, cloud credits, and more while enrolled.
</FeatureCard>

<FeatureCard title="Free hosting" icon="i-carbon-globe">
GitHub Pages and Vercel host a page or live demo at a free, shareable link.
</FeatureCard>

<FeatureCard title="Not just for code" icon="i-carbon-notebook">
Notes, a thesis, LaTeX. Anything text-based gets the same history and backup.
</FeatureCard>

</div>

---

# Monorepo vs polyrepo

How many repositories should a project use? Two common answers.

<div class="grid grid-cols-2 gap-4 pt-3">

<FeatureCard title="Monorepo" icon="i-carbon-data-base">
Everything (frontend, backend, docs) in <strong>one</strong> repo. Simple to start and easy to see the whole project at once. Great for small teams.
</FeatureCard>

<FeatureCard title="Polyrepo" icon="i-carbon-network-3">
Each piece in its <strong>own</strong> repo. Independent deploys and fine-grained access control. Common at larger scale.
</FeatureCard>

</div>

<Callout type="note">
There's no universally right answer. It's a trade-off between simplicity (mono) and independence (poly).
</Callout>

---

# Tools & integrations

Git lives in a whole ecosystem. A quick tour of where you'll meet it.

<div class="grid grid-cols-3 gap-3 pt-3">

<FeatureCard title="Terminal" icon="i-carbon-terminal">
The command line. Full power, and what this deck taught.
</FeatureCard>

<FeatureCard title="GitHub Desktop" icon="i-carbon-application">
A friendly GUI: click to stage, commit, and push.
</FeatureCard>

<FeatureCard title="VS Code" icon="i-carbon-code">
Git built right into your editor's sidebar.
</FeatureCard>

<FeatureCard title="AI agents" icon="i-carbon-bot">
Cursor, Claude, Copilot. Commit per task so you can always roll back.
</FeatureCard>

<FeatureCard title="Vercel · CI/CD" icon="i-carbon-rocket">
Push to <code>main</code> and your site goes live automatically.
</FeatureCard>

<FeatureCard title="Obsidian" icon="i-carbon-notebook">
Version your notes and "second brain", synced across devices.
</FeatureCard>

</div>

---

# Big files like PDFs and images

Git handles binary files too, just differently from your code.

<div class="grid grid-cols-2 gap-4 pt-3">

<FeatureCard title="It still saves every version" icon="i-carbon-document-pdf">
A PDF, an image, a dataset. Git keeps a full copy at every commit, so you can always get an old version back.
</FeatureCard>

<FeatureCard title="But they add up" icon="i-carbon-data-base">
Git can't show <em>what</em> changed inside a binary, and each saved version is a whole new copy, so a big file revised often makes the repo heavy.
</FeatureCard>

</div>

<Callout type="warning" title="GitHub's limits">
It blocks any single file over <strong>100 MB</strong>, and a repo should stay under about <strong>1 GB</strong>. A published Pages site is capped at <strong>1 GB</strong> too.
</Callout>

---

# Big files: LFS, or just rebuild

Two ways to keep a big file from bloating your repo.

<div class="grid grid-cols-2 gap-4 pt-3">

<FeatureCard title="Git LFS" icon="i-carbon-tag">
For a big file you <strong>must</strong> keep (a raw dataset). It stores a tiny pointer in Git and the real file in a separate place. Free up to 1 GB.
</FeatureCard>

<FeatureCard title="Or gitignore and rebuild" icon="i-carbon-recycle">
For a file you can <strong>regenerate</strong> (an export, a chart, a PDF). Ignore it and rebuild it, so it never bloats the repo at all.
</FeatureCard>

</div>

<Callout type="tip">
This deck does the second one: its exported PDFs are gitignored and rebuilt by the deploy script, so there is nothing large to store and no LFS needed.
</Callout>

---
class: text-sm
---

# The command cheat-sheet

| Command | From → To | Result |
| --- | --- | --- |
| `git init` | folder → Working Dir | Start tracking and create the `.git` brain |
| `git status` | Working Dir | List modified vs. untracked files |
| `git add` | Working Dir → Staging | Stage changes for the next snapshot |
| `git commit` | Staging → Local Repo | Record a save point locally |
| `git push` | Local Repo → Remote | Send history up to GitHub |
| `git pull` | Remote → Working Dir | Fetch **and** merge cloud changes into files |
| `git fetch` | Remote → Local Repo | Update local knowledge, files untouched |
| `git checkout -b` | Local Repo → new branch | Create a branch and switch to it |
| `git stash` | Working Dir → shelf | Shelve unfinished work for later |

---
layout: multicolumns
---

# The whole workflow on one screen

<template #col1>
<ColHead>1 · Start</ColHead>

- `git init` or `git clone`
- Add a `.gitignore`
- Set your identity
</template>

<template #col2>
<ColHead>2 · Daily loop</ColHead>

- `git status` to see what changed
- `git add .` to stage it
- `git commit -m "…"` to save it
</template>

<template #col3>
<ColHead>3 · Branch</ColHead>

- `git checkout -b feat`
- work, then commit
- open a Pull Request
</template>

<template #col4>
<ColHead>4 · Sync</ColHead>

- `git pull` before you push
- `git push origin main`
- goes live 🚀
</template>

---
layout: center
class: text-center
---

# Don't just code, manage

You can now track history, sync with GitHub, branch fearlessly, and recover from any mistake.

<div class="pt-6 text-base opacity-75 max-w-2xl mx-auto leading-relaxed">

Git turns coding from constant risk into complete control. It gives you the confidence to experiment, and the safety to build at scale.

</div>

<div class="pt-8 opacity-60 text-sm">

Press <KeyCap>o</KeyCap> for the overview. This deck is yours to revisit as a reference.

</div>

<!--
Close on encouragement: the commands matter less than the mindset. With Git, every
state is recoverable, so you're free to experiment, especially alongside AI agents.
-->
