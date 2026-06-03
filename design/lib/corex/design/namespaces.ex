defmodule Corex.Design.Namespaces do
  @moduledoc """
  Single source of truth for the theme-independent token scales that are bridged
  1:1 into Tailwind `@theme` namespaces.

  Each entry is `{tailwind_namespace, [{step, value}]}`. The same scales are
  emitted as runtime CSS variables by `Corex.Design.Emit.Tokens` and aliased into
  Tailwind utilities by `Corex.Design.Emit.Theme`, so the two stay in lockstep:
  defining a step here makes both `var(--<ns>-<step>)` (plain CSS) and the
  matching Tailwind utility (`shadow-md`, `ease-out`, `blur-lg`, ...) available.

  Theme-scoped scales (`color`, `spacing`/`space`/`size`, `text`, `radius`,
  `container`, `font`) are resolved per theme/mode and handled directly by the
  emitters; they are intentionally not listed here.
  """

  alias Corex.Design.Tokens.Scales

  @doc "Theme-independent scales bridged 1:1 into Tailwind `@theme` namespaces."
  def static_scales do
    [
      {"leading", Scales.leading()},
      {"tracking", Scales.tracking()},
      {"font-weight", Scales.weight()},
      {"shadow", Scales.shadow()},
      {"inset-shadow", Scales.inset_shadow()},
      {"drop-shadow", Scales.drop_shadow()},
      {"text-shadow", Scales.text_shadow()},
      {"blur", Scales.blur()},
      {"perspective", Scales.perspective()},
      {"aspect", Scales.aspect()},
      {"ease", Scales.ease()},
      {"animate", Scales.animate()},
      {"breakpoint", Scales.breakpoint()}
    ]
  end
end
