---
layout: section
---

<Eyebrow>Part 4</Eyebrow>

# GitHub & syncing

Connecting your local repo to the cloud, and keeping the two in step.

---

# The cloud bridge

Your commits are safe locally, but only on one machine. **Pushing** copies them to GitHub: off-site backup, plus a place to collaborate.

```bash
git push origin main           # send your local commits up to the cloud
```

<Callout type="note">
Git is <strong>distributed</strong>: GitHub isn't the "boss", just another copy. Your full history still lives on your laptop even if the server goes down.
</Callout>

---

# `fetch` vs `pull`: the classic confusion

Both bring news from GitHub. The difference is whether they touch the files you're looking at.

<div class="grid grid-cols-2 gap-4 pt-3 pb-2">

<FeatureCard title="git fetch: look, don't touch" icon="i-carbon-search">
Downloads the latest from GitHub into your local <em>knowledge</em> of the remote. Your working files stay exactly as they are.
</FeatureCard>

<FeatureCard title="git pull: fetch + merge" icon="i-carbon-arrow-down">
Downloads <strong>and</strong> immediately merges those changes into your current files. <code>pull</code> = <code>fetch</code> + <code>merge</code>.
</FeatureCard>

</div>

| | Downloads changes | Changes your files |
| --- | :---: | :---: |
| `git fetch` | ✅ | ❌ |
| `git pull` | ✅ | ✅ |

---

# `origin` and `main`: the vocabulary

Two words you'll see constantly when pushing and pulling.

<div class="grid grid-cols-2 gap-4 pt-3">

<FeatureCard title="origin" icon="i-carbon-cloud">
The default <strong>nickname</strong> for your remote on GitHub. <code>git push origin main</code> means "push to <em>origin</em>, the branch <em>main</em>."
</FeatureCard>

<FeatureCard title="main" icon="i-carbon-star">
The default <strong>primary branch</strong>, your stable, production-ready code.
</FeatureCard>

</div>

<Callout type="note">
In 2020 the industry renamed the default branch from <code>master</code> to <code>main</code>. You'll still meet <code>master</code> in older projects, but they mean the same thing.
</Callout>

---

# One golden rule: pull before you push

If a teammate pushed while you were working, your push will be rejected. Pull their changes in first, then send yours.

```bash
git pull origin main           # 1. get everyone's latest work
git push origin main           # 2. now send yours
```

<Callout type="tip">
This habit prevents most "rejected push" errors. It also catches merge conflicts early, while they're still small. More on conflicts next.
</Callout>
