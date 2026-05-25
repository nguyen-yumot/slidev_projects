<!--
  KeyCaps — render a comma-separated list of keys as keycaps.

  Usage:
    <KeyCaps>o</KeyCaps> Slide overview
    <KeyCaps>Space,→</KeyCaps> Next animation or slide

  The slot content is a comma-separated keys string. Whitespace
  around commas is trimmed. Renders one <KeyCap> per key — the
  plural of <KeyCap>. Follow the component with whatever label or
  sentence you want; KeyCaps renders only the keycaps.
-->
<script setup lang="ts">
import { computed, useSlots } from 'vue'
import KeyCap from './KeyCap.vue'

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
    <KeyCap v-for="(k, i) in keys" :key="i">{{ k }}</KeyCap>
  </span>
</template>

<style scoped>
.deck-keycaps {
  display: inline-flex;
  align-items: baseline;
  gap: 0.2rem;
}
</style>
