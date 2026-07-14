#!/usr/bin/env bash
# Build the public decks into dist/ and publish them to the gh-pages branch.
#   bash scripts/deploy.sh               build all + publish to GitHub Pages
#   bash scripts/deploy.sh --no-publish  build all + stage a local preview (npx serve .preview)
set -euo pipefail
cd "$(dirname "$0")/.."          # always run from the repo root

# ── Decks to publish. One folder name per line — each is decks/<name>/ with the deck's
#    entry at decks/<name>/slides.md. Each deck's card title and PDF filename come from
#    the deck's own front-matter `title` (→ first `# H1` → filename), resolved by
#    core/setup/deck-name.mjs — the same name `pnpm dev` exports.
#    The URL is always /<name>/ (the folder name).
DECKS=(
  "tutorial"
  "statistics"
  "git-github"
)

# ── Companion documents: extra Markdown files published alongside a deck — offered on the
#    landing page as "read online" (a styled in-site reader that renders Markdown + Mermaid)
#    plus a raw ".md" download. One entry per line, four |-separated fields:
#      <deck-folder>|<file.md>|<Card title>|<one-line description>
#    The source must be decks/<deck-folder>/<file.md>, and <deck-folder> must be a deck in
#    DECKS above (the doc is served from that deck's published folder). Leave empty for none.
DOCS=(
  "statistics|story.md|The Statistics Story"
  "git-github|story.md|The Git Story|Mai's midnight analysis — the deck's eight stops told as one continuous tale."
  "git-github|glossary.md|Glossary|Every key Git & GitHub term, explained for a first-timer."
)

# Split a DECKS entry into globals DECK_FILE (the deck's entry file) and DECK_NAME (its
# URL segment: the decks/ folder name). The card title / PDF name is the deck's
# front-matter `title`, resolved per-deck in the build loop below.
parse_deck() {
  DECK_NAME=$1
  DECK_FILE="decks/$1/slides.md"
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
# PDF link) by scripts/export-pdf.mjs (step 2), which drives a headless Chromium — so this
# needs Slidev's optional playwright-chromium.
if ! node -e "require.resolve('playwright-chromium/package.json')" >/dev/null 2>&1; then
  echo "deploy.sh: playwright-chromium is required to export the deck PDFs." >&2
  echo "  install it once:  pnpm add -D playwright-chromium && pnpm exec playwright install chromium" >&2
  exit 1
fi

# Warn about companion docs pointing at a deck that isn't published — they'd never attach to a
# card (each doc is emitted under its deck below, so an unpublished deck means the doc vanishes).
for entry in "${DOCS[@]:-}"; do
  [ -n "$entry" ] || continue
  IFS='|' read -r DOC_DECK _ _ _ <<< "$entry"
  case " ${DECKS[*]} " in
    *" $DOC_DECK "*) : ;;
    *) echo "deploy.sh: doc references deck '$DOC_DECK' which isn't in DECKS — it won't appear. Add it to DECKS." >&2 ;;
  esac
done

rm -rf dist                       # rebuild-all: start clean every run
cards=""
reader_decks=""                   # deck folders that get an in-site Markdown reader (set in the loop)
i=0
for entry in "${DECKS[@]}"; do
  parse_deck "$entry"
  i=$((i + 1)); idx=$(printf '%02d' "$i")   # 01, 02, … ordinal for each card
  echo "▶ building $DECK_FILE  →  dist/$DECK_NAME  (base /$REPO/$DECK_NAME/) + PDF"
  # The deck's front-matter `title` (→ first `# H1` → filename) is the single source of the
  # name, resolved here and — via deck-core's setup/preparser.ts — inside Slidev itself, so both
  # sides agree on the PDF path. TITLE is the display title (card text, verbatim); PDF_FILE is
  # the filesystem-safe form (--file collapses "/" so a "TCP/IP" title can't scatter the PDF
  # into a subfolder), matching the exportFilename the preparser sets; PDF_HREF its URL-encoded
  # link; DECK_TITLE / PDF_DOWNLOAD are the HTML-escaped display title and on-disk filename.
  TITLE=$(node core/setup/deck-name.mjs "$DECK_FILE")
  PDF_FILE="$(node core/setup/deck-name.mjs "$DECK_FILE" --file).pdf"
  PDF_HREF=$(node -e 'process.stdout.write(encodeURIComponent(process.argv[1]))' "$PDF_FILE")
  DECK_TITLE=$(html_escape "$TITLE")
  PDF_DOWNLOAD=$(html_escape "$PDF_FILE")

  # Step 1 — build the static site + the in-deck "Download PDF" button. We do NOT pass
  #   `--download`: that flag ALSO renders a full PDF via headless Chromium, which is both
  #   unreliable (truncated/blank) AND immediately thrown away — step 2 overwrites it. Instead
  #   we export DECK_DOWNLOAD_NAME so deck-core's preparser adds a STRING `download: <title>.pdf`
  #   headmatter value: Slidev shows the button and links it to that file, but runs its
  #   build-time export only for download true/"true"/"auto" — a string is skipped, so no
  #   wasted export. Step 2 writes the real <title>.pdf the button points at. (The env var
  #   scopes this to the build; `pnpm dev` never sets it, so dev shows no dead button.)
  # --out must be ABSOLUTE: Slidev resolves a relative outDir against the deck's own
  # folder (decks/<name>/), not the cwd, which would scatter dist/ into each deck.
  DECK_DOWNLOAD_NAME="$PDF_FILE" pnpm exec slidev build "$DECK_FILE" \
    --base "/$REPO/$DECK_NAME/" --out "$PWD/dist/$DECK_NAME"

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

  # Deck card = two sibling links: the deck (most of the row) and a small PDF pill.
  # (A nested <a> inside an <a> is invalid, hence the two siblings.)
  deck_card="<div class=\"card\">
          <a class=\"card-main\" href=\"./$DECK_NAME/\">
            <span class=\"card-index\">$idx</span>
            <span class=\"card-body\">
              <span class=\"card-name\">$DECK_TITLE</span>
              <span class=\"card-path\">/$DECK_NAME/</span>
            </span>
          </a>
          <a class=\"card-pdf\" href=\"./$DECK_NAME/$PDF_HREF\" download=\"$PDF_DOWNLOAD\">PDF</a>
        </div>"

  # Companion documents that BELONG TO this deck (matched by folder in the DOCS list): each is
  # copied into the deck's published folder (so its ".md" downloads same-origin) and rendered as
  # a rail-connected sub-row beneath the deck card — the in-site reader (view) + a raw ".md" pill.
  subdocs=""
  for dentry in "${DOCS[@]:-}"; do
    [ -n "$dentry" ] || continue
    IFS='|' read -r DOC_DECK DOC_FILE DOC_TITLE DOC_DESC <<< "$dentry"
    [ "$DOC_DECK" = "$DECK_NAME" ] || continue      # only this deck's docs
    DOC_SRC="decks/$DOC_DECK/$DOC_FILE"
    if [ ! -f "$DOC_SRC" ]; then
      echo "deploy.sh: doc source missing, skipping: $DOC_SRC" >&2; continue
    fi
    echo "  ↳ companion doc  $DOC_SRC  →  dist/$DECK_NAME/$DOC_FILE"
    cp "$DOC_SRC" "dist/$DECK_NAME/$DOC_FILE"
    case " $reader_decks " in *" $DECK_NAME "*) : ;; *) reader_decks="$reader_decks $DECK_NAME" ;; esac
    DOC_HREF=$(node -e 'process.stdout.write(encodeURIComponent(process.argv[1]))' "$DOC_FILE")
    DOC_TITLE_H=$(html_escape "$DOC_TITLE")
    DOC_FILE_H=$(html_escape "$DOC_FILE")
    subdocs="$subdocs
            <div class=\"subdoc\">
              <a class=\"subdoc-main\" href=\"./$DECK_NAME/read.html#$DOC_HREF\">
                <span class=\"subdoc-ico\" aria-hidden=\"true\"></span>
                <span class=\"subdoc-name\">$DOC_TITLE_H</span>
              </a>
              <a class=\"subdoc-md\" href=\"./$DECK_NAME/$DOC_HREF\" download=\"$DOC_FILE_H\">MD</a>
            </div>"
  done

  # Wrap this deck's docs in the rail container (empty when the deck has none).
  group_docs=""
  if [ -n "$subdocs" ]; then
    group_docs="
          <div class=\"subdocs\">$subdocs
          </div>"
  fi

  # Group = the deck card plus any companion docs nested beneath it.
  cards="$cards
      <div class=\"group\">
        $deck_card$group_docs
      </div>"
done

# The in-site Markdown reader, written into each deck folder that has a doc. One page for
# every doc: it reads ?doc=<file.md>, fetches that SAME-FOLDER file (the name is sanitised
# to a bare basename so it can't fetch elsewhere), and renders it — markdown-it for the prose
# and Mermaid for ```mermaid blocks (both from jsDelivr), styled to match the landing page.
for rd in $reader_decks; do
  cat > "dist/$rd/read.html" <<'READER'
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Reading…</title>
<link rel="icon" href="data:,">
<style>
  :root {
    color-scheme: light dark;
    --bg: #fbfbfc; --surface: #ffffff;
    --ink: #14161b; --muted: #4b5563; --faint: #9aa1ad;
    --line: #e7e8ec; --accent: #0f766e; --accent-2: #0d9488;
    --tint: rgba(15,118,110,.05); --code-bg: #f4f5f7;
    --shadow: 0 1px 2px rgba(20,22,27,.04), 0 10px 30px rgba(20,22,27,.05);
  }
  @media (prefers-color-scheme: dark) {
    :root {
      --bg: #0a0c11; --surface: #14171f;
      --ink: #f3f5f7; --muted: #b4bcc8; --faint: #5d6577;
      --line: #222732; --accent: #2dd4bf; --accent-2: #5eead4;
      --tint: rgba(45,212,191,.07); --code-bg: #171b22;
      --shadow: 0 1px 2px rgba(0,0,0,.4), 0 10px 30px rgba(0,0,0,.42);
    }
  }
  *,*::before,*::after { box-sizing: border-box; }
  html,body { margin: 0; }
  body {
    font-family: ui-sans-serif, system-ui, -apple-system, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
    color: var(--ink); line-height: 1.7; min-height: 100vh;
    background: radial-gradient(1000px 560px at 100% -8%, var(--tint), transparent 72%), var(--bg);
    -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility;
  }
  .topbar {
    position: sticky; top: 0; z-index: 5;
    display: flex; align-items: center; justify-content: space-between; gap: 1rem;
    padding: .75rem clamp(1rem, 4vw, 2rem);
    background: color-mix(in srgb, var(--bg) 85%, transparent);
    -webkit-backdrop-filter: blur(10px); backdrop-filter: blur(10px);
    border-bottom: 1px solid var(--line);
  }
  .back { display: inline-flex; align-items: center; gap: .4rem; color: var(--muted); text-decoration: none; font-size: .9rem; font-weight: 600; }
  .back:hover { color: var(--accent); }
  .dl {
    text-decoration: none; font-size: .74rem; font-weight: 700; letter-spacing: .06em; text-transform: uppercase;
    padding: .45rem .85rem; border: 1px solid var(--line); border-radius: 9px; color: var(--muted); white-space: nowrap;
    transition: color .15s, border-color .15s, background .15s;
  }
  .dl:hover { color: var(--accent); border-color: color-mix(in srgb, var(--accent) 40%, var(--line)); background: var(--tint); }
  main { max-width: 720px; margin: 0 auto; padding: clamp(1.5rem, 4vw, 2.6rem) clamp(1.15rem, 5vw, 1.5rem) 5rem; }
  .doc > :first-child { margin-top: 0; }
  .doc h1 {
    font-family: ui-serif, "New York", "Iowan Old Style", Georgia, Cambria, "Times New Roman", serif;
    font-weight: 600; letter-spacing: -.015em; line-height: 1.1; font-size: clamp(1.9rem, 5vw, 2.6rem); margin: .1rem 0 1.1rem;
  }
  .doc h2 { font-size: 1.4rem; font-weight: 700; letter-spacing: -.01em; margin: 2.2rem 0 .8rem; padding-bottom: .3rem; border-bottom: 1px solid var(--line); }
  .doc h3 { font-size: 1.12rem; font-weight: 700; margin: 1.6rem 0 .5rem; }
  .doc p { margin: .85rem 0; }
  .doc a { color: var(--accent); text-underline-offset: 3px; }
  .doc ul, .doc ol { padding-left: 1.35rem; }
  .doc li { margin: .3rem 0; }
  .doc em { color: var(--muted); }
  .doc strong { color: var(--ink); font-weight: 700; }
  .doc blockquote { margin: 1rem 0; padding: .5rem 1rem; border-left: 3px solid var(--accent); background: var(--tint); border-radius: 0 8px 8px 0; color: var(--muted); }
  .doc :not(pre) > code { font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace; font-size: .88em; background: var(--code-bg); border: 1px solid var(--line); border-radius: 5px; padding: .1em .38em; }
  .doc pre { background: var(--code-bg); border: 1px solid var(--line); border-radius: 12px; padding: 1rem 1.15rem; overflow-x: auto; }
  .doc pre code { font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace; font-size: .86em; }
  .doc table { border-collapse: collapse; width: 100%; margin: 1rem 0; font-size: .92rem; }
  .doc th, .doc td { border: 1px solid var(--line); padding: .5rem .7rem; text-align: left; }
  .doc th { background: var(--tint); }
  .doc hr { border: 0; border-top: 1px solid var(--line); margin: 2rem 0; }
  .doc .mermaid { display: flex; justify-content: center; margin: 1.4rem 0; padding: 1rem; background: var(--surface); border: 1px solid var(--line); border-radius: 14px; box-shadow: var(--shadow); overflow-x: auto; }
  .doc .mermaid svg { max-width: 100%; height: auto; }
  .status { color: var(--faint); padding: 2rem 0; }
</style>
</head>
<body>
  <div class="topbar">
    <a class="back" href="../">← All presentations</a>
    <a class="dl" id="dl" href="#" download>Download .md</a>
  </div>
  <main><article class="doc" id="doc"><p class="status">Loading…</p></article></main>

  <script src="https://cdn.jsdelivr.net/npm/markdown-it@14.1.0/dist/markdown-it.min.js"></script>
  <script type="module">
    import mermaid from 'https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.esm.min.mjs'
    const el = document.getElementById('doc')
    const dl = document.getElementById('dl')
    const fail = (m) => { el.innerHTML = '<p class="status">' + m + '</p>' }
    // The doc is named in the URL HASH (read.html#story.md), not a query — a hash survives the
    // clean-URL 301 that `serve` (the local preview) does to read.html, and works on GitHub
    // Pages too. Accept only a bare "<name>.md" in THIS folder — strip anything pointing elsewhere.
    let file = ''
    try { file = decodeURIComponent((location.hash || '').replace(/^#/, '')) } catch (_) { file = '' }
    file = file.replace(/[^\w.\-]/g, '')
    if (!/^[\w.\-]+\.md$/.test(file)) {
      fail('No document specified.')
    } else {
      dl.href = file; dl.setAttribute('download', file)
      try {
        const res = await fetch(file, { cache: 'no-cache' })
        if (!res.ok) throw new Error('HTTP ' + res.status)
        const src = await res.text()
        const md = window.markdownit({ html: false, linkify: true, typographer: true })
        const base = md.renderer.rules.fence || ((t, i, o, e, s) => s.renderToken(t, i, o))
        md.renderer.rules.fence = (t, i, o, e, s) =>
          t[i].info.trim() === 'mermaid'
            ? '<pre class="mermaid">' + md.utils.escapeHtml(t[i].content) + '</pre>'
            : base(t, i, o, e, s)
        el.innerHTML = md.render(src)
        const h1 = el.querySelector('h1')
        if (h1) document.title = h1.textContent.trim()
        const dark = matchMedia('(prefers-color-scheme: dark)').matches
        mermaid.initialize({ startOnLoad: false, securityLevel: 'loose', theme: dark ? 'dark' : 'default' })
        await mermaid.run({ querySelector: '.doc .mermaid' })
      } catch (err) {
        fail('Could not load “' + file + '”. ' + (err && err.message ? '(' + err.message + ')' : ''))
      }
    }
  </script>
</body>
</html>
READER
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
    --doc-ico: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%23000' stroke-width='1.8' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpath d='M14 3H7a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V8z'/%3E%3Cpath d='M14 3v5h5'/%3E%3Cpath d='M9 13h6M9 17h6'/%3E%3C/svg%3E");
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
  .list { display: flex; flex-direction: column; gap: clamp(.85rem, 2vw, 1.3rem); }
  /* A deck and its companion documents form one group; the group is what rises in on load. */
  .group {
    display: flex; flex-direction: column;
    animation: rise .55s cubic-bezier(.22,.61,.36,1) backwards;
  }
  .card {
    display: flex; align-items: stretch; gap: clamp(.6rem, 1.6vw, 1rem);
    padding: clamp(1rem, 2.4vw, 1.3rem) clamp(1.1rem, 2.6vw, 1.55rem);
    background: var(--surface); border: 1px solid var(--line); border-radius: 14px;
    box-shadow: var(--shadow);
    transition: transform .2s cubic-bezier(.22,.61,.36,1), box-shadow .2s ease, border-color .2s ease;
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
  /* Companion documents: lighter, indented rows nested under their deck, joined by a left rail
     that reads as "these belong to the card above". Flatter than a deck card (no shadow). */
  .subdocs {
    display: flex; flex-direction: column; gap: clamp(.35rem, .9vw, .5rem);
    margin: clamp(.5rem, 1.2vw, .7rem) 0 .1rem clamp(1.5rem, 3.4vw, 2.15rem);
    padding-left: clamp(.9rem, 2vw, 1.2rem);
    border-left: 2px solid var(--line);
  }
  .subdoc {
    display: flex; align-items: center; gap: clamp(.5rem, 1.4vw, .75rem);
    padding: clamp(.55rem, 1.4vw, .72rem) clamp(.85rem, 2vw, 1.05rem);
    background: var(--surface); border: 1px solid var(--line); border-radius: 11px;
    transition: transform .2s cubic-bezier(.22,.61,.36,1), border-color .2s ease, background .2s ease;
  }
  .subdoc:hover { transform: translateX(2px); border-color: var(--accent-line); background: var(--tint); }
  .subdoc-main {
    flex: 1; min-width: 0; display: flex; align-items: center; gap: clamp(.55rem, 1.5vw, .8rem);
    text-decoration: none; color: inherit;
  }
  .subdoc-main:focus-visible { outline: 2px solid var(--accent); outline-offset: 4px; border-radius: 6px; }
  /* Document glyph (mask, so it recolours on hover). */
  .subdoc-ico {
    width: 17px; height: 17px; flex: none;
    background: var(--faint);
    -webkit-mask: var(--doc-ico) center / contain no-repeat;
            mask: var(--doc-ico) center / contain no-repeat;
    transition: background .2s ease;
  }
  .subdoc:hover .subdoc-ico { background: var(--accent); }
  .subdoc-name {
    min-width: 0; font-size: clamp(.9rem, 2.1vw, 1rem); font-weight: 600;
    letter-spacing: -.005em; line-height: 1.35; color: var(--ink);
    overflow: hidden; text-overflow: ellipsis; white-space: nowrap;
    transition: color .2s ease;
  }
  .subdoc:hover .subdoc-name { color: var(--accent-2); }
  .subdoc-md {
    flex: none; align-self: center;
    padding: .32rem .72rem; border: 1px solid var(--line); border-radius: 8px;
    font-size: .68rem; font-weight: 700; letter-spacing: .08em; text-transform: uppercase;
    color: var(--muted); text-decoration: none; white-space: nowrap;
    transition: color .15s ease, border-color .15s ease, background .15s ease;
  }
  .subdoc-md:hover { color: var(--accent); border-color: var(--accent-line); background: var(--tint); }
  .subdoc-md:focus-visible { outline: 2px solid var(--accent); outline-offset: 2px; }
  .foot { margin-top: auto; padding-top: 3rem; color: var(--faint); font-size: .82rem; }
  .foot a { color: var(--accent); text-decoration: none; }
  .foot a:hover { text-decoration: underline; }
  @keyframes rise { from { opacity: 0; transform: translateY(12px); } to { opacity: 1; transform: translateY(0); } }
  .list > .group:nth-child(1){animation-delay:.05s} .list > .group:nth-child(2){animation-delay:.11s}
  .list > .group:nth-child(3){animation-delay:.17s} .list > .group:nth-child(4){animation-delay:.23s}
  .list > .group:nth-child(5){animation-delay:.29s} .list > .group:nth-child(6){animation-delay:.35s}
  @media (prefers-reduced-motion: reduce) {
    * { animation: none !important; transition: none !important; }
    .card:hover, .subdoc:hover { transform: none; }
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
# Permissive .gitignore in the output: gh-pages (--dotfiles) copies it over the repo's
# whitelist .gitignore in its publish work tree, so the built files are NOT ignored
# when staged. Without this, only .gitignore lands on gh-pages and every URL 404s.
# It still ignores .DS_Store so macOS junk from the gh-pages work tree never publishes.
printf '# published site — track everything except macOS junk\n.DS_Store\n' > dist/.gitignore
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
