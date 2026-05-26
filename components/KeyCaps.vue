<!--
  KeyCaps — render a comma-separated list of keys as keycaps.

  Usage:
    <KeyCaps>o</KeyCaps> Slide overview
    <KeyCaps>Space,→</KeyCaps> Next animation or slide
    <KeyCaps joiner="+">Cmd, K</KeyCaps>  → Cmd + K

  The slot content is a comma-separated keys string. Whitespace around
  commas is trimmed. Renders one <KeyCap> per key — the plural of <KeyCap>.
  Set `joiner` to render a separator between caps (e.g. `+` for chords).
-->
<script setup lang="ts">
import { computed, useSlots } from 'vue'
import KeyCap from './KeyCap.vue'

withDefaults(defineProps<{
  joiner?: string
  size?: 'sm' | 'md' | 'lg'
  tone?: 'neutral' | 'accent'
}>(), { joiner: '', size: 'md', tone: 'neutral' })

const slots = useSlots()

function textOf(nodes: any[]): string {
  return nodes.map((n) => {
    if (typeof n === 'string') return n
    if (typeof n?.children === 'string') return n.children
    if (Array.isArray(n?.children)) return textOf(n.children)
    return ''
  }).join('')
}

const keys = computed(() => {
  const nodes = slots.default?.() ?? []
  return textOf(nodes).split(',').map(k => k.trim()).filter(Boolean)
})
</script>

<template>
  <span class="deck-keycaps">
    <template v-for="(k, i) in keys" :key="i">
      <span v-if="i > 0 && joiner" class="deck-keycaps__joiner">{{ joiner }}</span>
      <KeyCap :size="size" :tone="tone">{{ k }}</KeyCap>
    </template>
  </span>
</template>

<style scoped>
.deck-keycaps {
  display: inline-flex;
  align-items: center;
  gap: 0.25rem;
}
.deck-keycaps__joiner {
  color: var(--deck-text-muted);
  font-size: 0.8em;
  margin: 0 0.05rem;
}
</style>
