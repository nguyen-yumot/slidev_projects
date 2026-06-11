<!--
  Callout — a coloured advice box used throughout the tutorial.

  Usage:
    <Callout type="tip">Keep slides to one idea each.</Callout>
    <Callout type="warning" title="Heads up">This needs a dependency.</Callout>
    <Callout type="note" size="sm" compact>Inline aside.</Callout>
    <Callout type="try" tone="solid">Filled emphasis variant.</Callout>
    <Callout type="blank">Highlighted text with no label or icon.</Callout>

  Types: tip | warning | note | try | blank
  Sizes: sm | md (default) | lg
  Tones: soft (default) | solid | outline
  compact: drops the icon tile and label row for tight inline use.
-->
<script setup lang="ts">
import { computed } from 'vue'

const props = withDefaults(defineProps<{
  type?: 'tip' | 'warning' | 'note' | 'try' | 'blank'
  title?: string
  size?: 'sm' | 'md' | 'lg'
  compact?: boolean | string
  tone?: 'soft' | 'solid' | 'outline'
}>(), { type: 'note', size: 'md', tone: 'soft' })

const presets = {
  tip:     { color: 'var(--deck-tip)',     icon: 'i-carbon-idea',        label: 'Tip' },
  warning: { color: 'var(--deck-warning)', icon: 'i-carbon-warning',     label: 'Watch out' },
  note:    { color: 'var(--deck-note)',    icon: 'i-carbon-information', label: 'Note' },
  try:     { color: 'var(--deck-try)',     icon: 'i-carbon-rocket',      label: 'Try it yourself' },
  blank:   { color: 'var(--deck-text-muted)', icon: '',                  label: '' },
} as const

const preset = computed(() => presets[props.type])
// MDC passes bare attributes as "", Vue passes booleans — accept both.
const isCompact = computed(() => props.compact !== undefined && props.compact !== false)
</script>

<template>
  <div
    class="deck-callout"
    :class="[`deck-callout--${size}`, `deck-callout--${tone}`, `deck-callout--${type}`, { 'deck-callout--compact': isCompact }]"
    :style="{ '--c': preset.color }"
  >
    <div v-if="!isCompact && preset.icon" class="deck-callout__icon-tile">
      <div class="deck-callout__icon" :class="preset.icon" />
    </div>
    <div v-else-if="isCompact && preset.icon" class="deck-callout__icon deck-callout__icon--inline" :class="preset.icon" />
    <div class="deck-callout__content">
      <div v-if="!isCompact && (title ?? preset.label)" class="deck-callout__title">{{ title ?? preset.label }}</div>
      <div class="deck-callout__body"><slot /></div>
    </div>
  </div>
</template>

<style scoped>
.deck-callout {
  display: flex;
  align-items: flex-start;
  gap: 0.75rem;
  padding: 0.85rem 1rem;
  border-radius: var(--deck-radius-md);
  border: 1px solid color-mix(in srgb, var(--c) 22%, var(--deck-border));
  background: var(--deck-glass);
  -webkit-backdrop-filter: var(--deck-backdrop-sm);
  backdrop-filter: var(--deck-backdrop-sm);
  box-shadow: var(--deck-shadow-sm);
  font-size: 0.92em;
  line-height: 1.55;
  color: var(--deck-text);
  position: relative;
  overflow: hidden;
}
/* Accent rail along the left edge (gradient or solid, per palette). */
.deck-callout::before {
  content: '';
  position: absolute;
  inset: 0 auto 0 0;
  width: 3px;
  background: var(--deck-callout-rail);
}

.deck-callout__icon-tile {
  flex-shrink: 0;
  width: 28px;
  height: 28px;
  border-radius: 8px;
  background: var(--deck-callout-tile-bg);
  display: flex;
  align-items: center;
  justify-content: center;
  margin-top: 0.1rem;
}
.deck-callout__icon {
  color: var(--c);
  font-size: 1.05rem;
}
.deck-callout__icon--inline {
  font-size: 1.1rem;
  margin-top: 0.15rem;
  flex-shrink: 0;
}

/* min-width:0 lets this flex item shrink below its content, so a wide code
   block scrolls (overflow-x:auto above) instead of stretching the callout. */
.deck-callout__content {
  min-width: 0;
}

.deck-callout__title {
  color: var(--c);
  font-weight: 600;
  font-size: 0.72em;
  text-transform: uppercase;
  letter-spacing: 0.14em;
  margin-bottom: 0.2rem;
}
.deck-callout__body :deep(p)            { margin: 0.2rem 0; }
.deck-callout__body :deep(p:first-child){ margin-top: 0; }
.deck-callout__body :deep(p:last-child) { margin-bottom: 0; }

/* Fenced code blocks inside a callout. The callout is overflow:hidden, so a
   wide line would be silently clipped — constrain to the callout width and let
   long lines scroll instead. Tighter padding/font so code sits inside neatly. */
.deck-callout__body :deep(pre) {
  margin: 0.45rem 0;
  max-width: 100%;
  overflow-x: auto;
  padding: 0.6rem 0.8rem;
  font-size: 0.85em;
}
.deck-callout__body :deep(pre:first-child) { margin-top: 0; }
.deck-callout__body :deep(pre:last-child)  { margin-bottom: 0; }

/* Size variants */
.deck-callout--sm { padding: 0.6rem 0.8rem; font-size: 0.85em; gap: 0.55rem; }
.deck-callout--sm .deck-callout__icon-tile { width: 22px; height: 22px; border-radius: 6px; }
.deck-callout--sm .deck-callout__icon { font-size: 0.9rem; }

.deck-callout--lg { padding: 1.1rem 1.25rem; font-size: 1em; gap: 0.9rem; }
.deck-callout--lg .deck-callout__icon-tile { width: 34px; height: 34px; border-radius: 10px; }
.deck-callout--lg .deck-callout__icon { font-size: 1.25rem; }

/* Tone variants */
.deck-callout--solid {
  background: color-mix(in srgb, var(--c) 14%, var(--deck-surface));
  border-color: color-mix(in srgb, var(--c) 32%, transparent);
}
.deck-callout--outline {
  background: transparent;
  -webkit-backdrop-filter: none;
  backdrop-filter: none;
  border-color: color-mix(in srgb, var(--c) 38%, transparent);
  box-shadow: none;
}

/* Blank variant — minimal highlight, no icon/label.
   The rail becomes a deliberate centered bar and the body sits with a touch
   more left air to compensate for the missing icon-tile. */
.deck-callout--blank { padding-left: 1.75rem; }
.deck-callout--blank.deck-callout--sm { padding-left: 1.4rem; }
.deck-callout--blank.deck-callout--lg { padding-left: 2.1rem; }
.deck-callout--blank::before {
  width: 4px;
  background: var(--deck-callout-rail-blank);
}
.deck-callout--blank.deck-callout--solid {
  background: var(--deck-surface-2);
  border-color: var(--deck-border-strong);
}
.deck-callout--blank.deck-callout--compact { padding-left: 1.1rem; }

/* Compact variant — title is omitted from the template; this just tightens
   spacing and centers the icon vertically with the body text. */
.deck-callout--compact {
  padding: 0.45rem 0.7rem;
  gap: 0.5rem;
  align-items: center;
}
.deck-callout--compact .deck-callout__body { font-size: 0.95em; }

/* Scale nested code down to match the small / compact callouts. */
.deck-callout--sm .deck-callout__body :deep(pre),
.deck-callout--compact .deck-callout__body :deep(pre) {
  padding: 0.45rem 0.6rem;
  font-size: 0.8em;
  margin: 0.3rem 0;
}
</style>
