defmodule Corex.New.ScaffoldHelper do
  @moduledoc false

  @stock_web_ex """
  defmodule MyAppWeb do
    def html do
      quote do
        use Phoenix.Component
        unquote(html_helpers())
      end
    end

    def live_view do
      quote do
        use Phoenix.LiveView
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

    scope "/", MyAppWeb do
      pipe_through :browser
      get "/", PageController, :home
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
      websocket: [connect_info: [session: @session_options]]

    plug Plug.Static,
      at: "/",
      from: :my_app,
      gzip: false,
      only: MyAppWeb.static_paths()

    plug MyAppWeb.Router
  end
  """

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

  @stock_config_exs ~S"""
  import Config

  config :my_app,
    ecto_repos: [MyApp.Repo],
    generators: [timestamp_type: :utc_datetime]

  import_config "#{config_env()}.exs"
  """

  def write_phoenix_scaffold!(install_dir) do
    File.mkdir_p!(Path.join(install_dir, "lib/my_app_web"))
    File.mkdir_p!(Path.join(install_dir, "config"))
    File.mkdir_p!(Path.join(install_dir, "assets/js"))
    File.mkdir_p!(Path.join(install_dir, "assets/css"))
    File.mkdir_p!(Path.join(install_dir, "test"))

    File.write!(Path.join(install_dir, "lib/my_app_web.ex"), @stock_web_ex)
    File.write!(Path.join(install_dir, "lib/my_app_web/router.ex"), @stock_router_ex)
    File.write!(Path.join(install_dir, "lib/my_app_web/endpoint.ex"), @stock_endpoint_ex)
    File.write!(Path.join(install_dir, "mix.exs"), @stock_mix_exs)
    File.write!(Path.join(install_dir, "config/config.exs"), @stock_config_exs)
    File.write!(Path.join(install_dir, "assets/js/app.js"), "// app\n")
    File.write!(Path.join(install_dir, "assets/css/app.css"), "/* css */\n")

    home =
      Path.join([
        install_dir,
        "lib/my_app_web/controllers/page_html/home.html.heex"
      ])

    File.mkdir_p!(Path.dirname(home))
    File.write!(home, "<!-- home -->\n")

    test_file = Path.join(install_dir, "test/my_app_web/controllers/page_controller_test.exs")
    File.mkdir_p!(Path.dirname(test_file))
    File.write!(test_file, "defmodule MyAppWeb.PageControllerTest do\n  use ExUnit.Case\nend\n")
  end

  def base_generate_opts(overrides \\ []) do
    Keyword.merge(
      [
        otp_app: :my_app,
        web_module: MyAppWeb,
        app_module: MyApp,
        mode: false,
        theme: false,
        lang: false,
        design: true,
        tailwind: true,
        mcp: true
      ],
      overrides
    )
  end

  def corex_repo_root do
    Path.expand("../../..", __DIR__)
  end
end
