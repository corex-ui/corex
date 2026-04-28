defmodule Mix.Corex.Install.Pipeline do
  @moduledoc """
  `Mix.Tasks.Corex.Install` delegates here. The pipeline uses `Igniter.Scribe` (`start_document`, one `section` per phase, and `Scribe.patch` for each step) so that global **`--scribe path.md`** on `igniter.install` produces a Markdown document with per-section diffs. See [Igniter — Writing generators](https://hexdocs.pm/igniter/writing-generators.html) and the install task's moduledoc.
  """

  alias Igniter.Libs.Phoenix, as: ILPhoenix
  alias Igniter.Project.Application, as: ProjectApplication

  alias Mix.Corex.Install.{
    Assets,
    Config,
    Design,
    I18n,
    Layouts,
    Starter,
    Web
  }

  @manual_lead_in """
  This guide shows what `mix igniter.install corex` changes in your project.

  If any step cannot be applied automatically, the installer will print a warning or notice with the exact manual edit to make.
  """

  @section_deps """
  Add required dependencies and enable the Phoenix extension so Corex can patch a Phoenix project consistently.
  """

  @section_phoenix_defaults """
  Ensure Phoenix defaults are set for JSON encoding and Gettext backend resolution.
  """

  @section_i18n_runtime """
  When `--lang` is enabled, configure Localize runtime settings based on the project Gettext backend.
  """

  @section_build """
  Configure ESM build requirements for Corex JavaScript: esbuild must use `--format=esm` and `--splitting`.
  """

  @section_endpoint """
  Configure development-only plugs on the web endpoint.
  """

  @section_assets_js """
  Patch `assets/js/app.js` to import Corex and include `...corex` in LiveView hooks.
  When design is enabled, replace `assets/css/app.css` with the Corex design entry (`@import` of `main.css`, theme, and `typo.css`); the stock phx.new Tailwind/daisy block is not kept.
  """

  @section_web_module """
  Patch the Phoenix web module so templates can call Corex components.
  """

  @section_layout """
  Patch the root layout so the app JS is loaded as an ES module and the `html` tag has the assigns Corex expects.
  """

  @section_router_plugs """
  Create optional plugs (mode, theme, and with `--lang` a Path plug for locale-stripped `assigns[:path]`), then insert them into the browser pipeline and wire optional i18n router helpers.
  """

  @section_starter """
  With `--replace`, patch `Layouts.app`, wrap the stock `home.html.heex` in that layout, remove stock `flash_group` / `theme_toggle` helpers, and do not add `Layouts.corex` or `GET /home`. Default is **on** for `mix corex.new`, **off** for `mix igniter.install corex`. With `--no-replace` (or defaults when install runs without `--replace`), add the demo `GET /home` route and `Layouts.corex` while leaving the default Phoenix home unchanged.
  """

  @section_design """
  Schedule design assets generation with `mix corex.design`.
  """

  def igniter(igniter) do
    opts =
      igniter
      |> merge_cli_flags_into_options()
      |> Config.maybe_auto_enable_design()

    Config.validate_opts!(opts)

    mcp? = Keyword.get(opts, :mcp, true)
    replace? = Keyword.get(opts, :replace, false)

    web_mod = ILPhoenix.web_module(igniter)
    app = ProjectApplication.app_name(igniter)
    themes = Config.themes_from_opts(opts)
    i18n? = Keyword.get(opts, :lang, false)

    igniter
    |> Igniter.Scribe.start_document("Manual Installation", @manual_lead_in, app_name: app)
    |> Igniter.Scribe.section("Dependencies and extensions", @section_deps, fn igniter ->
      Igniter.Scribe.patch(igniter, fn igniter ->
        igniter
        |> Igniter.compose_task("igniter.add_extension", ["phoenix"])
        |> Config.maybe_add_localize_web_dep(i18n?)
      end)
    end)
    |> Igniter.Scribe.section("Phoenix defaults", @section_phoenix_defaults, fn igniter ->
      Igniter.Scribe.patch(igniter, fn igniter ->
        igniter
        |> Config.configure_app_env(app, themes)
        |> Config.configure_designex(opts)
        |> Config.configure_test_phoenix()
      end)
    end)
    |> Igniter.Scribe.section("Optional i18n runtime", @section_i18n_runtime, fn igniter ->
      Igniter.Scribe.patch(igniter, fn igniter ->
        igniter
        |> Config.maybe_configure_localize_runtime(web_mod, i18n?)
        |> I18n.maybe_patch_layouts_for_language_switch(web_mod, i18n?)
        |> I18n.maybe_create_localize_helpers(web_mod, i18n?)
        |> I18n.maybe_patch_web_verified_routes(web_mod, i18n?)
        |> I18n.maybe_locale_notices(i18n?)
      end)
    end)
    |> Igniter.Scribe.section("Build configuration", @section_build, fn igniter ->
      Igniter.Scribe.patch(igniter, fn igniter ->
        igniter
        |> Assets.patch_esbuild_config(app)
      end)
    end)
    |> Igniter.Scribe.section("Asset hooks", @section_assets_js, fn igniter ->
      Igniter.Scribe.patch(igniter, fn igniter ->
        igniter
        |> Assets.patch_assets_js()
        |> Assets.maybe_install_corex_logo()
        |> maybe_patch_design_assets(opts)
      end)
    end)
    |> Igniter.Scribe.section("Root layout", @section_layout, fn igniter ->
      Igniter.Scribe.patch(igniter, fn igniter ->
        igniter
        |> Layouts.patch_root_layout(web_mod, themes, opts)
        |> Layouts.maybe_patch_replaced_or_stock_app_layout(
          web_mod,
          themes,
          opts,
          replace?,
          i18n?
        )
      end)
    end)
    |> Igniter.Scribe.section("Endpoint configuration", @section_endpoint, fn igniter ->
      Igniter.Scribe.patch(igniter, fn igniter ->
        Web.patch_endpoint_dev_plugs(igniter, web_mod, mcp?)
      end)
    end)
    |> Igniter.Scribe.section("Web module", @section_web_module, fn igniter ->
      Igniter.Scribe.patch(igniter, fn igniter ->
        Web.patch_web_module(igniter, web_mod, i18n?)
      end)
    end)
    |> Igniter.Scribe.section("Router and plugs", @section_router_plugs, fn igniter ->
      Igniter.Scribe.patch(igniter, fn igniter ->
        igniter
        |> Web.create_plug_files(web_mod, app, opts, i18n?)
        |> Web.patch_router_for_plugs(web_mod, opts, themes, i18n?)
      end)
    end)
    |> Igniter.Scribe.section("Optional starter", @section_starter, fn igniter ->
      Igniter.Scribe.patch(
        igniter,
        &apply_optional_starter(&1, replace?, web_mod, themes, opts, i18n?)
      )
    end)
    |> Igniter.Scribe.section("Design assets", @section_design, fn igniter ->
      Igniter.Scribe.patch(igniter, fn igniter ->
        Design.maybe_schedule_design(igniter, opts)
      end)
    end)
  end

  defp merge_cli_flags_into_options(igniter) do
    igniter.args.options
  end

  defp maybe_patch_design_assets(igniter, opts) do
    if Config.design_on?(opts) do
      Design.patch_assets_app_css_for_corex_design(igniter, opts)
    else
      igniter
    end
  end

  defp apply_optional_starter(igniter, true, _web_mod, _themes, _opts, _i18n?) do
    igniter
  end

  defp apply_optional_starter(igniter, false, web_mod, themes, opts, i18n?) do
    Starter.add_corex_page_and_layout(igniter, web_mod, themes, opts, i18n?)
  end
end
