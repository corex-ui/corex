defmodule Corex.Integration.CodeGeneration.CorexIntegrationTest do
  use Corex.Integration.CodeGeneratorCase, async: true

  describe "default app" do
    test "compiles, passes format check, and tests pass" do
      with_installer_tmp("corex_default", fn tmp_dir ->
        {app_root_path, _} = generate_corex_app(tmp_dir, "my_app")

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

        spawn_link(fn ->
          run_phx_server(app_root_path)
        end)

        :inets.start()
        {:ok, response} = request_with_retries("http://localhost:4000", 20)
        assert response.status_code == 200
        assert response.body =~ "Corex"
      end)
    end
  end

  describe "default app LiveView" do
    test "GET /live returns 200 and body contains Live View" do
      with_installer_tmp("corex_live", [autoremove?: false], fn tmp_dir ->
        {app_root_path, _} = generate_corex_app(tmp_dir, "my_app")

        assert_no_compilation_warnings(app_root_path)

        spawn_link(fn ->
          run_phx_server(app_root_path)
        end)

        :inets.start()
        {:ok, response} = request_with_retries("http://localhost:4000/live", 20)
        assert response.status_code == 200
        assert response.body =~ "Live View"
      end)
    end
  end

  describe "ExampleLiveTest" do
    @tag database: :postgresql
    test "generated LiveView test passes" do
      with_installer_tmp("corex_example_live", fn tmp_dir ->
        {app_root_path, _} = generate_corex_app(tmp_dir, "my_app")

        drop_test_database(app_root_path)

        {output, 0} =
          System.cmd("mix", ["test", "test/my_app_web/live/example_live_test.exs"],
            stderr_to_stdout: true,
            cd: app_root_path
          )

        assert output =~ "1 test, 0 failures"
      end)
    end
  end

  describe "app with --mode" do
    test "compiles and format check passes" do
      with_installer_tmp("corex_mode", fn tmp_dir ->
        {app_root_path, _} = generate_corex_app(tmp_dir, "my_app", ["--mode"])

        assert_no_compilation_warnings(app_root_path)
        assert_passes_formatter_check(app_root_path)
      end)
    end
  end

  describe "app with --theme uno:leo" do
    test "compiles and format check passes" do
      with_installer_tmp("corex_theme", fn tmp_dir ->
        {app_root_path, _} = generate_corex_app(tmp_dir, "my_app", ["--theme", "uno:leo"])

        assert_no_compilation_warnings(app_root_path)
        assert_passes_formatter_check(app_root_path)
      end)
    end
  end

  describe "app with --lang en:fr" do
    test "compiles and format check passes" do
      with_installer_tmp("corex_lang", fn tmp_dir ->
        {app_root_path, _} = generate_corex_app(tmp_dir, "my_app", ["--lang", "en:fr"])

        assert_no_compilation_warnings(app_root_path)
        assert_passes_formatter_check(app_root_path)
      end)
    end
  end

  describe "app with --no-ecto" do
    test "compiles, format check passes, and tests pass" do
      with_installer_tmp("corex_no_ecto", fn tmp_dir ->
        {app_root_path, _} = generate_corex_app(tmp_dir, "my_app", ["--no-ecto"])

        assert_no_compilation_warnings(app_root_path)
        assert_passes_formatter_check(app_root_path)
        assert_tests_pass(app_root_path)
      end)
    end
  end

  describe "app with --designex" do
    test "keeps design folder, compiles, and format check passes" do
      with_installer_tmp("corex_designex", fn tmp_dir ->
        {app_root_path, _} = generate_corex_app(tmp_dir, "my_app", ["--designex"])

        assert_no_compilation_warnings(app_root_path)
        assert_passes_formatter_check(app_root_path)
        assert_dir(Path.join(app_root_path, "assets/corex/design"))
      end)
    end
  end

  describe "app with --no-tidewave" do
    test "compiles and format check passes" do
      with_installer_tmp("corex_no_tidewave", fn tmp_dir ->
        {app_root_path, _} = generate_corex_app(tmp_dir, "my_app", ["--no-tidewave"])

        assert_no_compilation_warnings(app_root_path)
        assert_passes_formatter_check(app_root_path)
      end)
    end
  end

  describe "app with --lang and --rtl" do
    test "generates locale and RTL files, compiles, and format check passes" do
      with_installer_tmp("corex_lang_rtl", fn tmp_dir ->
        {app_root_path, _} =
          generate_corex_app(tmp_dir, "my_app", ["--lang", "en:ar", "--rtl", "ar"])

        assert_no_compilation_warnings(app_root_path)
        assert_passes_formatter_check(app_root_path)
        assert_file(Path.join(app_root_path, "priv/gettext/ar/LC_MESSAGES/errors.po"))
        assert_file(Path.join(app_root_path, "lib/my_app_web/plugs/locale.ex"))
        assert_file(Path.join(app_root_path, "lib/my_app_web/shared_events.ex"))
      end)
    end
  end

  describe "app with --mode, --theme, and --lang (combined)" do
    test "compiles and format check passes" do
      with_installer_tmp("corex_mode_theme_lang", fn tmp_dir ->
        {app_root_path, _} =
          generate_corex_app(tmp_dir, "my_app", [
            "--mode",
            "--theme", "neo:uno",
            "--lang", "en:fr"
          ])

        assert_no_compilation_warnings(app_root_path)
        assert_passes_formatter_check(app_root_path)
      end)
    end

    @tag database: :sqlite3
    test "compiles, format check passes, and test suite passes (sqlite3)" do
      with_installer_tmp("corex_mode_theme_lang_sqlite3", fn tmp_dir ->
        {app_root_path, _} =
          generate_corex_app(tmp_dir, "phx_blog", [
            "--database", "sqlite3",
            "--mode",
            "--theme", "neo:uno",
            "--lang", "en:fr"
          ])

        assert_no_compilation_warnings(app_root_path)
        assert_passes_formatter_check(app_root_path)
        drop_test_database(app_root_path)
        assert_tests_pass(app_root_path)
      end)
    end
  end

  describe "app with --no-ecto --no-dashboard" do
    test "compiles, format check passes, and tests pass" do
      with_installer_tmp("corex_no_ecto_no_dashboard", fn tmp_dir ->
        {app_root_path, _} =
          generate_corex_app(tmp_dir, "my_app", ["--no-ecto", "--no-dashboard"])

        assert_no_compilation_warnings(app_root_path)
        assert_passes_formatter_check(app_root_path)
        assert_tests_pass(app_root_path)
      end)
    end
  end

  describe "app with --theme HTTP check" do
    test "GET / returns theme-related markup" do
      with_installer_tmp("corex_theme_http", [autoremove?: false], fn tmp_dir ->
        {app_root_path, _} = generate_corex_app(tmp_dir, "my_app", ["--theme", "uno:leo"])

        assert_no_compilation_warnings(app_root_path)

        spawn_link(fn ->
          run_phx_server(app_root_path)
        end)

        :inets.start()
        {:ok, response} = request_with_retries("http://localhost:4000", 20)
        assert response.status_code == 200
        assert response.body =~ "ThemeLive" or response.body =~ "data-theme" or response.body =~ "theme"
      end)
    end
  end

  describe "app with --mode HTTP check" do
    test "GET / returns mode-related markup" do
      with_installer_tmp("corex_mode_http", [autoremove?: false], fn tmp_dir ->
        {app_root_path, _} = generate_corex_app(tmp_dir, "my_app", ["--mode"])

        assert_no_compilation_warnings(app_root_path)

        spawn_link(fn ->
          run_phx_server(app_root_path)
        end)

        :inets.start()
        {:ok, response} = request_with_retries("http://localhost:4000", 20)
        assert response.status_code == 200
        assert response.body =~ "ModeLive" or response.body =~ "data-mode" or response.body =~ "mode"
      end)
    end
  end

  describe "corex.new.web inside umbrella" do
    test "creates web app and injects config" do
      with_installer_tmp("corex_new_web", fn tmp_dir ->
        {app_root_path, _} = generate_corex_app(tmp_dir, "phx_umb", ["--umbrella"])
        integration_test_root = Path.expand("../../", __DIR__)
        extra_web_path = Path.join([app_root_path, "apps", "extra_web"])

        mix_run!(
          ["corex.new.web", extra_web_path, "--install"],
          integration_test_root
        )

        assert_file(Path.join(app_root_path, "apps/extra_web/mix.exs"))
        assert_file(Path.join(app_root_path, "config/config.exs"), fn file ->
          assert file =~ "extra_web" or file =~ "import_config"
        end)
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

  defp run_phx_server(app_root_path) do
    {_output, 0} =
      System.cmd(
        "elixir",
        [
          "--no-halt",
          "-e",
          "spawn fn -> IO.gets([]) && System.halt(0) end",
          "-S",
          "mix",
          "phx.server"
        ],
        cd: app_root_path
      )
  end

  defp request_with_retries(url, retries)

  defp request_with_retries(_url, 0), do: {:error, :out_of_retries}

  defp request_with_retries(url, retries) do
    case url |> to_charlist() |> :httpc.request() do
      {:ok, httpc_response} ->
        {{_, status_code, _}, raw_headers, body} = httpc_response

        {:ok,
         %{
           status_code: status_code,
           headers: for({k, v} <- raw_headers, do: {to_string(k), to_string(v)}),
           body: to_string(body)
         }}

      {:error, {:failed_connect, _}} ->
        Process.sleep(5_000)
        request_with_retries(url, retries - 1)

      {:error, reason} ->
        {:error, reason}
    end
  end
end
