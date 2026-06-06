<!--
  FeatureCard — a titled card with an optional icon, used for overviews.

  Usage:
    <FeatureCard title="Layouts" icon="i-carbon-grid">
    Pick a layout per slide with the `layout:` frontmatter key.
    </FeatureCard>

    <FeatureCard title="Tip" icon="i-carbon-idea" tone="tip" row>
    Row layout puts the icon next to the title.
    </FeatureCard>

    <FeatureCard title="Hero" icon="i-carbon-star" elevation="floating" display>
    Display-font title with deeper shadow.
    </FeatureCard>

  Pass `row` to put icon + title on the same line, body below.
  Optional: tone, elevation, display, interactive.
-->
<script setup lang="ts">
import { computed } from 'vue'

type Tone = 'default' | 'accent' | 'tip' | 'warning' | 'note' | 'try'

const props = withDefaults(defineProps<{
  title: string
  icon?: string
  row?: boolean | string
  tone?: Tone
  elevation?: 'flat' | 'raised' | 'floating'
  display?: boolean | string
  interactive?: boolean | string
}>(), { tone: 'default', elevation: 'raised' })

// MDC passes bare attributes as "" and Vue as booleans — accept both.
const truthy = (v: boolean | string | undefined) => v !== undefined && v !== false
const isRow = computed(() => truthy(props.row))
const isDisplay = computed(() => truthy(props.display))
const isInteractive = computed(() => truthy(props.interactive))

const toneColor: Record<Exclude<Tone, 'default'>, string> = {
  accent:  'var(--deck-accent)',
  tip:     'var(--deck-tip)',
  warning: 'var(--deck-warning)',
  note:    'var(--deck-note)',
  try:     'var(--deck-try)',
}

const styleVars = computed(() =>
  props.tone === 'default' ? {} : { '--c': toneColor[props.tone] },
)
</script>

<template>
  <div
    class="deck-card"
    :class="[
      `deck-card--${elevation}`,
      tone !== 'default' && 'deck-card--toned',
      { 'deck-card--row': isRow, 'deck-card--display': isDisplay, 'deck-card--interactive': isInteractive },
    ]"
    :style="styleVars"
  >
    <div v-if="icon" class="deck-card__icon-tile">
      <div class="deck-card__icon" :class="icon" />
    </div>
    <div class="deck-card__title">{{ title }}</div>
    <div class="deck-card__body"><slot /></div>
  </div>
</template>

<style scoped>
.deck-card {
  --c: var(--deck-accent);
  display: flex;
  flex-direction: column;
  gap: 0.55rem;
  padding: 1.15rem 1.2rem;
  border-radius: var(--deck-radius-lg);
  border: 1px solid transparent;
  background:
    linear-gradient(var(--deck-glass), var(--deck-glass)) padding-box,
    var(--deck-border-grad) border-box;
  -webkit-backdrop-filter: blur(var(--deck-blur));
  backdrop-filter: blur(var(--deck-blur));
  color: var(--deck-text);
  height: 100%;
  position: relative;
  min-width: 0;
  transition: transform 0.18s ease, box-shadow 0.18s ease;
}

.deck-card--flat     { box-shadow: var(--deck-shadow-sm); }
.deck-card--raised   { box-shadow: var(--deck-shadow-md); }
.deck-card--floating { box-shadow: var(--deck-shadow-lg); }

.deck-card--toned {
  background:
    linear-gradient(var(--deck-glass), var(--deck-glass)) padding-box,
    linear-gradient(135deg,
      color-mix(in srgb, var(--c) 55%, transparent),
      color-mix(in srgb, var(--c) 18%, transparent)) border-box;
}

.deck-card--interactive:hover {
  transform: translateY(-2px);
  box-shadow: var(--deck-shadow-lg);
}

.deck-card__icon-tile {
  width: 36px;
  height: 36px;
  border-radius: 10px;
  background: color-mix(in srgb, var(--c) 14%, var(--deck-accent-soft));
  display: flex;
  align-items: center;
  justify-content: center;
}
.deck-card__icon {
  color: var(--c);
  font-size: 1.25rem;
}

.deck-card__title {
  font-family: var(--deck-font-body);
  font-weight: 700;
  font-size: 1.08rem;
  letter-spacing: -0.005em;
  color: var(--deck-text-strong);
}
.deck-card--display .deck-card__title {
  font-family: var(--deck-font-display);
  font-weight: 700;
  font-size: 1.2rem;
}

.deck-card__body {
  font-size: 0.875em;
  line-height: 1.6;
  color: var(--deck-text-muted);
}
.deck-card__body :deep(p) { margin: 0; }
.deck-card__body :deep(p + p) { margin-top: 0.4rem; }

/* Fenced code blocks inside a card — keep them within the card and scroll wide
   lines instead of spilling past the rounded edge. */
.deck-card__body :deep(pre) {
  margin: 0.5rem 0 0;
  max-width: 100%;
  overflow-x: auto;
  padding: 0.6rem 0.8rem;
  font-size: 0.85em;
}
.deck-card__body :deep(pre:first-child) { margin-top: 0; }
.deck-card__body :deep(pre:last-child)  { margin-bottom: 0; }

/* Row variant — icon tile next to title, body spans full width below. */
.deck-card--row {
  display: grid;
  grid-template-columns: auto 1fr;
  column-gap: 0.85rem;
  row-gap: 0.5rem;
  align-items: center;
}
.deck-card--row .deck-card__icon-tile { grid-column: 1; grid-row: 1; width: 32px; height: 32px; }
.deck-card--row .deck-card__icon      { font-size: 1.1rem; }
.deck-card--row .deck-card__title     { grid-column: 2; grid-row: 1; }
.deck-card--row .deck-card__body      { grid-column: 1 / -1; grid-row: 2; }
</style>
