defmodule Corex.New.Generate do
  @moduledoc false

  alias Corex.New.{Patches, Shared, Templates}

  @doc """
  Runs all Corex post-generation work on a freshly-scaffolded Phoenix app at
  `install_dir`, driven by the normalized `opts` keyword list:

    * `:otp_app` (atom, required)  -  e.g. `:my_app`
    * `:web_module` (atom, required)  -  e.g. `MyAppWeb`
    * `:app_module` (atom, required)  -  e.g. `MyApp`
    * `:mode`, `:theme`, `:a11y`, `:lang`, `:design`, `:tailwind`, `:mcp`, `:usage_rules` (bool)
    * `:themes` (list of strings)  -  only used when `:theme` is true
    * `:dev` (string | nil)  -  path to local Corex checkout for `--dev PATH`
  """
  def run(install_dir, opts) do
    opts = normalize_opts(opts)

    write_layouts_ex(install_dir, opts)
    write_root_heex(install_dir, opts)
    write_home_heex(install_dir, opts)
    write_error_html(install_dir, opts)
    write_plugs(install_dir, opts)
    write_locale_helpers(install_dir, opts)
    write_a11y_helpers(install_dir, opts)
    write_app_js(install_dir, opts)
    write_app_css(install_dir, opts)

    Patches.patch_mix_exs(install_dir, opts)
    Patches.remove_daisyui_vendor!(install_dir)
    Patches.patch_agents_md(install_dir)
    Patches.remove_core_components!(install_dir, opts[:web_module], opts)
    Patches.patch_web_module(install_dir, opts[:web_module], opts)
    Patches.patch_web_gettext_sigils(install_dir, opts[:web_module], opts)
    Patches.patch_live_view_hooks(install_dir, opts[:web_module], opts)
    Patches.patch_router(install_dir, opts[:web_module], opts)
    Patches.patch_endpoint(install_dir, opts[:web_module], opts)
    Patches.patch_config_exs(install_dir, opts)
    Patches.patch_gitignore(install_dir, opts)
    Patches.patch_gettext_backend(install_dir, opts[:web_module], opts)
    Patches.patch_page_controller_test(install_dir, opts[:web_module])
    Patches.patch_error_html_test(install_dir, opts[:web_module], opts)

    if opts[:lang] do
      Patches.patch_verified_routes_path_prefixes!(install_dir, opts[:web_module], opts)
      copy_gettext_catalog(install_dir)
    end

    :ok
  end

  defp normalize_opts(opts) do
    otp_app = Keyword.fetch!(opts, :otp_app)
    web_module = Keyword.fetch!(opts, :web_module)
    app_module = Keyword.fetch!(opts, :app_module)

    opts
    |> Keyword.put(:otp_app, otp_app)
    |> Keyword.put(:web_module, web_module)
    |> Keyword.put(:app_module, app_module)
    |> Shared.put_theme_opts()
    |> Keyword.put_new(:mode, false)
    |> Keyword.put_new(:theme, false)
    |> Keyword.put_new(:a11y, false)
    |> Keyword.put_new(:lang, false)
    |> Keyword.put_new(:mcp, true)
    |> Keyword.put_new(:usage_rules, true)
    |> Keyword.put_new(:design, true)
    |> Keyword.put_new(:tailwind, true)
  end

  defp write_layouts_ex(install_dir, opts) do
    target =
      Path.join([install_dir, "lib", web_underscore(opts), "components", "layouts.ex"])

    write!(target, Templates.layouts_ex(template_assigns(install_dir, opts)))
  end

  defp write_root_heex(install_dir, opts) do
    target =
      Path.join([
        install_dir,
        "lib",
        web_underscore(opts),
        "components",
        "layouts",
        "root.html.heex"
      ])

    write!(target, Templates.root_heex(template_assigns(install_dir, opts)))
  end

  defp write_home_heex(install_dir, opts) do
    target =
      Path.join([
        install_dir,
        "lib",
        web_underscore(opts),
        "controllers",
        "page_html",
        "home.html.heex"
      ])

    if File.exists?(target) do
      write!(target, Templates.home_heex(template_assigns(install_dir, opts)))
    end
  end

  defp write_error_html(install_dir, opts) do
    if opts[:lang] do
      web = web_underscore(opts)
      controllers = Path.join([install_dir, "lib", web, "controllers"])
      error_dir = Path.join(controllers, "error_html")
      File.mkdir_p!(error_dir)

      write!(
        Path.join(controllers, "error_html.ex"),
        Templates.error_html_ex(template_assigns(install_dir, opts))
      )

      write!(
        Path.join(error_dir, "404.html.heex"),
        Templates.error_html_404(template_assigns(install_dir, opts))
      )
    end
  end

  defp write_plugs(install_dir, opts) do
    plugs_dir = Path.join([install_dir, "lib", web_underscore(opts), "plugs"])

    if opts[:mode] or opts[:theme] or opts[:lang] or opts[:a11y] do
      File.mkdir_p!(plugs_dir)
    end

    if opts[:mode] do
      write!(
        Path.join(plugs_dir, "mode.ex"),
        Templates.plug_mode(template_assigns(install_dir, opts))
      )
    end

    if opts[:theme] do
      write!(
        Path.join(plugs_dir, "theme.ex"),
        Templates.plug_theme(template_assigns(install_dir, opts))
      )
    end

    if opts[:a11y] do
      write!(
        Path.join(plugs_dir, "accessibility.ex"),
        Templates.plug_accessibility(template_assigns(install_dir, opts))
      )
    end
  end

  defp write_locale_helpers(install_dir, opts) do
    if opts[:lang] do
      web_dir = Path.join([install_dir, "lib", web_underscore(opts)])
      hooks_dir = Path.join(web_dir, "hooks")

      write!(
        Path.join(web_dir, "locale.ex"),
        Templates.locale_ex(template_assigns(install_dir, opts))
      )

      File.mkdir_p!(hooks_dir)

      write!(
        Path.join(hooks_dir, "layout.ex"),
        Templates.hooks_layout(template_assigns(install_dir, opts))
      )
    end
  end

  defp write_a11y_helpers(install_dir, opts) do
    if opts[:a11y] do
      hooks_dir = Path.join([install_dir, "lib", web_underscore(opts), "hooks"])
      File.mkdir_p!(hooks_dir)

      write!(
        Path.join(hooks_dir, "accessibility.ex"),
        Templates.hooks_accessibility(template_assigns(install_dir, opts))
      )
    end
  end

  defp write_app_js(install_dir, opts) do
    target = Path.join([install_dir, "assets", "js", "app.js"])
    write!(target, Templates.app_js(template_assigns(install_dir, opts)))
  end

  defp write_app_css(install_dir, opts) do
    target = Path.join([install_dir, "assets", "css", "app.css"])
    write!(target, Templates.app_css(template_assigns(install_dir, opts)))

    unless opts[:design] do
      Shared.copy_corex_base_css!(install_dir)
    end
  end

  defp template_assigns(install_dir, opts) do
    [
      web_module: inspect(opts[:web_module]),
      app_module: inspect(opts[:app_module]),
      otp_app: opts[:otp_app],
      mode: !!opts[:mode],
      theme: !!opts[:theme],
      a11y: !!opts[:a11y],
      lang: !!opts[:lang],
      design: !!opts[:design],
      tailwind: Keyword.get(opts, :tailwind, true),
      themes: opts[:themes],
      default_theme: opts[:default_theme],
      corex_js_import: corex_js_import(install_dir, opts)
    ]
  end

  defp corex_js_import(install_dir, opts) do
    Shared.corex_js_import(install_dir, opts, "corex.new")
  end

  defp web_underscore(opts), do: Atom.to_string(Keyword.fetch!(opts, :otp_app)) <> "_web"

  defp write!(path, contents), do: Shared.write!(path, contents)

  defp copy_gettext_catalog(install_dir), do: Shared.copy_gettext_catalog!(install_dir)
end
