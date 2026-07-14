---
layout: section
---

<Eyebrow>Part 5</Eyebrow>

# Branching & PRs

Experiment safely on a branch, then merge after a human review.

---

# Branching: a safe place to experiment

Working directly on `main` is risky. One bad change breaks the version everyone relies on. A **branch** is a separate copy where you can experiment freely.

<div class="grid grid-cols-2 gap-4 pt-3">

<FeatureCard title="A separate copy" icon="i-carbon-branch">
<code>main</code> is the version everyone relies on, so protect it. A branch is a separate copy where you can try things, and if they break, <code>main</code> is untouched.
</FeatureCard>

<FeatureCard title="Fail without fear" icon="i-carbon-checkmark-outline">
If the experiment breaks, delete the branch and return to <code>main</code> as if nothing happened. If it works, merge it in.
</FeatureCard>

</div>

<Callout type="tip">
In the AI era this is gold: let the AI try things on a branch. <code>main</code> stays clean no matter what it does.
</Callout>

---

# The branch workflow

Three steps: branch off, do your work, merge back.

```bash
git checkout -b feature-login   # 1. create a new branch and switch to it
# ... edit, git add, git commit, exactly as before ...
git checkout main               # 2. switch back to the stable branch
git merge feature-login         # 3. combine your work into main
```

<div class="flex items-center justify-center gap-2 pt-6 text-sm">
  <Chip>main</Chip>
  <span class="i-carbon-arrow-right opacity-40"></span>
  <Chip tone="accent">feature-login</Chip>
  <span class="opacity-60">commit · commit</span>
  <span class="i-carbon-arrow-right opacity-40"></span>
  <Chip>main</Chip>
  <span class="opacity-60">merged ✓</span>
</div>

<Callout type="note">
<code>git branch</code> lists your branches and shows which one you're currently on.
</Callout>

---

# Merge conflicts are decisions, not errors

A conflict happens when two branches changed the **same line** differently. Git can't guess which you want, so it stops and asks.

```text
<<<<<<< HEAD
const greeting = "Hello"
=======
const greeting = "Hi there"
>>>>>>> feature-login
```

<Callout type="note" title="A human decides">
This isn't a failure. It's Git handing you the decision. Keep the version you want (or combine them), delete the marker lines, then commit. The AI writes, and the human resolves.
</Callout>

---

# Pull Requests: the quality gate

A **Pull Request (PR)** proposes merging your branch on GitHub. Before anything reaches `main`, a human reviews it.

<div class="grid grid-cols-2 gap-4 pt-3">

<FeatureCard title="See every change" icon="i-carbon-compare">
GitHub shows each added (green) and removed (red) line. Teammates comment, suggest, and approve it line by line.
</FeatureCard>

<FeatureCard title="The AI safety gate" icon="i-carbon-user-certification">
When an agent generates hundreds of lines instantly, the PR is where a person inspects them <em>before</em> they go live.
</FeatureCard>

</div>

<div class="grid grid-cols-2 gap-3 pt-3">

<Callout type="note" title="Why 'pull' not 'push'">
You're asking the project's owner to <strong>pull</strong> your branch in. GitLab calls the very same thing a "Merge Request".
</Callout>

<Callout type="tip" title="It's a button">
Opening a PR is one click on GitHub, not a command. What follows is the review conversation: comments, suggestions, approval.
</Callout>

</div>

---

# Nobody touches your laptop

By the time you open a Pull Request, your branch is already pushed to GitHub. Your reviewer works entirely there, never on your machine.

<div class="flex items-stretch justify-center gap-2 pt-8 text-center">

  <div class="flex items-center justify-center w-36 px-2 py-5 rounded-lg bg-black/5 dark:bg-white/10 border border-black/10 dark:border-white/15 font-semibold text-sm">👩‍💻 Your laptop</div>

  <div class="flex flex-col items-center justify-center px-1">
    <Chip>git push</Chip>
    <div class="i-carbon-arrow-right text-xl opacity-40 mt-1"></div>
  </div>

  <div class="flex items-center justify-center w-40 px-2 py-5 rounded-lg bg-emerald-500/10 border border-emerald-500/30 font-semibold">☁️ GitHub</div>

  <div class="flex flex-col items-center justify-center px-1">
    <div class="i-carbon-arrow-left text-xl opacity-40 mb-1"></div>
    <span class="text-xs opacity-70">reviews &amp; merges</span>
  </div>

  <div class="flex items-center justify-center w-36 px-2 py-5 rounded-lg bg-black/5 dark:bg-white/10 border border-black/10 dark:border-white/15 font-semibold text-sm">👩‍🏫 Advisor</div>

</div>

<div class="pt-6">

<Callout type="tip" title="GitHub is the middleman">
Everyone pushes their work up to GitHub and pulls updates down from it. You and your reviewer never connect directly, and nobody reaches into anyone else's computer.
</Callout>

</div>

---

# Forking: contribute to repos you don't own

You can't push directly to someone else's repository. **Forking** makes your own copy on GitHub, the launchpad for contributing back.

<div class="grid grid-cols-2 gap-4 pt-3">

<FeatureCard title="Fork" icon="i-carbon-fork">
Copies someone else's repo into <strong>your own GitHub account</strong>, a repo you fully control.
</FeatureCard>

<FeatureCard title="Clone" icon="i-carbon-download">
Copies a repo to <strong>your computer</strong>. Clone your <em>fork</em> (not the original), so you can push to it.
</FeatureCard>

</div>

<Callout type="tip">
The open-source flow: <strong>fork</strong> → <strong>clone</strong> your fork → branch → open a <strong>Pull Request</strong> back to the original.
</Callout>

---
layout: center
class: text-center
---

# Branch freely, merge deliberately

Isolate every experiment on a branch, then bring it home through a reviewed Pull Request.

<div class="pt-4 opacity-70 text-sm max-w-2xl mx-auto">

One more term you'll hear: <strong>rebase</strong>, replaying your commits on top of the latest <code>main</code> for a cleaner, linear history. A polish step, not a beginner essential.

</div>
