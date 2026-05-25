<!--
  multicolumns — a dense reference layout with up to four named columns.

  Usage:
    ---
    layout: multicolumns
    ---

    # Keyboard reference

    <template #col1>
      <ColHead>Navigate</ColHead>
      ...
    </template>

    <template #col2>...</template>
    <template #col3>...</template>
    <template #col4>...</template>

  The layout counts which of #col1–#col4 you actually define, and picks the
  grid width to match: four filled slots → 4-col grid, two filled → 2-col,
  one filled → a single full-width column. Empty/undefined slots are ignored.

  The default slot (the slide body — typically a `# Heading`) sits above
  the columns. No gradient background — these slides stay clean so
  the dense content is the focus.
-->
<script setup lang="ts">
import { computed, useSlots } from 'vue'

const slots = useSlots()

const filledCols = computed(() =>
  ['col1', 'col2', 'col3', 'col4'].filter(name => !!slots[name]),
)

const gridClass = computed(() => {
  const n = filledCols.value.length
  if (n >= 4) return 'deck-multicol__grid--4'
  if (n === 3) return 'deck-multicol__grid--3'
  if (n === 2) return 'deck-multicol__grid--2'
  return 'deck-multicol__grid--1'
})
</script>

<template>
  <div class="slidev-layout deck-multicol">
    <div class="deck-multicol__heading"><slot /></div>
    <div class="deck-multicol__grid" :class="gridClass">
      <div v-for="name in filledCols" :key="name" class="deck-multicol__col">
        <slot :name="name" />
      </div>
    </div>
  </div>
</template>

<style scoped>
.deck-multicol {
  height: 100%;
  padding: 2.2rem 3rem 2.4rem;
  display: flex;
  flex-direction: column;
  gap: 1.2rem;
}
.deck-multicol__heading :deep(h1) {
  font-size: 1.9rem;
  font-weight: 700;
  margin: 0;
  color: var(--deck-accent-deep);
}
.deck-multicol__heading :deep(h1 + p),
.deck-multicol__heading :deep(p) {
  margin-top: 0.35rem;
  opacity: 0.75;
  font-size: 0.95rem;
}

.deck-multicol__grid {
  display: grid;
  gap: 1.4rem 1.8rem;
  flex: 1;
  min-height: 0;
}
.deck-multicol__grid--1 { grid-template-columns: 1fr; }
.deck-multicol__grid--2 { grid-template-columns: 1fr 1fr; }
.deck-multicol__grid--3 { grid-template-columns: repeat(3, 1fr); }
.deck-multicol__grid--4 { grid-template-columns: repeat(4, 1fr); }

.deck-multicol__col {
  font-size: 0.88em;
  line-height: 1.55;
  min-width: 0;
}
.deck-multicol__col :deep(p:first-child) { margin-top: 0; }
.deck-multicol__col :deep(p:last-child) { margin-bottom: 0; }
.deck-multicol__col :deep(pre) { margin: 0.45rem 0; }
.deck-multicol__col :deep(ul),
.deck-multicol__col :deep(ol) { margin: 0.3rem 0; padding-left: 1.1rem; }
</style>
