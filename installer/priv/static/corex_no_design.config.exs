# Config for the static neo/light Design export shipped with `--no-design`.
# Rebuild: from design/, mix corex.design.build --config ../installer/priv/static/corex_no_design.config.exs --output ../installer/priv/static/corex
# (or from repo root: mix assets.build)
[
  themes: [:neo],
  modes: [:light],
  default_theme: :neo,
  default_mode: :light,
  # All components + all semantic roles so anatomy @apply (e.g. ui-success) resolves.
  components: nil,
  accessibility: false,
  semantics: nil,
  scales: []
]
