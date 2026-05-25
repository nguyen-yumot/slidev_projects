<!--
  section — a track-divider layout. Gives each part of the tutorial a
  recognisable full-bleed accent slide. Use with `layout: section`.
-->
<template>
  <div class="slidev-layout deck-section">
    <div class="deck-section__inner">
      <slot />
    </div>
  </div>
</template>

<style scoped>
.deck-section {
  height: 100%;
  display: flex;
  align-items: center;
  padding: 0 3.5rem;
  background:
    radial-gradient(circle at 16% 28%, color-mix(in srgb, #fff 26%, transparent), transparent 55%),
    linear-gradient(120deg, var(--deck-accent-deep), var(--deck-accent));
  color: #fff;
}
.deck-section__inner {
  max-width: 72%;
}
.deck-section :deep(h1) {
  font-size: 3.1rem;
  font-weight: 800;
  color: #fff;
  margin: 0.2rem 0 0.5rem;
}
.deck-section :deep(p) {
  font-size: 1.15rem;
  opacity: 0.92;
  margin: 0;
}
.deck-section :deep(.deck-eyebrow) {
  opacity: 0.85;
}
</style>
