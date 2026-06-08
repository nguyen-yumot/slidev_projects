#!/usr/bin/env bash
# Build the public decks into dist/ and publish them to the gh-pages branch.
#   bash scripts/deploy.sh               build all + publish to GitHub Pages
#   bash scripts/deploy.sh --no-publish  build all + stage a local preview (npx serve .preview)
set -euo pipefail
cd "$(dirname "$0")/.."          # always run from the repo root

# ── Decks to publish. One filename per line (at the repo root). Each deck's card title
#    and PDF filename come from the deck's own front-matter `title` (→ first `# H1` →
#    filename), resolved by core/setup/deck-name.mjs — the same name `pnpm dev` exports.
#    The URL is always /<name>/, where <name> is the filename minus `Slidev_` and `.md`.
DECKS=(
  "Slidev_tutorial.md"
  "Slidev_statistics.md"
)

# Split a DECKS entry into globals DECK_FILE (the deck path) and DECK_NAME (its URL
# segment: the filename minus the `Slidev_` prefix and `.md`). The card title / PDF name
# is the deck's front-matter `title`, resolved per-deck in the build loop below.
parse_deck() {
  DECK_FILE=$1
  DECK_NAME=$(basename "$DECK_FILE" .md | sed 's/^Slidev_//')
}

# HTML-escape for safe use as element text AND inside a double-quoted attribute (" escaped).
# LC_ALL=C → byte-wise escape so multibyte titles (Japanese, etc.) pass through intact on any
# locale and never trip BSD sed's "illegal byte sequence".
html_escape() {
  printf '%s' "$1" | LC_ALL=C sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g; s/"/\&quot;/g'
}

# Owner + repo derived from the git remote — no edits needed after a fork/rename.
# Handles both https (…/owner/repo.git) and ssh (git@host:owner/repo.git) forms.
remote_url=$(git remote get-url origin)
slug=${remote_url%.git}; slug=${slug%/}   # strip trailing .git and slash
REPO=${slug##*/}                          # repo = last path segment
rest=${slug%/*}                           # everything before it
OWNER=${rest##*[:/]}                      # owner = segment after the last : or /
OWNER_LC=$(echo "$OWNER" | tr '[:upper:]' '[:lower:]')

# Fail clearly with no decks (also avoids empty-array expansion under set -u on bash 3.2).
if [ "${#DECKS[@]}" -eq 0 ]; then
  echo "deploy.sh: DECKS is empty — add at least one deck filename to publish." >&2
  exit 1
fi

# Each deck is rendered to a downloadable PDF (the in-deck Download button + the landing-page
# PDF link) — both `slidev build --download` and scripts/export-pdf.mjs drive a headless
# Chromium, which needs Slidev's optional playwright-chromium.
if ! node -e "require.resolve('playwright-chromium/package.json')" >/dev/null 2>&1; then
  echo "deploy.sh: playwright-chromium is required to export the deck PDFs." >&2
  echo "  install it once:  pnpm add -D playwright-chromium && pnpm exec playwright install chromium" >&2
  exit 1
fi

rm -rf dist                       # rebuild-all: start clean every run
cards=""
i=0
for entry in "${DECKS[@]}"; do
  parse_deck "$entry"
  i=$((i + 1)); idx=$(printf '%02d' "$i")   # 01, 02, … ordinal for each card
  echo "▶ building $DECK_FILE  →  dist/$DECK_NAME  (base /$REPO/$DECK_NAME/) + PDF"
  # The deck's front-matter `title` (→ first `# H1` → filename) is the single source of the
  # name, resolved here and — via @/core's setup/preparser.ts — inside Slidev itself, so both
  # sides agree on the PDF path. TITLE is the display title (card text, verbatim); PDF_FILE is
  # the filesystem-safe form (--file collapses "/" so a "TCP/IP" title can't scatter the PDF
  # into a subfolder), matching the exportFilename the preparser sets; PDF_HREF its URL-encoded
  # link; DECK_TITLE / PDF_DOWNLOAD are the HTML-escaped display title and on-disk filename.
  TITLE=$(node core/setup/deck-name.mjs "$DECK_FILE")
  PDF_FILE="$(node core/setup/deck-name.mjs "$DECK_FILE" --file).pdf"
  PDF_HREF=$(node -e 'process.stdout.write(encodeURIComponent(process.argv[1]))' "$PDF_FILE")
  DECK_TITLE=$(html_escape "$TITLE")
  PDF_DOWNLOAD=$(html_escape "$PDF_FILE")

  # Step 1 — build the static site + the in-deck "Download PDF" button (--download). The preparser
  #   sets exportFilename, so the build writes the PDF as dist/<name>/<title>.pdf and the button
  #   points there; its content is unreliable (truncated/blank — see step 2), so step 2 overwrites
  #   that same file.
  pnpm exec slidev build "$DECK_FILE" --base "/$REPO/$DECK_NAME/" --out "dist/$DECK_NAME" \
    --download

  # Step 2 — overwrite that PDF with one from Slidev's BROWSER exporter (the /export page you get
  #   from `pnpm dev` → open /export → print), driven headlessly. Every CLI exporter path is broken
  #   for the larger decks here: `slidev export` (dev) comes out BLANK, and `build --download` /
  #   one-piece comes out TRUNCATED (89/101 of 106) because it stacks all slides into one giant
  #   browser surface Chromium clips. `--per-slide` is correct but slow (~90-140s/deck). The browser
  #   exporter lays out each slide as its own print block and uses the browser's native print
  #   pagination (no surface limit) → complete + non-blank in a few seconds. Verify PDFs by file
  #   size + rendered pixels, never page count (a blank PDF still has the right page count). No
  #   --with-clicks: one page per slide at its final built state, matching the manual /export default.
  node scripts/export-pdf.mjs "$DECK_FILE" "dist/$DECK_NAME/$PDF_FILE"

  # Card = container div with two links: the deck (most of the row) and a small
  # PDF pill. (A nested <a> inside an <a> is invalid, hence the two siblings.)
  cards="$cards
      <div class=\"card\">
        <a class=\"card-main\" href=\"./$DECK_NAME/\">
          <span class=\"card-index\">$idx</span>
          <span class=\"card-body\">
            <span class=\"card-name\">$DECK_TITLE</span>
            <span class=\"card-path\">/$DECK_NAME/</span>
          </span>
        </a>
        <a class=\"card-pdf\" href=\"./$DECK_NAME/$PDF_HREF\" download=\"$PDF_DOWNLOAD\">PDF</a>
      </div>"
done

count=${#DECKS[@]}
if [ "$count" -eq 1 ]; then noun="presentation"; else noun="presentations"; fi

# Landing page (what /$REPO/ shows). Generated from the deck list above; CSS is
# self-contained so the page needs no assets. SPA deep-link fallback + skip Jekyll below.
mkdir -p dist          # ensure dist/ exists before writing the landing page
cat > dist/index.html <<EOF
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Presentations</title>
<link rel="icon" href="data:,">
<style>
  :root {
    color-scheme: light dark;
    --bg: #fbfbfc; --surface: #ffffff;
    --ink: #14161b; --muted: #6b7280; --faint: #9aa1ad;
    --line: #ececef; --accent: #0f766e; --accent-2: #0d9488;
    --accent-line: rgba(15,118,110,.34);
    --tint: rgba(15,118,110,.05);
    --shadow: 0 1px 2px rgba(20,22,27,.04), 0 14px 34px rgba(20,22,27,.05);
    --shadow-hover: 0 12px 26px rgba(15,118,110,.10), 0 34px 64px rgba(15,118,110,.10);
  }
  @media (prefers-color-scheme: dark) {
    :root {
      --bg: #0a0c11; --surface: #14171f;
      --ink: #f3f5f7; --muted: #98a2b3; --faint: #5d6577;
      --line: #222732; --accent: #2dd4bf; --accent-2: #5eead4;
      --accent-line: rgba(45,212,191,.36);
      --tint: rgba(45,212,191,.07);
      --shadow: 0 1px 2px rgba(0,0,0,.4), 0 14px 34px rgba(0,0,0,.42);
      --shadow-hover: 0 14px 30px rgba(0,0,0,.5), 0 36px 70px rgba(0,0,0,.55);
    }
  }
  *, *::before, *::after { box-sizing: border-box; }
  html, body { margin: 0; }
  body {
    font-family: ui-sans-serif, system-ui, -apple-system, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
    color: var(--ink);
    background: radial-gradient(1000px 560px at 100% -8%, var(--tint), transparent 72%), var(--bg);
    min-height: 100vh;
    -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility;
  }
  .wrap {
    max-width: 800px; margin: 0 auto; min-height: 100vh;
    display: flex; flex-direction: column;
    padding: clamp(3rem, 7vw, 6rem) clamp(1.35rem, 5vw, 2.5rem) 3.5rem;
  }
  .head { margin-bottom: clamp(1.6rem, 4vw, 2.4rem); }
  .eyebrow {
    margin: .85rem 0 0; color: var(--accent); font-size: .72rem;
    font-weight: 700; text-transform: uppercase; letter-spacing: .2em;
  }
  .head h1 {
    margin: 0; font-weight: 600; letter-spacing: -.015em; line-height: 1.04;
    font-size: clamp(2.4rem, 6vw, 3.6rem);
    font-family: ui-serif, "New York", "Iowan Old Style", Georgia, Cambria, "Times New Roman", serif;
  }
  .list { display: flex; flex-direction: column; gap: clamp(.55rem, 1.3vw, .85rem); }
  .card {
    display: flex; align-items: stretch; gap: clamp(.6rem, 1.6vw, 1rem);
    padding: clamp(1rem, 2.4vw, 1.3rem) clamp(1.1rem, 2.6vw, 1.55rem);
    background: var(--surface); border: 1px solid var(--line); border-radius: 14px;
    box-shadow: var(--shadow);
    transition: transform .2s cubic-bezier(.22,.61,.36,1), box-shadow .2s ease, border-color .2s ease;
    animation: rise .55s cubic-bezier(.22,.61,.36,1) backwards;
  }
  .card:hover { transform: translateY(-2px); box-shadow: var(--shadow-hover); border-color: var(--accent-line); }
  .card-main {
    flex: 1; min-width: 0; display: grid; grid-template-columns: auto 1fr;
    align-items: baseline; gap: clamp(.85rem, 2.5vw, 1.5rem);
    text-decoration: none; color: inherit;
  }
  .card-main:focus-visible { outline: 2px solid var(--accent); outline-offset: 4px; border-radius: 6px; }
  .card-index {
    font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace;
    font-variant-numeric: tabular-nums; font-size: .78rem; font-weight: 600;
    color: var(--faint); letter-spacing: .04em; padding-top: .2rem;
    transition: color .2s ease;
  }
  .card:hover .card-index { color: var(--accent); }
  .card-pdf {
    flex: none; align-self: center;
    padding: .4rem .8rem; border: 1px solid var(--line); border-radius: 9px;
    font-size: .72rem; font-weight: 700; letter-spacing: .08em; text-transform: uppercase;
    color: var(--muted); text-decoration: none; white-space: nowrap;
    transition: color .15s ease, border-color .15s ease, background .15s ease;
  }
  .card-pdf:hover { color: var(--accent); border-color: var(--accent-line); background: var(--tint); }
  .card-pdf:focus-visible { outline: 2px solid var(--accent); outline-offset: 2px; }
  .card-body { min-width: 0; display: flex; flex-direction: column; gap: .25rem; }
  .card-name {
    font-size: clamp(1.1rem, 2.6vw, 1.28rem); font-weight: 600;
    letter-spacing: -.01em; line-height: 1.3; color: var(--ink);
    transition: color .2s ease;
  }
  .card:hover .card-name { color: var(--accent-2); }
  .card-path {
    font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace;
    font-size: .8rem; color: var(--muted); word-break: break-all;
  }
  .foot { margin-top: auto; padding-top: 3rem; color: var(--faint); font-size: .82rem; }
  .foot a { color: var(--accent); text-decoration: none; }
  .foot a:hover { text-decoration: underline; }
  @keyframes rise { from { opacity: 0; transform: translateY(12px); } to { opacity: 1; transform: translateY(0); } }
  .card:nth-child(1){animation-delay:.05s} .card:nth-child(2){animation-delay:.11s}
  .card:nth-child(3){animation-delay:.17s} .card:nth-child(4){animation-delay:.23s}
  .card:nth-child(5){animation-delay:.29s} .card:nth-child(6){animation-delay:.35s}
  @media (prefers-reduced-motion: reduce) {
    * { animation: none !important; transition: none !important; }
    .card:hover { transform: none; }
  }
</style>
</head>
<body>
  <main class="wrap">
    <header class="head">
      <h1>Presentations</h1>
      <p class="eyebrow">$count $noun</p>
    </header>
    <section class="list">$cards
    </section>
    <footer class="foot">Built with <a href="https://sli.dev">Slidev</a></footer>
  </main>
</body>
</html>
EOF
cp dist/index.html dist/404.html
touch dist/.nojekyll
# Empty .gitignore in the output: gh-pages (--dotfiles) copies it over the repo's
# whitelist .gitignore in its publish work tree, so the built files are NOT ignored
# when staged. Without this, only .gitignore lands on gh-pages and every URL 404s.
printf '# published site — nothing ignored here\n' > dist/.gitignore
find dist -name '.DS_Store' -delete 2>/dev/null || true   # don't publish macOS junk

if [ "${1:-}" = "--no-publish" ]; then
  # Decks reference assets at the absolute base "/$REPO/...", so a plain
  # `serve dist` would 404. Stage the build under a real ./$REPO/ folder so the
  # paths resolve exactly like the live Pages site, plus a root redirect so
  # `serve .preview` lands on the page directly (no directory-listing click).
  rm -rf .preview && mkdir -p ".preview/$REPO"
  cp -R dist/. ".preview/$REPO/"
  printf '<!doctype html><meta charset="utf-8"><meta http-equiv="refresh" content="0; url=./%s/">\n' "$REPO" > .preview/index.html
  echo "✓ built — preview with:"
  echo "    npx serve .preview"
  echo "  then open  http://localhost:3000/"
  exit 0
fi

echo "▶ publishing dist/ → gh-pages"
# --no-history: replace the branch with a single fresh commit each deploy, so the
# multi-MB exported PDFs don't pile up in branch history over time. (The published
# site only needs the latest output; history on a generated branch has no value.)
pnpm exec gh-pages -d dist --dotfiles --no-history -b gh-pages
echo "✓ live (allow ~1 min on first deploy):"
for entry in "${DECKS[@]}"; do
  parse_deck "$entry"
  echo "    https://$OWNER_LC.github.io/$REPO/$DECK_NAME/"
done
