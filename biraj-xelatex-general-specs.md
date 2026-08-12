# LaTeX Doc General Specs — Biraj's Notes

## Page & Body
```
Page: A4, margin 0.8in all sides
Class: \documentclass[12pt]{article}
Body: 12pt fixed
Golbally Line spacing: 1.2 (\setstretch{1.2})
Para indent: 0pt | Para skip: 5pt
Hyphenation: disabled (\hyphenpenalty=10000, \exhyphenpenalty=10000)
left aligned, not use justify contents until specified
use paraindent only for bullet points, roman numbered points/lists, just how it should be done professionally. Understand first then do it.
```

## Heading Scale & Multi-Line Heading Spacing
```
Step 1: Scan the actual heading tree depth of THIS document
        (top-level only? +1 sub? +sub-sub? +sub-sub-sub?)
Step 2: Build bottom-up from body (12pt fixed)
        deepest sub-heading present = body + 2pt
        each level up from there = +2pt more
Step 3: Apply top-level exception LAST
        top-level = its direct child's size + 3pt
        (not +2pt) — plus centered, bold, CAPS
Never assume/reserve a size for a level that isn't in the doc.
Only Top level heading should be bold, centered, all CAPS.

Multi-Line Heading Line Spacing Rule:
When a long title or heading wraps into 2 or more lines, set `baselineskip` proportionally to 1.2x font size (e.g. \fontsize{21}{26}\selectfont for 21pt font, \fontsize{18}{22}\selectfont for 18pt font, \fontsize{16}{20}\selectfont for 16pt font) ended with \par so that inter-line spacing between wrapped heading lines is comfortable (1.2 line height), never tight or squished.

Example — doc with Top-level + 1 sub-level only:
  Body            12pt  regular
  Sub-heading     14pt  bold        (12 + 2)
  Top-level       17pt  bold, centered, CAPS   (14 + 3)

Example — doc with Top-level + 3 nested sub-levels:
  Body              12pt  regular
  Level 3 (1.1.1)   14pt  bold
  Level 2 (1.1)     16pt  bold
  Level 1 (1.)      18pt  bold
  Top-level         21pt  bold, centered, CAPS
```

## Header & Footer
```
Header rule:  none (\headrulewidth = 0pt)
Footer rule:  none by default (\footrulewidth = 0pt) — do not add unless asked
Page number:  centered in footer
Branding:     "Biraj's Notes" — muted/deep purple — bottom-RIGHT of footer
              Include by default on every page
              OMIT when explicitly told to remove branding for that doc —
              apply this instruction per-document going forward without
              needing to be reminded each time
```

## Fonts (XeLaTeX)
```
Main:  TeX Gyre Pagella      \setmainfont{TeX Gyre Pagella}
Mono:  TeX Gyre Cursor @88%  \setmonofont[Scale=0.88]{TeX Gyre Cursor}
Math:  Latin Modern Math     \setmathfont{Latin Modern Math}
Overleaf .tex source only:   \setmainfont{Calibri}
Deliverable: always both .tex + compiled .pdf
```

## Table Rules
```
Borders:     full grid, all cells
Spacing:     \tabcolsep + \arraystretch padding
Alignment:   left-align cell content
Header row:  centered horizontal + vertical + bold
Row colour:  none — no \rowcolor, no column background tints
& count:     must exactly match column spec (no mismatches)
balance the table and spacings as per contents, not use justify contents (no mistakes)
```

## TikZ Rules
```
Libraries: load all required libraries explicitly
Nodes:     define before use
Fill tint: light tints ONLY (e.g. myred!10, myblue!10)
           never solid/dark fills at !50 or above
           proper spacing and clear labelling
```

## Inline Code
```
\code{}  → bold, monospace, background RGB(225,228,233) (darker cool-gray pill for crisp contrast against white page background; \fboxsep=2.5pt)
```

## Code Block (listings) Style
```
Background: RGB(242,244,248)
Comments:   RGB(106,153,85), italic
Border:     single frame, RGB(208,215,222)
Never dark backgrounds
```

## Branding
```
See "Header & Footer" section above for placement/omit rule.
```

## Math Formatting (chat, not LaTeX docs)
```
Inline:  $...$
Display: $$...$$
No \[...\] delimiters; prefer single-line expressions
Scientific notation: wrap in $...$; strip \text and stray backslashes
```
