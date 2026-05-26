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
  the dense content is the focus. Hairline column dividers + a gradient
  bar above the heading give quiet visual structure.
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
  padding: var(--deck-multicol-pad-y) var(--deck-multicol-pad-x);
  display: flex;
  flex-direction: column;
  gap: 1.4rem;
}

/* Gradient chapter bar above the heading. */
.deck-multicol__heading::before {
  content: '';
  display: block;
  width: 56px;
  height: 4px;
  border-radius: 999px;
  background: var(--deck-border-grad);
  margin-bottom: 0.7rem;
}
.deck-multicol__heading :deep(h1) {
  font-family: var(--deck-font-display);
  font-size: 2.1rem;
  font-weight: 700;
  letter-spacing: -0.01em;
  margin: 0;
  color: var(--deck-text-strong);
  line-height: 1.15;
}
.deck-multicol__heading :deep(h1 + p),
.deck-multicol__heading :deep(p) {
  margin-top: 0.4rem;
  color: var(--deck-text-muted);
  font-size: 0.98rem;
  line-height: 1.55;
}

.deck-multicol__grid {
  display: grid;
  gap: 1.6rem 2rem;
  flex: 1;
  min-height: 0;
}
.deck-multicol__grid--1 { grid-template-columns: 1fr; }
.deck-multicol__grid--2 { grid-template-columns: 1fr 1fr; }
.deck-multicol__grid--3 { grid-template-columns: repeat(3, 1fr); }
.deck-multicol__grid--4 { grid-template-columns: repeat(4, 1fr); }

.deck-multicol__col {
  font-size: 0.88em;
  line-height: 1.6;
  min-width: 0;
  color: var(--deck-text);
}
/* Hairline divider between columns — only visible up close. */
.deck-multicol__col:not(:first-child) {
  border-left: 1px solid var(--deck-border);
  padding-left: var(--deck-space-5);
}
.deck-multicol__col :deep(p:first-child) { margin-top: 0; }
.deck-multicol__col :deep(p:last-child)  { margin-bottom: 0; }
.deck-multicol__col :deep(pre)           { margin: 0.5rem 0; }
.deck-multicol__col :deep(ul),
.deck-multicol__col :deep(ol)            { margin: 0.35rem 0; padding-left: 1.1rem; }
</style>
