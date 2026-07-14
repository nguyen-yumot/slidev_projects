---
layout: section
---

<Eyebrow>Part 2</Eyebrow>

# The four locations

To control your code, picture it moving through four rooms, each a different *state* of your project.

---
layout: multicolumns
---

# Four rooms your code lives in

<template #col1>

<ColHead>1 · Working Directory</ColHead>

The **playground**, your project folder, where you actively edit.

<div class="pt-2 text-sm opacity-80">State: <strong>untracked</strong> or <strong>modified</strong></div>

<div class="pt-2"><Chip>git add</Chip> → Staging</div>

</template>

<template #col2>

<ColHead>2 · Staging Area</ColHead>

The **mirror**, where you group exactly the changes you want in the next snapshot.

<div class="pt-2 text-sm opacity-80">State: <strong>staged</strong></div>

<div class="pt-2"><Chip>git commit</Chip> → Local repo</div>

</template>

<template #col3>

<ColHead>3 · Local Repository</ColHead>

The **filing cabinet**, the hidden `.git` folder with your full history.

<div class="pt-2 text-sm opacity-80">State: <strong>committed</strong></div>

<div class="pt-2"><Chip>git push</Chip> → Remote</div>

</template>

<template #col4>

<ColHead>4 · Remote (GitHub)</ColHead>

The **cloud backup**, the shared mirror, safe from local hardware failure.

<div class="pt-2 text-sm opacity-80">State: <strong>synced</strong></div>

<div class="pt-2"><Chip>git pull</Chip> → Local repo</div>

</template>

---

# The flow: how a change travels

Every command's real job is to move your work between rooms, out to the cloud and back again.

<div class="text-xs font-semibold uppercase tracking-widest opacity-45 text-center pt-6">Out to the cloud</div>

<div class="flex items-stretch justify-center gap-1.5 pt-2 text-center">

  <div class="flex items-center justify-center w-34 px-2 py-4 rounded-lg bg-black/5 dark:bg-white/10 border border-black/10 dark:border-white/15 font-semibold text-sm">Working Directory</div>

  <div class="flex flex-col items-center justify-center px-1">
    <Chip>git add</Chip>
    <div class="i-carbon-arrow-right text-xl opacity-40 mt-1"></div>
  </div>

  <div class="flex items-center justify-center w-34 px-2 py-4 rounded-lg bg-black/5 dark:bg-white/10 border border-black/10 dark:border-white/15 font-semibold text-sm">Staging Area</div>

  <div class="flex flex-col items-center justify-center px-1">
    <Chip>git commit</Chip>
    <div class="i-carbon-arrow-right text-xl opacity-40 mt-1"></div>
  </div>

  <div class="flex items-center justify-center w-34 px-2 py-4 rounded-lg bg-black/5 dark:bg-white/10 border border-black/10 dark:border-white/15 font-semibold text-sm">Local Repository</div>

  <div class="flex flex-col items-center justify-center px-1">
    <Chip>git push</Chip>
    <div class="i-carbon-arrow-right text-xl opacity-40 mt-1"></div>
  </div>

  <div class="flex items-center justify-center w-34 px-2 py-4 rounded-lg bg-emerald-500/10 border border-emerald-500/30 font-semibold text-sm">Remote · GitHub</div>

</div>

<div class="text-xs font-semibold uppercase tracking-widest opacity-45 text-center pt-7">Coming back the other way</div>

<div class="flex items-stretch justify-center gap-1.5 pt-2 text-center">

  <div class="flex items-center justify-center w-34 px-2 py-4 rounded-lg bg-black/5 dark:bg-white/10 border border-black/10 dark:border-white/15 font-semibold text-sm">Working Directory</div>

  <div class="flex flex-col items-center justify-center px-1">
    <div class="flex gap-1">
      <Chip>git checkout</Chip>
      <Chip>git restore</Chip>
    </div>
    <div class="i-carbon-arrow-left text-xl opacity-40 mt-1"></div>
  </div>

  <div class="flex items-center justify-center w-34 px-2 py-4 rounded-lg bg-black/5 dark:bg-white/10 border border-black/10 dark:border-white/15 font-semibold text-sm">Local Repository</div>

  <div class="flex flex-col items-center justify-center px-1">
    <div class="flex gap-1">
      <Chip>git pull</Chip>
      <Chip>git fetch</Chip>
    </div>
    <div class="i-carbon-arrow-left text-xl opacity-40 mt-1"></div>
  </div>

  <div class="flex items-center justify-center w-34 px-2 py-4 rounded-lg bg-emerald-500/10 border border-emerald-500/30 font-semibold text-sm">Remote · GitHub</div>

</div>

<div class="pt-6 text-sm opacity-75 text-center">

<Chip>git pull</Chip> / <Chip>git fetch</Chip> bring the cloud down to local, while <Chip>git checkout</Chip> / <Chip>git restore</Chip> bring that history back into your working files.

</div>

---

# The `.git` folder is the brain

When you run `git init` or `git clone`, Git creates one hidden folder: `.git`. It holds **everything**: every version, every commit message, all the history.

<div class="grid grid-cols-2 gap-4 p-3">

<FeatureCard title="It's the whole repository" icon="i-carbon-data-base">
The files you see are just the <em>current</em> checkout. The full timeline lives compressed inside <code>.git</code>.
</FeatureCard>

<FeatureCard title="Decentralised" icon="i-carbon-network-4">
Because every clone carries the whole <code>.git</code>, there's no single point of failure. The cloud is just another copy.
</FeatureCard>

</div>

<Callout type="warning">
Delete the <code>.git</code> folder and the project is no longer tracked. Git forgets it was ever a repository. Leave it alone, since you almost never touch it directly.
</Callout>

<!--
Presenter note: "ls -a" reveals the hidden .git folder. You don't edit it by hand.
The commands are the proper interface to it.
-->
