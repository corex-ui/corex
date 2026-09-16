defmodule Mix.Tasks.Corex.Gen.AuthTest do
  use ExUnit.Case, async: false

  import MixGenHelpers

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
      assert login =~ ~s(class="button ui-accent)
      assert registration =~ "native_input"
      assert settings =~ "password_input"
      assert confirmation =~ ~s(class="button ui-accent)

      schema_file = File.read!(Path.join(tmp, "#{singular}.ex"))
      assert schema_file =~ "Bcrypt.hash_pwd_salt"
      assert File.exists?(Path.join(tmp, "#{singular}_token.ex"))
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
        assert output =~ ~s(scope "/")
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
      Mix.Corex.Gen.Auth.layout_menu_code(
        context: nil,
        schema: schema,
        scope_config: scope_config
      )

    assert code =~ "navigate"
    assert code =~ "log-in"
    refute code =~ "menu menu-horizontal"
    refute code =~ "<.link"
  end
end
