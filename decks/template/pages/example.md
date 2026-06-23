# Split big decks across `pages/`

This slide lives in `pages/example.md` and is pulled into `slides.md` with the `src:`
frontmatter key. Add one file per section and import each with its own `src:` block.

<Callout type="note">
Keeping each section in its own file under <code>pages/</code> keeps <code>slides.md</code> short — it becomes a table of contents that stitches the parts together.
</Callout>
