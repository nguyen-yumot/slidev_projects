<!--
  KeyCap — renders its slot as a keyboard key.

  Usage:  Press <KeyCap>o</KeyCap> for the overview, <KeyCap>f</KeyCap> for fullscreen.
-->
<template>
  <kbd class="deck-keycap"><slot /></kbd>
</template>

<style scoped>
.deck-keycap {
  display: inline-block;
  padding: 0.05em 0.45em;
  margin: 0 0.1em;
  font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace;
  font-size: 0.82em;
  line-height: 1.5;
  border-radius: 6px;
  border: 1px solid color-mix(in srgb, currentColor 30%, transparent);
  border-bottom-width: 2px;
  background: color-mix(in srgb, currentColor 8%, transparent);
  white-space: nowrap;
}
</style>
