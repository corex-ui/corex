defmodule Corex.IgniterTest do
  use ExUnit.Case, async: true

  import Igniter.Test

  @moduletag :requires_igniter

  describe "run_setup_phase/2" do
    @tag :requires_igniter
    test "sets corex_project_paths in assigns" do
      igniter = phx_test_project(app_name: :phx_setup)
      result = Corex.Igniter.run_setup_phase(igniter, design: false)

      assert {_project_path, _web_path, _web_namespace, _web_app_str} =
               result.assigns[:corex_project_paths]
    end
  end

  describe "run_config_phase/2" do
    @tag :requires_igniter
    test "adds corex config" do
      igniter =
        phx_test_project(app_name: :phx_config)
        |> Corex.Igniter.run_setup_phase(design: false)

      result = Corex.Igniter.run_config_phase(igniter, [])

      source = Rewrite.source!(result.rewrite, "config/config.exs")
      content = Rewrite.Source.get(source, :content)
      assert content =~ ~r/config :corex/
    end

    @tag :requires_igniter
    test "adds corex config only once when run twice" do
      igniter =
        phx_test_project(app_name: :phx_config_twice)
        |> Corex.Igniter.run_setup_phase(design: false)

      result1 = Corex.Igniter.run_config_phase(igniter, [])
      result2 = Corex.Igniter.run_config_phase(result1, [])

      source = Rewrite.source!(result2.rewrite, "config/config.exs")
      content = Rewrite.Source.get(source, :content)
      config_count = content |> String.split("config :corex") |> length() |> Kernel.-(1)
      assert config_count == 1
    end

    @tag :requires_igniter
    test "adds rtl config when rtl opts provided" do
      igniter =
        phx_test_project(app_name: :phx_rtl_config)
        |> Corex.Igniter.run_setup_phase(design: false)

      result = Corex.Igniter.run_config_phase(igniter, rtl: "ar:he")

      source = Rewrite.source!(result.rewrite, "config/config.exs")
      content = Rewrite.Source.get(source, :content)
      assert content =~ ~r/rtl_locales/
    end
  end

  describe "run_assets_phase/2" do
    @tag :requires_igniter
    test "patches app.js and esbuild config" do
      igniter =
        phx_test_project(app_name: :phx_assets)
        |> Corex.Igniter.run_setup_phase(design: false)

      result = Corex.Igniter.run_assets_phase(igniter, [])

      js_source = Rewrite.source!(result.rewrite, "assets/js/app.js")
      js_content = Rewrite.Source.get(js_source, :content)
      assert js_content =~ ~r/from "corex"/

      config_source = Rewrite.source!(result.rewrite, "config/config.exs")
      config_content = Rewrite.Source.get(config_source, :content)
      assert config_content =~ ~r/--format=esm --splitting/
    end
  end

  describe "run_layout_phase/2" do
    @tag :requires_igniter
    test "patches root layout and web module" do
      igniter =
        phx_test_project(app_name: :phx_layout)
        |> Corex.Igniter.run_setup_phase(design: false)

      result = Corex.Igniter.run_layout_phase(igniter, [])

      layout_source =
        Rewrite.source!(result.rewrite, "lib/phx_layout_web/components/layouts/root.html.heex")

      layout_content = Rewrite.Source.get(layout_source, :content)
      assert layout_content =~ ~r/type="module"/
      assert layout_content =~ ~r/data-theme=/

      web_source = Rewrite.source!(result.rewrite, "lib/phx_layout_web.ex")
      web_content = Rewrite.Source.get(web_source, :content)
      assert web_content =~ ~r/use Corex/
    end
  end

  describe "run_css_phase/2" do
    @tag :requires_igniter
    test "patches app.css and removes daisy when design" do
      igniter =
        phx_test_project(app_name: :phx_css_design)
        |> Corex.Igniter.run_setup_phase(design: true)

      result = Corex.Igniter.run_css_phase(igniter, design: true)

      source = Rewrite.source!(result.rewrite, "assets/css/app.css")
      content = Rewrite.Source.get(source, :content)
      refute content =~ ~r/@plugin "\.\.\/vendor\/daisyui/
      refute content =~ ~r/@plugin "\.\.\/vendor\/daisyui-theme/
      assert content =~ ~r/\[data-mode=dark\]/
    end

    @tag :requires_igniter
    test "does not touch app.css daisy when no-design" do
      igniter =
        phx_test_project(app_name: :phx_css_no_design)
        |> Corex.Igniter.run_setup_phase(design: false)

      result = Corex.Igniter.run_css_phase(igniter, design: false)

      source = Rewrite.source!(result.rewrite, "assets/css/app.css")
      content = Rewrite.Source.get(source, :content)
      refute content =~ ~r/@import "\.\.\/corex/
    end
  end

  describe "validate_opts!/1" do
    @tag :requires_igniter
    test "accepts valid theme" do
      Corex.Igniter.validate_opts!(theme: "neo:uno")
    end

    test "raises when theme has fewer than 2 values" do
      assert_raise Mix.Error, ~r/--theme requires at least 2 values/, fn ->
        Corex.Igniter.validate_opts!(theme: "neo")
      end
    end

    @tag :requires_igniter
    @tag :requires_igniter
    test "accepts valid languages" do
      Corex.Igniter.validate_opts!(languages: "en:fr:ar")
    end

    test "raises when languages has fewer than 2 values" do
      assert_raise Mix.Error, ~r/--languages requires at least 2 values/, fn ->
        Corex.Igniter.validate_opts!(languages: "en")
      end
    end

    @tag :requires_igniter
    @tag :requires_igniter
    test "accepts empty opts" do
      Corex.Igniter.validate_opts!([])
    end
  end
end
