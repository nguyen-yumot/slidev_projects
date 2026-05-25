<!--
  Callout — a coloured advice box used throughout the tutorial.

  Usage:
    <Callout type="tip">Keep slides to one idea each.</Callout>
    <Callout type="warning" title="Heads up">This needs a dependency.</Callout>

  Types: tip | warning | note | try
-->
<script setup lang="ts">
import { computed } from 'vue'

const props = withDefaults(defineProps<{
  type?: 'tip' | 'warning' | 'note' | 'try'
  title?: string
}>(), { type: 'note' })

const presets = {
  tip:     { color: 'var(--deck-tip)',     icon: 'i-carbon-idea',        label: 'Tip' },
  warning: { color: 'var(--deck-warning)', icon: 'i-carbon-warning',     label: 'Watch out' },
  note:    { color: 'var(--deck-note)',    icon: 'i-carbon-information', label: 'Note' },
  try:     { color: 'var(--deck-try)',     icon: 'i-carbon-rocket',      label: 'Try it yourself' },
} as const

const preset = computed(() => presets[props.type])
</script>

<template>
  <div class="deck-callout" :style="{ '--c': preset.color }">
    <div class="deck-callout__icon" :class="preset.icon" />
    <div class="deck-callout__content">
      <div class="deck-callout__title">{{ title ?? preset.label }}</div>
      <div class="deck-callout__body"><slot /></div>
    </div>
  </div>
</template>

<style scoped>
.deck-callout {
  display: flex;
  gap: 0.7rem;
  padding: 0.8rem 1rem;
  border-radius: var(--deck-radius, 10px);
  border-left: 4px solid var(--c);
  background: color-mix(in srgb, var(--c) 9%, transparent);
  font-size: 0.92em;
  line-height: 1.55;
}
.deck-callout__icon {
  color: var(--c);
  font-size: 1.25rem;
  flex-shrink: 0;
  margin-top: 0.1rem;
}
.deck-callout__title {
  color: var(--c);
  font-weight: 700;
  font-size: 0.74em;
  text-transform: uppercase;
  letter-spacing: 0.07em;
  margin-bottom: 0.15rem;
}
.deck-callout__body :deep(p) { margin: 0.2rem 0; }
.deck-callout__body :deep(p:first-child) { margin-top: 0; }
.deck-callout__body :deep(p:last-child) { margin-bottom: 0; }
</style>
