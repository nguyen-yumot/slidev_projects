<!--
  Eyebrow — the small uppercase tag above a track's opening title.

  Usage:
    <Eyebrow>Part 3 · Advanced</Eyebrow>

  Replaces the hand-written `<div class="deck-eyebrow">…</div>`. Renders the
  global `.deck-eyebrow` class (defined in styles/tutorial.css) rather than a
  private scoped class, because `layouts/section.vue` targets `.deck-eyebrow`
  via `:deep()` to dim it on the dark divider slides. Keeping the class name
  preserves that override; folding the style inward would break it.
-->
<template>
  <div class="deck-eyebrow"><slot /></div>
</template>
