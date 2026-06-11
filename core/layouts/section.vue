<!--
  section — a track-divider layout. Gives each part of the tutorial a
  recognisable full-bleed accent slide. Use with `layout: section`.

  The background, blend mode, and foreground colour come from the palette
  (--deck-section-bg / --deck-section-blend / --deck-section-fg), so each
  variant decides how rich the divider is: flat/glass layer a gradient,
  accent glow, and SVG grain; minimal/print use a flat solid.
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
  padding: 0 var(--deck-section-pad);
  color: var(--deck-section-fg);
  /* The whole layered background lives in the palette (light + dark blocks) so
     variants can swap it — flat/glass keep grain + glows, minimal/print use a
     cheap solid that PDF viewers paint instantly. */
  background: var(--deck-section-bg);
  background-blend-mode: var(--deck-section-blend);
  position: relative;
}

.deck-section__inner {
  max-width: var(--deck-section-max);
  position: relative;
}

/* Chapter marker — thin gradient bar above the eyebrow. */
.deck-section__inner::before {
  content: '';
  display: block;
  width: 64px;
  height: 2px;
  margin-bottom: 1.2rem;
  background: var(--deck-section-bar);
  border-radius: 999px;
}

.deck-section :deep(h1) {
  font-family: var(--deck-font-display);
  font-size: 3.6rem;
  font-weight: 700;
  letter-spacing: -0.015em;
  color: var(--deck-section-fg);
  line-height: 1.05;
  margin: 0.3rem 0 0.7rem;
}
.deck-section :deep(p) {
  font-family: var(--deck-font-body);
  font-size: 1.2rem;
  line-height: 1.55;
  opacity: 0.92;
  margin: 0;
  max-width: 32em;
}

/* Eyebrow on the section divider: dim slightly + recolour the accent swatch
   to the divider foreground (white on flat/glass/minimal, ink on print). */
.deck-section :deep(.deck-eyebrow) {
  color: color-mix(in srgb, var(--deck-section-fg) 85%, transparent);
}
.deck-section :deep(.deck-eyebrow::before) {
  background: var(--deck-section-eyebrow-dot);
}
</style>
