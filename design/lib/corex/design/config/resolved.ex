defmodule Corex.Design.Config.Resolved do
  @moduledoc false

  alias Corex.Design.ThemeDefinition.Resolved, as: ThemeResolved

  def normalize(config) when is_list(config), do: resolved_options(config)
  def normalize(config) when is_map(config), do: resolved_options(config)

  def resolved_options(config \\ Corex.Design.design_config()) do
    config = normalize_input(config)

    case Map.get(config, :theme) do
      module when is_atom(module) and module != nil ->
        if theme_module_ready?(module) do
          module
          |> ThemeResolved.to_flat_config()
          |> ThemeResolved.to_options_keyword()
        else
          flatten_options(config)
        end

      _ ->
        flatten_options(config)
    end
  end

  def theme_module_ready?(module) when is_atom(module) and module != nil do
    Code.ensure_loaded?(module) and
      function_exported?(module, :output, 0) and
      function_exported?(module, :scales, 0) and
      function_exported?(module, :themes, 0)
  end

  defp normalize_input(list) when is_list(list), do: Map.new(list)
  defp normalize_input(map) when is_map(map), do: map

  defp flatten_options(config) do
    [
      output: Map.get(config, :output),
      default_theme: Map.get(config, :default_theme, :neo),
      default_mode: Map.get(config, :default_mode, :light),
      themes: Map.get(config, :themes),
      scales: normalize_scales(Map.get(config, :scales, [])),
      components: Map.get(config, :components),
      semantics: Map.get(config, :semantics)
    ]
  end

  defp normalize_scales(list) when is_list(list), do: list
  defp normalize_scales(map) when is_map(map), do: Map.to_list(map)
  defp normalize_scales(_), do: []
end
