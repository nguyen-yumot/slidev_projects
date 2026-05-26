<!--
  ColHead — a consistent column heading inside multi-column slides.

  Usage:
    <ColHead>Typography</ColHead>
    <ColHead tone="tip">What works</ColHead>
    <ColHead align="center">Centered</ColHead>

  Extra classes pass through, so positioning helpers still work:
    <ColHead class="pt-4">Connect &amp; settings</ColHead>

  Tones: accent (default) | tip | warning | note | try | neutral
  Align: left (default) | center
-->
<script setup lang="ts">
import { computed } from 'vue'

type Tone = 'accent' | 'tip' | 'warning' | 'note' | 'try' | 'neutral'

const props = withDefaults(defineProps<{
  tone?: Tone
  align?: 'left' | 'center'
}>(), { tone: 'accent', align: 'left' })

const toneColor: Record<Exclude<Tone, 'neutral'>, string> = {
  accent:  'var(--deck-accent)',
  tip:     'var(--deck-tip)',
  warning: 'var(--deck-warning)',
  note:    'var(--deck-note)',
  try:     'var(--deck-try)',
}

const styleVars = computed(() =>
  props.tone === 'neutral'
    ? { '--c': 'var(--deck-text-muted)' }
    : { '--c': toneColor[props.tone] },
)
</script>

<template>
  <div
    class="deck-colhead__label"
    :class="[`deck-colhead__label--${align}`]"
    :style="styleVars"
  >
    <slot />
  </div>
</template>

<style scoped>
.deck-colhead__label {
  display: flex;
  align-items: center;
  gap: 0.55rem;
  font-family: var(--deck-font-body);
  font-weight: 600;
  font-size: 1.05rem;
  color: var(--deck-text-strong);
  padding-bottom: 0.4rem;
  margin-bottom: 0.4rem;
  border-bottom: 1px solid var(--deck-border);
}
.deck-colhead__label::before {
  content: '';
  display: inline-block;
  width: 4px;
  height: 18px;
  border-radius: 2px;
  background: linear-gradient(180deg, var(--c), color-mix(in srgb, var(--c) 50%, transparent));
  flex-shrink: 0;
}

.deck-colhead__label--center {
  justify-content: center;
}
</style>
