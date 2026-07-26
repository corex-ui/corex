defmodule Corex.Design.Emit.Semantic do
  @moduledoc false

  alias Corex.Design.Emit.Css
  alias Corex.Design.Scales
  alias Corex.Design.Tokens.Colors
  alias Corex.Design.Tokens.Naming
  alias Corex.Design.Tokens.Scales, as: TokenScales
  alias Corex.Design.Write

  @doc false
  def color_roles do
    allowed = semantic_role_set()

    Colors.generate()
    |> Map.values()
    |> Enum.flat_map(&Map.keys/1)
    |> Enum.filter(fn role ->
      role_allowed_for_bridge?(role, allowed)
    end)
    |> Enum.uniq()
    |> Enum.sort()
  end

  defp semantic_role_set do
    Corex.Design.Filter.semantic_strings() |> MapSet.new()
  end

  @structural_roles ~w(root layer ink ink-muted link border focus shadow ui ui-hover ui-active ui-muted)

  @derived_suffixes ~w(-text -contrast)

  defp role_allowed_for_bridge?(role, _allowed) when role in @structural_roles, do: true

  defp role_allowed_for_bridge?(role, allowed) do
    case Enum.find(@derived_suffixes, &String.ends_with?(role, &1)) do
      nil -> MapSet.member?(allowed, role) or String.starts_with?(role, "surface-")
      suffix -> MapSet.member?(allowed, String.replace_suffix(role, suffix, ""))
    end
  end

  @doc false
  def write_color_bridge!(output_root) do
    decls = Enum.map(color_roles(), &Css.forward("color-#{&1}", "color-#{&1}"))

    write_bridge!(output_root, "color.css", decls)
  end

  @doc false
  def write_border_bridge!(output_root) do
    static = [
      Css.declaration("radius-none", "0px"),
      Css.declaration("radius-full", "9999px")
    ]

    themed =
      Scales.steps(:radius)
      |> Enum.reject(&(&1 in ~w(none full)))
      |> Enum.map(&Css.forward("radius-#{&1}", "theme-radius-#{&1}"))

    write_bridge!(output_root, "border.css", static ++ themed)
  end

  @doc false
  def write_dimension_bridge!(output_root) do
    steps = ~w(sm md lg xl)

    decls =
      Naming.breakpoint_theme_decls() ++
        [Css.forward("spacing", "theme-spacing")] ++
        container_bridge_decls() ++
        Enum.map(steps, &Css.forward("spacing-space-#{&1}", "theme-spacing-space-#{&1}")) ++
        Enum.map(steps, &Css.forward("spacing-size-#{&1}", "theme-spacing-size-#{&1}")) ++
        [
          Css.forward("spacing-space", "spacing-space-md"),
          Css.forward("spacing-size", "spacing-size-md")
        ]

    write_bridge!(output_root, "dimension.css", decls)
  end

  @doc false
  def write_font_bridge!(output_root) do
    families =
      Enum.map(~w(sans serif mono code display), &Css.forward("font-#{&1}", "theme-font-#{&1}"))

    weights =
      Enum.map(
        ~w(thin extralight light normal medium semibold bold extrabold black),
        &Css.forward("font-weight-#{&1}", "theme-font-weight-#{&1}")
      )

    write_bridge!(output_root, "font.css", families ++ weights)
  end

  @doc false
  def write_text_bridge!(output_root) do
    size_steps =
      TokenScales.text()
      |> Enum.map(fn {step, _} -> text_token_step(step) end)
      |> Enum.uniq()

    sizes =
      Enum.flat_map(size_steps, fn step ->
        [
          Css.forward("text-#{step}", "theme-text-#{step}"),
          Css.forward("text-#{step}--line-height", "theme-text-#{step}--line-height")
        ]
      end)

    display = [
      Css.forward("text-display-sm", "theme-text-4xl"),
      Css.forward("text-display-sm--line-height", "theme-text-4xl--line-height")
    ]

    leadings = forward_steps(TokenScales.leading(), "leading", "theme-text-leading")
    trackings = forward_steps(TokenScales.tracking(), "tracking", "theme-text-tracking")

    write_bridge!(output_root, "text.css", sizes ++ display ++ leadings ++ trackings)
  end

  @doc false
  def write_effect_bridge!(output_root) do
    decls =
      forward_steps(TokenScales.shadow(), "shadow", "theme-shadow") ++
        forward_steps(TokenScales.inset_shadow(), "inset-shadow", "theme-inset-shadow") ++
        forward_steps(TokenScales.drop_shadow(), "drop-shadow", "theme-drop-shadow") ++
        forward_steps(TokenScales.text_shadow(), "text-shadow", "theme-text-shadow") ++
        forward_steps(TokenScales.blur(), "blur", "theme-blur")

    write_bridge!(output_root, "effect.css", decls)
  end

  defp write_bridge!(output_root, file, declarations) do
    path = Path.join([output_root, "tokens", "semantic", file])

    Write.atomic!(path, Css.document([Css.theme_inline(declarations)]))
  end

  defp forward_steps(scale, prefix, target_prefix) do
    Enum.map(scale, fn {step, _value} ->
      Css.forward("#{prefix}-#{dash(step)}", "#{target_prefix}-#{dash(step)}")
    end)
  end

  defp container_bridge_decls do
    Enum.map(
      Scales.master_ladder_strings(),
      &Css.forward("container-#{&1}", "theme-container-#{&1}")
    )
  end

  @doc false
  def remove_legacy_color_scope!(output_root) do
    path = Path.join([output_root, "tokens", "semantic", "color-scope.css"])

    if File.exists?(path) do
      File.rm!(path)
    end

    :ok
  end

  defp text_token_step(step), do: Naming.text_token_step(step)

  defp dash(value), do: Naming.dash(value)
end
