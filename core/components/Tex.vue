<!--
  Tex — renders its slot as KaTeX math.

  Usage:
    <Chip><Tex>R^2</Tex></Chip>
    <ColHead>Variance <Tex>\sigma^2</Tex></ColHead>
    <KeyCap><Tex>\Sigma</Tex></KeyCap>
    <Tex block>\int_0^1 x^2\,dx</Tex>   ← display mode, on its own line

  Why this exists: Slidev's `$…$` / `$$…$$` math is a markdown-it inline rule,
  so it only fires where markdown-it parses *markdown* — plain text, block MDC
  slots (`::FeatureCard{} … ::`), and divs. Content inside an *inline* component
  tag (<Chip>, <ColHead>, <Eyebrow>, <KeyCap>) is treated as raw HTML and skipped,
  so `$x^2$` shows up literally there. <Tex> renders KaTeX itself, at runtime, so
  math composes inside those tags and in mixed text+math headings.

  The slot is read as a *raw* LaTeX string — backslashes, `^`, and `_` pass
  through untouched (no `$` delimiters, no markdown escaping). Pass `block` for
  display mode. KaTeX's stylesheet is already loaded globally by Slidev, so this
  needs only the math engine, no CSS import.

  One caveat: the slot is still compiled as a Vue template at build time, so the
  LaTeX must have **balanced braces** and avoid a literal `{{` (Vue interpolation)
  or `<` immediately followed by a letter (parsed as a tag). All valid LaTeX
  satisfies this — `\frac{a}{b}`, `\sum_{i=1}^n`, bmatrix with `\\` & `&`, and
  `a \lt b` all work. A hanging-brace typo (`\frac{a}{`) fails the build, not the
  render — which surfaces the mistake immediately rather than silently.
-->
<script setup lang="ts">
import { computed, useSlots } from 'vue'
import katex from 'katex'

const props = defineProps<{
  block?: boolean | string
}>()

// MDC passes bare attributes as "" and Vue as booleans — accept both (matches FeatureCard).
const isBlock = computed(() => props.block !== undefined && props.block !== false)

const slots = useSlots()

function textOf(nodes: any[]): string {
  return nodes.map((n) => {
    if (typeof n === 'string') return n
    if (typeof n?.children === 'string') return n.children
    if (Array.isArray(n?.children)) return textOf(n.children)
    return ''
  }).join('')
}

const html = computed(() => {
  const src = textOf(slots.default?.() ?? []).trim()
  // throwOnError: false → a KaTeX-level mistake (unknown command, bad arg) renders red
  // inline instead of throwing. Brace/tag-level issues are caught earlier by the Vue
  // template compiler (see header note), so they surface at build time, not here.
  return katex.renderToString(src, { throwOnError: false, displayMode: isBlock.value })
})
</script>

<template>
  <component :is="isBlock ? 'div' : 'span'" class="deck-tex" v-html="html" />
</template>
