<!--
  KeyCap — renders its slot as a keyboard key.

  Usage:
    Press <KeyCap>o</KeyCap> for the overview, <KeyCap>f</KeyCap> for fullscreen.
    <KeyCap tone="accent" size="lg">Cmd</KeyCap>

  Sizes: sm | md (default) | lg
  Tones: neutral (default) | accent
-->
<script setup lang="ts">
withDefaults(defineProps<{
  size?: 'sm' | 'md' | 'lg'
  tone?: 'neutral' | 'accent'
}>(), { size: 'md', tone: 'neutral' })
</script>

<template>
  <kbd
    class="deck-keycap"
    :class="[`deck-keycap--${size}`, tone === 'accent' && 'deck-keycap--accent']"
  >
    <slot />
  </kbd>
</template>

<style scoped>
.deck-keycap {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-width: 1.6em;
  padding: 0.15em 0.5em;
  margin: 0 0.1em;
  font-family: var(--deck-font-mono);
  font-size: 0.82em;
  font-weight: 500;
  line-height: 1.4;
  color: var(--deck-text-strong);
  background: linear-gradient(180deg, var(--deck-surface), var(--deck-surface-2));
  border: 1px solid var(--deck-border-strong);
  border-radius: var(--deck-radius-sm);
  box-shadow:
    0 1px 0 var(--deck-border-strong),
    0 2px 0 color-mix(in srgb, var(--deck-border-strong) 60%, transparent),
    inset 0 1px 0 rgba(255, 255, 255, 0.8);
  text-shadow: 0 1px 0 rgba(255, 255, 255, 0.6);
  white-space: nowrap;
  vertical-align: middle;
  transition: transform 0.08s ease, box-shadow 0.08s ease;
}
:global(.dark) .deck-keycap {
  box-shadow:
    0 1px 0 rgba(0, 0, 0, 0.4),
    0 2px 0 rgba(0, 0, 0, 0.25),
    inset 0 1px 0 rgba(255, 255, 255, 0.08);
  text-shadow: 0 -1px 0 rgba(0, 0, 0, 0.4);
}

.deck-keycap--sm {
  font-size: 0.72em;
  padding: 0.1em 0.4em;
  min-width: 1.4em;
}
.deck-keycap--lg {
  font-size: 0.92em;
  padding: 0.22em 0.65em;
  min-width: 1.9em;
}

.deck-keycap--accent {
  color: var(--deck-accent-deep);
  background: linear-gradient(180deg, var(--deck-accent-soft), color-mix(in srgb, var(--deck-accent-soft) 75%, transparent));
  border-color: color-mix(in srgb, var(--deck-accent) 35%, transparent);
  box-shadow:
    0 1px 0 color-mix(in srgb, var(--deck-accent) 30%, transparent),
    0 2px 0 color-mix(in srgb, var(--deck-accent) 18%, transparent),
    inset 0 1px 0 rgba(255, 255, 255, 0.7);
}
:global(.dark) .deck-keycap--accent {
  color: var(--deck-accent-deep);
}
</style>
