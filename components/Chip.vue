<!--
  Chip — a small monospace pill, used for naming features, layouts, or keys.

  Usage:
    <Chip>default</Chip>
    <Chip tone="tip">passed</Chip>
    <Chip tone="accent" size="sm">v2</Chip>

  Tones: neutral (default) | accent | tip | warning | note | try
  Sizes: sm | md (default)

  Composition is the parent's job — wrap a row of <Chip>s in `flex flex-wrap
  gap-2` (or any grid) to lay them out. Keeps the component minimal and
  matches how <KeyCap> is used.
-->
<script setup lang="ts">
import { computed } from 'vue'

type Tone = 'neutral' | 'accent' | 'tip' | 'warning' | 'note' | 'try'

const props = withDefaults(defineProps<{
  tone?: Tone
  size?: 'sm' | 'md'
}>(), { tone: 'neutral', size: 'md' })

const toneColor: Record<Exclude<Tone, 'neutral'>, string> = {
  accent:  'var(--deck-accent)',
  tip:     'var(--deck-tip)',
  warning: 'var(--deck-warning)',
  note:    'var(--deck-note)',
  try:     'var(--deck-try)',
}

const styleVars = computed(() =>
  props.tone === 'neutral' ? {} : { '--c': toneColor[props.tone] },
)
</script>

<template>
  <span
    class="deck-chip__pill"
    :class="[`deck-chip__pill--${size}`, tone !== 'neutral' && 'deck-chip__pill--toned']"
    :style="styleVars"
  >
    <slot />
  </span>
</template>

<style scoped>
.deck-chip__pill {
  display: inline-block;
  padding: 0.35rem 0.55rem;
  border-radius: var(--deck-radius-sm);
  background: var(--deck-glass-tint);
  border: 1px solid var(--deck-border);
  box-shadow: var(--deck-shadow-inset);
  font-family: var(--deck-font-mono);
  font-size: 0.85em;
  line-height: 1.2;
  color: var(--deck-text);
  -webkit-backdrop-filter: blur(var(--deck-blur-sm));
  backdrop-filter: blur(var(--deck-blur-sm));
  transition: transform 0.15s ease, border-color 0.15s ease, background 0.15s ease;
}
.deck-chip__pill:hover {
  border-color: color-mix(in srgb, var(--deck-accent) 35%, var(--deck-border));
  transform: translateY(-1px);
}

.deck-chip__pill--sm {
  padding: 0.22rem 0.45rem;
  font-size: 0.78em;
}

.deck-chip__pill--toned {
  background: color-mix(in srgb, var(--c) 10%, transparent);
  border-color: color-mix(in srgb, var(--c) 28%, transparent);
  color: color-mix(in srgb, var(--c) 65%, var(--deck-text-strong));
}
.deck-chip__pill--toned:hover {
  border-color: color-mix(in srgb, var(--c) 45%, transparent);
  background: color-mix(in srgb, var(--c) 14%, transparent);
}
</style>
