#!/usr/bin/env bash
# Build the public decks into dist/ and publish them to the gh-pages branch.
#   bash scripts/deploy.sh               build all + publish to GitHub Pages
#   bash scripts/deploy.sh --no-publish  build all + stage a local preview (npx serve .preview)
set -euo pipefail
cd "$(dirname "$0")/.."          # always run from the repo root

# ── Decks to publish. One per line: the deck filename at the repo root, with an
#    OPTIONAL custom card title after a "|". Without "|Title", the title is derived
#    from the filename (Slidev_my-talk.md → "My talk").
#      Slidev_stats.md                 → card titled "Stats"
#      Slidev_stats.md|Statistics 101  → card titled "Statistics 101"
#    (The URL is always /<filename>/ — a custom title changes only the displayed text.)
#    Quote each entry so the "|" is treated as text, not a shell pipe.
DECKS=(
  "Slidev_tutorial.md|Getting Started with Slidev"
  "Slidev_statistics.md|Statistics for Researchers"
)

# Split a DECKS entry into globals DECK_FILE / DECK_NAME / DECK_TITLE.
# DECK_TITLE is HTML-escaped so titles may contain & < > safely.
parse_deck() {
  local entry=$1 custom t cap
  DECK_FILE=${entry%%|*}                              # before the first "|"
  custom=${entry#*|}; [ "$custom" = "$entry" ] && custom=""   # after it, if any
  DECK_NAME=$(basename "$DECK_FILE" .md | sed 's/^Slidev_//')
  if [ -n "$custom" ]; then
    t=$custom                                         # custom title, used verbatim (may be Japanese, etc.)
  else
    t=$(printf '%s' "$DECK_NAME" | LC_ALL=C sed 's/[-_]/ /g')  # "my-talk" → "my talk"
    cap=$(printf '%s' "${t:0:1}" | tr '[:lower:]' '[:upper:]')
    t="$cap${t:1}"                                    # capitalize first letter (ASCII filenames)
  fi
  # LC_ALL=C → byte-wise escape, so multibyte titles (Japanese, etc.) pass through
  # intact on any locale and never trip BSD sed's "illegal byte sequence".
  DECK_TITLE=$(printf '%s' "$t" | LC_ALL=C sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g')
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

rm -rf dist                       # rebuild-all: start clean every run
cards=""
i=0
for entry in "${DECKS[@]}"; do
  parse_deck "$entry"
  i=$((i + 1)); idx=$(printf '%02d' "$i")   # 01, 02, … ordinal for each card
  echo "▶ building $DECK_FILE  →  dist/$DECK_NAME  (base /$REPO/$DECK_NAME/)"
  pnpm exec slidev build "$DECK_FILE" --base "/$REPO/$DECK_NAME/" --out "dist/$DECK_NAME"

  cards="$cards
      <a class=\"card\" href=\"./$DECK_NAME/\">
        <span class=\"card-index\">$idx</span>
        <span class=\"card-body\">
          <span class=\"card-name\">$DECK_TITLE</span>
          <span class=\"card-path\">/$DECK_NAME/</span>
        </span>
      </a>"
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
    display: grid; grid-template-columns: auto 1fr; align-items: baseline;
    gap: clamp(.85rem, 2.5vw, 1.5rem);
    padding: clamp(1rem, 2.4vw, 1.3rem) clamp(1.1rem, 2.6vw, 1.55rem);
    background: var(--surface); border: 1px solid var(--line); border-radius: 14px;
    text-decoration: none; color: inherit; box-shadow: var(--shadow);
    transition: transform .2s cubic-bezier(.22,.61,.36,1), box-shadow .2s ease, border-color .2s ease;
    animation: rise .55s cubic-bezier(.22,.61,.36,1) backwards;
  }
  .card:hover { transform: translateY(-2px); box-shadow: var(--shadow-hover); border-color: var(--accent-line); }
  .card:focus-visible { outline: 2px solid var(--accent); outline-offset: 3px; }
  .card-index {
    font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace;
    font-variant-numeric: tabular-nums; font-size: .78rem; font-weight: 600;
    color: var(--faint); letter-spacing: .04em; padding-top: .2rem;
    transition: color .2s ease;
  }
  .card:hover .card-index { color: var(--accent); }
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
pnpm exec gh-pages -d dist --dotfiles -b gh-pages
echo "✓ live (allow ~1 min on first deploy):"
for entry in "${DECKS[@]}"; do
  parse_deck "$entry"
  echo "    https://$OWNER_LC.github.io/$REPO/$DECK_NAME/"
done
