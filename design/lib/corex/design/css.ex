defmodule Corex.Design.Css do
  @moduledoc false

  alias Corex.Design.Css.Properties
  alias Corex.Design.Css.Values
  alias Corex.Design.Emit.Tokens, as: Var
  alias Corex.Design.Palette
  alias Corex.Design.RoleAliases
  alias Corex.Design.Tokens.Scales

  @scale_kinds ~W(space size container text leading weight tracking radius shadow font color)a
  @color_keywords ~W(transparent currentcolor inherit initial unset)a
  @layout_keywords ~W(auto min-content max-content fit-content inherit initial unset none)a

  def resolve(property, value, context \\ []) do
    prop = Properties.normalize(property)
    validate_property!(prop, context)
    resolve_value(prop, Properties.kind(prop), value, context)
  end

  def resolve_property_value({property, value}, context \\ []) do
    prop = Properties.normalize(property)
    {semantic_css_name(prop), resolve(prop, value, context)}
  end

  defp semantic_css_name(:ring), do: "box-shadow"
  defp semantic_css_name(prop), do: Properties.css_name(prop)

  def resolve_value(value, context \\ []) do
    case resolve_tagged(value, context) do
      {:ok, resolved} -> resolved
      :error -> resolve_scalar(value)
    end
  end

  defp resolve_scalar(value) when is_binary(value), do: value
  defp resolve_scalar(value) when is_number(value), do: to_string(value)
  defp resolve_scalar(value) when is_atom(value), do: Atom.to_string(value)

  def validate_property!(property, context \\ []) do
    unless Properties.supported?(property) do
      raise ArgumentError, error_message(context, "unknown property #{inspect(property)}")
    end
  end

  defp resolve_value(_prop, :custom, value, ctx) do
    resolve_custom_value(value, ctx)
  end

  defp resolve_value(prop, :semantic, value, ctx) do
    resolve_semantic(prop, value, ctx)
  end

  defp resolve_value(_prop, :enum, {:raw, literal}, _ctx), do: to_string(literal)

  defp resolve_value(prop, :enum, value, _ctx) do
    Values.validate_enum!(prop, value)
  end

  defp resolve_value(prop, kind, value, ctx) do
    resolve_typed(kind, value, prop, ctx)
  end

  defp resolve_semantic(:ring, value, _ctx) when is_integer(value) do
    width = Integer.to_string(value)
    "inset 0 0 0 #{width}px var(--color-focus)"
  end

  defp resolve_semantic(:ring, value, ctx) when is_binary(value) do
    resolve_semantic(:ring, String.to_integer(value), ctx)
  end

  defp resolve_typed(kind, value, prop, ctx) do
    case resolve_tagged(value, ctx) do
      {:ok, resolved} -> resolved
      :error -> resolve_untagged(kind, value, prop, ctx)
    end
  end

  defp resolve_tagged({:raw, literal}, _ctx), do: {:ok, to_string(literal)}

  defp resolve_tagged({:color, name}, _ctx),
    do: {:ok, Var.ref([:color, RoleAliases.resolve(name)])}

  defp resolve_tagged({kind, step}, ctx) when kind in @scale_kinds do
    validate_step!(kind, step, ctx)
    {:ok, ref_for(kind, step)}
  end

  defp resolve_tagged(_value, _ctx), do: :error

  defp resolve_untagged(_kind, value, _prop, _ctx) when is_binary(value), do: value

  defp resolve_untagged(_kind, value, _prop, _ctx) when is_number(value), do: to_string(value)

  defp resolve_untagged(:color, value, _prop, _ctx) when value in @color_keywords,
    do: Atom.to_string(value)

  defp resolve_untagged(_kind, value, _prop, _ctx) when value in @layout_keywords,
    do: Atom.to_string(value)

  defp resolve_untagged(kind, value, prop, ctx) when is_atom(value) do
    case kind do
      :enum ->
        Values.validate_enum!(prop, value)

      k
      when k in [
             :space,
             :size,
             :container,
             :text,
             :leading,
             :weight,
             :tracking,
             :radius,
             :shadow,
             :font,
             :color
           ] ->
        validate_step!(k, value, ctx)
        ref_for(k, value)

      :number ->
        to_string(value)

      :length ->
        Atom.to_string(value)

      :raw ->
        Atom.to_string(value) |> String.replace("_", "-")

      _ ->
        raise ArgumentError,
              error_message(ctx, "bare atom #{inspect(value)} not allowed for #{inspect(prop)}")
    end
  end

  defp resolve_custom_value(value, _ctx) do
    case value do
      {:color, name} -> Var.ref([:color, RoleAliases.resolve(name)])
      {:raw, lit} -> to_string(lit)
      {:space, s} -> ref_for(:space, s)
      {:size, s} -> ref_for(:size, s)
      {:radius, s} -> ref_for(:radius, s)
      {:text, s} -> ref_for(:text, s)
      other when is_binary(other) -> other
      other when is_number(other) -> to_string(other)
      other when is_atom(other) -> Atom.to_string(other)
    end
  end

  defp ref_for(:space, step), do: Var.ref([:space, step])
  defp ref_for(:size, step), do: Var.ref([:size, step])
  defp ref_for(:container, step), do: Var.ref([:container, step])
  defp ref_for(:text, step), do: Var.ref([:text, step])
  defp ref_for(:leading, step), do: Var.ref([:leading, step])
  defp ref_for(:weight, step), do: Var.ref([:"font-weight", step])
  defp ref_for(:tracking, step), do: Var.ref([:tracking, step])
  defp ref_for(:radius, step), do: Var.ref([:radius, step])
  defp ref_for(:shadow, step), do: Var.ref([:shadow, step])
  defp ref_for(:font, step), do: Var.ref([:font, step])
  defp ref_for(:color, step), do: Var.ref([:color, RoleAliases.resolve(step)])

  defp validate_step!(kind, step, ctx) do
    step = if kind == :color, do: RoleAliases.resolve(step), else: step
    steps = steps_for(kind)

    unless step in steps do
      raise ArgumentError,
            error_message(
              ctx,
              "unknown #{kind} step #{inspect(step)}; allowed: #{inspect(steps)}"
            )
    end
  end

  defp steps_for(:space), do: [:space | Keyword.keys(Scales.space_mult())]
  defp steps_for(:size), do: [:size | Keyword.keys(Scales.size_mult())]
  defp steps_for(:container), do: Keyword.keys(Scales.container())
  defp steps_for(:text), do: Keyword.keys(Scales.text())
  defp steps_for(:leading), do: Keyword.keys(Scales.leading())
  defp steps_for(:weight), do: Keyword.keys(Scales.weight())
  defp steps_for(:tracking), do: Keyword.keys(Scales.tracking())
  defp steps_for(:radius), do: Keyword.keys(Scales.radius())
  defp steps_for(:shadow), do: Keyword.keys(Scales.shadow())
  defp steps_for(:font), do: Keyword.keys(Scales.font())
  defp steps_for(:color), do: Palette.color_atoms()

  defp error_message(ctx, msg) do
    case ctx do
      [recipe: id, selector: sel] ->
        "Corex.Design.Css: #{msg} in recipe #{inspect(id)} at #{inspect(sel)}"

      [recipe: id] ->
        "Corex.Design.Css: #{msg} in recipe #{inspect(id)}"

      _ ->
        "Corex.Design.Css: #{msg}"
    end
  end
end

defmodule Corex.Design.Css.Properties do
  @moduledoc false

  @kinds %{
    display: :enum,
    position: :enum,
    top: :length,
    right: :length,
    bottom: :length,
    left: :length,
    inset: :length,
    inset_block: :length,
    inset_block_start: :length,
    inset_block_end: :length,
    inset_inline: :length,
    inset_inline_start: :length,
    inset_inline_end: :length,
    z_index: :number,
    flex_direction: :enum,
    flex_wrap: :enum,
    flex_flow: :raw,
    flex: :raw,
    flex_grow: :number,
    flex_shrink: :number,
    flex_basis: :raw,
    align_items: :enum,
    align_self: :enum,
    justify_content: :enum,
    justify_items: :enum,
    gap: :space,
    row_gap: :space,
    column_gap: :space,
    grid_template_columns: :raw,
    grid_template_rows: :raw,
    grid_auto_flow: :enum,
    grid_auto_columns: :raw,
    grid_row: :raw,
    width: :container,
    min_width: :container,
    max_width: :container,
    height: :size,
    min_height: :size,
    max_height: :size,
    margin: :space,
    margin_top: :space,
    margin_right: :space,
    margin_bottom: :space,
    margin_left: :space,
    margin_block: :space,
    margin_inline: :space,
    padding: :space,
    padding_top: :space,
    padding_right: :space,
    padding_bottom: :space,
    padding_left: :space,
    padding_block: :space,
    padding_inline: :space,
    padding_inline_start: :space,
    padding_inline_end: :space,
    margin_inline_start: :space,
    block_size: :raw,
    inline_size: :raw,
    border: :raw,
    border_width: :raw,
    border_style: :enum,
    border_color: :color,
    border_top: :raw,
    border_right: :raw,
    border_bottom: :raw,
    border_left: :raw,
    border_inline_start: :raw,
    border_radius: :radius,
    border_top_left_radius: :radius,
    border_top_right_radius: :radius,
    border_bottom_left_radius: :radius,
    border_bottom_right_radius: :radius,
    outline: :raw,
    outline_color: :color,
    outline_offset: :length,
    box_shadow: :shadow,
    background: :raw,
    background_color: :color,
    color: :color,
    fill: :color,
    stroke: :color,
    opacity: :number,
    font_family: :font,
    font_size: :text,
    font_weight: :weight,
    font_style: :enum,
    line_height: :leading,
    letter_spacing: :tracking,
    text_align: :enum,
    text_decoration_line: :enum,
    text_decoration_thickness: :raw,
    text_underline_offset: :raw,
    text_overflow: :enum,
    white_space: :enum,
    overflow: :enum,
    overflow_x: :enum,
    overflow_y: :enum,
    isolation: :enum,
    cursor: :enum,
    pointer_events: :enum,
    user_select: :enum,
    appearance: :enum,
    box_sizing: :enum,
    aspect_ratio: :raw,
    transform: :raw,
    transition: :raw,
    transition_property: :raw,
    transition_duration: :raw,
    animation: :raw,
    content: :raw,
    mask_image: :raw,
    mask_size: :raw,
    mask_repeat: :raw,
    mask_position: :raw,
    visibility: :enum,
    clip: :raw,
    list_style: :enum,
    vertical_align: :enum,
    ring: :semantic
  }

  @aliases %{
    bg: :background_color,
    radius: :border_radius
  }

  def kinds, do: @kinds

  def aliases, do: @aliases

  def normalize(prop) when is_atom(prop) do
    Map.get(@aliases, prop, prop)
  end

  def kind(prop) when is_atom(prop) do
    prop = normalize(prop)

    cond do
      custom_property?(prop) -> :custom
      Map.has_key?(@kinds, prop) -> Map.fetch!(@kinds, prop)
      true -> :raw
    end
  end

  def supported?(prop) when is_atom(prop) do
    prop = normalize(prop)
    custom_property?(prop) or Map.has_key?(@kinds, prop) or Map.has_key?(@aliases, prop)
  end

  def custom_property?(prop) when is_atom(prop) do
    prop
    |> Atom.to_string()
    |> String.starts_with?("--")
  end

  def css_name(prop) when is_atom(prop) do
    prop
    |> normalize()
    |> Atom.to_string()
    |> String.replace("_", "-")
  end
end

defmodule Corex.Design.Css.Values do
  @moduledoc false

  @enums %{
    display:
      ~W(none block inline inline-block flex inline-flex grid inline-grid contents table table-row table-cell),
    position: ~W(static relative absolute fixed sticky),
    text_align: ~W(left right center justify start end),
    overflow: ~W(visible hidden scroll auto clip),
    isolation: ~W(auto isolate),
    overflow_x: ~W(visible hidden scroll auto clip),
    overflow_y: ~W(visible hidden scroll auto clip),
    white_space: ~W(normal nowrap pre pre-wrap pre-line break-spaces),
    text_overflow: ~W(clip ellipsis),
    flex_direction: ~W(row row-reverse column column-reverse),
    flex_wrap: ~W(nowrap wrap wrap-reverse),
    align_items: ~W(flex-start flex-end center baseline stretch start end),
    align_self: ~W(auto flex-start flex-end center baseline stretch),
    justify_content:
      ~W(flex-start flex-end center space-between space-around space-evenly stretch start end),
    justify_items: ~W(start end center stretch),
    grid_auto_flow: ~W(row column dense row dense column),
    cursor: ~W(auto default pointer wait text move not-allowed grab grabbing),
    pointer_events: ~W(auto none),
    user_select: ~W(auto none text all),
    appearance: ~W(none auto),
    box_sizing: ~W(content-box border-box),
    visibility: ~W(visible hidden collapse),
    font_style: ~W(normal italic),
    text_decoration_line: ~W(none underline line-through overline),
    border_style: ~W(none solid dashed dotted double hidden),
    list_style: ~W(none disc decimal),
    vertical_align: ~W(baseline top middle bottom sub super)
  }

  def validate_enum!(property, value) when is_atom(value) do
    allowed = Map.fetch!(@enums, property)

    value =
      value
      |> Atom.to_string()
      |> String.replace("_", "-")

    unless value in allowed do
      raise ArgumentError,
            "invalid #{property} value #{inspect(value)}; allowed: #{inspect(allowed)}"
    end

    value
  end

  def validate_enum!(_property, value) when is_binary(value), do: value
  def validate_enum!(_property, value) when is_number(value), do: to_string(value)

  def enum_property?(property), do: Map.has_key?(@enums, property)
end
