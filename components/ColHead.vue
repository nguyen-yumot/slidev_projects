<!--
  ColHead — a consistent column heading inside multi-column slides.

  Usage:
    <ColHead>Typography</ColHead>

  Replaces the hand-written `<div class="deck-colhead">…</div>`. Extra classes
  pass through, so positioning helpers still work:
    <ColHead class="pt-4">Connect &amp; settings</ColHead>
-->
<template>
  <div class="deck-colhead__label"><slot /></div>
</template>

<style scoped>
.deck-colhead__label {
  font-weight: 700;
  font-size: 1.05rem;
  color: var(--deck-accent);
  margin-bottom: 0.15rem;
}
</style>
