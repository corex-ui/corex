defmodule Corex.New.Templates do
  @moduledoc false

  require EEx

  templates_root = Path.expand("../../templates", __DIR__)

  @templates [
    layouts_ex: "corex/lib/app_web/components/layouts.ex.eex",
    root_heex: "corex/lib/app_web/components/layouts/root.html.heex.eex",
    home_heex: "corex/lib/app_web/controllers/page_html/home.html.heex.eex",
    plug_mode: "corex/lib/app_web/plugs/mode.ex.eex",
    plug_theme: "corex/lib/app_web/plugs/theme.ex.eex",
    hooks_layout: "corex/lib/app_web/hooks/layout.ex.eex",
    locale_ex: "corex/lib/app_web/locale.ex.eex",
    app_js: "corex/assets/js/app.js.eex",
    app_css: "corex/assets/css/app.css.eex"
  ]

  for {name, rel_path} <- @templates do
    abs = Path.join(templates_root, rel_path)
    @external_resource abs
    EEx.function_from_file(:def, name, abs, [:assigns])
  end

  @doc """
  Returns the list of template names available on this module.
  """
  def list_templates, do: Keyword.keys(@templates)
end
