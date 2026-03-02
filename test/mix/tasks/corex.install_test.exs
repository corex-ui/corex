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

  test "install with --mode adds mode script to root and replaces app layout with Corex" do
    igniter =
      phx_test_project(app_name: :phx_mode)
      |> Igniter.compose_task("corex.install", ["--yes", "--mode"])

    root_source =
      Rewrite.source!(igniter.rewrite, "lib/phx_mode_web/components/layouts/root.html.heex")

    root_content = Rewrite.Source.get(root_source, :content)
    assert root_content =~ ~r/data-mode=/
    assert root_content =~ ~r/phx:set-mode/
    refute root_content =~ ~r/phx:set-theme/

    layouts_source = Rewrite.source!(igniter.rewrite, "lib/phx_mode_web/components/layouts.ex")
    layouts_content = Rewrite.Source.get(layouts_source, :content)

    assert layouts_content =~ ~r/class="typo layout"/,
           "def app is replaced with Corex layout"

    assert layouts_content =~ ~r/toast_group/,
           "layouts use toast_group instead of flash_group"

    refute layouts_content =~ ~r/def flash_group/,
           "flash_group should be removed when no-preserve"
  end

  test "install with --theme adds theme script to root" do
    igniter =
      phx_test_project(app_name: :phx_theme)
      |> Igniter.compose_task("corex.install", ["--yes", "--theme", "neo:uno"])

    root_source =
      Rewrite.source!(igniter.rewrite, "lib/phx_theme_web/components/layouts/root.html.heex")

    root_content = Rewrite.Source.get(root_source, :content)
    assert root_content =~ ~r/data-theme=/
    assert root_content =~ ~r/phx:set-theme/
    refute root_content =~ ~r/phx:set-mode/
  end

  test "install with design adds corex CSS imports" do
    igniter =
      phx_test_project(app_name: :phx_design)
      |> Igniter.compose_task("corex.install", ["--yes"])

    source = Rewrite.source!(igniter.rewrite, "assets/css/app.css")
    content = Rewrite.Source.get(source, :content)
    assert content =~ ~r/@import "\.\.\/corex\/main\.css"/

    root_source =
      Rewrite.source!(igniter.rewrite, "lib/phx_design_web/components/layouts/root.html.heex")

    root_content = Rewrite.Source.get(root_source, :content)

    assert root_content =~ ~r/lang="en"\s+data-theme="neo"\s+data-mode="light"/,
           "default install uses simple root with static en/neo/light"

    refute root_content =~ ~r/phx:set-mode|phx:set-theme/,
           "root should have no mode/theme script when neither --mode nor --theme"
  end

  test "design adds Corex imports and uses data-mode for dark variant" do
    igniter =
      phx_test_project(app_name: :phx_design_daisy)
      |> Igniter.compose_task("corex.install", ["--yes"])

    source = Rewrite.source!(igniter.rewrite, "assets/css/app.css")
    content = Rewrite.Source.get(source, :content)

    assert content =~ ~r/@import "\.\.\/corex\/main\.css"/,
           "Should add Corex imports when design"

    assert content =~ ~r/@import "\.\.\/corex\/components\/toast\.css"/,
           "Should add toast.css when design"

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

  test "default keeps root route as home and overwrites home.html.heex" do
    igniter =
      phx_test_project(app_name: :phx_default_route)
      |> Igniter.compose_task("corex.install", ["--yes"])

    router_source = Rewrite.source!(igniter.rewrite, "lib/phx_default_route_web/router.ex")
    router_content = Rewrite.Source.get(router_source, :content)

    assert router_content =~ ~r/get\s*\(\s*"\/"\s*,\s*PageController\s*,\s*:home\s*\)/,
           "default no-preserve keeps get \"/\" PageController :home"

    home_source =
      Rewrite.source!(
        igniter.rewrite,
        "lib/phx_default_route_web/controllers/page_html/home.html.heex"
      )

    home_content = Rewrite.Source.get(home_source, :content)

    assert home_content =~ ~r/Build/,
           "home.html.heex has Corex landing content"
  end

  test "preserve creates CorexLayouts, corex_app.css/js and adds get /corex without modifying root or home" do
    igniter =
      phx_test_project(app_name: :phx_preserve)
      |> Igniter.compose_task("corex.install", ["--yes", "--preserve"])

    corex_root =
      Rewrite.source!(
        igniter.rewrite,
        "lib/phx_preserve_web/components/core_layouts/corex_root.html.heex"
      )

    corex_root_content = Rewrite.Source.get(corex_root, :content)
    assert corex_root_content =~ ~r/data-theme=/
    assert corex_root_content =~ ~r/data-mode=/
    assert corex_root_content =~ ~r/corex_app\.css/
    assert corex_root_content =~ ~r/corex_app\.js/

    root_source =
      Rewrite.source!(igniter.rewrite, "lib/phx_preserve_web/components/layouts/root.html.heex")

    root_content = Rewrite.Source.get(root_source, :content)

    refute root_content =~ ~r/data-theme="neo"/,
           "root.html.heex should not be patched with data-theme when preserve"

    router_source = Rewrite.source!(igniter.rewrite, "lib/phx_preserve_web/router.ex")
    router_content = Rewrite.Source.get(router_source, :content)

    assert router_content =~
             ~r/get\s*\(?\s*"\/corex"\s*,\s*PageController\s*,\s*:corex_page\s*\)?/,
           "router should have get /corex route"

    assert router_content =~ ~r/get\s*\(?\s*"\/"\s*,\s*PageController\s*,\s*:home\s*\)?/,
           "home route should be kept when preserve"

    layouts_content =
      Rewrite.source!(igniter.rewrite, "lib/phx_preserve_web/components/layouts.ex")
      |> Rewrite.Source.get(:content)

    refute layouts_content =~ ~r/corex_app/,
           "layouts.ex should not have corex_app when preserve"

    corex_app_css =
      Rewrite.source!(igniter.rewrite, "assets/css/corex_app.css")
      |> Rewrite.Source.get(:content)

    assert corex_app_css =~ ~r/@import "\.\.\/corex\/main\.css"/,
           "corex_app.css should have Corex imports"

    core_layouts =
      Rewrite.source!(igniter.rewrite, "lib/phx_preserve_web/components/core_layouts.ex")
      |> Rewrite.Source.get(:content)

    assert core_layouts =~ ~r/CorexLayouts/
    assert core_layouts =~ ~r/embed_templates "core_layouts\/\*"/
  end

  test "install with --only uses hooks import and use Corex only" do
    igniter =
      phx_test_project(app_name: :phx_only)
      |> Igniter.compose_task("corex.install", [
        "--no-design",
        "--yes",
        "--only",
        "accordion:checkbox"
      ])

    app_js = Rewrite.source!(igniter.rewrite, "assets/js/app.js")
    app_js_content = Rewrite.Source.get(app_js, :content)

    assert app_js_content =~ ~r/import \{ hooks \} from "corex"/,
           "expected hooks import when --only"

    assert app_js_content =~ ~r/hooks\(\["Accordion", "Checkbox"\]\)/,
           "expected hooks with PascalCase names"

    web_ex = Rewrite.source!(igniter.rewrite, "lib/phx_only_web.ex")
    web_ex_content = Rewrite.Source.get(web_ex, :content)

    assert web_ex_content =~ ~r/use Corex, only: \[:accordion, :checkbox\]/,
           "expected use Corex only"
  end

  test "install with --prefix uses use Corex prefix" do
    igniter =
      phx_test_project(app_name: :phx_prefix)
      |> Igniter.compose_task("corex.install", ["--no-design", "--yes", "--prefix", "ui"])

    web_ex = Rewrite.source!(igniter.rewrite, "lib/phx_prefix_web.ex")
    web_ex_content = Rewrite.Source.get(web_ex, :content)

    assert web_ex_content =~ ~r/use Corex, prefix: "ui"/,
           "expected use Corex prefix"
  end

  test "preserve does not add corex route twice when running install twice" do
    igniter =
      phx_test_project(app_name: :phx_preserve_idempotent)
      |> Igniter.compose_task("corex.install", ["--yes", "--preserve"])
      |> Igniter.Test.apply_igniter!()
      |> Igniter.compose_task("corex.install", ["--yes", "--preserve"])

    router_source =
      Rewrite.source!(igniter.rewrite, "lib/phx_preserve_idempotent_web/router.ex")

    router_content = Rewrite.Source.get(router_source, :content)

    corex_route_matches =
      Regex.scan(
        ~r/get\s*\(?\s*"\/corex"\s*,\s*PageController\s*,\s*:corex_page\s*\)?/,
        router_content
      )

    assert length(corex_route_matches) == 1,
           "Expected exactly one get /corex route when running install twice with preserve, got #{length(corex_route_matches)}"
  end
end
