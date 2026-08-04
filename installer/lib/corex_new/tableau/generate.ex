defmodule Corex.New.Tableau.Generate do
  @moduledoc false

  alias Corex.New.Patches
  alias Corex.New.Shared
  alias Corex.New.Tableau.Templates

  def run(install_dir, opts) do
    opts = normalize_opts(opts)
    assigns = template_assigns(install_dir, opts)

    remove_tableau_scaffold!(install_dir)
    write_layouts(install_dir, opts, assigns)
    write_pages(install_dir, opts, assigns)
    write_support_modules(install_dir, opts, assigns)
    write_gen_post_task(install_dir, assigns)
    write_assets(install_dir, opts, assigns)
    write_config(install_dir, assigns)
    write_mix_exs(install_dir, assigns)
    write_sample_post(install_dir, assigns)
    write_extra_dir(install_dir)
    write_formatter(install_dir)

    if opts[:lang] do
      copy_gettext_catalog(install_dir)
    end

    Patches.patch_gitignore(install_dir, opts)
    Patches.write_cursor_mcp_json!(install_dir, Keyword.put(opts, :mcp_port, 4004))

    :ok
  end

  defp remove_tableau_scaffold!(install_dir) do
    Enum.each(["lib/layouts", "lib/pages"], fn rel ->
      remove_scaffold_dir(Path.join(install_dir, rel))
    end)

    :ok
  end

  defp remove_scaffold_dir(path) do
    if File.exists?(path), do: File.rm_rf!(path), else: []
  end

  defp write_gen_post_task(install_dir, assigns) do
    write!(
      Path.join([install_dir, "lib", "mix", "tasks", "post.ex"]),
      Templates.gen_post_task(assigns)
    )
  end

  defp normalize_opts(opts) do
    opts
    |> Shared.put_theme_opts()
    |> Keyword.put_new(:mode, false)
    |> Keyword.put_new(:theme, false)
    |> Keyword.put_new(:a11y, false)
    |> Keyword.put_new(:lang, false)
    |> Keyword.put_new(:mcp, true)
    |> Keyword.put_new(:usage_rules, true)
    |> Keyword.put_new(:design, true)
  end

  defp write_layouts(install_dir, opts, assigns) do
    app_dir = app_lib_dir(install_dir, opts)

    write!(
      Path.join([app_dir, "layouts", "root_layout.ex"]),
      Templates.root_layout(assigns)
    )

    write!(
      Path.join([app_dir, "layouts", "post_layout.ex"]),
      Templates.post_layout(assigns)
    )

    unless opts[:lang] do
      write!(
        Path.join([app_dir, "layouts", "tag_layout.ex"]),
        Templates.tag_layout(assigns)
      )
    end

    write!(
      Path.join([app_dir, "layouts", "shell.ex"]),
      Templates.shell(assigns)
    )
  end

  defp write_pages(install_dir, opts, assigns) do
    app_dir = app_lib_dir(install_dir, opts)

    write!(
      Path.join([app_dir, "pages", "home_page.ex"]),
      Templates.home_page(assigns)
    )

    write!(
      Path.join([app_dir, "pages", "blog_index_page.ex"]),
      Templates.blog_index_page(assigns)
    )

    unless opts[:lang] do
      write!(
        Path.join([app_dir, "pages", "tags_index_page.ex"]),
        Templates.tags_index_page(assigns)
      )
    end

    if opts[:lang] do
      write!(
        Path.join([app_dir, "pages", "root_index_page.ex"]),
        Templates.root_index_page(assigns)
      )
    end

    write!(
      Path.join([app_dir, "pages", "not_found_page.ex"]),
      Templates.not_found_page(assigns)
    )
  end

  defp write_support_modules(install_dir, opts, assigns) do
    app_dir = app_lib_dir(install_dir, opts)

    write!(Path.join(app_dir, "config.ex"), Templates.config_module(assigns))
    write!(Path.join(app_dir, "application.ex"), Templates.application_module(assigns))
    write!(Path.join(app_dir, "md_ex_converter.ex"), Templates.md_ex_converter(assigns))

    write!(
      Path.join([app_dir, "markdown", "code_blocks.ex"]),
      Templates.code_blocks(assigns)
    )

    write!(
      Path.join([app_dir, "markdown", "block_renderer.ex"]),
      Templates.block_renderer(assigns)
    )

    if opts[:mcp] do
      write!(Path.join(app_dir, "mcp.ex"), Templates.mcp_module(assigns))
    end

    if opts[:theme] do
      write!(Path.join(app_dir, "theme.ex"), Templates.theme_module(assigns))
    end

    if opts[:mode] do
      write!(Path.join(app_dir, "mode.ex"), Templates.mode_module(assigns))
    end

    if opts[:a11y] do
      write!(Path.join(app_dir, "accessibility.ex"), Templates.accessibility_module(assigns))
    end

    if opts[:lang] do
      write!(Path.join(app_dir, "gettext.ex"), Templates.gettext_module(assigns))
      write!(Path.join(app_dir, "gettext_sigil.ex"), Templates.gettext_sigil_module(assigns))
      write!(Path.join(app_dir, "locale.ex"), Templates.locale_module(assigns))
    end
  end

  defp write_assets(install_dir, opts, assigns) do
    write!(
      Path.join([install_dir, "assets", "css", "site.css"]),
      Templates.site_css(assigns)
    )

    blog_css_src =
      Path.join([
        Path.expand("../../../templates/corex_tableau/assets/css", __DIR__),
        "blog.css"
      ])

    write!(
      Path.join([install_dir, "assets", "css", "blog.css"]),
      File.read!(blog_css_src)
    )

    prose_css_src =
      Path.join([
        Path.expand("../../../templates/corex_tableau/assets/css", __DIR__),
        "prose.css"
      ])

    write!(
      Path.join([install_dir, "assets", "css", "prose.css"]),
      File.read!(prose_css_src)
    )

    unless opts[:design] do
      Shared.copy_corex_export!(install_dir)
    end

    write!(
      Path.join([install_dir, "assets", "js", "site.js"]),
      Templates.site_js(assigns)
    )

    if opts[:lang] do
      locale_js_src =
        Path.join([
          Path.expand("../../../templates/corex_tableau/assets/js", __DIR__),
          "locale.js"
        ])

      write!(
        Path.join([install_dir, "assets", "js", "locale.js"]),
        File.read!(locale_js_src)
      )
    end

    heroicons_src =
      Path.join([
        Path.expand("../../../templates/corex_tableau/assets/vendor", __DIR__),
        "heroicons.js"
      ])

    write!(
      Path.join([install_dir, "assets", "vendor", "heroicons.js"]),
      File.read!(heroicons_src)
    )
  end

  defp copy_gettext_catalog(install_dir), do: Shared.copy_gettext_catalog!(install_dir)

  defp write_config(install_dir, assigns) do
    write!(Path.join([install_dir, "config", "config.exs"]), Templates.config_exs(assigns))
    write!(Path.join([install_dir, "config", "dev.exs"]), Templates.dev_exs(assigns))
    write!(Path.join([install_dir, "config", "prod.exs"]), Templates.prod_exs(assigns))
    write!(Path.join([install_dir, "config", "test.exs"]), Templates.test_exs(assigns))
  end

  defp write_mix_exs(install_dir, assigns) do
    write!(Path.join(install_dir, "mix.exs"), Templates.mix_exs(assigns))
  end

  defp write_sample_post(install_dir, assigns) do
    if Keyword.get(assigns, :lang) do
      Enum.each([{"en", ""}, {"fr", "-fr"}, {"ar", "-ar"}], fn {locale, suffix} ->
        write!(
          Path.join([install_dir, "_posts", "2026-01-01-welcome#{suffix}.md"]),
          Templates.sample_post(Keyword.put(assigns, :locale, locale))
        )
      end)
    else
      write!(
        Path.join([install_dir, "_posts", "2026-01-01-welcome.md"]),
        Templates.sample_post(assigns)
      )
    end

    :ok
  end

  defp write_extra_dir(install_dir) do
    File.mkdir_p!(Path.join(install_dir, "extra"))
  end

  defp write_formatter(install_dir) do
    path = Path.join(install_dir, ".formatter.exs")

    unless File.exists?(path) do
      write!(path, """
      [
        import_deps: [:phoenix],
        plugins: [Phoenix.LiveView.HTMLFormatter],
        inputs: ["*.{heex,ex,exs}", "{config,lib,test}/**/*.{heex,ex,exs}"]
      ]
      """)
    end
  end

  defp template_assigns(install_dir, opts) do
    components = installer_components(opts)

    [
      app_module: inspect(opts[:app_module]),
      otp_app: opts[:otp_app],
      mode: !!opts[:mode],
      theme: !!opts[:theme],
      a11y: !!opts[:a11y],
      lang: !!opts[:lang],
      mcp: Keyword.get(opts, :mcp, true),
      usage_rules: Keyword.get(opts, :usage_rules, true),
      design: !!opts[:design],
      themes: opts[:themes],
      default_theme: opts[:default_theme],
      components: components,
      corex_js_import: corex_js_import(install_dir, opts),
      corex_dep_source: corex_dep_source(opts),
      corex_design_dep_source: corex_design_dep_source(opts),
      corex_mcp_dep_source: corex_mcp_dep_source(opts)
    ]
  end

  defp installer_components(opts) do
    Corex.New.Components.installer_components(opts)
  end

  defp corex_js_import(install_dir, opts) do
    Shared.corex_js_import(install_dir, opts, "corex.tableau.new")
  end

  defp corex_dep_source(opts), do: Shared.corex_dep_source(opts)
  defp corex_design_dep_source(opts), do: Shared.corex_design_dep_source(opts)
  defp corex_mcp_dep_source(opts), do: Shared.corex_mcp_dep_source(opts)

  defp app_lib_dir(install_dir, opts) do
    Path.join([install_dir, "lib", Atom.to_string(opts[:otp_app])])
  end

  defp write!(path, contents), do: Shared.write!(path, contents)
end
