#let default_style = (
  page_margin: (x: 1.2in, y: 1.2in),
  page_numbering: "1",
  body_font: "New Computer Modern",
  body_size: 11pt,
  paragraph_leading: 1em,
  paragraph_indent: 1.8em,
  heading_numbering: "1.",
  heading_size: 1em,
  heading_weight: "bold",
  heading_level1_size: 0.95em,
  abstract_size: 0.92em,
  accent_main: rgb(0, 0, 100),
)

#let apply_aesthetics(style: none, doc) = {
  let s = if style == none { default_style } else { default_style + style }

  set page(margin: s.page_margin, numbering: s.page_numbering)
  set text(font: s.body_font, size: s.body_size)
  set par(leading: s.paragraph_leading, first-line-indent: s.paragraph_indent, justify: true)
  set heading(numbering: s.heading_numbering)

  show heading: set block(above: 2em, below: 1em)
  show heading: set text(size: s.heading_size, weight: s.heading_weight)
  show heading: it => {
    if it.level == 1 {
      smallcaps(align(center, text(size: s.heading_level1_size, it)))
    } else {
      it
    }
  }

  show link: set text(s.accent_main)
  show ref: set text(s.accent_main)
  show cite: set text(s.accent_main)

  doc
}

#let title_block(
  title,
  subtitle: none,
  authors: (),
  date: datetime.today().display("[month repr:long] [day], [year]"),
) = {
  v(2.5em)
  set align(center)
  set par(leading: 0.5em)
  text(1.2em, title)
  if subtitle != none {
    linebreak()
    text(1em, subtitle)
  }

  if authors.len() > 0 {
    v(1em)
    let ncols = calc.min(authors.len(), 3)
    grid(columns: (1fr,) * ncols, row-gutter: 18pt, ..authors.map(author => [#author]))
  }

  v(0.6em)
  text(date)
  set align(left)
}

#let abstract_block(body) = pad(
  x: 3em,
  y: 1.2em,
  text(size: default_style.abstract_size, [#smallcaps("Abstract.") #body]),
)
