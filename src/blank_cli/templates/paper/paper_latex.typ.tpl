#import "./aesthetics.typ": apply_aesthetics, title_block, abstract_block

#show: doc => apply_aesthetics(doc)

#title_block(
  [{{project_name}}],
  subtitle: [A TeXst-style Typst starter],
  authors: ([Author One], [Author Two]),
)

#abstract_block[
  This paper studies a clear research question, describes a minimal empirical design,
  and reports a compact result that can be extended in later drafts.
]

#outline(title: [Contents])

#heading(level: 1)[Introduction]

State the question in one paragraph. Summarize why it matters and what contribution
this draft makes relative to existing work.

#heading(level: 1)[Design]

Define your setup with concise notation:

$ y_i = alpha + beta x_i + epsilon_i $

Then explain variables and identifying assumptions in plain text.

#heading(level: 1)[Results]

Use one table and one figure in early drafts. Keep interpretation close to estimates.

#figure(
  table(
    columns: 3,
    [Model], [Estimate], [SE],
    [Baseline], [0.18], [(0.05)],
    [With controls], [0.12], [(0.04)],
  ),
  caption: [Main coefficient estimates.]
)

#heading(level: 1)[Conclusion]

Summarize the key finding, one limitation, and one concrete next step.

#bibliography("ref.bib")
