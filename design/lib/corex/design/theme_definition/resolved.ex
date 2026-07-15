defmodule Corex.Design.ThemeDefinition.Resolved do
  @moduledoc false

  def to_flat_config(module) when is_atom(module) and module != nil do
    :code.ensure_loaded(module)

    unless Corex.Design.Config.Resolved.theme_module_ready?(module) do
      raise ArgumentError, "#{inspect(module)} must use Corex.Design.ThemeDefinition"
    end

    scales = module.scales()
    themes = normalize_themes(module.themes())

    %{
      output: module.output(),
      default_theme: module.default_theme(),
      default_mode: module.default_mode(),
      scales: scales,
      themes: themes
    }
  end

  def to_options_keyword(flat) do
    [
      output: flat.output,
      default_theme: flat.default_theme,
      default_mode: flat.default_mode,
      themes: flat.themes,
      scales: flat.scales
    ]
  end

  defp normalize_themes(nil), do: nil

  defp normalize_themes(themes) when is_list(themes) do
    if Keyword.keyword?(themes) do
      themes
      |> Enum.map(fn {id, spec} -> {id, normalize_theme_spec(spec)} end)
      |> Map.new()
    else
      themes
    end
  end

  defp normalize_themes(themes) when is_map(themes), do: themes

  defp normalize_theme_spec(spec) when is_map(spec) do
    %{
      colors: Map.fetch!(spec, :colors),
      dimensions: normalize_dimensions(Map.fetch!(spec, :dimensions)),
      palette: Map.get(spec, :palette, %{}),
      typography: Map.get(spec, :typography)
    }
  end

  defp normalize_dimensions(dims) when is_map(dims) do
    base = %{
      space_scale: Map.get(dims, :space_scale, Map.get(dims, :density, 1.0)),
      size_scale: Map.get(dims, :size_scale, Map.get(dims, :size, 1.0)),
      text_scale: Map.get(dims, :text_scale, 1.0),
      radius_scale: Map.get(dims, :radius_scale, 1.0),
      container_scale: Map.get(dims, :container_scale, 1.0),
      radius: Map.get(dims, :radius, %{})
    }

    case Map.get(dims, :font) do
      nil -> base
      font -> Map.put(base, :font, font)
    end
  end
end
