defmodule Mix.Corex.Install.Pipeline do
  @moduledoc """
  `Mix.Tasks.Corex.Install` delegates here. The pipeline uses `Igniter.Scribe` (`start_document`, one `section` per phase, and `Scribe.patch` for each step) so that global **`--scribe path.md`** on `igniter.install` produces a Markdown document with per-section diffs. See [Igniter — Writing generators](https://hexdocs.pm/igniter/writing-generators.html) and the install task’s moduledoc.
  """

  alias Mix.Corex.Install.Codemods

  alias Mix.Corex.Install.{
    Build,
    Deps,
    Design,
    Endpoint,
    I18n,
    Layouts,
    Options,
    PhoenixConfig,
    Plugs,
    Router,
    Starter
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
  """

  @section_web_module """
  Patch the Phoenix web module so templates can call Corex components.
  """

  @section_layout """
  Patch the root layout so the app JS is loaded as an ES module and the `html` tag has the assigns Corex expects.
  """

  @section_router_plugs """
  Create optional plugs (mode/theme), then insert them into the browser pipeline and wire optional i18n router helpers.
  """

  @section_starter """
  When not using `--replace`, add a `GET /corex` page and a `corex` layout. When using `--replace`, replace the app layout and home instead.
  """

  @section_design """
  Schedule design assets generation with `mix corex.design`.
  """

  def igniter(igniter) do
    opts = merge_cli_flags_into_options(igniter)
    Options.validate_opts!(opts)

    mcp? = Keyword.get(opts, :mcp, true)
    skills? = Keyword.get(opts, :skills, true)
    replace? = Keyword.get(opts, :replace, false)

    web_mod = Igniter.Libs.Phoenix.web_module(igniter)
    app = Igniter.Project.Application.app_name(igniter)
    themes = Options.themes_from_opts(opts)
    i18n? = Keyword.get(opts, :lang, false)

    igniter
    |> Igniter.Scribe.start_document("Manual Installation", @manual_lead_in, app_name: app)
    |> Igniter.Scribe.section("Dependencies and extensions", @section_deps, fn igniter ->
      Igniter.Scribe.patch(igniter, fn igniter ->
        igniter
        |> Igniter.compose_task("igniter.add_extension", ["phoenix"])
        |> Deps.maybe_add_localize_web_dep(i18n?)
        |> Deps.maybe_add_usage_rules(skills?)
      end)
    end)
    |> Igniter.Scribe.section("Phoenix defaults", @section_phoenix_defaults, fn igniter ->
      Igniter.Scribe.patch(igniter, fn igniter ->
        igniter
        |> PhoenixConfig.configure_phoenix_defaults(web_mod)
        |> PhoenixConfig.configure_app_env(app, themes)
        |> PhoenixConfig.configure_designex(opts)
        |> PhoenixConfig.configure_test_phoenix()
      end)
    end)
    |> Igniter.Scribe.section("Optional i18n runtime", @section_i18n_runtime, fn igniter ->
      Igniter.Scribe.patch(igniter, fn igniter ->
        igniter
        |> PhoenixConfig.maybe_configure_localize_runtime(web_mod, i18n?)
        |> I18n.maybe_create_localize_helpers(web_mod, i18n?)
        |> I18n.maybe_patch_layouts_for_language_switch(web_mod, i18n?)
        |> I18n.maybe_patch_web_verified_routes(web_mod, i18n?)
        |> I18n.maybe_enable_phoenix_route_helpers_for_localize(web_mod, i18n?)
        |> I18n.maybe_locale_notices(i18n?)
      end)
    end)
    |> Igniter.Scribe.section("Build configuration", @section_build, fn igniter ->
      Igniter.Scribe.patch(igniter, fn igniter ->
        igniter
        |> Build.patch_esbuild_config(app)
      end)
    end)
    |> Igniter.Scribe.section("Asset hooks", @section_assets_js, fn igniter ->
      Igniter.Scribe.patch(igniter, fn igniter ->
        Build.patch_assets_js(igniter)
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
        Endpoint.patch_endpoint_dev_plugs(igniter, web_mod, mcp?)
      end)
    end)
    |> Igniter.Scribe.section("Web module", @section_web_module, fn igniter ->
      Igniter.Scribe.patch(igniter, fn igniter ->
        Codemods.patch_web_module(igniter, web_mod, i18n?)
      end)
    end)
    |> Igniter.Scribe.section("Router and plugs", @section_router_plugs, fn igniter ->
      Igniter.Scribe.patch(igniter, fn igniter ->
        igniter
        |> Plugs.create_plug_files(web_mod, app, opts, i18n?)
        |> Router.patch_router_for_plugs(web_mod, opts, themes, i18n?)
      end)
    end)
    |> Igniter.Scribe.section("Optional starter", @section_starter, fn igniter ->
      Igniter.Scribe.patch(igniter, fn igniter ->
        if replace? do
          Layouts.maybe_patch_replaced_home(igniter, web_mod, i18n?)
        else
          Starter.add_corex_page_and_layout(igniter, web_mod, themes, opts, i18n?)
        end
      end)
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
end
