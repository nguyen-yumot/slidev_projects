<!--
  FeatureCard — a titled card with an optional icon, used for overviews.

  Usage:
    <FeatureCard title="Layouts" icon="i-carbon-grid">
    Pick a layout per slide with the `layout:` frontmatter key.
    </FeatureCard>

  Pass `row` to put icon + title on the same line, body below.
-->
<script setup lang="ts">
import { computed } from 'vue'

const props = defineProps<{
  title: string
  icon?: string
  row?: boolean | string
}>()

// MDC passes bare attributes as empty strings ("row") and Vue passes them
// as booleans (:row="true"). Accept both shapes; reject only undefined/false.
const isRow = computed(() => props.row !== undefined && props.row !== false)
</script>

<template>
  <div class="deck-card" :class="{ 'deck-card--row': isRow }">
    <div v-if="icon" class="deck-card__icon" :class="icon" />
    <div class="deck-card__title">{{ title }}</div>
    <div class="deck-card__body"><slot /></div>
  </div>
</template>

<style scoped>
.deck-card {
  display: flex;
  flex-direction: column;
  gap: 0.45rem;
  padding: 1.1rem 1.15rem;
  border-radius: 14px;
  background: color-mix(in srgb, var(--deck-accent) 6%, transparent);
  border: 1px solid color-mix(in srgb, var(--deck-accent) 22%, transparent);
  height: 100%;
}
.deck-card__icon {
  color: var(--deck-accent);
  font-size: 1.7rem;
}
.deck-card__title {
  font-weight: 700;
  font-size: 1.05rem;
}
.deck-card__body {
  font-size: 0.84em;
  line-height: 1.55;
  opacity: 0.85;
}
.deck-card__body :deep(p) { margin: 0; }

.deck-card--row {
  display: grid;
  grid-template-columns: auto 1fr;
  column-gap: 0.7rem;
  row-gap: 0.35rem;
  align-items: center;
}
.deck-card--row .deck-card__icon  { grid-column: 1; grid-row: 1; font-size: 1.4rem; }
.deck-card--row .deck-card__title { grid-column: 2; grid-row: 1; }
.deck-card--row .deck-card__body  { grid-column: 1 / -1; grid-row: 2; }
</style>
