defmodule Corex.Design.Emit.Tokens do
  @moduledoc false

  alias Corex.Design.Theme
  alias Corex.Design.Tokens.Colors
  alias Corex.Design.Tokens.Scales

  @doc "Builds a CSS custom property name from parts, e.g. `[:space, :sm]` -> `--space-sm`."
  def name(parts) do
    "--" <> (parts |> List.wrap() |> Enum.map_join("-", &dash/1))
  end

  @doc "Builds a `var(--name)` reference from parts."
  def ref(parts), do: "var(#{name(parts)})"

  @doc "Full font stack map for a theme: Scales defaults merged with theme overrides."
  def font_stacks_for(theme) when is_atom(theme) do
    base = Scales.font()

    case Theme.font_stacks(theme) do
      nil -> base
      %{} = overrides -> Keyword.merge(base, Map.to_list(overrides))
      overrides when is_list(overrides) -> Keyword.merge(base, overrides)
    end
  end

  @doc """
  Emits the token layer as plain CSS from pure-Elixir definitions:

    * `:root` carries the mode/theme-independent scale (leading, tracking,
      weight, font, shadow), the default theme's dimension scale, and the
      default theme/mode colors, so a bare page renders.
    * `[data-theme="<t>"]` blocks carry each non-default theme's dimension scale.
    * `[data-theme="<t>"][data-mode="<m>"]` blocks carry every other theme/mode
      color set. The default theme/mode pair is omitted here since `:root`
      already carries it (no duplicate block).
  """
  def css do
    colors = Colors.generate()
    dt = Theme.default_theme()
    dm = Theme.default_mode()

    root =
      block(
        ":root",
        static_decls_without_font() ++
          dimension_decls(dt, include_font: true) ++
          color_decls(colors[{dt, dm}])
      )

    theme_blocks =
      for theme <- Theme.themes(), theme != dt do
        block(~s([data-theme="#{theme}"]), dimension_decls(theme, include_font: true))
      end

    color_blocks =
      for theme <- Theme.themes(), mode <- Theme.modes(), {theme, mode} != {dt, dm} do
        block(
          ~s([data-theme="#{theme}"][data-mode="#{mode}"]),
          color_decls(colors[{theme, mode}])
        )
      end

    [root | theme_blocks ++ color_blocks]
    |> Enum.join("\n\n")
  end

  defp static_decls_without_font do
    leading = for {step, v} <- Scales.leading(), do: {name([:leading, step]), Scales.num(v)}

    text_leading =
      for {step, v} <- Scales.text_leading(), do: {"--text-#{dash(step)}--line-height", v}

    tracking = for {step, v} <- Scales.tracking(), do: {name([:tracking, step]), v}

    weight =
      for {step, v} <- Scales.weight(), do: {name([:"font-weight", step]), Integer.to_string(v)}

    shadow = for {step, tpl} <- Scales.shadow(), do: {name([:shadow, step]), tpl}

    inset_shadow =
      for {step, tpl} <- Scales.inset_shadow(), do: {name([:"inset-shadow", step]), tpl}

    drop_shadow = for {step, tpl} <- Scales.drop_shadow(), do: {name([:"drop-shadow", step]), tpl}
    text_shadow = for {step, tpl} <- Scales.text_shadow(), do: {name([:"text-shadow", step]), tpl}
    blur = for {step, v} <- Scales.blur(), do: {name([:blur, step]), v}
    perspective = for {step, v} <- Scales.perspective(), do: {name([:perspective, step]), v}
    aspect = for {step, v} <- Scales.aspect(), do: {name([:aspect, step]), v}
    ease = for {step, v} <- Scales.ease(), do: {name([:ease, step]), v}
    animate = for {step, v} <- Scales.animate(), do: {name([:animate, step]), v}
    breakpoint = for {step, v} <- Scales.breakpoint(), do: {name([:breakpoint, step]), v}

    leading ++
      text_leading ++
      tracking ++
      weight ++
      shadow ++
      inset_shadow ++
      drop_shadow ++
      text_shadow ++ blur ++ perspective ++ aspect ++ ease ++ animate ++ breakpoint
  end

  defp dimension_decls(theme, opts) do
    include_font = Keyword.get(opts, :include_font, false)

    space =
      [{name([:spacing]), Theme.spacing(theme)}] ++
        [{name([:space]), Theme.space_default(theme)}] ++
        for {step, v} <- Theme.space(theme), do: {name([:space, step]), v}

    size =
      [{name([:size]), Theme.size_default(theme)}] ++
        for {step, v} <- Theme.size(theme), do: {name([:size, step]), v}

    text = for {step, v} <- Theme.text(theme), do: {name([:text, step]), v}

    radius =
      [{name([:radius]), Theme.radius_default(theme)}] ++
        for {step, v} <- Theme.radius(theme), do: {name([:radius, step]), v}

    container =
      if theme == Theme.default_theme() or
           Theme.container(theme) != Theme.container(Theme.default_theme()) do
        for {step, v} <- Theme.container(theme), do: {name([:container, step]), v}
      else
        []
      end

    font =
      if include_font do
        font_decls(theme)
      else
        []
      end

    space ++ size ++ text ++ radius ++ container ++ font
  end

  defp font_decls(theme) do
    for {step, members} <- font_stacks_for(theme) do
      {name([:font, step]), Scales.font_stack(members)}
    end
  end

  defp color_decls(nil), do: []

  defp color_decls(colors) do
    colors
    |> Enum.sort_by(fn {role, _hex} -> role end)
    |> Enum.map(fn {role, hex} -> {name([:color, role]), hex} end)
  end

  defp block(selector, decls) do
    body = Enum.map_join(decls, "\n", fn {name, value} -> "  #{name}: #{value};" end)
    "#{selector} {\n#{body}\n}"
  end

  defp dash(value), do: value |> to_string() |> String.replace("_", "-")
end

defmodule Corex.Design.Emit.Theme do
  @moduledoc false

  alias Corex.Design.Emit.Tokens
  alias Corex.Design.Namespaces
  alias Corex.Design.Theme
  alias Corex.Design.Tokens.Colors
  alias Corex.Design.Tokens.Scales

  @doc """
  Emits the Tailwind v4 token bundle, derived from the pure-Elixir model.

  Three layers:

    * the Corex runtime token layer (`Corex.Design.Emit.Tokens`): `--color-*`,
      `--space-*`, `--font-weight-*`, … with real values on `:root` and overridden on
      `[data-theme][data-mode]`, so recipe and component CSS resolve against the
      live theme;
    * a `--theme-<tailwind-key>` source layer on `:root` that aliases each Corex
      runtime variable. Tailwind's `@theme inline` utilities reference
      `var(--theme-<key>)`, so these names match what Tailwind emits and resolve
      through the Corex variables (and therefore stay themeable);
    * a `@theme inline` block mapping Tailwind namespaces (`--color-*`,
      `--spacing-*`, `--font-weight-*`, `--radius-*`, …) so Tailwind generates
      utilities (`bg-accent`, `p-space-lg`, `font-bold`).

  Runtime tokens use short Corex names (`--space-md`, `--font-sans`). The bridge
  maps Tailwind utility namespaces (`--spacing-space-md`, `--font-display`) onto
  those same runtime variables.
  """
  def css do
    Enum.join([Tokens.css(), bridge_css()], "\n\n") <> "\n"
  end

  @doc false
  def bridge_css do
    pairs = bridge_pairs()

    Enum.join(
      [source_block(pairs), bridge_block(pairs), container_sizing_utilities()],
      "\n\n"
    ) <> "\n"
  end

  defp source_block(pairs) do
    decls = for {key, corex} <- pairs, do: {"--theme-#{key}", "var(#{corex})"}
    block(":root", decls)
  end

  defp bridge_block(pairs) do
    decls = for {key, _corex} <- pairs, do: {"--#{key}", "var(--theme-#{key})"}
    block("@theme inline", decls)
  end

  defp bridge_pairs do
    dt = Theme.default_theme()
    dm = Theme.default_mode()

    color_pairs(dt, dm) ++
      spacing_pairs(dt) ++
      scale_pairs("text", Theme.text(dt), "text") ++
      text_leading_pairs() ++
      scale_pairs("radius", Theme.radius(dt), "radius") ++
      scale_pairs("container", Theme.container(dt), "container") ++
      scale_pairs("font", Tokens.font_stacks_for(dt), "font") ++
      static_scale_pairs()
  end

  defp static_scale_pairs do
    Enum.flat_map(Namespaces.static_scales(), fn {ns, steps} ->
      scale_pairs(ns, steps, ns)
    end)
  end

  defp text_leading_pairs do
    for {step, _} <- Scales.text_leading() do
      key = "text-#{dash(step)}--line-height"
      {key, "--text-#{dash(step)}--line-height"}
    end
  end

  defp color_pairs(dt, dm) do
    Colors.generate()
    |> Map.fetch!({dt, dm})
    |> Map.keys()
    |> Enum.sort()
    |> Enum.map(fn role -> {"color-#{role}", "--color-#{role}"} end)
  end

  defp spacing_pairs(dt) do
    space =
      [{"spacing", "--spacing"}] ++
        [{"spacing-space", "--space"}] ++
        for {step, _} <- Theme.space(dt), do: {"spacing-space-#{step}", "--space-#{step}"}

    size =
      [{"spacing-size", "--size"}] ++
        for {step, _} <- Theme.size(dt), do: {"spacing-size-#{step}", "--size-#{step}"}

    space ++ size
  end

  defp scale_pairs(tailwind_ns, steps, corex_ns) do
    for {step, _} <- steps, do: {"#{tailwind_ns}-#{step}", "--#{corex_ns}-#{step}"}
  end

  defp container_sizing_utilities do
    """
    @utility min-w-* {
      min-width: --value(--container-*, [length]);
    }

    @utility min-h-* {
      min-height: --value(--container-*, [length]);
    }

    @utility max-h-* {
      max-height: --value(--container-*, [length]);
    }
    """
    |> String.trim()
  end

  defp block(selector, decls) do
    body = Enum.map_join(decls, "\n", fn {name, value} -> "  #{name}: #{value};" end)
    "#{selector} {\n#{body}\n}"
  end

  defp dash(value), do: value |> to_string() |> String.replace("_", "-")
end

defmodule Corex.Design.Emit.Typography do
  @moduledoc false

  alias Corex.Design.Style
  alias Corex.Design.Theme

  def css do
    default_theme = Theme.default_theme()
    default_map = Theme.typography(default_theme)

    shared =
      default_map
      |> Enum.map_join("\n\n", fn {element, sx} ->
        Style.to_css(selectors(element), sx)
      end)

    overrides =
      Theme.themes()
      |> Enum.reject(&(&1 == default_theme))
      |> Enum.flat_map(fn theme ->
        theme_map = Theme.typography(theme)
        diff = diff_elements(default_map, theme_map)

        if diff == %{} do
          []
        else
          Enum.map(diff, fn {element, sx} ->
            Style.to_css(scoped_selectors(theme, element), sx)
          end)
        end
      end)
      |> Enum.join("\n\n")

    [shared, overrides]
    |> Enum.reject(&(&1 == ""))
    |> Enum.join("\n\n")
  end

  defp selectors("blockquote p"), do: ".typo blockquote p"

  defp selectors(".list li"), do: ".typo .list li"

  defp selectors(".list li:last-child"), do: ".typo .list li:last-child"

  defp selectors(".list li:hover"), do: ".typo .list li:hover"

  defp selectors(element), do: ".typo #{element}"

  defp scoped_selectors(theme, element) do
    ~s([data-theme="#{theme}"] .typo #{element})
  end

  defp diff_elements(base, over) do
    over
    |> Map.take(Map.keys(base))
    |> Enum.reject(fn {key, sx} -> Map.get(base, key) == sx end)
    |> Map.new()
  end
end

defmodule Corex.Design.Emit.StyleRecipe do
  @moduledoc false

  alias Corex.Design.Bem
  alias Corex.Design.Emit.TailwindCss
  alias Corex.Design.Emit.TailwindUtilitiesRecipe
  alias Corex.Design.Selector
  alias Corex.Design.Style

  @doc """
  Compiles sx-based recipes to component-layer CSS (`@apply` extra rules, utility-skipped variants).
  """
  def to_css(recipe) do
    ctx = [recipe: recipe, kind: recipe.kind]

    case recipe.kind do
      kind when kind in [:recipe, :style_recipe] ->
        compile_single(recipe, ctx)

      kind when kind in [:slot_recipe, :style_slot_recipe, :style_part_recipe] ->
        compile_slot(recipe, ctx)

      :layout ->
        compile_layout(recipe, ctx)
    end
  end

  defp compile_single(recipe, ctx) do
    id = recipe.id
    base = recipe_base(recipe, ctx)

    blocks =
      [
        Style.to_css(host_selector(id, ctx), base, ctx)
        | variant_blocks(id, recipe.variants, ctx)
      ] ++ compound_blocks(id, recipe_axis_overrides(recipe), ctx)

    join_blocks(blocks, recipe, ctx)
  end

  defp compile_slot(recipe, ctx) do
    id = recipe.id
    scope = recipe.scope
    base_map = slot_base_map(recipe, ctx)

    base_blocks =
      for {slot, sx} <- base_map do
        Style.to_css(slot_selector(id, scope, slot, ctx), sx, ctx)
      end

    variant_blocks =
      for {axis, values} <- recipe.variants,
          {value, slot_map} <- values,
          not skip_variant?(axis, value, slot_map, ctx),
          {slot, sx} <- normalize_slot_map(slot_map) do
        sel = slot_variant_selector(id, scope, axis, value, slot, ctx)
        Style.to_css(sel, sx, ctx)
      end

    compound_blocks =
      for cv <- recipe_axis_overrides(recipe),
          {slot, sx} <- normalize_slot_map(Map.fetch!(cv, :style)) do
        sel = slot_compound_selector(id, scope, cv, slot, ctx)
        Style.to_css(sel, sx, [selector: sel] ++ ctx)
      end

    join_blocks(base_blocks ++ variant_blocks ++ compound_blocks, recipe, ctx)
  end

  defp compile_layout(recipe, ctx) do
    id = recipe.id
    base_block = Style.to_css(layout_host(id), sx_map(recipe.base), ctx)

    variant_blocks =
      for {axis, values} <- recipe.variants,
          {value, props} <- values,
          not skip_variant?(axis, value, props, ctx) do
        Style.to_css(layout_variant_selector(id, axis, value), sx_map(props), ctx)
      end

    join_blocks([base_block | variant_blocks], recipe, ctx)
  end

  defp layout_host(id), do: Selector.host(id)

  defp layout_variant_selector(id, axis, value) do
    name = Selector.class_name(id)
    ".#{name}.#{name}--#{Bem.step(axis, value)}"
  end

  defp join_blocks(blocks, recipe, _ctx) do
    extras = extra_rules_css(recipe.extra_rules || [])

    (blocks ++ extras)
    |> Enum.reject(&(&1 == ""))
    |> Enum.join("\n\n")
  end

  defp extra_rules_css(rules) do
    case TailwindCss.rules_css(rules) do
      "" -> []
      css -> [css]
    end
  end

  defp recipe_base(recipe, _ctx), do: sx_map(recipe.base)

  defp slot_base_map(recipe, _ctx) do
    recipe.base
    |> slot_blocks_map()
  end

  defp variant_blocks(id, variants, ctx) do
    for {axis, values} <- variants,
        {value, block} <- values,
        not skip_variant?(axis, value, block, ctx) do
      Style.to_css(variant_selector(id, axis, value, ctx), sx_map(block), ctx)
    end
  end

  defp compound_blocks(id, axis_overrides, ctx) do
    for cv <- axis_overrides do
      match = Map.fetch!(cv, :match)
      style = Map.fetch!(cv, :style)
      sel = compound_selector(id, match, ctx)
      Style.to_css(sel, sx_map(style), ctx)
    end
  end

  defp recipe_axis_overrides(%{axis_overrides: overrides}), do: overrides
  defp recipe_axis_overrides(_), do: []

  defp sx_map(%{} = map), do: map
  defp sx_map(list) when is_list(list), do: Map.new(list)

  defp slot_blocks_map(slot_blocks) when is_list(slot_blocks) do
    for {slot, block} <- slot_blocks, into: %{}, do: {slot, sx_map(block)}
  end

  defp slot_blocks_map(%{} = map), do: map

  defp normalize_slot_map(%{} = map) do
    if Map.has_key?(map, :decls) or Map.has_key?(map, :children) do
      raise ArgumentError, "expected sx slot map, got a :decls/:children block"
    else
      Enum.to_list(map)
    end
  end

  defp normalize_slot_map(list) when is_list(list), do: list

  defp host_selector(id, _ctx), do: Selector.host(id)

  defp variant_selector(id, axis, value, _ctx), do: bem_variant_selector(id, axis, value)

  defp bem_variant_selector(id, axis, value) do
    name = Selector.class_name(id)
    ".#{name}.#{name}--#{bem_suffix(axis, value)}"
  end

  defp bem_suffix(axis, value), do: Bem.step(axis, value)

  defp compound_selector(id, match, _ctx), do: bem_compound(id, match)

  defp bem_compound(id, match) do
    name = Selector.class_name(id)

    ".#{name}" <>
      Enum.map_join(match, "", fn {axis, value} ->
        ".#{name}--#{bem_suffix(axis, value)}"
      end)
  end

  defp slot_selector(id, _scope, :host, ctx), do: host_selector(id, ctx)

  defp slot_selector(id, scope, slot, _ctx) do
    descend([Selector.host(id)], Selector.slot(scope, part(slot)))
  end

  defp slot_variant_selector(id, _scope, axis, value, :host, ctx),
    do: variant_selector(id, axis, value, ctx)

  defp slot_variant_selector(id, scope, axis, value, slot, _ctx) do
    descend([bem_variant_selector(id, axis, value)], Selector.slot(scope, part(slot)))
  end

  defp slot_compound_selector(id, _scope, %{match: match}, :host, ctx),
    do: compound_selector(id, match, ctx)

  defp slot_compound_selector(id, scope, %{match: match}, slot, _ctx) do
    descend([bem_compound(id, match)], Selector.slot(scope, part(slot)))
  end

  defp descend(selectors, suffix) do
    selectors
    |> Enum.map(&"#{&1} #{suffix}")
    |> group()
  end

  defp group(selectors), do: Enum.join(selectors, ",\n")

  defp part(slot), do: slot |> to_string() |> String.replace("_", "-")

  defp skip_variant?(axis, value, _block, ctx) do
    recipe = Keyword.fetch!(ctx, :recipe)
    utility_axis? = axis in TailwindUtilitiesRecipe.utility_axes(recipe)
    scale_value? = not keyword_sizing_value?(value)

    utility_axis? and scale_value?
  end

  defp keyword_sizing_value?(value), do: value in [:none, :full, :auto, :fit]
end

defmodule Corex.Design.Emit.Layers do
  @moduledoc false

  alias Corex.Design.Emit.TailwindCss
  alias Corex.Design.RecipePresets
  alias Corex.Design.Rule

  def reset_css do
    """
    *,
    *::before,
    *::after {
      box-sizing: border-box;
    }

    html {
      -webkit-text-size-adjust: 100%;
      tab-size: 4;
      scrollbar-gutter: stable;
    }

    body {
      margin: 0;
    }

    [hidden]:where(:not([hidden="until-found"])) {
      display: none !important;
    }

    img,
    video,
    canvas {
      display: block;
      max-width: 100%;
    }

    svg {
      display: block;
    }

    button:not([data-scope]):not([data-button]):not(.button),
    input,
    select,
    textarea {
      font: inherit;
      color: inherit;
    }
    """
  end

  def base_css do
    """
    body {
      min-height: 100vh;
      min-height: 100dvh;
      font-family: var(--font-sans);
      font-size: var(--text-base);
      line-height: var(--leading-base);
      font-weight: var(--font-weight-normal);
      color: var(--color-ui-ink);
      background-color: var(--color-root);
      text-wrap: wrap;
      -webkit-font-smoothing: antialiased;
      -moz-osx-font-smoothing: grayscale;
    }

    a {
      color: inherit;
    }

    .typo {
      font-family: var(--font-sans);
      font-size: var(--text-base);
      line-height: var(--leading-base);
      font-weight: var(--font-weight-normal);
      color: var(--color-ui-ink);
      text-wrap: wrap;
    }

    .typo:focus-visible {
      outline: none;
    }

    .sr-only {
      position: absolute;
      width: 1px;
      height: 1px;
      padding: 0;
      margin: -1px;
      overflow: hidden;
      clip: rect(0, 0, 0, 0);
      white-space: nowrap;
      border: 0;
    }

    [data-part="icon"],
    [data-part="indicator"],
    [data-part="item-indicator"],
    [data-part="branch-indicator"],
    .button [data-icon],
    .link [data-icon],
    .badge [data-icon],
    [data-part="indicator"] [data-icon],
    [data-part="item-indicator"] [data-icon] {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      flex-shrink: 0;
      color: currentcolor;
      width: 1em !important;
      height: 1em !important;
    }

    [data-part="icon"],
    [data-part="indicator"],
    [data-part="item-indicator"],
    [data-part="branch-indicator"] {
      width: 1em;
      height: 1em;
    }

    :focus {
      outline: none;
    }

    :focus-visible {
      outline: 2px solid var(--color-accent);
      outline-offset: 2px;
    }

    .icon {
      display: flex;
      align-items: center;
      justify-content: center;
      height: 1em !important;
      width: 1em !important;
      color: currentcolor;
      flex-shrink: 0;
    }

    [dir="rtl"] .icon {
      transform: scaleX(-1);
    }
    """ <> global_scrollbar_css()
  end

  def unlayered_host_icon_css do
    """
    .button [data-icon],
    .link [data-icon],
    .badge [data-icon],
    [data-part="indicator"] [data-icon],
    [data-part="item-indicator"] [data-icon],
    .clipboard [data-scope="clipboard"][data-part="trigger"] [data-scope="clipboard"][data-part="copy"] [data-icon],
    .clipboard [data-scope="clipboard"][data-part="trigger"] [data-scope="clipboard"][data-part="copied"] [data-icon] {
      width: 1em !important;
      height: 1em !important;
    }
    """
  end

  defp global_scrollbar_css do
    TailwindCss.rules_css([
      Rule.new("*", children: RecipePresets.scrollbar_sm_children())
    ])
  end
end

defmodule Corex.Design.Emit.Responsive do
  @moduledoc """
  Universal, component-agnostic responsive visibility utilities (Chakra-style
  `hideFrom` / `hideBelow`) emitted into the Tailwind recipe bundle.

  Each utility is matched by a BEM-style class, a data attribute, and (for the
  attribute form) is produced by the runtime resolver, so a page can hide an
  element responsively via `<.row hide_below="md">`, `class="row hide-below-md"`,
  or `data-hide-below="md"` interchangeably.
  """

  alias Corex.Design.Tokens.Scales

  @doc "Global visibility utilities shared by every component and layout primitive."
  def css do
    [unconditional(), Enum.map(Scales.breakpoint(), &breakpoint_block/1)]
    |> List.flatten()
    |> Enum.join("\n\n")
  end

  defp unconditional do
    """
    .hidden,
    [data-hidden] {
      display: none !important;
    }
    """
    |> String.trim_trailing()
  end

  defp breakpoint_block({step, width}) do
    """
    @media (min-width: #{width}) {
      .hide-from-#{step},
      [data-hide-from="#{step}"] {
        display: none !important;
      }
    }

    @media not all and (min-width: #{width}) {
      .hide-below-#{step},
      [data-hide-below="#{step}"] {
        display: none !important;
      }
    }
    """
    |> String.trim_trailing()
  end
end

defmodule Corex.Design.Emit.TailwindRecipe do
  @moduledoc false

  alias Corex.Design.Emit.StyleRecipe
  alias Corex.Design.Emit.TailwindUtilitiesRecipe

  def to_css(recipe) do
    utilities = TailwindUtilitiesRecipe.utilities(recipe)
    body = StyleRecipe.to_css(recipe)

    join_sections([utilities, layer_components(body)])
  end

  defp layer_components(""), do: ""

  defp layer_components(css) do
    """
    @layer components {
    #{indent(css)}
    }
    """
  end

  defp join_sections(sections) do
    sections
    |> Enum.reject(&(&1 in [nil, ""]))
    |> Enum.join("\n\n")
  end

  defp indent(text) do
    text
    |> String.split("\n")
    |> Enum.map_join("\n", fn
      "" -> ""
      line -> "  " <> line
    end)
  end
end

defmodule Corex.Design.Emit.TailwindUtilities do
  @moduledoc false

  alias Corex.Design.Emit.TailwindCss
  alias Corex.Design.Fragment

  @base ~W(ui_root ui_trigger ui_icon ui_content ui_label ui_input ui_item ui_link ui_error ui_readonly ui_loading)a

  def css do
    wildcards = %{
      ui_trigger: trigger_wildcard_lines(),
      ui_icon: icon_wildcard_lines(),
      ui_item: item_wildcard_lines(),
      ui_link: link_wildcard_lines()
    }

    @base
    |> Enum.map(&base_utility/1)
    |> Kernel.++(Enum.map(wildcards, &wildcard_utility/1))
    |> Enum.reject(&(&1 in [nil, ""]))
    |> Enum.join("\n\n")
  end

  defp base_utility(id) do
    name = Fragment.utility_name(id)
    body = TailwindCss.fragment_utility_body(id)

    """
    @utility #{name} {
    #{body}
    }
    """
  end

  defp wildcard_utility({id, lines}) do
    name = Fragment.utility_name(id) <> "--*"

    """
    @utility #{name} {
    #{Enum.join(lines, "\n")}
    }
    """
  end

  defp trigger_wildcard_lines do
    scale_lines() ++
      [
        "  background-color: --value(--color-*, [color]);",
        "  color: --value(--color-*-ink, [color]);",
        "",
        "  &:hover {",
        "    background-color: --value(--color-*-hover, [color]);",
        "  }",
        "",
        "  &:active {",
        "    background-color: --value(--color-*-active, [color]);",
        "  }",
        "",
        "  &:focus-visible {",
        "    outline: none;",
        "    box-shadow: inset 0 0 0 2px --value(--color-*-ink, [color]);",
        "  }",
        "",
        "  &:disabled,",
        "  &[data-disabled],",
        "  &[disabled] {",
        "    background-color: --value(--color-*-muted, [color]);",
        "    cursor: not-allowed;",
        "  }",
        "",
        "  &[data-state=\"open\"],",
        "  &[data-state=\"checked\"],",
        "  &[data-state=\"on\"] {",
        "    background-color: --value(--color-*, [color]);",
        "    color: --value(--color-*-ink, [color]);",
        "",
        "    &:hover {",
        "      background-color: --value(--color-*-hover, [color]);",
        "    }",
        "",
        "    &:active {",
        "      background-color: --value(--color-*-active, [color]);",
        "    }",
        "",
        "    &:focus-visible {",
        "      box-shadow: inset 0 0 0 2px --value(--color-*-ink, [color]);",
        "      outline: none;",
        "    }",
        "",
        "    &:disabled,",
        "    &[data-disabled],",
        "    &[disabled] {",
        "      background-color: --value(--color-*-muted, [color]);",
        "      cursor: not-allowed;",
        "    }",
        "  }"
      ]
  end

  defp icon_wildcard_lines do
    [
      "  font-size: --value(--text-*, [length]);",
      "  line-height: --value(--text-*--line-height, [length]);"
    ]
  end

  defp item_wildcard_lines do
    scale_lines() ++
      [
        "  background-color: --value(--color-*, [color]);",
        "  color: --value(--color-*-ink, [color]);",
        "",
        "  &:hover {",
        "    background-color: --value(--color-*-hover, [color]);",
        "  }",
        "",
        "  &:active {",
        "    background-color: --value(--color-*-active, [color]);",
        "  }",
        "",
        "  &:focus-visible {",
        "    outline: none;",
        "    box-shadow: inset 0 0 0 2px --value(--color-*-ink, [color]);",
        "  }",
        "",
        "  &:disabled,",
        "  &[data-disabled],",
        "  &[disabled] {",
        "    background-color: --value(--color-*-muted, [color]);",
        "    color: var(--color-ui-ink-muted);",
        "    cursor: not-allowed;",
        "  }",
        "",
        "  &[data-selected],",
        "  &[data-state=\"checked\"],",
        "  &[data-state=\"on\"],",
        "  &[data-in-range],",
        "  &[data-checked],",
        "  &[data-indeterminate] {",
        "    background-color: --value(--color-*, [color]);",
        "    color: --value(--color-*-ink, [color]);",
        "",
        "    &:hover {",
        "      background-color: --value(--color-*-hover, [color]);",
        "    }",
        "",
        "    &:active {",
        "      background-color: --value(--color-*-active, [color]);",
        "    }",
        "",
        "    &:focus-visible {",
        "      box-shadow: inset 0 0 0 2px --value(--color-*-ink, [color]);",
        "      outline: none;",
        "    }",
        "",
        "    &:disabled,",
        "    &[data-disabled],",
        "    &[disabled] {",
        "      background-color: --value(--color-*-muted, [color]);",
        "      cursor: not-allowed;",
        "    }",
        "  }"
      ]
  end

  defp link_wildcard_lines do
    [
      "  font-size: --value(--text-*, [length]);",
      "  line-height: --value(--text-*--line-height, [length]);",
      "  color: --value(--color-ui-ink-*, [color]);",
      "  gap: calc(--value(--spacing-*, [length]) * 0.5);"
    ]
  end

  defp scale_lines do
    [
      "  font-size: --value(--text-*, [length]);",
      "  line-height: --value(--text-*--line-height, [length]);",
      "  padding-inline: --value(--spacing-space-*, [length]);",
      "  gap: --value(--spacing-space-*, [length]);",
      "  min-height: --value(--spacing-size-*, [length]);"
    ]
  end
end

defmodule Corex.Design.Emit.TailwindUtilitiesRecipe do
  @moduledoc false

  alias Corex.Design.Axis
  alias Corex.Design.Rule
  alias Corex.Design.Selector

  @prefixed_axes %{radius: "rounded", text: "text"}
  @layout_scale_axes ~W(padding padding_inline padding_block gap radius text)a

  def utility_axes(%{kind: :layout} = recipe) do
    @layout_scale_axes
    |> Enum.filter(&layout_scale_axis?(&1, recipe))
  end

  def utility_axes(recipe) do
    []
    |> maybe_utility_axis(:radius, recipe, &prefixed_axis?/2)
    |> maybe_utility_axis(:text, recipe, &prefixed_axis?/2)
    |> maybe_utility_axis(:max_width, recipe, &container_axis?/2)
    |> maybe_utility_axis(:max_height, recipe, &container_axis?/2)
    |> maybe_utility_axis(:size, recipe, &size_axis?/2)
  end

  def utilities(%{kind: :layout} = recipe), do: layout_utilities(recipe)

  def utilities(recipe) do
    name = Selector.class_name(recipe.id)

    []
    |> maybe_add(prefixed_utility(name, :radius, recipe))
    |> maybe_add(prefixed_utility(name, :text, recipe))
    |> maybe_add(container_utility(name, :max_width, recipe))
    |> maybe_add(container_utility(name, :max_height, recipe))
    |> maybe_add(size_utility(name, recipe))
    |> Enum.reject(&(&1 in [nil, ""]))
    |> Enum.join("\n\n")
    |> case do
      "" -> nil
      css -> css
    end
  end

  defp layout_utilities(recipe) do
    name = Selector.class_name(recipe.id)

    @layout_scale_axes
    |> Enum.map(&layout_scale_utility(name, &1, recipe))
    |> Enum.reject(&(&1 in [nil, ""]))
    |> Enum.join("\n\n")
    |> case do
      "" -> nil
      css -> css
    end
  end

  defp maybe_utility_axis(axes, axis, recipe, pred) do
    if pred.(axis, recipe), do: [axis | axes], else: axes
  end

  defp layout_scale_axis?(axis, recipe) do
    layout_scale_axis?(axis, recipe, scale_variant_values(recipe, axis))
  end

  defp layout_scale_axis?(_axis, _recipe, []), do: false
  defp layout_scale_axis?(_axis, _recipe, _values), do: true

  defp layout_scale_utility(name, axis, recipe) do
    values = scale_variant_values(recipe, axis)

    if values == [] do
      nil
    else
      suffix = Axis.name(axis)

      scale_utility(
        "#{name}--#{suffix}-*",
        ["  #{layout_axis_line(axis)}"]
      )
    end
  end

  defp layout_axis_line(:padding), do: "padding: --value(--spacing-space-*, [length]);"

  defp layout_axis_line(:padding_inline),
    do: "padding-inline: --value(--spacing-space-*, [length]);"

  defp layout_axis_line(:padding_block),
    do: "padding-block: --value(--spacing-space-*, [length]);"

  defp layout_axis_line(:gap), do: "gap: --value(--spacing-space-*, [length]);"
  defp layout_axis_line(:radius), do: "border-radius: --value(--radius-*, [length]);"
  defp layout_axis_line(:text), do: axis_utility_lines(:text) |> Enum.join("\n  ")

  defp scale_variant_values(recipe, axis) do
    case Keyword.get(recipe.variants, axis) do
      nil ->
        []

      values ->
        values
        |> Enum.reject(fn {value, _} -> keyword_sizing_value?(value) end)
        |> Enum.map(fn {value, _} -> value end)
    end
  end

  defp prefixed_axis?(axis, recipe), do: scale_variant_values(recipe, axis) != []

  defp container_axis?(axis, recipe), do: container_slots(recipe, axis) != []

  defp size_axis?(axis, recipe) do
    axis == :size and slot_axis_lines(recipe, [:size]) != []
  end

  defp size_utility(name, recipe) do
    case slot_axis_lines(recipe, [:size]) do
      [] -> nil
      lines -> scale_utility("#{name}--size-*", lines)
    end
  end

  defp maybe_add(list, nil), do: list
  defp maybe_add(list, item), do: list ++ [item]

  defp prefixed_utility(name, axis, recipe) do
    slot_lines = slot_axis_lines(recipe, [axis])
    host_lines = host_prefixed_lines(recipe, axis)
    extra_lines = utility_extra_lines(recipe, name, [axis])

    lines =
      (host_lines ++ slot_lines ++ extra_lines)
      |> Enum.uniq()
      |> Enum.reject(&(&1 == ""))

    suffix = Map.fetch!(@prefixed_axes, axis)
    scale_utility("#{name}--#{suffix}-*", lines)
  end

  defp host_prefixed_lines(recipe, axis) do
    if single_host_recipe?(recipe) and axis in Map.keys(@prefixed_axes) do
      case axis do
        :radius -> ["  border-radius: --value(--radius-*, [length]);"]
        :text -> axis_utility_lines(:text) |> Enum.map(&("  " <> &1))
      end
    else
      []
    end
  end

  defp container_utility(name, axis, recipe) do
    slots = container_slots(recipe, axis)

    cond do
      slots == [] ->
        nil

      slots == [:host] ->
        prop = container_property(axis)

        scale_utility(
          "#{name}--#{container_suffix(axis)}-*",
          ["  #{prop}: --value(--container-*, [length]);"]
        )

      true ->
        prop = container_property(axis)

        lines =
          for slot <- slots do
            selector = slot_selector(recipe, slot)

            """
              #{selector} {
                #{prop}: --value(--container-*, [length]);
              }
            """
            |> String.trim()
          end

        scale_utility("#{name}--#{container_suffix(axis)}-*", lines)
    end
  end

  defp slot_axis_lines(%{kind: kind}, _axes) when kind in [:recipe, :style_recipe, :layout],
    do: []

  defp slot_axis_lines(recipe, axes) do
    axes
    |> Enum.flat_map(fn axis ->
      recipe.variants
      |> Keyword.get(axis, [])
      |> slot_sx_union()
      |> Enum.flat_map(fn {slot, sx_keys} ->
        selector = slot_selector(recipe, slot)

        lines =
          sx_keys
          |> Enum.flat_map(&sx_property_lines/1)
          |> Enum.uniq()
          |> Enum.map_join("\n", &("    " <> &1))

        if lines == "" do
          []
        else
          [
            """
              #{selector} {
              #{lines}
              }
            """
          ]
        end
      end)
    end)
  end

  defp utility_extra_lines(recipe, name, axes) do
    recipe.extra_rules
    |> filter_utility_extra_rules(name, axes)
    |> Enum.flat_map(&utility_rule_lines/1)
  end

  defp filter_utility_extra_rules(rules, name, axes) do
    Enum.filter(rules, fn %Rule{selector: selector} ->
      variant_utility_rule?(selector, name, axes)
    end)
  end

  defp variant_utility_rule?(selector, name, axes) do
    Enum.any?(axes, &Axis.utility_host?(selector, name, &1))
  end

  defp utility_rule_lines(%Rule{selector: selector} = rule) do
    target_selector = Selector.strip_host_variant(selector, recipe_name_from_selector(selector))

    decl_lines =
      rule.decls
      |> Enum.flat_map(fn
        {:include, _} ->
          []

        {:raw, _} ->
          []

        {prop, _}
        when prop in [
               :background_color,
               :color,
               :border_inline_start,
               :padding_inline,
               :padding_inline_start,
               :gap
             ] ->
          sx_property_lines(prop)

        {prop, _val} ->
          sx_property_lines(prop)
      end)
      |> Enum.uniq()
      |> Enum.map_join("\n", &("    " <> &1))

    if decl_lines == "" do
      []
    else
      [
        """
          #{target_selector} {
        #{decl_lines}
          }
        """
      ]
    end
  end

  defp recipe_name_from_selector("." <> rest) do
    rest
    |> String.split(".", parts: 2)
    |> hd()
  end

  defp slot_sx_union(values) do
    values
    |> Enum.flat_map(fn {_value, block} -> normalize_slot_map(block) end)
    |> Enum.group_by(fn {slot, _} -> slot end, fn {_, sx} -> Map.keys(sx_map(sx)) end)
    |> Enum.map(fn {slot, key_lists} ->
      {slot, key_lists |> List.flatten() |> Enum.uniq()}
    end)
  end

  defp container_slots(recipe, axis) do
    case Keyword.get(recipe.variants, axis) do
      nil ->
        []

      values ->
        values
        |> Enum.reject(fn {value, _} -> keyword_sizing_value?(value) end)
        |> Enum.flat_map(fn {_value, block} ->
          normalize_slot_map(block) |> Enum.map(fn {slot, _} -> slot end)
        end)
        |> Enum.uniq()
    end
  end

  defp single_host_recipe?(recipe) do
    recipe.kind in [:recipe, :style_recipe, :layout]
  end

  defp slot_selector(%{scope: _scope}, :host), do: "&"

  defp slot_selector(%{scope: scope}, slot) do
    part = slot |> Atom.to_string() |> String.replace("_", "-")
    ~s([data-scope="#{scope}"][data-part="#{part}"])
  end

  defp normalize_slot_map(%{} = map) do
    cond do
      Map.has_key?(map, :decls) or Map.has_key?(map, :children) ->
        [{:host, map}]

      slot_map?(map) ->
        Enum.to_list(map)

      true ->
        [{:host, map}]
    end
  end

  defp normalize_slot_map(list) when is_list(list), do: list

  defp slot_map?(map) do
    map
    |> Map.keys()
    |> Enum.any?(&slot_entry_key?/1)
  end

  defp slot_entry_key?(key), do: Axis.slot_part?(key)

  defp sx_map(%{} = map), do: map
  defp sx_map(list) when is_list(list), do: Map.new(list)

  defp axis_utility_lines(:text) do
    [
      "font-size: --value(--text-*, [length]);",
      "line-height: --value(--text-*--line-height, [length]);"
    ]
  end

  defp axis_utility_lines(_), do: []

  defp sx_property_lines(:font_size), do: ["font-size: --value(--text-*, [length]);"]

  defp sx_property_lines(:line_height),
    do: ["line-height: --value(--text-*--line-height, [length]);"]

  defp sx_property_lines(:padding_inline),
    do: ["padding-inline: --value(--spacing-space-*, [length]);"]

  defp sx_property_lines(:padding), do: ["padding: --value(--spacing-space-*, [length]);"]
  defp sx_property_lines(:gap), do: ["gap: --value(--spacing-space-*, [length]);"]
  defp sx_property_lines(:min_height), do: ["min-height: --value(--spacing-size-*, [length]);"]

  defp sx_property_lines(:margin_bottom),
    do: ["margin-bottom: --value(--spacing-space-*, [length]);"]

  defp sx_property_lines(:border_radius), do: ["border-radius: --value(--radius-*, [length]);"]
  defp sx_property_lines(:color), do: ["color: --value(--color-ui-ink-*, [color]);"]

  defp sx_property_lines(:background_color),
    do: ["background-color: --value(--color-*, [color]);"]

  defp sx_property_lines(:max_width), do: ["max-width: --value(--container-*, [length]);"]

  defp sx_property_lines(:padding_inline_start),
    do: ["padding-inline-start: --value(--spacing-space-*, [length]);"]

  defp sx_property_lines(:border_inline_start),
    do: ["border-inline-start: 1px solid --value(--color-*-ink, [color]);"]

  defp sx_property_lines(:outline), do: []
  defp sx_property_lines(_), do: []

  defp scale_utility(pattern, lines, opts \\ [])

  defp scale_utility(_pattern, [], _opts), do: nil

  defp scale_utility(pattern, lines, _opts) do
    """
    @utility #{pattern} {
    #{Enum.join(lines, "\n")}
    }
    """
  end

  defp container_property(:max_width), do: "max-width"
  defp container_property(:max_height), do: "max-height"

  defp container_suffix(:max_width), do: "max-w"
  defp container_suffix(:max_height), do: "max-h"

  defp keyword_sizing_value?(value), do: value in [:none, :full, :auto, :fit]
end
