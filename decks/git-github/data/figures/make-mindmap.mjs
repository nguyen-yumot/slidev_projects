// Generate the deck's overview mind-map as light + dark SVGs that fit a 16:9 slide.
// One reproducible source → two themed files, so they never drift.
//
//   node decks/git-github/data/figures/make-mindmap.mjs
//
// Writes decks/git-github/public/mind-map-{light,dark}.svg. The eight branches are the
// deck's eight sections (matching the agenda); leaves are each section's key commands.
// Colours match the flat-look --deck-* tokens in core/styles/palette-flat.css.

import { writeFileSync, mkdirSync } from 'node:fs'
import { dirname, resolve } from 'node:path'
import { fileURLToPath } from 'node:url'

const HERE = dirname(fileURLToPath(import.meta.url))
const OUT = resolve(HERE, '../../public')
const FONT = "ui-sans-serif, system-ui, -apple-system, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif"

const W = 1280, H = 520
const N = 8
const TOP = 18, STEP = (H - TOP * 2) / N
const ROOT = { x: 22, y: H / 2 - 40, w: 186, h: 80 }          // hub pill (left, centred)
const NODE = { x: 290, w: 244, h: 50 }                         // category boxes column
const LEAF_X = 560                                             // leaf text starts here

// The eight sections, in deck order, each with representative leaves.
const CATS = [
  ['Fundamentals',            'Git vs GitHub · version control · distributed · AI safety net'],
  ['The four locations',      'working dir · staging · local repo · remote'],
  ['Local workflow',          'init · clone · add · commit · status · log'],
  ['GitHub & syncing',        'push · fetch vs pull · origin / main'],
  ['Branching & PRs',         'branch · merge · conflicts · Pull Requests · forking · rebase'],
  ['Safety nets',             'stash · restore · revert · reset'],
  ['Setup & security',        'SSH keys · .gitignore · secrets · default branch'],
  ['Best practices & tools',  'small commits · protect main · CLI · GUI · CI/CD · Obsidian'],
]

const THEMES = {
  light: {
    root: '#2b90b6', rootText: '#ffffff',
    node: '#eef6fb', nodeStroke: 'rgba(43,144,182,0.28)',
    badge: '#2b90b6', badgeText: '#ffffff',
    label: '#0f172a', leaf: '#475569',
    link: '#2b90b6', linkOpacity: 0.4,
  },
  dark: {
    root: '#5ab4d6', rootText: '#08222e',
    node: '#10242f', nodeStroke: 'rgba(90,180,214,0.32)',
    badge: '#5ab4d6', badgeText: '#08222e',
    label: '#f1f5f9', leaf: '#94a3b8',
    link: '#5ab4d6', linkOpacity: 0.5,
  },
}

const esc = (s) => s.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;')
const cy = (i) => TOP + STEP * (i + 0.5)

function build(t) {
  const rootRight = ROOT.x + ROOT.w
  const rootMidY = ROOT.y + ROOT.h / 2

  const links = CATS.map((_, i) => {
    const y = cy(i)
    const cMid = (rootRight + NODE.x) / 2
    return `  <path d="M${rootRight},${rootMidY} C${cMid},${rootMidY} ${cMid},${y} ${NODE.x},${y}" fill="none" stroke="${t.link}" stroke-opacity="${t.linkOpacity}" stroke-width="2"/>`
  }).join('\n')

  const nodes = CATS.map(([name, leaves], i) => {
    const y = cy(i)
    const ny = y - NODE.h / 2
    const bx = NODE.x + 26
    return [
      `  <rect x="${NODE.x}" y="${ny.toFixed(1)}" width="${NODE.w}" height="${NODE.h}" rx="11" fill="${t.node}" stroke="${t.nodeStroke}" stroke-width="1.5"/>`,
      `  <circle cx="${bx}" cy="${y.toFixed(1)}" r="13" fill="${t.badge}"/>`,
      `  <text x="${bx}" y="${y.toFixed(1)}" font-size="13" font-weight="700" fill="${t.badgeText}" text-anchor="middle" dominant-baseline="central" font-family="${FONT}">${i + 1}</text>`,
      `  <text x="${bx + 22}" y="${y.toFixed(1)}" font-size="15" font-weight="700" fill="${t.label}" dominant-baseline="central" font-family="${FONT}">${esc(name)}</text>`,
      `  <text x="${LEAF_X}" y="${y.toFixed(1)}" font-size="13" fill="${t.leaf}" dominant-baseline="central" font-family="${FONT}">${esc(leaves)}</text>`,
    ].join('\n')
  }).join('\n')

  return `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 ${W} ${H}" width="${W}" height="${H}" role="img">
${links}
  <rect x="${ROOT.x}" y="${ROOT.y}" width="${ROOT.w}" height="${ROOT.h}" rx="18" fill="${t.root}"/>
  <text x="${ROOT.x + ROOT.w / 2}" y="${rootMidY}" font-size="20" font-weight="700" fill="${t.rootText}" text-anchor="middle" dominant-baseline="central" font-family="${FONT}">Git &amp; GitHub</text>
${nodes}
</svg>
`
}

mkdirSync(OUT, { recursive: true })
for (const [name, theme] of Object.entries(THEMES)) {
  const file = resolve(OUT, `mind-map-${name}.svg`)
  writeFileSync(file, build(theme))
  console.log(`  ✓ wrote ${file}`)
}
