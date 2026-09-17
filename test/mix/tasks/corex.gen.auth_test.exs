defmodule Mix.Tasks.Corex.Gen.AuthTest do
  use ExUnit.Case, async: false

  import MixGenHelpers

  alias Mix.Corex.Gen.Auth, as: GenAuth

  test "run/1 raises on --no-live" do
    assert_raise Mix.Error, ~r/LiveView-only/, fn ->
      run_generator("corex.gen.auth", ["Accounts", "User", "users", "--no-live", "--no-compile"])
    end
  end

  test "run/1 raises without context/schema/table" do
    assert_raise Mix.Error, ~r/Invalid arguments/, fn ->
      run_generator("corex.gen.auth", ["Accounts", "--no-compile"])
    end
  end

  test "run/1 generates Corex LiveView auth markup" do
    with_test_output(fn tmp ->
      n = System.unique_integer([:positive])
      schema = "AuthUser#{n}"
      singular = Phoenix.Naming.underscore(schema)
      plural = singular <> "s"

      run_generator("corex.gen.auth", [
        "AuthAccounts#{n}",
        schema,
        plural,
        "--no-compile"
      ])

      login = File.read!(Path.join([tmp, "web/live", "#{singular}_live", "login.ex"]))

      registration =
        File.read!(Path.join([tmp, "web/live", "#{singular}_live", "registration.ex"]))

      settings = File.read!(Path.join([tmp, "web/live", "#{singular}_live", "settings.ex"]))

      confirmation =
        File.read!(Path.join([tmp, "web/live", "#{singular}_live", "confirmation.ex"]))

      for page <- [login, registration, settings, confirmation] do
        assert page =~ "native_input" or page =~ "layout_heading" or page =~ "action"
        refute page =~ "core_components"
        refute page =~ "btn btn-primary"
        refute page =~ "<.header>"
        refute page =~ "<.input"
      end

      assert login =~ "password_input"
      assert login =~ ~S(class="button ui-accent)
      assert registration =~ "native_input"
      assert settings =~ "password_input"
      assert confirmation =~ ~S(class="button ui-accent)

      schema_file = File.read!(Path.join(tmp, "#{singular}.ex"))
      assert schema_file =~ "Bcrypt.hash_pwd_salt"
      assert File.exists?(Path.join(tmp, "#{singular}_token.ex"))

      login_test =
        File.read!(Path.join([tmp, "test/live", "#{singular}_live", "login_test.exs"]))

      assert login_test =~ ~S(id="login_form_magic_email-input")
      refute login_test =~ ~S(id="login_form_magic_email" value=)
    end)
  end

  test "run/1 with --hashing-lib pbkdf2 uses Pbkdf2 in the schema" do
    with_test_output(fn tmp ->
      n = System.unique_integer([:positive])
      schema = "AuthHash#{n}"
      singular = Phoenix.Naming.underscore(schema)
      plural = singular <> "s"

      run_generator("corex.gen.auth", [
        "AuthHashAccounts#{n}",
        schema,
        plural,
        "--hashing-lib",
        "pbkdf2",
        "--no-compile"
      ])

      schema_file = File.read!(Path.join(tmp, "#{singular}.ex"))
      assert schema_file =~ "Pbkdf2.hash_pwd_salt"
      assert schema_file =~ "Pbkdf2.verify_pass"
      refute schema_file =~ "Bcrypt."
    end)
  end

  test "run/1 raises on unknown --hashing-lib" do
    assert_raise Mix.Error, ~r/hashing-lib/, fn ->
      run_generator("corex.gen.auth", [
        "Accounts",
        "User",
        "users",
        "--hashing-lib",
        "md5",
        "--no-compile"
      ])
    end
  end

  test "run/1 with locale layout prints locale-scoped route instructions" do
    with_test_output(fn tmp ->
      prev = Application.get_env(:corex, :generators)
      Application.put_env(:corex, :generators, layout: [locale: true, mode: true, theme: true])

      try do
        n = System.unique_integer([:positive])
        schema = "AuthLocale#{n}"
        singular = Phoenix.Naming.underscore(schema)
        plural = singular <> "s"

        output =
          run_generator(
            "corex.gen.auth",
            ["AuthLocaleAccounts#{n}", schema, plural, "--no-compile"],
            loud: true
          )

        assert output =~ "locale"
        assert output =~ ~S(scope "/:locale")
        login = File.read!(Path.join([tmp, "web/live", "#{singular}_live", "login.ex"]))
        assert login =~ "current_path={@current_path}"
        assert login =~ "mode={@mode}"
      after
        case prev do
          nil -> Application.delete_env(:corex, :generators)
          val -> Application.put_env(:corex, :generators, val)
        end
      end
    end)
  end

  test "layout_menu_code uses Corex navigate" do
    schema = %{route_prefix: "/users", singular: "user"}
    scope_config = %{scope: %{assign_key: :current_scope}}

    {_dup, code} =
      GenAuth.layout_menu_code(
        context: nil,
        schema: schema,
        scope_config: scope_config
      )

    assert code =~ "navigate"
    assert code =~ "log-in"
    refute code =~ "menu menu-horizontal"
    refute code =~ "<.link"
  end

  test "inject_layout_menu indents account nav as a header child" do
    schema = %{route_prefix: "/users", singular: "user"}
    scope_config = %{scope: %{assign_key: :current_scope}}

    layout = "      </div>\n    </header>\n"

    injected =
      case GenAuth.inject_layout_menu(
             [context: nil, schema: schema, scope_config: scope_config],
             layout
           ) do
        {:ok, content} -> content
        other -> flunk("expected {:ok, content}, got: #{inspect(other)}")
      end

    assert injected =~ ~r/^      <nav /m
    assert injected =~ ~r/^    <\/header>/m
    refute injected =~ ~r/^              <nav /m
  end

  test "inject_layout_scope_assign adds current_scope to Layouts.app" do
    injected =
      case GenAuth.inject_layout_scope_assign(
             "<Layouts.app\n  flash={@flash}\n  mode={@mode}>\n",
             :current_scope
           ) do
        {:ok, content} -> content
        other -> flunk("expected {:ok, content}, got: #{inspect(other)}")
      end

    assert injected =~ "flash={@flash}\n  current_scope={@current_scope}\n"

    assert :already_injected =
             GenAuth.inject_layout_scope_assign(injected, :current_scope)
  end

  test "inject_auth_routes splices into scope /:locale after the locale home route" do
    wrapped = """

      ## Authentication routes

      scope "/", Try2Web do
        pipe_through [:browser, :require_authenticated_client]

        live_session :require_authenticated_client,
          on_mount: [{Try2Web.ClientAuth, :require_authenticated}] do
          live "/clients/settings", ClientLive.Settings, :edit
        end

        post "/clients/update-password", ClientSessionController, :update_password
      end

      scope "/", Try2Web do
        pipe_through [:browser]

        live_session :current_client,
          on_mount: [{Try2Web.ClientAuth, :mount_current_scope}] do
          live "/clients/log-in", ClientLive.Login, :new
        end
      end
    """

    inner = """
        live_session :current_client,
          on_mount: [{Try2Web.ClientAuth, :mount_current_scope}] do
          live "/clients/log-in", ClientLive.Login, :new
        end

        post "/clients/log-in", ClientSessionController, :create

        scope "/" do
          pipe_through [:require_authenticated_client]

          live_session :require_authenticated_client,
            on_mount: [{Try2Web.ClientAuth, :require_authenticated}] do
            live "/clients/settings", ClientLive.Settings, :edit
          end

          post "/clients/update-password", ClientSessionController, :update_password
        end
    """

    injected =
      case GenAuth.inject_auth_routes(try2_router(), wrapped, inner) do
        {:ok, content} -> content
        other -> flunk("expected {:ok, content}, got: #{inspect(other)}")
      end

    {unprefixed, locale} = locale_scope_halves(injected)

    refute unprefixed =~ "live \"/clients/log-in\""
    refute unprefixed =~ "pipe_through [:require_authenticated_client]"
    assert locale =~ "live \"/clients/log-in\""
    assert locale =~ "pipe_through [:require_authenticated_client]"
    assert locale =~ "post \"/clients/update-password\""

    refute injected =~
             ~r/scope "\/", Try2Web do\n\s+pipe_through \[:browser, :require_authenticated_client\]/

    assert :already_injected = GenAuth.inject_auth_routes(injected, wrapped, inner)
  end

  test "inject_auth_routes appends wrapped scopes when there is no locale scope" do
    router = """
    defmodule AppWeb.Router do
      use AppWeb, :router

      scope "/", AppWeb do
        pipe_through :browser

        get "/", PageController, :home
      end
    end
    """

    wrapped = """

      ## Authentication routes

      scope "/", AppWeb do
        pipe_through [:browser]

        live_session :current_user,
          on_mount: [{AppWeb.UserAuth, :mount_current_scope}] do
          live "/users/log-in", UserLive.Login, :new
        end
      end
    """

    injected =
      case GenAuth.inject_auth_routes(router, wrapped, "    live \"/users/log-in\"\n") do
        {:ok, content} -> content
        other -> flunk("expected {:ok, content}, got: #{inspect(other)}")
      end

    assert injected =~ ~S(scope "/", AppWeb do)
    assert injected =~ "## Authentication routes"
    assert injected =~ ~S(live "/users/log-in")
    refute injected =~ ~S(scope "/:locale")
  end

  test "inject_auth_routes falls back to sibling locale scopes without a home route" do
    router = """
    defmodule AppWeb.Router do
      use AppWeb, :router

      scope "/:locale", AppWeb do
        pipe_through :browser

        live "/dashboard", DashboardLive
      end
    end
    """

    wrapped = """

      ## Authentication routes

      scope "/", AppWeb do
        pipe_through [:browser]

        live_session :current_user,
          on_mount: [{AppWeb.UserAuth, :mount_current_scope}] do
          live "/users/log-in", UserLive.Login, :new
        end
      end
    """

    inner = """
        live_session :current_user,
          on_mount: [{AppWeb.UserAuth, :mount_current_scope}] do
          live "/users/log-in", UserLive.Login, :new
        end
    """

    injected =
      case GenAuth.inject_auth_routes(router, wrapped, inner) do
        {:ok, content} -> content
        other -> flunk("expected {:ok, content}, got: #{inspect(other)}")
      end

    assert injected =~ ~S(scope "/:locale", AppWeb do)
    assert injected =~ ~S(live "/users/log-in")

    refute injected =~
             ~r/scope "\/", AppWeb do\n\s+pipe_through \[:browser\]\n\s+live_session :current_user/
  end

  defp try2_router do
    """
    defmodule Try2Web.Router do
      use Try2Web, :router

      import Try2Web.ClientAuth

      use Localize.Routes, gettext: Try2Web.Gettext, helpers: false

      pipeline :browser do
        plug :accepts, ["html"]
        plug :fetch_session
        plug :fetch_live_flash
        plug :protect_from_forgery
        plug :put_secure_browser_headers
        plug :fetch_current_scope_for_client
      end

      scope "/", Try2Web do
        pipe_through :browser

        get "/", PageController, :home
      end

      scope "/:locale", Try2Web do
        pipe_through :browser

        get "/", PageController, :home
      end
    end
    """
  end

  defp locale_scope_halves(router) do
    case String.split(router, ~S(scope "/:locale"), parts: 2) do
      [unprefixed, locale] -> {unprefixed, locale}
      _ -> flunk("expected a scope \"/:locale\" in injected router")
    end
  end
end
