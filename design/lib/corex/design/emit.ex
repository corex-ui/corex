defmodule Corex.Design.Emit.Css do
  @moduledoc false

  alias Corex.Design.Css
  alias Corex.Design.Fragment
  alias Corex.Design.Rule

  @indent "  "

  @doc """
  Renders a list of top-level rules to plain CSS, separated by blank lines.
  """
  def rules_css(rules) when is_list(rules) do
    rules
    |> Enum.map(&rule_css/1)
    |> Enum.reject(&(&1 == ""))
    |> Enum.join("\n\n")
  end

  @doc """
  Renders a single rule (and its nested children) to plain CSS using native CSS
  nesting. Fragment includes in the declaration list are expanded inline.
  """
  def rule_css(rule, level \\ 0)

  def rule_css(%Rule{selector: selector} = rule, level) do
    {decls, children} = expand(rule)

    inner =
      [decl_lines(decls, level + 1), child_blocks(children, level + 1)]
      |> Enum.reject(&(&1 == ""))
      |> Enum.join("\n")

    pad = String.duplicate(@indent, level)

    if inner == "" do
      ""
    else
      "#{pad}#{selector} {\n#{inner}\n#{pad}}"
    end
  end

  defp expand(%Rule{decls: decls, children: children}) do
    Enum.reduce(decls, {[], children}, fn
      {:include, fragment}, {acc_decls, acc_children} ->
        %{decls: frag_decls, children: frag_children} = Fragment.get!(fragment)
        {acc_decls ++ frag_decls, acc_children ++ frag_children}

      decl, {acc_decls, acc_children} ->
        {acc_decls ++ [decl], acc_children}
    end)
  end

  defp decl_lines([], _level), do: ""

  defp decl_lines(decls, level) do
    pad = String.duplicate(@indent, level)

    decls
    |> Enum.map_join("\n", fn decl -> pad <> decl_line(decl) end)
  end

  defp decl_line({:raw, css}) when is_binary(css), do: css

  defp decl_line({property, value}) do
    {css_prop, css_val} = Css.resolve_property_value({property, value})
    "#{css_prop}: #{css_val};"
  end

  defp child_blocks([], _level), do: ""

  defp child_blocks(children, level) do
    children
    |> Enum.map(&rule_css(&1, level))
    |> Enum.reject(&(&1 == ""))
    |> Enum.join("\n\n")
  end

end
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
        static_decls_without_font() ++ dimension_decls(dt, include_font: true) ++
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
    weight = for {step, v} <- Scales.weight(), do: {name([:"font-weight", step]), Integer.to_string(v)}
    shadow = for {step, tpl} <- Scales.shadow(), do: {name([:shadow, step]), tpl}
    inset_shadow = for {step, tpl} <- Scales.inset_shadow(), do: {name([:"inset-shadow", step]), tpl}
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
    container = for {step, v} <- Theme.container(theme), do: {name([:container, step]), v}

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

  # Tailwind only wires `--container-*` to `max-w-*`. We extend the same scale to
  # `min-w-*`, `max-h-*`, and `min-h-*` via explicit per-step utilities. Using a
  # specific class name (not the `*` functional form) means Tailwind's built-in
  # keyword utilities (`min-w-0`, `max-h-full`, ...) keep working; we only add the
  # named container steps, which never collide with those keywords.
  defp container_sizing_utilities do
    dt = Theme.default_theme()

    for {prop, prefix} <- [{"min-width", "min-w"}, {"min-height", "min-h"}, {"max-height", "max-h"}],
        {step, _} <- Theme.container(dt) do
      "@utility #{prefix}-#{step} {\n  #{prop}: var(--container-#{step});\n}"
    end
    |> Enum.join("\n\n")
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

  defp selectors("blockquote p"), do: "body blockquote p, .typo blockquote p"

  defp selectors(".list li"), do: "body .list li, .typo .list li"

  defp selectors(".list li:last-child"),
    do: "body .list li:last-child, .typo .list li:last-child"

  defp selectors(".list li:hover"), do: "body .list li:hover, .typo .list li:hover"

  defp selectors(element), do: "body #{element}, .typo #{element}"

  defp scoped_selectors(theme, element) do
    ~s([data-theme="#{theme}"] body #{element}, [data-theme="#{theme}"] .typo #{element})
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

  alias Corex.Design.Axis
  alias Corex.Design.Condition
  alias Corex.Design.Emit.Css
  alias Corex.Design.Emit.TailwindCss
  alias Corex.Design.Emit.SelectorRewrite
  alias Corex.Design.Selector
  alias Corex.Design.Style
  alias Corex.Design.Tokens.Scales

  @prefixed_bem_axes ~w(text)a

  @doc """
  Compiles sx-based recipes to CSS strings for the plain CSS export target.
  """
  def to_css(recipe, opts \\ []) do
    ctx = [
      recipe: recipe.id,
      kind: recipe.kind,
      tailwind: Keyword.get(opts, :tailwind, false)
    ]

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
          {value, props} <- values do
        sx = sx_map(props)

        base = Style.to_css(layout_variant_selector(id, axis, value), sx, ctx)

        responsive =
          for {bp, _width} <- Scales.breakpoint() do
            inner = Style.to_css(layout_responsive_selector(id, axis, value, bp), sx, ctx)
            if inner == "", do: "", else: wrap_media(bp, inner)
          end

        [base | responsive]
      end
      |> List.flatten()

    join_blocks([base_block | variant_blocks], recipe, ctx)
  end

  defp layout_host(id), do: Selector.host(id)

  defp layout_variant_selector(id, axis, value) do
    name = Selector.class_name(id)
    ".#{name}.#{name}--#{Axis.name(axis)}-#{value}"
  end

  defp layout_responsive_selector(id, axis, value, bp) do
    name = Selector.class_name(id)
    ".#{name}.#{bp}\\:#{name}--#{Axis.name(axis)}-#{value}"
  end

  defp wrap_media(bp, inner) do
    media = Condition.selector(bp)

    body =
      inner
      |> String.split("\n")
      |> Enum.map_join("\n", fn
        "" -> ""
        line -> "  " <> line
      end)

    "#{media} {\n#{body}\n}"
  end

  defp join_blocks(blocks, recipe, ctx) do
    extras = extra_rules_css(recipe.extra_rules || [], ctx)

    (blocks ++ extras)
    |> Enum.reject(&(&1 == ""))
    |> Enum.join("\n\n")
  end

  defp extra_rules_css(rules, ctx) do
    rules
    |> SelectorRewrite.adapt_rules()
    |> render_extra_rules(ctx)
  end

  defp render_extra_rules(rules, ctx) do
    if Keyword.get(ctx, :tailwind, false) do
      case TailwindCss.rules_css(rules) do
        "" -> []
        css -> [css]
      end
    else
      Enum.map(rules, &Css.rule_css/1)
    end
  end

  defp merge_base(recipe), do: merge_base_impl(recipe)

  def merge_base_for_compile(recipe), do: merge_base_impl(recipe)

  def merge_slot_base_for_compile(recipe), do: merge_slot_base_impl(recipe)

  defp merge_base_impl(%{base: base, variants: variants, default_variants: defaults}) do
    defaults
    |> Enum.reduce(sx_map(base), fn {axis, value}, acc ->
      variant_sx =
        variants
        |> Keyword.fetch!(axis)
        |> value_block(value)
        |> sx_map()

      Style.merge(acc, variant_sx)
    end)
  end

  defp recipe_base(recipe, ctx) do
    if Keyword.get(ctx, :tailwind, false) do
      sx_map(recipe.base)
    else
      merge_base(recipe)
    end
  end

  defp slot_base_map(recipe, ctx) do
    if Keyword.get(ctx, :tailwind, false) do
      slot_base_without_defaults(recipe)
    else
      merge_slot_base(recipe)
    end
  end

  defp slot_base_without_defaults(recipe) do
    recipe.base
    |> slot_blocks_map()
  end

  defp merge_slot_base(recipe), do: merge_slot_base_impl(recipe)

  defp merge_slot_base_impl(%{base: base, variants: variants, default_variants: defaults}) do
    base_map = base |> slot_blocks_map()

    Enum.reduce(defaults, base_map, fn {axis, value}, acc ->
      variant_slots =
        variants
        |> Keyword.fetch!(axis)
        |> value_block(value)
        |> normalize_slot_map()
        |> slot_blocks_map()

      Map.merge(acc, variant_slots, fn _slot, a, b -> Style.merge(a, b) end)
    end)
  end

  defp variant_blocks(id, variants, ctx) do
    for {axis, values} <- variants,
        {value, block} <- values,
        not skip_variant?(axis, value, block, ctx) do
      Style.to_css(variant_selector(id, axis, value, ctx), sx_map(block), ctx)
    end
  end

  defp compound_blocks(id, axis_overrides, ctx) do
    for cv <- axis_overrides,
        not skip_compound?(cv, ctx) do
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

  defp value_block(values, value) do
    Enum.find_value(values, fn {v, block} -> if v == value, do: block end) ||
      raise ArgumentError, "no variant value #{inspect(value)}"
  end

  defp host_selector(id, _ctx), do: Selector.host(id)

  defp variant_selector(id, axis, value, _ctx), do: bem_variant_selector(id, axis, value)

  defp bem_variant_selector(id, axis, value) do
    name = Selector.class_name(id)
    ".#{name}.#{name}--#{bem_suffix(axis, value)}"
  end

  defp bem_suffix(:max_width, value), do: "max-w-#{value}"
  defp bem_suffix(:max_height, value), do: "max-h-#{value}"
  defp bem_suffix(:width, value), do: "w-#{value}"
  defp bem_suffix(:height, value), do: "h-#{value}"
  defp bem_suffix(:surface, value), do: "on-#{value}"
  defp bem_suffix(:radius, value), do: "rounded-#{value}"
  defp bem_suffix(axis, value) when axis in @prefixed_bem_axes, do: "#{Axis.name(axis)}-#{value}"
  defp bem_suffix(_axis, value), do: to_string(value)

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

  defp skip_variant?(_axis, _value, _block, _ctx), do: false

  defp skip_compound?(_cv, _ctx), do: false
end
defmodule Corex.Design.Emit.Layers do
  @moduledoc false

  alias Corex.Design.Emit.Css
  alias Corex.Design.Presets
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
    Css.rules_css([
      Rule.new("*", children: Presets.scrollbar_sm_children())
    ])
  end
end
defmodule Corex.Design.Emit.Responsive do
  @moduledoc """
  Universal, component-agnostic responsive visibility utilities (Chakra-style
  `hideFrom` / `hideBelow`) emitted into both the plain-CSS and Tailwind exports.

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
defmodule Corex.Design.Emit.SelectorRewrite do
  @moduledoc false

  def adapt_rules(rules), do: rules
end
defmodule Corex.Design.Emit.TailwindRecipe do
  @moduledoc false

  alias Corex.Design.Emit.StyleRecipe
  alias Corex.Design.Emit.TailwindUtilitiesRecipe

  def to_css(%{kind: :layout} = recipe) do
    layer_components(StyleRecipe.to_css(recipe))
  end

  def to_css(recipe) do
    utilities = TailwindUtilitiesRecipe.utilities(recipe)
    body = StyleRecipe.to_css(recipe, tailwind: true)

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
defmodule Corex.Design.Emit.TailwindCss do
  @moduledoc false

  alias Corex.Design.Css
  alias Corex.Design.Fragment
  alias Corex.Design.Rule

  @indent "  "

  def rules_css(rules) when is_list(rules) do
    rules
    |> Enum.map(&rule_css/1)
    |> Enum.reject(&(&1 == ""))
    |> Enum.join("\n\n")
  end

  def rule_css(%Rule{selector: selector} = rule, level \\ 0) do
    {decls, children} = expand(rule)

    inner =
      [decl_lines(decls, level + 1), child_blocks(children, level + 1)]
      |> Enum.reject(&(&1 == ""))
      |> Enum.join("\n")

    pad = String.duplicate(@indent, level)

    if inner == "" do
      ""
    else
      "#{pad}#{selector} {\n#{inner}\n#{pad}}"
    end
  end

  def fragment_utility_body(id) do
    %{decls: decls, children: children} = Fragment.get!(id)
    rule = %Rule{selector: "&", decls: decls, children: children}
    rule_css(rule, 0) |> String.trim_leading()
  end

  defp expand(%Rule{decls: decls, children: children}) do
    Enum.reduce(decls, {[], children}, fn
      {:include, fragment}, {acc_decls, acc_children} ->
        name = Fragment.utility_name(fragment)
        {acc_decls ++ [{:apply, name}], acc_children}

      decl, {acc_decls, acc_children} ->
        {acc_decls ++ [decl], acc_children}
    end)
  end

  defp decl_lines([], _level), do: ""

  defp decl_lines(decls, level) do
    pad = String.duplicate(@indent, level)

    decls
    |> Enum.map_join("\n", fn decl -> pad <> decl_line(decl) end)
  end

  defp decl_line({:apply, name}), do: "@apply #{name};"

  defp decl_line({:raw, css}) when is_binary(css), do: css

  defp decl_line({property, value}) do
    {css_prop, css_val} = Css.resolve_property_value({property, value})
    "#{css_prop}: #{css_val};"
  end

  defp child_blocks([], _level), do: ""

  defp child_blocks(children, level) do
    children
    |> Enum.map(&rule_css(&1, level))
    |> Enum.reject(&(&1 == ""))
    |> Enum.join("\n\n")
  end
end
defmodule Corex.Design.Emit.TailwindUtilities do
  @moduledoc false

  alias Corex.Design.Emit.TailwindCss
  alias Corex.Design.Fragment

  @base ~w(ui_root ui_trigger ui_icon ui_content ui_label ui_input ui_item ui_link ui_error ui_readonly ui_loading)a

  @modifiers ~w(ui_trigger_square ui_trigger_circle ui_trigger_ghost)a

  def css do
    wildcards = %{
      ui_trigger: trigger_wildcard_lines(),
      ui_icon: icon_wildcard_lines(),
      ui_item: item_wildcard_lines(),
      ui_link: link_wildcard_lines()
    }

    (@base
     |> Enum.map(&base_utility/1)
     |> Kernel.++(Enum.map(@modifiers, &modifier_utility/1))
     |> Kernel.++(Enum.map(wildcards, &wildcard_utility/1)))
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

  defp modifier_utility(id) do
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

  alias Corex.Design.Rule
  alias Corex.Design.Selector

  @prefixed_axes %{radius: "rounded", text: "text"}

  def utilities(%{kind: :layout}), do: nil

  def utilities(recipe) do
    name = Selector.class_name(recipe.id)

    []
    |> maybe_add(prefixed_utility(name, :radius, recipe))
    |> maybe_add(prefixed_utility(name, :text, recipe))
    |> maybe_add(container_utility(name, :max_width, recipe))
    |> maybe_add(container_utility(name, :max_height, recipe))
    |> Enum.reject(&(&1 in [nil, ""]))
    |> Enum.join("\n\n")
    |> case do
      "" -> nil
      css -> css
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

  defp slot_axis_lines(%{kind: kind}, _axes) when kind in [:recipe, :style_recipe, :layout], do: []

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
          |> Enum.map(&("    " <> &1))
          |> Enum.join("\n")

        if lines == "" do
          []
        else
          ["""
            #{selector} {
            #{lines}
            }
          """]
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
    host_mod = ".#{name}.#{name}--"

    String.starts_with?(selector, host_mod) and
      Enum.any?(axes, fn axis -> axis_rule_match?(selector, axis) end)
  end

  defp axis_rule_match?(selector, :text), do: String.contains?(selector, "--text-")
  defp axis_rule_match?(selector, :radius), do: String.contains?(selector, "--rounded-")
  defp axis_rule_match?(selector, :size), do: String.contains?(selector, "> p")
  defp axis_rule_match?(_selector, _axis), do: false

  defp utility_rule_lines(%Rule{} = rule) do
    target_selector = utility_target_selector(rule.selector)

    decl_lines =
      rule.decls
      |> Enum.flat_map(fn
        {:include, _} -> []
        {:raw, _} -> []
        {prop, _} when prop in [:background_color, :color, :border_inline_start, :padding_inline, :padding_inline_start, :gap] ->
          sx_property_lines(prop)

        {prop, _val} -> sx_property_lines(prop)
      end)
      |> Enum.uniq()
      |> Enum.map(&("    " <> &1))
      |> Enum.join("\n")

    if decl_lines == "" do
      []
    else
      ["""
        #{target_selector} {
      #{decl_lines}
        }
      """]
    end
  end

  defp utility_target_selector(selector) do
    selector
    |> String.replace(~r/\.[a-z0-9-]+\.[a-z0-9-]+--(?:text-|rounded-)?[^ ]+ /, "")
    |> String.trim()
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

  defp slot_entry_key?(:host), do: true

  defp slot_entry_key?(key) when is_atom(key) do
    name = Atom.to_string(key)

    Regex.match?(
      ~r/^(item|branch|control|root|label|trigger|indicator|content|error|input|icon)/,
      name
    )
  end

  defp slot_entry_key?(_), do: false

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
  defp sx_property_lines(:line_height), do: ["line-height: --value(--text-*--line-height, [length]);"]
  defp sx_property_lines(:padding_inline), do: ["padding-inline: --value(--spacing-space-*, [length]);"]
  defp sx_property_lines(:padding), do: ["padding: --value(--spacing-space-*, [length]);"]
  defp sx_property_lines(:gap), do: ["gap: --value(--spacing-space-*, [length]);"]
  defp sx_property_lines(:min_height), do: ["min-height: --value(--spacing-size-*, [length]);"]
  defp sx_property_lines(:margin_bottom), do: ["margin-bottom: --value(--spacing-space-*, [length]);"]
  defp sx_property_lines(:border_radius), do: ["border-radius: --value(--radius-*, [length]);"]
  defp sx_property_lines(:color), do: ["color: --value(--color-ui-ink-*, [color]);"]
  defp sx_property_lines(:background_color), do: ["background-color: --value(--color-*, [color]);"]
  defp sx_property_lines(:max_width), do: ["max-width: --value(--container-*, [length]);"]
  defp sx_property_lines(:padding_inline_start), do: ["padding-inline-start: --value(--spacing-space-*, [length]);"]
  defp sx_property_lines(:border_inline_start), do: ["border-inline-start: 1px solid --value(--color-*-ink, [color]);"]
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
