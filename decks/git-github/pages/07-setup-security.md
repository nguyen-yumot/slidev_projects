---
layout: section
---

<Eyebrow>Part 7</Eyebrow>

# Setup & security

The one-time professional setup, and protecting your secrets, which matters more than ever.

---

# Authentication: prefer SSH

GitHub needs to know it's really you before it accepts a push. There are two ways, and SSH keys are the smoother one.

<div class="grid grid-cols-2 gap-4 pt-3">

<FeatureCard title="HTTPS + token" icon="i-carbon-password">
Works everywhere, but you paste a personal access token (or get prompted), which is fiddly for everyday use.
</FeatureCard>

<FeatureCard title="SSH key" icon="i-carbon-license">
A one-time setup that identifies your machine to GitHub. After that, push and pull with no passwords at all.
</FeatureCard>

</div>

```bash
ssh-keygen -t ed25519 -C "you@personal.com"   # generate a key, then add the .pub to GitHub
```

<Callout type="tip">
Set it up once per computer, and enjoy password-free <code>push</code> and <code>pull</code> forever after.
</Callout>

---

# `.gitignore`, properly: protect your secrets

You met `.gitignore` in Part 3. Here's why it's non-negotiable in the AI era.

<div class="grid grid-cols-2 gap-4 pt-3">

<FeatureCard title="Keys get scraped in seconds" icon="i-carbon-warning-alt">
Your <code>.env</code> holds the API keys that power your LLMs. Push them to a public repo and bots find them almost instantly, racking up real charges.
</FeatureCard>

<FeatureCard title="History never forgets" icon="i-carbon-time">
Committing a secret then deleting it isn't enough. It stays in the Git <strong>history</strong>. The only safe move is to never commit it.
</FeatureCard>

</div>

<Callout type="warning">
Add <code>.env</code> and key files to <code>.gitignore</code> <strong>before</strong> your first commit. If a secret ever does leak, rotate (regenerate) the key immediately.
</Callout>

---

# Defaults worth setting once

A couple of one-time settings that make every future repo behave the way you expect.

<div class="grid grid-cols-2 gap-4 pt-3">

<FeatureCard title="Default branch = main" icon="i-carbon-branch">
Make new repos start on <code>main</code> (not the legacy <code>master</code>), matching today's standard.
</FeatureCard>

<FeatureCard title="Your identity" icon="i-carbon-user">
The <code>user.name</code> / <code>user.email</code> you set during setup, attributed on every commit.
</FeatureCard>

</div>

```bash
git config --global init.defaultBranch main   # new repos start on "main"
```

<Callout type="note">
These live in your global Git config. Set them on a fresh machine and forget about them.
</Callout>
