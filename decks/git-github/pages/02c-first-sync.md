---
layout: section
---

<Eyebrow>Hands-on</Eyebrow>

# See it work: push, pull, restore

Run these now and watch your files travel to GitHub and back, then survive a mistake. Don't worry about the exact commands; Parts 3–4 explain each one.

<div class="pt-3 text-sm opacity-70">Make file changes in Finder or your editor. In the terminal you only ever run <code>git</code> and <code>gh</code>.</div>

---

# Push: send your files up

In **Finder**, make a folder and create three text files inside it named `notes.txt`, `todo.txt`, and `readme.txt`. Open Terminal in that folder, then save your first snapshot:

```bash
git init                       # start tracking this folder
git add .                      # stage all three files
git commit -m "First commit"   # save the snapshot locally
git branch -M main             # name the default branch "main"
```

Now create the GitHub repo and push to it in one command:

```bash
gh repo create hello-git --public --source=. --push
```

<Callout type="tip">
First time only: <code>brew install gh</code>, then <code>gh auth login</code> (a quick browser sign-in). Now refresh <strong>github.com</strong> and you'll see all three files there. Your laptop just synced <strong>up</strong> to the cloud.
</Callout>

---

# Commit again: stack a second snapshot

You rarely stop at one commit. In your editor, add a line to `readme.txt` and save, then take a second snapshot:

```bash
git add .                              # stage the change
git commit -m "Add a note to readme"   # snapshot #2, saved on your laptop
git log --oneline                      # two commits now, newest on top
```

<Callout type="note" title="commit ≠ push">
That <code>commit</code> saved to your laptop only, we haven't pushed it. <code>git push</code> is a separate step that uploads commits to GitHub, and you choose when to run it.
</Callout>

---

# Push now, or later?

`commit` and `push` are two different moves, so you decide when your work goes up to GitHub.

<div class="grid grid-cols-2 gap-4 pt-3">

<FeatureCard title="Push after the change" icon="i-carbon-cloud-upload">
Collaborating, switching computers, or want an off-laptop <strong>backup</strong>? Run <code>git push</code> so GitHub has your latest commits. A good default habit.
</FeatureCard>

<FeatureCard title="No need to push yet" icon="i-carbon-laptop">
Just experimenting or mid-task on your own machine? Keep committing locally and <strong>push later</strong>, at a tidy stopping point. Nothing is lost, it's all saved on your laptop.
</FeatureCard>

</div>

<Callout type="tip">
Rule of thumb: <strong>commit often</strong> (cheap, local, private); <strong>push when it's worth backing up or sharing</strong>. A whole stack of local commits can travel up in a single <code>git push</code>.
</Callout>

---

# Time-travel: visit an old commit, then come back

Two commits means you can hop back to an earlier one, look around, then return, all without losing a thing.

```bash
git log --oneline       # copy the short ID of "First commit", e.g. a1b2c3d
git checkout a1b2c3d    # your files become snapshot #1 (no readme note yet)
git checkout main       # jump back to the latest commit, the note returns
```

<Callout type="tip">
You're only <strong>visiting</strong>: <code>git checkout a1b2c3d</code> shows the project exactly as it was at that commit, and <code>git checkout main</code> returns you to the newest one. Nothing is changed or deleted here, unlike <code>reset --hard</code> in Part 6.
</Callout>

---

# Safety net: undo a mistake

Everything you commit is saved, so mistakes are reversible. Try it: in **Finder** delete `todo.txt`, and in your editor wipe the text in `notes.txt` and save. Then:

```bash
git status               # todo.txt deleted, notes.txt modified
git restore todo.txt     # bring the deleted file back
git restore notes.txt    # revert the wrecked file to its last snapshot
```

<Callout type="tip">
<code>git restore</code> rewinds your working files to the last commit, the snapshot that's also safe on GitHub. Nothing you've committed is ever truly lost.
</Callout>

---

# Pull: bring a change down

Changes travel the other way too. Make an edit on GitHub itself:

<div class="flex flex-col gap-1.5 pt-2">
  <div>1 · On <strong>github.com</strong>, open <code>notes.txt</code> → click the ✏️ pencil → add a line → <strong>Commit changes</strong></div>
  <div>2 · Back in your terminal, run the command below</div>
  <div>3 · Open <code>notes.txt</code> on your laptop, and the new line is already there</div>
</div>

```bash
git pull        # download GitHub's new commit to your laptop
```

<Callout type="note">
<code>git pull</code> = fetch + merge: it brings <strong>down</strong> commits that are on GitHub but not yet on your laptop. (It doesn't undo your local edits; that's what <code>git restore</code> is for.)
</Callout>

---

# What just happened

| Command | What it did |
| --- | --- |
| `git init` | started tracking your folder |
| `git add` | staged files for the next snapshot |
| `git commit` | saved a snapshot to local history |
| `git log --oneline` | listed your commits and their IDs |
| `gh repo create … --push` | made the GitHub repo and pushed |
| `git push` | sends new local commits up to GitHub |
| `git pull` | brings GitHub's commits down to your laptop |
| `git checkout <id>` | visits an old commit (`git checkout main` returns) |
| `git restore` | rewinds a file to its last saved snapshot |

<div class="pt-3 text-sm opacity-75 text-center">Commit often locally; push when it's worth backing up or sharing. <code>git checkout</code> time-travels, <code>git restore</code> rewinds. Parts 3–4 unpack init/add/commit/push/pull; Part 6 covers restore and reset.</div>
