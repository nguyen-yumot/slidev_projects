---
layout: section
---

<Eyebrow>Before you start</Eyebrow>

# Get set up: Git + <br> a GitHub account

Two one-time things the rest of this course assumes you already have. About five minutes now, and you're ready for Part 3.

---

# Step 1: Install Git

Git is a free tool that runs **on your laptop**. Install it once per machine, then pick your OS:

<div class="flex flex-col gap-2.5 pt-4">

  <div class="grid grid-cols-[5.5rem_14rem_1fr] items-center gap-x-4 px-4 py-3 rounded-lg bg-black/5 dark:bg-white/10 border border-black/10 dark:border-white/15">
    <span class="font-semibold">macOS</span>
    <code class="font-mono text-sm whitespace-nowrap">brew install git</code>
    <span class="text-xs opacity-55">or <code>xcode-select --install</code></span>
  </div>

  <div class="grid grid-cols-[5.5rem_14rem_1fr] items-center gap-x-4 px-4 py-3 rounded-lg bg-black/5 dark:bg-white/10 border border-black/10 dark:border-white/15">
    <span class="font-semibold">Windows</span>
    <code class="font-mono text-sm whitespace-nowrap">winget install Git.Git</code>
    <span class="text-xs opacity-55">or installer at <code>git-scm.com</code></span>
  </div>

  <div class="grid grid-cols-[5.5rem_14rem_1fr] items-center gap-x-4 px-4 py-3 rounded-lg bg-black/5 dark:bg-white/10 border border-black/10 dark:border-white/15">
    <span class="font-semibold">Linux</span>
    <code class="font-mono text-sm whitespace-nowrap">sudo apt install git</code>
    <span class="text-xs opacity-55">Fedora: <code>sudo dnf install git</code></span>
  </div>

</div>

Then confirm it worked:

```bash
git --version        # prints e.g. "git version 2.45.0" → you're ready
```

<Callout type="tip">
No version number? Close and reopen your terminal so it picks up the new command, then try again.
</Callout>

---

# Step 2: Create a GitHub account

GitHub is the free website that stores your repos in the cloud. The account is **separate** from Git itself, and free for everyday use.

<div class="grid grid-cols-2 gap-4 p-3">

<FeatureCard title="Sign up">

<div class="flex flex-col gap-1.5">
  <div>1 · Go to <code>github.com</code> → <strong>Sign up</strong></div>
  <div>2 · Pick a <strong>username</strong> (<code>your-name</code>), the handle shown in every repo URL</div>
  <div>3 · Choose a <strong>password</strong></div>
  <div>4 · Enter your <strong>email</strong> <code>you@personal.com</code>, which you'll reuse in Step 3</div>
</div>

</FeatureCard>

<FeatureCard title="Verify, and you're in">
Confirm the link GitHub emails you. The free plan covers unlimited public <em>and</em> private repos, which is everything this course needs.
</FeatureCard>

</div>

<Callout type="note">
Git and GitHub are <strong>different things</strong>: <strong>Git</strong> runs on your laptop (Part 1), while <strong>GitHub</strong> is one place to keep a copy online. You'll link them securely with an SSH key in Part 7.
</Callout>

---

# Step 3: set your ID card

Tell Git who you are. Use the **same email as your GitHub account** so your commits link back to your profile. This stamps every snapshot with your name.

```bash
git config --global user.name  "Your Name"         # display name (can differ from your username)
git config --global user.email "you@personal.com"  # the same email as Step 2
```

You do this **once per machine**. Every commit you ever make is then attributed to this identity.

<Callout type="note">

`--global` sets your identity for **every** project on your computer. Run the same command **without** `--global` inside a single repo to override it there, which is handy for a work email on work projects:

```bash
git config --global user.email "you@personal.com"   # default for all repos
cd ~/work/project                                    # go into one repo
git config user.email "you@company.com"              # no --global → just this repo
```

</Callout>
