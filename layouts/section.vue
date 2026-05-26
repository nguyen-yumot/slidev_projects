<!--
  section — a track-divider layout. Gives each part of the tutorial a
  recognisable full-bleed accent slide. Use with `layout: section`.

  Layered background: deep-ocean gradient, soft accent glow, top-left
  highlight (sun on water), and a subtle SVG grain overlay for texture.
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
  color: #fff;
  background:
    /* Grain texture overlay (inline SVG fractalNoise) */
    url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='220' height='220'><filter id='n'><feTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='2' stitchTiles='stitch'/><feColorMatrix values='0 0 0 0 1  0 0 0 0 1  0 0 0 0 1  0 0 0 0.5 0'/></filter><rect width='100%25' height='100%25' filter='url(%23n)' opacity='0.55'/></svg>"),
    /* Top-left soft highlight (sun on the water) */
    radial-gradient(circle at 14% 18%, rgba(255, 255, 255, 0.20), transparent 50%),
    /* Accent glow */
    radial-gradient(circle at 78% 22%, var(--deck-accent-glow), transparent 55%),
    /* Base diagonal — deep sea to open ocean */
    linear-gradient(135deg, #082f49 0%, #0c4a6e 45%, #0284c7 100%);
  background-blend-mode: overlay, normal, normal, normal;
  position: relative;
}

:global(.dark) .deck-section {
  background:
    url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='220' height='220'><filter id='n'><feTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='2' stitchTiles='stitch'/><feColorMatrix values='0 0 0 0 1  0 0 0 0 1  0 0 0 0 1  0 0 0 0.5 0'/></filter><rect width='100%25' height='100%25' filter='url(%23n)' opacity='0.4'/></svg>"),
    radial-gradient(circle at 14% 18%, rgba(255, 255, 255, 0.10), transparent 50%),
    radial-gradient(circle at 78% 22%, var(--deck-accent-glow), transparent 55%),
    linear-gradient(135deg, #020617 0%, #082f49 45%, #075985 100%);
  background-blend-mode: overlay, normal, normal, normal;
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
  background: linear-gradient(90deg, #ffffff, rgba(255, 255, 255, 0.1));
  border-radius: 999px;
}

.deck-section :deep(h1) {
  font-family: var(--deck-font-display);
  font-size: 3.6rem;
  font-weight: 700;
  letter-spacing: -0.015em;
  color: #fff;
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

/* Eyebrow on the dark section: dim slightly + whiten the accent swatch. */
.deck-section :deep(.deck-eyebrow) {
  color: rgba(255, 255, 255, 0.85);
}
.deck-section :deep(.deck-eyebrow::before) {
  background: linear-gradient(135deg, #ffffff, rgba(255, 255, 255, 0.55));
}
</style>
