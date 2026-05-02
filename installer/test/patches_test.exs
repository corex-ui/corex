Code.require_file("mix_helper.exs", __DIR__)

defmodule Corex.New.PatchesTest do
  use ExUnit.Case, async: false

  import MixHelper

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

  @stock_web_with_live_view """
  defmodule MyAppWeb do
    def live_view do
      quote do
        use Phoenix.LiveView

        unquote(html_helpers())
      end
    end

    defp html_helpers do
      quote do
      end
    end
  end
  """

  @stock_web_ex """
  defmodule MyAppWeb do
    def html do
      quote do
        use Phoenix.Component
        unquote(html_helpers())
      end
    end

    defp html_helpers do
      quote do
        use Gettext, backend: MyAppWeb.Gettext
        import Phoenix.HTML
        alias Phoenix.LiveView.JS
        alias MyAppWeb.Layouts
        unquote(verified_routes())
      end
    end
  end
  """

  @stock_endpoint_ex """
  defmodule MyAppWeb.Endpoint do
    use Phoenix.Endpoint, otp_app: :my_app

    @session_options [
      store: :cookie,
      key: "_my_app_key",
      signing_salt: "x",
      same_site: "Lax"
    ]

    socket "/live", Phoenix.LiveView.Socket,
      websocket: [connect_info: [session: @session_options]],
      longpoll: [connect_info: [session: @session_options]]

    plug Plug.Static,
      at: "/",
      from: :my_app,
      gzip: not code_reloading?,
      only: MyAppWeb.static_paths(),
      raise_on_missing_only: code_reloading?

    if code_reloading? do
      plug Phoenix.CodeReloader
    end

    plug MyAppWeb.Router
  end
  """

  @stock_router_ex """
  defmodule MyAppWeb.Router do
    use MyAppWeb, :router

    pipeline :browser do
      plug :accepts, ["html"]
      plug :fetch_session
      plug :fetch_live_flash
      plug :put_root_layout, html: {MyAppWeb.Layouts, :root}
      plug :protect_from_forgery
      plug :put_secure_browser_headers
    end

    pipeline :api do
      plug :accepts, ["json"]
    end

    scope "/", MyAppWeb do
      pipe_through :browser

      get "/", PageController, :home
    end
  end
  """

  @stock_config_exs """
  import Config

  config :my_app,
    ecto_repos: [MyApp.Repo],
    generators: [timestamp_type: :utc_datetime]

  config :esbuild,
    version: "0.25.4",
    my_app: [
      args:
        ~w(js/app.js --bundle --target=es2022 --outdir=../priv/static/assets --external:/fonts/* --external:/images/* --alias:@=.),
      cd: Path.expand("../assets", __DIR__),
      env: %{"NODE_PATH" => [Path.expand("../deps", __DIR__), Mix.Project.build_path()]}
    ]

  import_config "#{"#"}{config_env()}.exs"
  """

  @mix_exs_with_aliases """
  defmodule MyApp.MixProject do
    use Mix.Project

    def project do
      [
        app: :my_app,
        version: "0.1.0",
        elixir: "~> 1.17",
        aliases: aliases(),
        deps: deps()
      ]
    end

    def application do
      [extra_applications: [:logger]]
    end

    defp deps do
      [
        {:phoenix, "~> 1.8.0"},
        {:tailwind, "~> 0.3", runtime: Mix.env() == :dev},
        {:esbuild, "~> 0.10", runtime: Mix.env() == :dev}
      ]
    end

    defp aliases do
      [
        "assets.build": ["compile", "tailwind my_app", "esbuild my_app"],
        "assets.deploy": [
          "tailwind my_app --minify",
          "esbuild my_app --minify",
          "phx.digest"
        ]
      ]
    end
  end
  """

  describe "patch_mix_exs/2" do
    test "inserts :corex dependency once" do
      in_tmp(:patch_mix_exs, fn ->
        File.write!("mix.exs", @stock_mix_exs)

        Patches.patch_mix_exs(File.cwd!(), [])
        body = File.read!("mix.exs")
        assert body =~ "{:corex,"

        Patches.patch_mix_exs(File.cwd!(), [])
        body2 = File.read!("mix.exs")
        assert length(String.split(body2, "{:corex,")) == 2
      end)
    end

    test "adds :localize_web when lang: true" do
      in_tmp(:patch_mix_exs_lang, fn ->
        File.write!("mix.exs", @stock_mix_exs)
        Patches.patch_mix_exs(File.cwd!(), lang: true)
        body = File.read!("mix.exs")
        assert body =~ "{:localize_web,"
      end)
    end

    test "uses a path dep when --dev is given" do
      in_tmp(:patch_mix_exs_dev, fn ->
        File.write!("mix.exs", @stock_mix_exs)
        Patches.patch_mix_exs(File.cwd!(), dev: "../corex")
        body = File.read!("mix.exs")
        assert body =~ ~s({:corex, [path: "../corex", override: true]})
      end)
    end

    test "adds designex dep and aliases when designex: true" do
      in_tmp(:patch_mix_exs_designex, fn ->
        File.write!("mix.exs", @mix_exs_with_aliases)

        Patches.patch_mix_exs(File.cwd!(), designex: true)
        body = File.read!("mix.exs")
        assert body =~ ~r/\{:designex,\s*"~> 1.0",\s*runtime:\s*Mix\.env\(\)\s*==\s*:dev\}/

        assert body =~
                 ~r/"assets\.build":\s*\[\s*"compile",\s*"designex corex",\s*"tailwind my_app"/

        assert body =~ ~r/"assets\.deploy":\s*\[\s*"designex corex",\s*"tailwind my_app --minify"/

        Patches.patch_mix_exs(File.cwd!(), designex: true)
        body2 = File.read!("mix.exs")
        assert Regex.scan(~r/"designex corex"/, body2) |> length() == 2
      end)
    end

    test "adds json_polyfill when --lang and :json is not loaded" do
      mix_exs = """
      defmodule MyApp.MixProject do
        use Mix.Project

        def project do
          [app: :my_app, version: "0.1.0", deps: deps()]
        end

        def application do
          [mod: {MyApp.Application, []}, extra_applications: [:logger, :runtime_tools]]
        end

        defp deps do
          [
            {:phoenix, "~> 1.8.1"},
            {:jason, "~> 1.2"}
          ]
        end
      end
      """

      in_tmp(:patch_mix_exs_json_polyfill, fn ->
        File.write!("mix.exs", mix_exs)
        Patches.patch_mix_exs(File.cwd!(), lang: true)
        body = File.read!("mix.exs")

        if Code.ensure_loaded?(:json) do
          refute body =~ ~r/\{:json_polyfill,/
        else
          assert body =~ ~r/\{:json_polyfill,\s*"~> 0\.2 or ~> 1\.0"\}/
        end
      end)
    end
  end

  describe "patch_live_view_for_lang/3" do
    test "inserts on_mount Hooks.Layout when lang is true" do
      in_tmp(:patch_live_view_lang, fn ->
        File.mkdir_p!("lib")
        File.write!("lib/my_app_web.ex", @stock_web_with_live_view)

        Patches.patch_live_view_for_lang(File.cwd!(), MyAppWeb, lang: true)
        body = File.read!("lib/my_app_web.ex")

        assert body =~ "use Phoenix.LiveView"
        assert body =~ "on_mount MyAppWeb.Hooks.Layout"
        refute body =~ ~r/use Phoenix\.LiveView,\s*on_mount:/
      end)
    end

    test "is idempotent" do
      in_tmp(:patch_live_view_lang_idem, fn ->
        File.mkdir_p!("lib")
        File.write!("lib/my_app_web.ex", @stock_web_with_live_view)

        Patches.patch_live_view_for_lang(File.cwd!(), MyAppWeb, lang: true)
        Patches.patch_live_view_for_lang(File.cwd!(), MyAppWeb, lang: true)

        body = File.read!("lib/my_app_web.ex")

        assert length(String.split(body, "on_mount MyAppWeb.Hooks.Layout")) == 2
      end)
    end

    test "does not modify when lang is false" do
      in_tmp(:patch_live_view_no_lang, fn ->
        File.mkdir_p!("lib")
        File.write!("lib/my_app_web.ex", @stock_web_with_live_view)

        Patches.patch_live_view_for_lang(File.cwd!(), MyAppWeb, [])
        body = File.read!("lib/my_app_web.ex")
        assert body == @stock_web_with_live_view
      end)
    end

    test "normalizes use Phoenix.LiveView, on_mount: [...] to a following on_mount line" do
      with_option = """
      defmodule MyAppWeb do
        def live_view do
          quote do
            use Phoenix.LiveView, on_mount: [MyAppWeb.Hooks.Layout]

            unquote(html_helpers())
          end
        end

        defp html_helpers do
          quote do
          end
        end
      end
      """

      in_tmp(:patch_live_view_option_form, fn ->
        File.mkdir_p!("lib")
        File.write!("lib/my_app_web.ex", with_option)

        Patches.patch_live_view_for_lang(File.cwd!(), MyAppWeb, lang: true)
        body = File.read!("lib/my_app_web.ex")

        assert body =~ "use Phoenix.LiveView\n"
        assert body =~ "on_mount MyAppWeb.Hooks.Layout"
        refute body =~ ~r/use Phoenix\.LiveView,\s*on_mount:/
      end)
    end
  end

  describe "patch_web_module/2" do
    test "adds `use Corex` in html_helpers once" do
      in_tmp(:patch_web_module, fn ->
        File.mkdir_p!("lib")
        File.write!("lib/my_app_web.ex", @stock_web_ex)

        Patches.patch_web_module(File.cwd!(), MyAppWeb)
        body = File.read!("lib/my_app_web.ex")
        assert body =~ "use Corex"

        Patches.patch_web_module(File.cwd!(), MyAppWeb)
        body2 = File.read!("lib/my_app_web.ex")
        assert length(String.split(body2, "use Corex")) == 2
      end)
    end
  end

  describe "patch_router/3" do
    test "inserts mode/theme plugs and locale scope when flags enabled (no path plug)" do
      in_tmp(:patch_router_all, fn ->
        File.mkdir_p!("lib/my_app_web")
        File.write!("lib/my_app_web/router.ex", @stock_router_ex)

        Patches.patch_router(File.cwd!(), MyAppWeb, mode: true, theme: true, lang: true)
        body = File.read!("lib/my_app_web/router.ex")

        assert body =~ "plug MyAppWeb.Plugs.Mode"
        assert body =~ "plug MyAppWeb.Plugs.Theme"
        refute body =~ "plug MyAppWeb.Plugs.Path"
        assert body =~ "use Localize.Routes"
        assert body =~ "Localize.Plug.PutLocale"
        assert body =~ ~s(scope "/:locale")
      end)
    end

    test "is idempotent" do
      in_tmp(:patch_router_idempotent, fn ->
        File.mkdir_p!("lib/my_app_web")
        File.write!("lib/my_app_web/router.ex", @stock_router_ex)

        Patches.patch_router(File.cwd!(), MyAppWeb, mode: true)
        Patches.patch_router(File.cwd!(), MyAppWeb, mode: true)

        body = File.read!("lib/my_app_web/router.ex")
        assert length(String.split(body, "plug MyAppWeb.Plugs.Mode")) == 2
      end)
    end

    test "does not modify router when no feature flags" do
      in_tmp(:patch_router_noop, fn ->
        File.mkdir_p!("lib/my_app_web")
        File.write!("lib/my_app_web/router.ex", @stock_router_ex)

        Patches.patch_router(File.cwd!(), MyAppWeb, [])
        body = File.read!("lib/my_app_web/router.ex")
        assert body == @stock_router_ex
      end)
    end
  end

  describe "patch_endpoint/3" do
    test "inserts Corex.MCP after Plug.Static when mcp is true" do
      in_tmp(:patch_endpoint_mcp, fn ->
        File.mkdir_p!("lib/my_app_web")
        File.write!("lib/my_app_web/endpoint.ex", @stock_endpoint_ex)

        Patches.patch_endpoint(File.cwd!(), MyAppWeb, mcp: true)
        body = File.read!("lib/my_app_web/endpoint.ex")

        assert body =~
                 "raise_on_missing_only: code_reloading?\n\n  if Mix.env() in [:dev, :test] do\n    plug Corex.MCP"

        assert body =~ "plug Corex.MCP"
      end)
    end

    test "is idempotent" do
      in_tmp(:patch_endpoint_idempotent, fn ->
        File.mkdir_p!("lib/my_app_web")
        File.write!("lib/my_app_web/endpoint.ex", @stock_endpoint_ex)

        Patches.patch_endpoint(File.cwd!(), MyAppWeb, mcp: true)
        Patches.patch_endpoint(File.cwd!(), MyAppWeb, mcp: true)

        body = File.read!("lib/my_app_web/endpoint.ex")
        assert length(String.split(body, "plug Corex.MCP")) == 2
      end)
    end

    test "does not modify endpoint when mcp is false" do
      in_tmp(:patch_endpoint_no_mcp, fn ->
        File.mkdir_p!("lib/my_app_web")
        File.write!("lib/my_app_web/endpoint.ex", @stock_endpoint_ex)

        Patches.patch_endpoint(File.cwd!(), MyAppWeb, mcp: false)
        body = File.read!("lib/my_app_web/endpoint.ex")
        assert body == @stock_endpoint_ex
      end)
    end
  end

  describe "patch_config_exs/2" do
    test "adds esbuild ESM flags and /js outdir" do
      in_tmp(:patch_config_esbuild, fn ->
        File.mkdir_p!("config")
        File.write!("config/config.exs", @stock_config_exs)

        Patches.patch_config_exs(File.cwd!(), otp_app: :my_app)
        body = File.read!("config/config.exs")
        assert body =~ "--format=esm"
        assert body =~ "--splitting"
        assert body =~ "--outdir=../priv/static/assets/js"
      end)
    end

    test "adds themes and localize config when flags enabled" do
      in_tmp(:patch_config_themes_lang, fn ->
        File.mkdir_p!("config")
        File.write!("config/config.exs", @stock_config_exs)

        Patches.patch_config_exs(
          File.cwd!(),
          otp_app: :my_app,
          theme: true,
          themes: ["neo", "uno"],
          lang: true
        )

        body = File.read!("config/config.exs")
        assert body =~ ~s(themes: ["neo", "uno"])
        assert body =~ "config :localize"
        assert body =~ "default_locale: :en"
        assert body =~ "supported_locales: [:en, :ar]"
      end)
    end

    test "adds config :designex when designex: true" do
      in_tmp(:patch_config_designex, fn ->
        File.mkdir_p!("config")
        File.write!("config/config.exs", @stock_config_exs)

        Patches.patch_config_exs(File.cwd!(), otp_app: :my_app, designex: true)
        body = File.read!("config/config.exs")
        assert body =~ "config :designex"
        assert body =~ ~s(version: "1.0.2")
        assert body =~ ~s(commit: "1da4b31")
        assert body =~ ~s(dir: "corex")
        assert body =~ "--dir=design --script=build.mjs --tokens=tokens"

        Patches.patch_config_exs(File.cwd!(), otp_app: :my_app, designex: true)
        body2 = File.read!("config/config.exs")
        assert Regex.scan(~r/config :designex/, body2) |> length() == 1
      end)
    end
  end
end
