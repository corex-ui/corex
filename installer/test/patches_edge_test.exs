defmodule Corex.New.PatchesEdgeTest do
  use ExUnit.Case, async: false

  import Corex.New.MixHelper

  alias Corex.New.Patches

  @stock_mix_exs """
  defmodule MyApp.MixProject do
    use Mix.Project

    def project do
      [app: :my_app, version: "0.1.0", deps: deps()]
    end

    defp deps do
      [
        {:phoenix, "~> 1.8.1"},
        {:phoenix_live_view, "~> 1.1.0"}
      ]
    end
  end
  """

  defp assert_shell_info_contains!(substring) do
    assert_receive {:mix_shell, :info, message}, 500

    text =
      message
      |> List.wrap()
      |> IO.iodata_to_binary()

    assert text =~ substring
  end

  describe "patch_verified_routes_path_prefixes!/3 edge cases" do
    test "raises when verified_routes cannot be patched" do
      in_tmp(:verified_routes_raise, fn ->
        File.mkdir_p!("lib")
        File.write!("lib/my_app_web.ex", "defmodule MyAppWeb do\nend\n")

        assert_raise Mix.Error, ~r/Could not add path_prefixes/, fn ->
          Patches.patch_verified_routes_path_prefixes!(File.cwd!(), MyAppWeb,
            lang: true,
            otp_app: :my_app
          )
        end
      end)
    end

    test "prints success message when path_prefixes are added" do
      web_ex = """
      defmodule MyAppWeb do
        defp verified_routes do
          quote do
            use Phoenix.VerifiedRoutes,
              endpoint: MyAppWeb.Endpoint,
              router: MyAppWeb.Router,
              statics: MyAppWeb.static_paths()
          end
        end
      end
      """

      in_tmp(:verified_routes_info, fn ->
        File.mkdir_p!("lib/my_app_web")
        File.write!("lib/my_app_web/locale.ex", "defmodule MyAppWeb.Locale do\nend\n")
        File.write!("lib/my_app_web.ex", web_ex)

        flush()

        Patches.patch_verified_routes_path_prefixes!(File.cwd!(), MyAppWeb,
          lang: true,
          otp_app: :my_app
        )

        assert_shell_info_contains!("adding path_prefixes")

        assert File.read!("lib/my_app_web.ex") =~
                 "path_prefixes: [{MyAppWeb.Locale, :current, []}]"
      end)
    end

    test "replaces verified_routes def when statics line uses another module" do
      web_ex = """
      defmodule MyAppWeb do
        defp verified_routes do
          quote do
            use Phoenix.VerifiedRoutes,
              endpoint: MyAppWeb.Endpoint,
              router: MyAppWeb.Router,
              statics: Other.static_paths()
          end
        end
      end
      """

      in_tmp(:verified_routes_replace_def, fn ->
        File.mkdir_p!("lib/my_app_web")
        File.write!("lib/my_app_web/locale.ex", "defmodule MyAppWeb.Locale do\nend\n")
        File.write!("lib/my_app_web.ex", web_ex)

        Patches.patch_verified_routes_path_prefixes!(File.cwd!(), MyAppWeb,
          lang: true,
          otp_app: :my_app
        )

        body = File.read!("lib/my_app_web.ex")
        assert body =~ "path_prefixes: [{MyAppWeb.Locale, :current, []}]"
        assert body =~ "statics: MyAppWeb.static_paths()"
      end)
    end
  end

  describe "patch_mix_exs/2 edge cases" do
    test "warns when deps block cannot be located" do
      mix_exs = """
      defmodule MyApp.MixProject do
        use Mix.Project

        def project do
          [app: :my_app, version: "0.1.0"]
        end
      end
      """

      in_tmp(:patch_mix_no_deps, fn ->
        File.write!("mix.exs", mix_exs)

        flush()
        Patches.patch_mix_exs(File.cwd!(), [])
        assert_shell_info_contains!("Could not locate `defp deps do")
        refute File.read!("mix.exs") =~ "{:corex,"
      end)
    end

    test "uses hex constraint when --dev path is blank" do
      in_tmp(:patch_mix_blank_dev, fn ->
        File.write!("mix.exs", @stock_mix_exs)
        Patches.patch_mix_exs(File.cwd!(), dev: "   ")
        body = File.read!("mix.exs")
        assert body =~ "{:corex,"
        refute body =~ "path:"
      end)
    end

    test "warns when assets.build alias is missing" do
      in_tmp(:patch_corex_design_build_no_alias, fn ->
        File.write!("mix.exs", @stock_mix_exs)

        flush()
        Patches.patch_mix_exs(File.cwd!(), design: true)
        assert_shell_info_contains!("assets.build")
      end)
    end

    test "inserts corex.design.build after multiline compile in assets.build" do
      mix_exs = """
      defmodule MyApp.MixProject do
        use Mix.Project

        def project do
          [app: :my_app, version: "0.1.0", aliases: aliases(), deps: deps()]
        end

        defp deps do
          [{:phoenix, "~> 1.8.0"}]
        end

        defp aliases do
          [
            "assets.build": [
              "compile",
              "tailwind my_app"
            ],
            "assets.deploy": [
              "compile",
              "tailwind my_app --minify",
              "phx.digest"
            ]
          ]
        end
      end
      """

      in_tmp(:patch_corex_design_build_multiline_build, fn ->
        File.write!("mix.exs", mix_exs)
        Patches.patch_mix_exs(File.cwd!(), design: true)
        body = File.read!("mix.exs")
        assert body =~ "\"corex.design.build\""
      end)
    end
  end

  describe "patch_config_exs/2 edge cases" do
    test "appends Corex.Design config when import_config marker is absent" do
      config = """
      import Config

      config :my_app, ecto_repos: [MyApp.Repo]
      """

      in_tmp(:patch_config_corex_design_build_append, fn ->
        File.mkdir_p!("config")
        File.write!("config/config.exs", config)

        Patches.patch_config_exs(File.cwd!(), otp_app: :my_app, design: true)
        body = File.read!("config/config.exs")
        assert body =~ "config :corex_design"
      end)
    end

    test "appends localize config when import_config marker is absent" do
      config = """
      import Config

      config :my_app, ecto_repos: [MyApp.Repo]
      """

      in_tmp(:patch_config_localize_append, fn ->
        File.mkdir_p!("config")
        File.write!("config/config.exs", config)

        Patches.patch_config_exs(File.cwd!(), otp_app: :my_app, lang: true)
        body = File.read!("config/config.exs")
        assert body =~ "config :localize"
      end)
    end

    test "patches esbuild outdir when assets path lacks /js suffix" do
      config = """
      import Config

      config :esbuild,
        my_app: [
          args: ~w(js/app.js --bundle --outdir=../priv/static/assets)
        ]
      """

      in_tmp(:patch_config_outdir, fn ->
        File.mkdir_p!("config")
        File.write!("config/config.exs", config)

        Patches.patch_config_exs(File.cwd!(), otp_app: :my_app)
        body = File.read!("config/config.exs")
        assert body =~ "--outdir=../priv/static/assets/js"
      end)
    end

    test "leaves themes unchanged when app config block is not found" do
      config = """
      import Config

      config :other_app, foo: :bar
      """

      in_tmp(:patch_config_no_app_block, fn ->
        File.mkdir_p!("config")
        File.write!("config/config.exs", config)

        Patches.patch_config_exs(File.cwd!(), otp_app: :my_app, theme: true, themes: ["neo"])
        body = File.read!("config/config.exs")
        refute body =~ ~s(themes: ["neo"])
      end)
    end
  end

  describe "patch_gettext_backend/3 edge cases" do
    test "leaves gettext file unchanged when Backend use is absent" do
      in_tmp(:patch_gettext_no_backend, fn ->
        File.mkdir_p!("lib/my_app_web")

        File.write!(
          "lib/my_app_web/gettext.ex",
          "defmodule MyAppWeb.Gettext do\n  use Gettext, otp_app: :my_app\nend\n"
        )

        Patches.patch_gettext_backend(File.cwd!(), MyAppWeb, lang: true)
        body = File.read!("lib/my_app_web/gettext.ex")
        refute body =~ "locales:"
      end)
    end

    test "no-ops when gettext file is missing" do
      in_tmp(:patch_gettext_missing, fn ->
        assert :ok == Patches.patch_gettext_backend(File.cwd!(), MyAppWeb, lang: true)
      end)
    end
  end

  describe "patch_page_controller_test/2 edge cases" do
    test "no-ops when page controller test is missing" do
      in_tmp(:patch_page_test_missing, fn ->
        assert :ok == Patches.patch_page_controller_test(File.cwd!(), MyAppWeb)
      end)
    end

    test "leaves file unchanged when expected string is absent" do
      in_tmp(:patch_page_test_no_match, fn ->
        path = "test/my_app_web/controllers/page_controller_test.exs"
        File.mkdir_p!(Path.dirname(path))

        File.write!(
          path,
          """
          defmodule MyAppWeb.PageControllerTest do
            use MyAppWeb.ConnCase

            test "GET /", %{conn: conn} do
              assert true
            end
          end
          """
        )

        Patches.patch_page_controller_test(File.cwd!(), MyAppWeb)
        assert File.read!(path) =~ "assert true"
      end)
    end
  end

  describe "patch_live_view_for_lang/3 when lang is false" do
    test "returns :ok without modifying web module" do
      web_ex = "defmodule MyAppWeb do\nend\n"

      in_tmp(:patch_live_view_no_lang, fn ->
        File.mkdir_p!("lib")
        File.write!("lib/my_app_web.ex", web_ex)

        assert :ok == Patches.patch_live_view_for_lang(File.cwd!(), MyAppWeb, lang: false)
        assert File.read!("lib/my_app_web.ex") == web_ex
      end)
    end
  end
end
