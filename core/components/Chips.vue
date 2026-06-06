<!--
  Chips — render a comma-separated list as <Chip> pills.

  Usage:
    <Chips>default, cover, center</Chips>
    <Chips tone="accent" size="sm">v1, v2, v3</Chips>

  Slot content is a comma-separated string; whitespace around commas is
  trimmed. Renders one <Chip> per item — the plural of <Chip>, already laid
  out in a wrapping flex row. For a single pill, reach for <Chip>.
-->
<script setup lang="ts">
import { computed, useSlots } from 'vue'
import Chip from './Chip.vue'

type Tone = 'neutral' | 'accent' | 'tip' | 'warning' | 'note' | 'try'

withDefaults(defineProps<{
  tone?: Tone
  size?: 'sm' | 'md'
}>(), { tone: 'neutral', size: 'md' })

const slots = useSlots()

function textOf(nodes: any[]): string {
  return nodes.map((n) => {
    if (typeof n === 'string') return n
    if (typeof n?.children === 'string') return n.children
    if (Array.isArray(n?.children)) return textOf(n.children)
    return ''
  }).join('')
}

const labels = computed(() => {
  const nodes = slots.default?.() ?? []
  return textOf(nodes).split(',').map(s => s.trim()).filter(Boolean)
})
</script>

<template>
  <span class="deck-chips">
    <Chip v-for="(label, i) in labels" :key="i" :tone="tone" :size="size">{{ label }}</Chip>
  </span>
</template>

<style scoped>
.deck-chips {
  display: inline-flex;
  flex-wrap: wrap;
  gap: 0.5rem;
}
</style>
