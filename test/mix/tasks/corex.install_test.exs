defmodule Mix.Tasks.Corex.InstallTest do
  use ExUnit.Case, async: true
  import Igniter.Test

  test "patches app.js with corex import" do
    phx_test_project(app_name: :phx_patch_js)
    |> Igniter.compose_task("corex.install", ["--no-design", "--yes"])
    |> assert_has_patch("assets/js/app.js", """
     +|import corex from "corex"
    """)
  end

  test "patches app.js with corex hooks" do
    phx_test_project(app_name: :phx_patch_hooks)
    |> Igniter.compose_task("corex.install", ["--no-design", "--yes"])
    |> assert_has_patch("assets/js/app.js", """
     +|  hooks: {...colocatedHooks, ...corex},
    """)
  end

  test "patches esbuild config with format=esm and splitting" do
    phx_test_project(app_name: :phx_esbuild)
    |> Igniter.compose_task("corex.install", ["--no-design", "--yes"])
    |> assert_has_patch("config/config.exs", """
     +|      ~w(js/app.js --bundle --format=esm --splitting --target=
    """)
  end

  test "adds rtl_locales to config with --rtl" do
    igniter =
      phx_test_project(app_name: :phx_rtl)
      |> Igniter.compose_task("corex.install", ["--no-design", "--yes", "--rtl", "ar"])

    source = Rewrite.source!(igniter.rewrite, "config/config.exs")
    content = Rewrite.Source.get(source, :content)
    assert content =~ ~r/rtl_locales: \["ar"\]/
  end

  test "does not add use Corex twice when running install twice" do
    igniter =
      phx_test_project(app_name: :phx_idempotent)
      |> Igniter.compose_task("corex.install", ["--no-design", "--yes"])
      |> Igniter.Test.apply_igniter!()
      |> Igniter.compose_task("corex.install", ["--no-design", "--yes"])

    source = Rewrite.source!(igniter.rewrite, "lib/phx_idempotent_web.ex")
    content = Rewrite.Source.get(source, :content)
    use_corex_matches = Regex.scan(~r/\buse Corex\b/, content)

    assert length(use_corex_matches) == 1,
           "Expected exactly one 'use Corex', got #{length(use_corex_matches)}"
  end

  test "does not warn when root layout already patched on second run" do
    igniter =
      phx_test_project(app_name: :phx_idempotent)
      |> Igniter.compose_task("corex.install", ["--yes"])
      |> Igniter.Test.apply_igniter!()
      |> Igniter.compose_task("corex.install", ["--yes"])

    source =
      Rewrite.source!(igniter.rewrite, "lib/phx_idempotent_web/components/layouts/root.html.heex")

    content = Rewrite.Source.get(source, :content)
    assert content =~ ~r/type="module"/, "Expected type=\"module\" on script"

    assert content =~ ~r/data-theme=/ or content =~ ~r/data-mode=/,
           "Expected data-theme or data-mode on html"

    root_layout_warning? =
      Enum.any?(igniter.warnings, fn w ->
        to_string(w) =~ ~r/root\.html\.heex/ and to_string(w) =~ ~r/Could not patch/
      end)

    refute root_layout_warning?, "Should not warn about root layout when already patched"
  end

  test "install with --mode adds mode script and mode_toggle to layouts" do
    igniter =
      phx_test_project(app_name: :phx_mode)
      |> Igniter.compose_task("corex.install", ["--yes", "--mode"])

    source =
      Rewrite.source!(igniter.rewrite, "lib/phx_mode_web/components/layouts/root.html.heex")

    content = Rewrite.Source.get(source, :content)
    assert content =~ ~r/data-mode=/

    layouts_source = Rewrite.source!(igniter.rewrite, "lib/phx_mode_web/components/layouts.ex")
    layouts_content = Rewrite.Source.get(layouts_source, :content)
    assert layouts_content =~ ~r/<\.mode_toggle \/>/
    assert layouts_content =~ ~r/def mode_toggle\(assigns\)/
  end

  test "install with --theme adds theme config" do
    igniter =
      phx_test_project(app_name: :phx_theme)
      |> Igniter.compose_task("corex.install", ["--yes", "--theme", "neo:uno"])

    source =
      Rewrite.source!(igniter.rewrite, "lib/phx_theme_web/components/layouts/root.html.heex")

    content = Rewrite.Source.get(source, :content)
    assert content =~ ~r/data-theme=|data-mode=/
  end

  test "install with design adds corex CSS imports" do
    igniter =
      phx_test_project(app_name: :phx_design)
      |> Igniter.compose_task("corex.install", ["--yes"])

    source = Rewrite.source!(igniter.rewrite, "assets/css/app.css")
    content = Rewrite.Source.get(source, :content)
    assert content =~ ~r/@import "\.\.\/corex\/main\.css"/
  end

  test "design removes daisyui CSS and uses data-mode for dark variant" do
    igniter =
      phx_test_project(app_name: :phx_design_daisy)
      |> Igniter.compose_task("corex.install", ["--yes"])

    source = Rewrite.source!(igniter.rewrite, "assets/css/app.css")
    content = Rewrite.Source.get(source, :content)

    refute content =~ ~r/@plugin "\.\.\/vendor\/daisyui/, "Should remove daisyui plugin"

    refute content =~ ~r/@plugin "\.\.\/vendor\/daisyui-theme/,
           "Should remove daisyui-theme plugin"

    refute content =~ ~r/\[data-theme=dark\]/,
           "Should replace data-theme=dark with data-mode=dark"

    assert content =~ ~r/\[data-mode=dark\]/, "Should use data-mode=dark for dark variant"
  end

  test "no-design does not touch daisyui or add data-theme/data-mode" do
    igniter =
      phx_test_project(app_name: :phx_no_design)
      |> Igniter.compose_task("corex.install", ["--no-design", "--yes"])

    source = Rewrite.source!(igniter.rewrite, "assets/css/app.css")
    content = Rewrite.Source.get(source, :content)

    refute content =~ ~r/@import "\.\.\/corex\/main\.css"/,
           "Should not add corex CSS imports when no-design"

    root_source =
      Rewrite.source!(igniter.rewrite, "lib/phx_no_design_web/components/layouts/root.html.heex")

    root_content = Rewrite.Source.get(root_source, :content)

    refute root_content =~ ~r/data-theme="neo"/,
           "Should not add data-theme when no-design"

    refute root_content =~ ~r/data-mode="light"/,
           "Should not add data-mode when no-design"
  end
end
