defmodule Corex.Design.DumpConfig do
  @moduledoc false

  alias Corex.Design.Config
  alias Corex.Design.Theme
  alias Corex.Design.Tokens.Colors
  alias Corex.Design.Tokens.Scales
  alias Corex.Design.Vocabulary

  def export do
    %{
      config: sanitize(Corex.Design.design_config()),
      resolved: sanitize(Map.new(Config.resolved_options())),
      vocabulary: %{
        semantic_roles: Vocabulary.semantic_strings(),
        scales: scale_export()
      },
      themes: theme_export(),
      colors: color_export()
    }
  end

  defp theme_export do
    Theme.resolved_themes()
    |> Map.new(fn {id, spec} ->
      {Atom.to_string(id), sanitize(spec)}
    end)
  end

  defp color_export do
    Colors.generate()
    |> Map.new(fn {{theme, mode}, tokens} ->
      {"#{theme}-#{mode}", tokens}
    end)
  end

  defp scale_export do
    %{
      space: Scales.space_steps(),
      size: Scales.size_steps(),
      text: Scales.text_steps(),
      radius: Scales.radius_steps(),
      weight: Scales.weight_steps(),
      visual: Scales.visual_steps(),
      shape: Scales.shape_steps()
    }
  end

  defp sanitize(term), do: Jason.decode!(Jason.encode!(term))
end
