<!--
  Chip — a small monospace pill, used for naming features, layouts, or keys.

  Usage:
    <Chip>default</Chip>
    <div class="flex flex-wrap gap-2"><Chip>cover</Chip><Chip>center</Chip></div>

  Composition is the parent's job — wrap a row of <Chip>s in `flex flex-wrap
  gap-2` (or any grid) to lay them out. Keeps the component minimal and
  matches how <KeyCap> is used.
-->
<template>
  <span class="deck-chip__pill"><slot /></span>
</template>

<style scoped>
.deck-chip__pill {
  display: inline-block;
  padding: 0.4rem 0.55rem;
  border-radius: 8px;
  background: color-mix(in srgb, var(--deck-accent) 10%, transparent);
  border: 1px solid color-mix(in srgb, var(--deck-accent) 25%, transparent);
  font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace;
  font-size: 0.85em;
  line-height: 1.2;
}
</style>
