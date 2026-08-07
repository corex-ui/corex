defmodule Corex.Design.Emit.Semantic do
  @moduledoc false

  alias Corex.Design.Emit.Css
  alias Corex.Design.Filter
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
    Filter.semantic_strings() |> MapSet.new()
  end

  defp role_allowed_for_bridge?(role, allowed) do
    cond do
      role in Filter.structural_bridge_strings() ->
        true

      true ->
        case Enum.find(Filter.derived_suffixes(), &String.ends_with?(role, &1)) do
          nil -> MapSet.member?(allowed, role)
          suffix -> MapSet.member?(allowed, String.replace_suffix(role, suffix, ""))
        end
    end
  end

  @doc false
  def write_color_bridge!(output_root) do
    decls = Enum.map(color_roles(), &identity("color-#{&1}"))

    write_bridge!(output_root, "color.css", decls)
  end

  @doc false
  def write_border_bridge!(output_root) do
    static = [
      Css.declaration("radius-none", "0px"),
      Css.declaration("radius-full", "9999px"),
      identity("border-width"),
      identity("ring-width"),
      identity("ring-offset")
    ]

    themed =
      Scales.steps(:radius)
      |> Enum.reject(&(&1 in ~w(none full)))
      |> Enum.map(&identity("radius-#{&1}"))

    write_bridge!(output_root, "border.css", static ++ themed)
  end

  @doc false
  def write_dimension_bridge!(output_root) do
    steps = ~w(sm md lg xl)

    decls =
      Naming.breakpoint_theme_decls() ++
        [identity("spacing")] ++
        container_bridge_decls() ++
        Enum.map(steps, &identity("spacing-space-#{&1}")) ++
        Enum.map(steps, &identity("spacing-size-#{&1}")) ++
        [
          Css.forward("spacing-space", "spacing-space-md"),
          Css.forward("spacing-size", "spacing-size-md")
        ]

    write_bridge!(output_root, "dimension.css", decls)
  end

  @doc false
  def write_font_bridge!(output_root) do
    families = Enum.map(~w(sans serif mono code display), &identity("font-#{&1}"))

    weights =
      Enum.map(
        ~w(thin extralight light normal medium semibold bold extrabold black),
        &identity("font-weight-#{&1}")
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
          identity("text-#{step}"),
          identity("text-#{step}--line-height")
        ]
      end)

    display = [
      Css.forward("text-display-sm", "text-4xl"),
      Css.forward("text-display-sm--line-height", "text-4xl--line-height")
    ]

    leadings = identity_steps(TokenScales.leading(), "leading")
    trackings = identity_steps(TokenScales.tracking(), "tracking")

    path = Path.join([output_root, "tokens", "semantic", "text.css"])

    Write.atomic!(
      path,
      Css.document([
        Css.theme(sizes ++ display),
        Css.theme_inline(leadings ++ trackings)
      ])
    )
  end

  @doc false
  def write_effect_bridge!(output_root) do
    decls =
      identity_steps(TokenScales.shadow(), "shadow") ++
        identity_steps(TokenScales.inset_shadow(), "inset-shadow") ++
        identity_steps(TokenScales.drop_shadow(), "drop-shadow") ++
        identity_steps(TokenScales.text_shadow(), "text-shadow") ++
        identity_steps(TokenScales.blur(), "blur") ++
        [
          identity("duration-fast"),
          identity("duration-normal"),
          identity("duration-slow"),
          identity("opacity-disabled"),
          identity("opacity-backdrop")
        ]

    write_bridge!(output_root, "effect.css", decls)
  end

  defp write_bridge!(output_root, file, declarations) do
    path = Path.join([output_root, "tokens", "semantic", file])

    Write.atomic!(path, Css.document([Css.theme_inline(declarations)]))
  end

  defp identity(name), do: Css.forward(name, name)

  defp identity_steps(scale, prefix) do
    Enum.map(scale, fn {step, _value} ->
      identity("#{prefix}-#{dash(step)}")
    end)
  end

  defp container_bridge_decls do
    Enum.map(Scales.master_ladder_strings(), &identity("container-#{&1}"))
  end

  defp text_token_step(step), do: Naming.text_token_step(step)

  defp dash(value), do: Naming.dash(value)
end
