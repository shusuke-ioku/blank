#import "./aesthetics.typ": paper, theorem, proof, caption_with_note

#show: doc => paper(
  title: [{{project_name}}],
  subtitle: [Optional Subtitle],
  authors: (
    (name: [Author One]),
    (name: [Author Two]),
  ),
  date: datetime.today().display("[month repr:long] [day], [year]"),
  abstract: [
    Write a concise abstract summarizing your research question, method, and findings.
  ],
  doc,
)

#heading(level: 1)[Introduction]

Start your paper here.

#heading(level: 1)[Main Result]

#theorem[
State your main theorem or proposition.
]

#proof[
Add your proof or argument.
]

#figure(
  block(width: 100%)[
    #set text(size: 0.8em)
    #table(
      columns: 7,
      align: (left, center, center, center, center, center, center),
      inset: (x: 5pt, y: 4pt),
      stroke: none,
      table.hline(stroke: 1.2pt),
      [Outcome:], table.cell(colspan: 6)[_Dependent Variable Placeholder_],
      [Model:], [(1)], [(2)], [(3)], [(4)], [(5)], [(6)],
      [], [+12 months], [+24 months], [+36 months], [+48 months], [+60 months], [All periods],
      table.hline(stroke: 0.7pt),
      [*Main Treatment × Post*], [$0.173^(**)$ #linebreak() (0.061)], [$0.192^(**)$ #linebreak() (0.074)], [$0.214^(**)$ #linebreak() (0.088)], [$0.228^(**)$ #linebreak() (0.095)], [$0.205^(*)$ #linebreak() (0.108)], [$0.241^(**)$ #linebreak() (0.099)],
      [Control 1 × Post], [$-0.041$ #linebreak() (0.052)], [$-0.028$ #linebreak() (0.061)], [$-0.017$ #linebreak() (0.069)], [$-0.022$ #linebreak() (0.075)], [$-0.015$ #linebreak() (0.083)], [$-0.009$ #linebreak() (0.080)],
      [Control 2 × Post], [0.067 #linebreak() (0.049)], [0.072 #linebreak() (0.058)], [0.081 #linebreak() (0.066)], [0.076 #linebreak() (0.071)], [0.089 #linebreak() (0.079)], [0.095 #linebreak() (0.076)],
      table.hline(stroke: 0.4pt),
      [Prefecture FE], [Yes], [Yes], [Yes], [Yes], [Yes], [Yes],
      [Month FE], [Yes], [Yes], [Yes], [Yes], [Yes], [Yes],
      table.hline(stroke: 0.4pt),
      [Observations], [1,250], [1,780], [2,310], [2,840], [3,370], [3,920],
      [$R^2$], [0.912], [0.918], [0.924], [0.927], [0.931], [0.934],
      table.hline(stroke: 1.2pt),
    )
  ],
  caption: caption_with_note([Table Title Placeholder], [Table note placeholder. Replace with model description, fixed effects, standard-error details, and significance-code conventions.]),
)<tab:sample_coeff>

#heading(level: 1)[Appendix]

#outline(title: [Contents])

#heading(level: 2)[Additional Material]

Place supplementary derivations, robustness checks, or extended tables here.
