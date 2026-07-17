defmodule Corex.MCP.DesignAvailable do
  @moduledoc false

  @layout :"Elixir.Corex.Design.ComponentLayout"
  @axes :"Elixir.Corex.Design.Axes"
  @filter :"Elixir.Corex.Design.Filter"
  @theme :"Elixir.Corex.Design.Theme"
  @theme_options :"Elixir.Corex.Design.Theme.Options"

  def design_available? do
    match?({:module, _}, Code.ensure_loaded(@layout)) and
      match?({:module, _}, Code.ensure_loaded(@axes))
  end

  def ensure_design do
    if design_available?() do
      :ok
    else
      {:error,
       "corex_design is not loaded. Add {:corex_design, \"~> 0.2\", runtime: false, only: :dev} to mix.exs."}
    end
  end

  def layout_ids, do: apply(@layout, :ids, [])
  def layout_get(id), do: apply(@layout, :get, [id])
  def layout_host_selector(id), do: apply(@layout, :host_selector, [id])
  def layout_host_width_label(id), do: apply(@layout, :host_width_label, [id])
  def layout_default_max_label(id), do: apply(@layout, :default_max_label, [id])
  def layout_css_path(id), do: apply(@layout, :css_path, [id])

  def default_semantics, do: apply(@filter, :default_semantics, [])
  def sizes, do: apply(@axes, :sizes, [])
  def radii, do: apply(@axes, :radii, [])

  def theme_modes, do: apply(@theme, :modes, [])
  def default_theme, do: apply(@theme, :default_theme, [])
  def default_mode, do: apply(@theme, :default_mode, [])

  def preset_ids do
    if function_exported?(@theme_options, :preset_ids, 0) do
      apply(@theme_options, :preset_ids, [])
    else
      ~w(neo uno duo leo)a
    end
  end
end
