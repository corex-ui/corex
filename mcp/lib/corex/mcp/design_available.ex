defmodule Corex.MCP.DesignAvailable do
  @moduledoc false

  @components :"Elixir.Corex.Design.Components"
  @scales :"Elixir.Corex.Design.Scales"
  @filter :"Elixir.Corex.Design.Filter"
  @theme :"Elixir.Corex.Design.Theme"
  @theme_options :"Elixir.Corex.Design.Theme.Validator"

  def design_available? do
    match?({:module, _}, Code.ensure_loaded(@components)) and
      match?({:module, _}, Code.ensure_loaded(@scales))
  end

  def ensure_design do
    if design_available?() do
      :ok
    else
      {:error,
       "corex_design is not loaded. Add {:corex_design, \"~> 0.2\", runtime: false} to mix.exs."}
    end
  end

  def component_ids, do: apply(@components, :ids, [])
  def component_get(id), do: apply(@components, :get!, [id])
  def host_selector(id), do: apply(@components, :host_selector, [id])
  def host_width(id), do: apply(@components, :host_width, [id])
  def default_max(id), do: apply(@components, :default_max, [id])
  def host_width_label(id), do: apply(@components, :host_width_label, [id])
  def default_max_label(id), do: apply(@components, :default_max_label, [id])
  def css_path(id), do: apply(@components, :css_path, [id])
  def axes_for(css_id) when is_binary(css_id), do: apply(@components, :axes_for, [css_id])
  def fetch_css_id(id) when is_binary(id), do: apply(@components, :fetch_css_id, [id])

  def default_semantics, do: apply(@filter, :default_semantics, [])
  def sizes, do: apply(@scales, :steps, [:size])
  def radii, do: apply(@scales, :steps, [:radius])
  def max_heights, do: apply(@scales, :steps, [:max_height])
  def widths, do: apply(@scales, :steps, [:width])

  def theme_modes, do: apply(@theme, :modes, [])
  def default_theme, do: apply(@theme, :default_theme, [])
  def default_mode, do: apply(@theme, :default_mode, [])
  def preset_ids, do: apply(@theme_options, :preset_ids, [])
end
