---
layout: section
---

<Eyebrow>Part 1</Eyebrow>

# Fundamentals

What Git is, what GitHub is, and why version control matters, before you type a single command.

---

# Git is not GitHub

The single most common beginner mix-up. They work together, but they are not the same thing.

<div class="grid grid-cols-2 gap-4 pt-4">

<FeatureCard title="Git: the engine" icon="i-carbon-tool-kit">
A <strong>version control system</strong> that runs <strong>locally</strong> on your computer. It tracks every change, manages history, and works completely offline.
</FeatureCard>

<FeatureCard title="GitHub: the platform" icon="i-carbon-logo-github">
A <strong>cloud service</strong> that <strong>hosts</strong> Git repositories online for backup, collaboration, and code review. It's one of several (GitLab, Bitbucket).
</FeatureCard>

</div>

<Callout type="tip" title="THE PHOTO ANALOGY">
<strong>Git is your camera</strong>. Each <strong>commit</strong> takes a photo of your whole project, a saved version you can return to anytime. <strong>GitHub is the photo-sharing site</strong>, where you post the album so others can view it, comment, and build on it.
</Callout>

<!--
Presenter note: you can use Git for years with no GitHub account at all. GitHub
becomes essential the moment you want backup, collaboration, or a review process.
-->

---

# Version control = a time machine for your code

Before Git, "saving" meant `project_final_v2_ACTUALLY_final.zip`. Version control replaces that mess with something far more powerful.

<div class="grid grid-cols-2 gap-4 pt-3">

<FeatureCard title="Every save is recoverable" icon="i-carbon-recording">
Git records a <strong>snapshot</strong> each time you commit. Rewind to any point in your project's history, and nothing is ever truly lost.
</FeatureCard>

<FeatureCard title="Distributed by design" icon="i-carbon-network-3">
Every developer holds a <strong>full copy</strong> of the entire history. No central server to fail, and it works offline.
</FeatureCard>

</div>

<Callout type="note">
Git was created in 2005 by <strong>Linus Torvalds</strong>, the same mind behind Linux. Today it's used by roughly <strong>94% of developers</strong> (Stack Overflow, 2022): the de-facto industry standard.
</Callout>

---

# Your undo button for the AI era

When an AI agent can rewrite twenty files in ten seconds, you aren't just writing code. You're managing **risk**. Git is the safety net.

<div class="grid grid-cols-2 gap-4 pt-3">

<FeatureCard title="Commit per task, not per session" icon="i-carbon-checkmark-outline">
Finished a feature, like a login modal or a refactor? Snapshot it <strong>immediately</strong>. Each commit is a working checkpoint you can return to.
</FeatureCard>

<FeatureCard title="One bad prompt away" icon="i-carbon-warning-alt">
AI is always one bad prompt from breaking everything. If the next prompt hallucinates, roll back to the last good commit in seconds.
</FeatureCard>

</div>

<Callout type="tip">
The mindset shift: Git turns coding from a high-risk activity into one where you can <strong>experiment boldly</strong>, because every state is recoverable.
</Callout>

---
layout: center
class: text-center
---

# Git is local. GitHub is the cloud.

Keep that one distinction in your pocket.

<div class="pt-4 opacity-70">

Next: the four places your code lives on its way from your editor to the cloud.

</div>
