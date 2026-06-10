defmodule Corex.Design.Config.Resolved do
  @moduledoc false

  def normalize(config) when is_list(config) do
    flatten_options(Map.new(config))
  end

  def resolved_options(config \\ Corex.Design.design_config()) do
    normalize(config)
  end

  defp flatten_options(config) do
    recipes = keyword_or_empty(config, :recipes)

    [
      default_theme: Map.get(config, :default_theme, :neo),
      default_mode: Map.get(config, :default_mode, :light),
      themes: Map.get(config, :themes),
      scales: normalize_scales(Map.get(config, :scales, [])),
      include_recipes: Keyword.get(recipes, :include),
      recipes: Keyword.get(recipes, :sources, []),
      role_aliases: Map.get(config, :aliases, %{})
    ]
  end

  defp normalize_scales(list) when is_list(list), do: list
  defp normalize_scales(map) when is_map(map), do: Map.to_list(map)
  defp normalize_scales(_), do: []

  defp keyword_or_empty(map, key) do
    case Map.get(map, key) do
      list when is_list(list) -> list
      _ -> []
    end
  end
end
