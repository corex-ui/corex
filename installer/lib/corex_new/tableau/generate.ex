defmodule Corex.New.Tableau.Generate do
  @moduledoc false

  alias Corex.New.Patches
  alias Corex.New.Tableau.Templates

  @default_themes ["neo", "uno", "duo", "leo"]

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

    :ok
  end

  defp remove_tableau_scaffold!(install_dir) do
    for rel <- ["lib/layouts", "lib/pages"] do
      path = Path.join(install_dir, rel)

      if File.exists?(path) do
        File.rm_rf!(path)
      end
    end
  end

  defp write_gen_post_task(install_dir, assigns) do
    write!(
      Path.join([install_dir, "lib", "mix", "tasks", "post.ex"]),
      Templates.gen_post_task(assigns)
    )
  end

  defp normalize_opts(opts) do
    themes =
      cond do
        Keyword.get(opts, :theme, false) -> Keyword.get(opts, :themes, @default_themes)
        true -> ["neo"]
      end

    default_theme = List.first(themes) || "neo"

    opts
    |> Keyword.put(:themes, themes)
    |> Keyword.put(:default_theme, default_theme)
    |> Keyword.put_new(:mode, false)
    |> Keyword.put_new(:theme, false)
    |> Keyword.put_new(:lang, false)
    |> Keyword.put_new(:mcp, true)
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

    if opts[:mcp] do
      write!(Path.join(app_dir, "mcp.ex"), Templates.mcp_module(assigns))
    end

    if opts[:theme] do
      write!(Path.join(app_dir, "theme.ex"), Templates.theme_module(assigns))
    end

    if opts[:mode] do
      write!(Path.join(app_dir, "mode.ex"), Templates.mode_module(assigns))
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

  defp copy_gettext_catalog(install_dir) do
    src = Corex.New.Generate.bundled_gettext_catalog_root()
    dest = Path.join(install_dir, "priv/gettext")

    unless File.dir?(src) do
      Mix.raise("""
      Corex gettext catalog template is missing at #{src}.

      Expected installer/priv/gettext with default.pot and en/fr/ar PO files.
      """)
    end

    Mix.shell().info([:green, "* copying ", :reset, "gettext catalog → priv/gettext/"])
    File.mkdir_p!(Path.dirname(dest))
    File.cp_r!(src, dest)
  end

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
    write!(
      Path.join([install_dir, "_posts", "2026-01-01-welcome.md"]),
      Templates.sample_post(assigns)
    )
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
      lang: !!opts[:lang],
      mcp: Keyword.get(opts, :mcp, true),
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
    base = ~w(toast layout-heading typo icon link button scrollbar)a

    base =
      if Keyword.get(opts, :mode, false) do
        base ++ [:toggle]
      else
        base
      end

    if Keyword.get(opts, :theme, false) or Keyword.get(opts, :lang, false) do
      base ++ [:select]
    else
      base
    end
  end

  defp corex_js_import(install_dir, opts) do
    case Keyword.get(opts, :dev) do
      path when is_binary(path) ->
        trimmed = String.trim(path)

        if trimmed != "" do
          Corex.New.Cli.validate_dev_path!(trimmed)
          corex_root = Path.expand(trimmed, install_dir)
          mjs = Path.join([corex_root, "priv", "static", "corex.mjs"])

          unless File.exists?(mjs) do
            Mix.raise("""
            Expected Corex bundle at #{mjs}.

            From the Corex checkout run:

                mix assets.build

            Then re-run corex.tableau.new with --dev.
            """)
          end

          js_dir = Path.join([install_dir, "assets", "js"])
          relative_import_from(js_dir, mjs)
        else
          "corex"
        end

      _ ->
        "corex"
    end
  end

  defp relative_import_from(js_dir, target_file) do
    js_dir = Path.expand(js_dir)
    target_file = Path.expand(target_file)

    from_parts = Path.split(js_dir)
    to_parts = Path.split(target_file)

    {from_rest, to_rest} = drop_common_prefix(from_parts, to_parts)

    ups = List.duplicate("..", length(from_rest))
    Path.join(ups ++ to_rest) |> String.replace("\\", "/")
  end

  defp drop_common_prefix([h | ta], [h | tb]), do: drop_common_prefix(ta, tb)
  defp drop_common_prefix(a, b), do: {a, b}

  defp corex_dep_source(opts) do
    case Keyword.get(opts, :dev) do
      path when is_binary(path) ->
        trimmed = String.trim(path)

        if trimmed != "" do
          Corex.New.Cli.validate_dev_path!(trimmed)
          "[path: #{inspect(trimmed)}, override: true]"
        else
          corex_dep_constraint()
        end

      _ ->
        corex_dep_constraint()
    end
  end

  defp corex_dep_constraint do
    "\"~> 0.2.0\""
  end

  defp corex_design_dep_source(opts) do
    case Keyword.get(opts, :dev) do
      path when is_binary(path) ->
        trimmed = String.trim(path)

        if trimmed != "" do
          Corex.New.Cli.validate_dev_path!(trimmed)
          design_path = Path.join(trimmed, "design")
          "[path: #{inspect(design_path)}, runtime: false]"
        else
          "\"~> 0.2.0\", runtime: false"
        end

      _ ->
        "\"~> 0.2.0\", runtime: false"
    end
  end

  defp corex_mcp_dep_source(opts) do
    case Keyword.get(opts, :dev) do
      path when is_binary(path) ->
        trimmed = String.trim(path)

        if trimmed != "" do
          Corex.New.Cli.validate_dev_path!(trimmed)
          mcp_path = Path.join(trimmed, "mcp")
          "[path: #{inspect(mcp_path)}, only: :dev]"
        else
          "\"~> 0.2.0\", only: :dev"
        end

      _ ->
        "\"~> 0.2.0\", only: :dev"
    end
  end

  defp app_lib_dir(install_dir, opts) do
    Path.join([install_dir, "lib", Atom.to_string(opts[:otp_app])])
  end

  defp write!(path, contents) do
    File.mkdir_p!(Path.dirname(path))
    File.write!(path, contents)
  end
end
