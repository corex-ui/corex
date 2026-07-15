defmodule Corex.New.Tableau.Templates do
  @moduledoc false

  require EEx

  templates_root = Path.expand("../../../templates", __DIR__)

  @templates [
    root_layout: "corex_tableau/lib/app/layouts/root_layout.ex.eex",
    post_layout: "corex_tableau/lib/app/layouts/post_layout.ex.eex",
    home_page: "corex_tableau/lib/app/pages/home_page.ex.eex",
    blog_index_page: "corex_tableau/lib/app/pages/blog_index_page.ex.eex",
    root_index_page: "corex_tableau/lib/app/pages/root_index_page.ex.eex",
    not_found_page: "corex_tableau/lib/app/pages/not_found_page.ex.eex",
    config_module: "corex_tableau/lib/app/config.ex.eex",
    application_module: "corex_tableau/lib/app/application.ex.eex",
    mcp_module: "corex_tableau/lib/app/mcp.ex.eex",
    md_ex_converter: "corex_tableau/lib/app/md_ex_converter.ex.eex",
    theme_module: "corex_tableau/lib/app/theme.ex.eex",
    mode_module: "corex_tableau/lib/app/mode.ex.eex",
    gettext_module: "corex_tableau/lib/app/gettext.ex.eex",
    gettext_sigil_module: "corex_tableau/lib/app/gettext_sigil.ex.eex",
    locale_module: "corex_tableau/lib/app/locale.ex.eex",
    site_css: "corex_tableau/assets/css/site.css.eex",
    site_js: "corex_tableau/assets/js/site.js.eex",
    config_exs: "corex_tableau/config/config.exs.eex",
    dev_exs: "corex_tableau/config/dev.exs.eex",
    prod_exs: "corex_tableau/config/prod.exs.eex",
    test_exs: "corex_tableau/config/test.exs.eex",
    mix_exs: "corex_tableau/mix.exs.eex",
    sample_post: "corex_tableau/_posts/sample_post.md.eex",
    gen_post_task: "corex_tableau/lib/mix/tasks/post.ex.eex"
  ]

  for {name, rel_path} <- @templates do
    abs = Path.join(templates_root, rel_path)
    @external_resource abs
    EEx.function_from_file(:def, name, abs, [:assigns])
  end

  def list_templates, do: Keyword.keys(@templates)
end
