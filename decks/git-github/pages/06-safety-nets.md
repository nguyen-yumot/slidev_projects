---
layout: section
---

<Eyebrow>Part 6</Eyebrow>

# Safety nets

Undo mistakes and recover work. The freedom to fail, on purpose.

---

# The panic protocol

Something went wrong? There's a command for every kind of "undo".

| Situation | Command |
| --- | --- |
| "I messed up my current, uncommitted edits." | `git restore .` |
| "I need to switch tasks but my work is half-done." | `git stash` … `git stash pop` |
| "A commit broke things, rewind to a known-good point." | `git reset --hard <commit>` |
| "Undo a bad commit, but keep history honest." | `git revert <commit>` |

<Callout type="warning">
<code>reset --hard</code> permanently discards changes. Use it on <strong>local</strong> work only, never on commits you've already pushed and shared.
</Callout>

---

# Which undo? Ask how far it went

The right tool depends on one thing: how far the mistake has already traveled.

<div class="flex flex-col gap-3 pt-4 max-w-3xl mx-auto">

  <div class="flex items-center gap-3">
    <div class="flex-1 px-4 py-3 rounded-lg bg-black/5 dark:bg-white/10 border border-black/10 dark:border-white/15 text-sm">Still in your <strong>unsaved edits</strong></div>
    <div class="i-carbon-arrow-right text-xl opacity-40 flex-none"></div>
    <div class="w-44 flex-none"><Chip tone="accent">git restore</Chip></div>
  </div>

  <div class="flex items-center gap-3">
    <div class="flex-1 px-4 py-3 rounded-lg bg-black/5 dark:bg-white/10 border border-black/10 dark:border-white/15 text-sm">In a <strong>commit</strong>, only on your laptop</div>
    <div class="i-carbon-arrow-right text-xl opacity-40 flex-none"></div>
    <div class="w-44 flex-none"><Chip tone="accent">git reset --hard</Chip></div>
  </div>

  <div class="flex items-center gap-3">
    <div class="flex-1 px-4 py-3 rounded-lg bg-black/5 dark:bg-white/10 border border-black/10 dark:border-white/15 text-sm">Already <strong>pushed</strong> to the team</div>
    <div class="i-carbon-arrow-right text-xl opacity-40 flex-none"></div>
    <div class="w-44 flex-none"><Chip tone="accent">git revert</Chip></div>
  </div>

</div>

<div class="pt-5">

<Callout type="warning">
Already pushed? Don't erase shared history, it breaks everyone else's copy. <code>git revert</code> adds a <strong>new</strong> commit that undoes the old one.
</Callout>

</div>

---

# `revert` vs `reset`: two kinds of undo

Both undo a commit, but they tell very different stories.

<div class="grid grid-cols-2 gap-4 pt-3">

<FeatureCard title="git revert: the safe undo" icon="i-carbon-undo">
Creates a <strong>new</strong> commit that reverses an old one. History stays intact and honest, so everyone sees the fix. Safe on shared branches.
</FeatureCard>

<FeatureCard title="git reset: the rewind" icon="i-carbon-warning-alt">
Moves your branch <strong>back in time</strong>, erasing later commits. Powerful but destructive, so keep it to local, unshared work.
</FeatureCard>

</div>

<Callout type="tip">
Rule of thumb: <strong>revert</strong> in public (shared branches), <strong>reset</strong> in private (local only).
</Callout>

---

# `git stash`: shelve work for later

Mid-task and suddenly need to switch branches? Don't commit half-finished work, just stash it.

```bash
git stash            # tuck all uncommitted changes safely aside
git checkout main    # go fix that urgent bug on another branch
git stash pop        # come back and restore your work, right where you left off
```

<Callout type="note">
It sets your half-done work aside so you can deal with the interruption, then brings it back when you return.
</Callout>
