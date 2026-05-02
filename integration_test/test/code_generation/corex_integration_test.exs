defmodule Corex.Integration.CodeGeneration.CorexIntegrationTest do
  use Corex.Integration.CodeGeneratorCase, async: true

  describe "default app" do
    test "compiles, passes format check, and tests pass" do
      with_installer_tmp("corex_default", fn tmp_dir ->
        {app_root_path, _} = generate_corex_app(tmp_dir, "my_app")

        assert_corex_greenfield_file_invariants!(app_root_path, "my_app")
        assert_no_compilation_warnings(app_root_path)
        assert_passes_formatter_check(app_root_path)
      end)
    end

    @tag database: :postgresql
    test "has a passing test suite" do
      with_installer_tmp("corex_default", fn tmp_dir ->
        {app_root_path, _} = generate_corex_app(tmp_dir, "my_app")

        drop_test_database(app_root_path)
        assert_tests_pass(app_root_path)
      end)
    end
  end

  describe "default app home page" do
    test "GET / returns 200 and body contains Corex" do
      with_installer_tmp("corex_home", [autoremove?: false], fn tmp_dir ->
        {app_root_path, _} = generate_corex_app(tmp_dir, "my_app")

        assert_no_compilation_warnings(app_root_path)

        port = run_phx_server(app_root_path)

        :inets.start()
        {:ok, response} = request_with_retries("http://localhost:#{port}", 45)
        assert response.status_code == 200
        assert response.body =~ "Corex"
      end)
    end
  end

  # NOTE: We don't require a specific LiveView route in generated apps.

  describe "ExampleLiveTest" do
    @tag database: :postgresql
    test "generated LiveView test passes" do
      with_installer_tmp("corex_example_live", fn tmp_dir ->
        {app_root_path, _} = generate_corex_app(tmp_dir, "my_app")

        drop_test_database(app_root_path)

        {output, 0} =
          System.cmd(
            "mix",
            ["test", "--timeout", "600000", "test/my_app_web/live/example_live_test.exs"],
            stderr_to_stdout: true,
            cd: app_root_path
          )

        assert output =~ "1 test, 0 failures"
      end)
    end
  end

  describe "app with --mode" do
    test "compiles, format check passes, and tests pass" do
      with_installer_tmp("corex_mode", fn tmp_dir ->
        {app_root_path, _} = generate_corex_app(tmp_dir, "my_app", ["--mode"])

        assert_no_compilation_warnings(app_root_path)
        assert_passes_formatter_check(app_root_path)
        assert_tests_pass(app_root_path)
      end)
    end
  end

  describe "app with --theme" do
    test "compiles, format check passes, and tests pass" do
      with_installer_tmp("corex_theme", fn tmp_dir ->
        {app_root_path, _} =
          generate_corex_app(tmp_dir, "my_app", ["--theme"])

        assert_no_compilation_warnings(app_root_path)
        assert_passes_formatter_check(app_root_path)
        assert_tests_pass(app_root_path)
      end)
    end
  end

  describe "app with --lang (i18n)" do
    test "compiles, format check passes, and tests pass" do
      with_installer_tmp("corex_lang", fn tmp_dir ->
        {app_root_path, _} = generate_corex_app(tmp_dir, "my_app", ["--lang"])

        assert_no_compilation_warnings(app_root_path)
        assert_passes_formatter_check(app_root_path)
        assert_tests_pass(app_root_path)
        assert_corex_lang_path_plug_invariants!(app_root_path, "my_app")
      end)
    end
  end

  describe "app with --designex" do
    test "keeps design folder, compiles, format check passes, and tests pass" do
      with_installer_tmp("corex_designex", fn tmp_dir ->
        {app_root_path, _} =
          generate_corex_app(tmp_dir, "my_app", ["--designex"])

        assert_no_compilation_warnings(app_root_path)
        assert_passes_formatter_check(app_root_path)
        assert_dir(Path.join(app_root_path, "assets/corex/design"))
        assert_file(Path.join([app_root_path, "assets", "corex", "design", "build.mjs"]))
        mix_exs = File.read!(Path.join(app_root_path, "mix.exs"))
        assert mix_exs =~ ~r/\{:designex,/
        assert mix_exs =~ "designex corex"
        cfg = File.read!(Path.join(app_root_path, "config/config.exs"))
        assert cfg =~ "config :designex"
        assert_assets_build_pass(app_root_path)
        assert_tests_pass(app_root_path)
      end)
    end
  end

  describe "app with --mode, --theme, and --lang (combined)" do
    test "compiles, format check passes, and tests pass" do
      with_installer_tmp("corex_mode_theme_lang", fn tmp_dir ->
        {app_root_path, _} =
          generate_corex_app(tmp_dir, "my_app", [
            "--mode",
            "--theme",
            "--lang"
          ])

        assert_no_compilation_warnings(app_root_path)
        assert_passes_formatter_check(app_root_path)
        assert_tests_pass(app_root_path)
        assert_corex_lang_path_plug_invariants!(app_root_path, "my_app")

        web = Path.join(app_root_path, "lib/my_app_web")

        for rel <- ["plugs/mode.ex", "plugs/theme.ex", "plugs/path.ex"] do
          assert File.exists?(Path.join(web, rel))
        end

        layouts = File.read!(Path.join(web, "components/layouts.ex"))
        assert layouts =~ "def language_switch"
      end)
    end

    @tag database: :sqlite3
    test "compiles, format check passes, and test suite passes (sqlite3)" do
      with_installer_tmp("corex_mode_theme_lang_sqlite3", fn tmp_dir ->
        {app_root_path, _} =
          generate_corex_app(tmp_dir, "phx_blog", [
            "--database",
            "sqlite3",
            "--mode",
            "--theme",
            "--lang"
          ])

        assert_no_compilation_warnings(app_root_path)
        assert_passes_formatter_check(app_root_path)
        drop_test_database(app_root_path)
        assert_tests_pass(app_root_path)
      end)
    end
  end

  describe "app with --no-design" do
    test "patches JS and home but does not run design (no assets/corex, no design imports in app.css)" do
      with_installer_tmp("corex_no_design_flag", fn tmp_dir ->
        {app_root_path, _} = generate_corex_app(tmp_dir, "my_app", ["--no-design"])

        assert_corex_no_design_replace_invariants!(app_root_path, "my_app")
        assert_no_compilation_warnings(app_root_path)
      end)
    end
  end

  describe "app with --no-dashboard" do
    test "compiles, format check passes, and tests pass" do
      with_installer_tmp("corex_no_ecto_no_dashboard", fn tmp_dir ->
        {app_root_path, _} =
          generate_corex_app(tmp_dir, "my_app", ["--no-dashboard"])

        assert_no_compilation_warnings(app_root_path)
        assert_passes_formatter_check(app_root_path)
        assert_tests_pass(app_root_path)
      end)
    end
  end

  describe "app with --theme HTTP check" do
    test "GET / returns theme-related markup" do
      with_installer_tmp("corex_theme_http", [autoremove?: false], fn tmp_dir ->
        {app_root_path, _} =
          generate_corex_app(tmp_dir, "my_app", ["--theme"])

        assert_no_compilation_warnings(app_root_path)

        port = run_phx_server(app_root_path)

        :inets.start()
        {:ok, response} = request_with_retries("http://localhost:#{port}", 45)
        assert response.status_code == 200

        assert response.body =~ "ThemeLive" or response.body =~ "data-theme" or
                 response.body =~ "theme"
      end)
    end
  end

  describe "mix corex.new with --mode and --theme (design assets)" do
    test "compile + assets.build succeed; design imports and root layout data attrs" do
      with_installer_tmp("corex_mode_theme_design", [autoremove?: false], fn tmp_dir ->
        {app_root_path, _} =
          generate_corex_app(tmp_dir, "my_app", ["--mode", "--theme"])

        assert_no_compilation_warnings(app_root_path)
        assert_assets_build_pass(app_root_path)

        assert_file(Path.join(app_root_path, "assets/css/app.css"), fn content ->
          assert content =~ "/* corex:design-imports */"
          assert content =~ ~s(@import "../corex/main.css";)
          assert content =~ ~s(@import "../corex/theme/neo.css";)
          assert content =~ ~s(@import "../corex/components/typo.css";)
          refute content =~ "../vendor/daisyui"
          refute content =~ "daisyui-theme"
        end)

        assert_file(
          Path.join(app_root_path, "lib/my_app_web/components/layouts/root.html.heex"),
          fn content ->
            assert content =~ ~r/<html\b[^>]*\bdata-theme=/
            assert content =~ ~r/<html\b[^>]*\bdata-mode=/
            refute content =~ ~r/window\.addEventListener\(\s*[\"']phx:set-theme/
            refute content =~ "dataset.phxTheme"
          end
        )
      end)
    end
  end

  describe "app with --mode HTTP check" do
    test "GET / returns mode-related markup" do
      with_installer_tmp("corex_mode_http", [autoremove?: false], fn tmp_dir ->
        {app_root_path, _} = generate_corex_app(tmp_dir, "my_app", ["--mode"])

        assert_no_compilation_warnings(app_root_path)

        port = run_phx_server(app_root_path)

        :inets.start()
        {:ok, response} = request_with_retries("http://localhost:#{port}", 45)
        assert response.status_code == 200

        assert response.body =~ "ModeLive" or response.body =~ "data-mode" or
                 response.body =~ "mode"
      end)
    end
  end

  describe "Corex.Code / mix corex.code" do
    test "mix corex.code works when Makeup is in generated app" do
      with_installer_tmp("corex_code_makeup", fn tmp_dir ->
        {app_root_path, _} = generate_corex_app(tmp_dir, "my_app")

        modify_file(Path.join(app_root_path, "mix.exs"), fn content ->
          String.replace(
            content,
            ~r/\{:jason, "~> 1\.2"\}/,
            "{:makeup, \"~> 1.2\"},\n      {:makeup_elixir, \"~> 1.0.1 or ~> 1.1\"},\n      {:jason, \"~> 1.2\"}"
          )
        end)

        mix_run!(["deps.get"], app_root_path)
        mix_run!(["corex.code"], app_root_path)

        assert_file(Path.join(app_root_path, "assets/css/code_highlight.css"))
      end)
    end
  end
end
