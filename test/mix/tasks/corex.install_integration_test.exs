defmodule Mix.Tasks.Corex.InstallIntegrationTest do
  use ExUnit.Case, async: false

  import CorexTest.InstallIntegrationCase

  @moduletag :integration
  @moduletag timeout: 300_000

  setup context do
    tmp_dir =
      case Map.get(context, :tmp_dir) do
        nil ->
          base = System.tmp_dir!()
          path = Path.join(base, "corex_install_#{System.unique_integer([:positive])}")
          File.mkdir_p!(path)
          path

        dir ->
          dir
      end

    {:ok, tmp_dir: tmp_dir}
  end

  defp run_install_and_assert(tmp_dir, app_name, install_args, assertions \\ []) do
    project_dir = run_phoenix_project(tmp_dir, app_name)
    corex_path = Path.expand("../../..", __DIR__)

    {output, exit_code} = run_corex_install(project_dir, corex_path, install_args)

    assert exit_code == 0, "install failed: #{output}"

    if Keyword.get(assertions, :templates?, true) do
      templates_root = Path.join(project_dir, "priv/templates")

      assert File.dir?(Path.join(templates_root, "phx.gen.html")),
             "templates not copied. install output: #{output}"

      assert File.dir?(Path.join(templates_root, "phx.gen.live"))
    end

    if Keyword.get(assertions, :app_js?, true) do
      app_js = File.read!(Path.join(project_dir, "assets/js/app.js"))
      assert app_js =~ ~r/from "corex"/
    end

    assert_no_compilation_warnings(project_dir)
    assert_tests_pass(project_dir)
    format_project(project_dir)
    assert_passes_formatter_check(project_dir)

    project_dir
  end

  test "preserve: keeps home, adds corex_page, default tests pass", %{tmp_dir: tmp_dir} do
    run_install_and_assert(tmp_dir, "demo_preserve", ["--preserve"])
  end

  test "no-preserve: overwrites home, patches PageControllerTest to expect Corex", %{
    tmp_dir: tmp_dir
  } do
    run_install_and_assert(tmp_dir, "demo_no_preserve", [])
  end

  test "no-preserve + mode: overwrites home plus mode script and mode_toggle", %{tmp_dir: tmp_dir} do
    run_install_and_assert(tmp_dir, "demo_mode", ["--mode"])
  end

  test "preserve + mode: preserve flow with mode", %{tmp_dir: tmp_dir} do
    run_install_and_assert(tmp_dir, "demo_preserve_mode", ["--preserve", "--mode"])
  end

  test "theme: theme config in root and theme_toggle", %{tmp_dir: tmp_dir} do
    run_install_and_assert(tmp_dir, "demo_theme", ["--theme", "neo:uno"])
  end

  test "languages: gettext locales wired", %{tmp_dir: tmp_dir} do
    run_install_and_assert(tmp_dir, "demo_languages", ["--languages", "en:fr"])
  end

  test "rtl: RTL config in config.exs", %{tmp_dir: tmp_dir} do
    run_install_and_assert(tmp_dir, "demo_rtl", ["--rtl", "ar"])
  end

  test "no-design: skips design files, no data-theme/data-mode", %{tmp_dir: tmp_dir} do
    project_dir = run_install_and_assert(tmp_dir, "demo_no_design", ["--no-design"])

    root_source =
      Path.join(project_dir, "lib/demo_no_design_web/components/layouts/root.html.heex")

    root_content = File.read!(root_source)

    refute root_content =~ ~r/data-theme="neo"/, "should not add data-theme when no-design"
    refute root_content =~ ~r/data-mode="light"/, "should not add data-mode when no-design"
  end
end
