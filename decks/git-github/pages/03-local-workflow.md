---
layout: section
---

<Eyebrow>Part 3</Eyebrow>

# The local workflow

From an empty folder to your first saved snapshot, using the commands you'll run every day.

---

# Start tracking: `init` vs `clone`

Two ways a folder becomes a Git repository, and both create the hidden `.git`.

<div class="grid grid-cols-2 gap-4 pt-3">

<FeatureCard title="Brand-new project" icon="i-carbon-folder-add">
Starting from your own folder? <code>git init</code> turns it into a fresh, empty repository, right where you are.
</FeatureCard>

<FeatureCard title="Existing project" icon="i-carbon-download">
Want a project that already exists online? <code>git clone &lt;url&gt;</code> downloads it, full history and all.
</FeatureCard>

</div>

```bash
git init                       # start version control in the current folder
git clone <url>                # or copy an existing project from GitHub
```

<Callout type="tip">
Cloning with an <strong>SSH</strong> URL skips typing your password every time. More on SSH keys in Part 7.
</Callout>

---

# `.gitignore`: your security guard

A plain text file listing what Git should **never** track. Create it before your first commit.

```bash
# .gitignore
.env                 # secrets and API keys, never commit these
node_modules/        # huge, re-installable dependency folders
.DS_Store            # operating-system junk
```

<Callout type="warning">
<strong>Never commit secrets.</strong> Anything matched by <code>.gitignore</code> stays in your working directory and never travels to GitHub. Why this matters so much in the AI era: Part 7.
</Callout>

---

# The daily loop

Three commands, run over and over. They are the heartbeat of working with Git.

```bash
git status                      # what changed? run this constantly
git add .                       # stage your changes for the next snapshot
git commit -m "Add login form"  # save the snapshot to your local history
```

<Callout type="tip" title="The getting-ready analogy">
<code>git add</code> is checking yourself in the <strong>mirror</strong>, where you can still swap a shirt (unstage a file) before you leave. <code>git commit</code> is walking out the door, and the snapshot is final.
</Callout>

<!--
Presenter note: git status is the most-run command in all of Git. Encourage learners
to run it before and after every add and commit until the model is second nature.
-->

---

# Good commits, and reading history

A message in the present tense, describing one logical change, is a gift to future-you.

```bash
git commit -m "Add password reset email"   # present tense, one idea
git commit -am "Fix footer typo"            # -a: stage tracked files + commit in one step
git log --oneline                           # scan history compactly, find commit IDs
```

<div class="grid grid-cols-2 gap-4 pt-2">

<Callout type="tip" title="One commit = one idea">
Small, focused commits keep history readable and make rollbacks surgical.
</Callout>

<Callout type="note" title="Check before you commit">
Run <code>git status</code> first to make sure no <code>.env</code> or stray file is about to be saved.
</Callout>

</div>

---

# What "history" really is

Your commits aren't a loose pile of saves. Each one is linked to the one before it, and that ordered chain **is** your history.

<div class="grid grid-cols-2 gap-4 pt-3">

<FeatureCard title="A chain of snapshots" icon="i-carbon-version">
Every commit points back to its parent, forming one timeline from your first save to now. <code>git log</code> walks that chain. Your <strong>working files</strong> are only the latest link; <strong>history</strong> is every link behind it.
</FeatureCard>

<FeatureCard title="History never forgets" icon="i-carbon-data-base">
A file you once committed stays in history <strong>even after you delete it</strong> from your folder. Removing it today doesn't erase it from older snapshots, which is exactly why a secret must never be committed in the first place.
</FeatureCard>

</div>

<Callout type="warning" title="Deleting a file is not erasing its history">
Deleting a file only changes your <strong>newest</strong> snapshot; every older commit still holds it. Truly purging something means <strong>rewriting history</strong> (advanced), and once a commit is shared, rewriting it breaks everyone else's copy, so we <code>revert</code> instead (Part 6).
</Callout>
