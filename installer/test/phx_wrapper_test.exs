defmodule Corex.New.PhxWrapperTest do
  use ExUnit.Case, async: true

  alias Corex.New.PhxWrapper

  test "corex_igniter_install_target without --dev_corex is hex package name" do
    assert PhxWrapper.corex_igniter_install_target([]) == "corex"
  end

  test "corex_igniter_install_target with --dev_corex path" do
    assert PhxWrapper.corex_igniter_install_target(dev_corex: "../corex") == "corex@path:../corex"
    assert PhxWrapper.corex_igniter_install_target(dev_corex: "../../corex") == "corex@path:../../corex"
  end

  test "corex_igniter_install_target trims dev_corex path" do
    assert PhxWrapper.corex_igniter_install_target(dev_corex: "  ../corex  ") == "corex@path:../corex"
  end

  test "corex_igniter_install_target normalizes backslashes in path" do
    assert PhxWrapper.corex_igniter_install_target(dev_corex: "..\\corex") == "corex@path:../corex"
  end

  test "IgniterArgv.to_argv passes --corex.no-mcp when mcp is false" do
    alias Corex.New.IgniterArgv

    assert IgniterArgv.to_argv(mcp: false) == [
             "--corex.no-mcp"
           ]

    assert IgniterArgv.to_argv(mcp: true) == []
  end

  test "phx_new_content_flags passes Phoenix content flags" do
    o =
      PhxWrapper.phx_new_content_flags(
        no_version_check: true,
        assets: false,
        esbuild: false,
        tailwind: false,
        gettext: false,
        html: false
      )

    assert o == [
             "--no-version-check",
             "--no-assets",
             "--no-esbuild",
             "--no-tailwind",
             "--no-gettext",
             "--no-html"
           ]
  end

  test "igniter_install_yes_argv is --yes and --yes-to-deps by default" do
    in_fixture_env(fn ->
      System.delete_env("MIX_COREX_IGNITER_INTERACTIVE")
      System.delete_env("CI")
      assert PhxWrapper.igniter_install_yes_argv() == ["--yes", "--yes-to-deps"]
    end)
  end

  test "igniter_install_yes_argv omits --yes with MIX_COREX_IGNITER_INTERACTIVE=1 and no CI" do
    in_fixture_env(fn ->
      System.put_env("MIX_COREX_IGNITER_INTERACTIVE", "1")
      System.delete_env("CI")
      assert PhxWrapper.igniter_install_yes_argv() == []
    end)
  end

  test "igniter_install_yes_argv still uses --yes in CI" do
    in_fixture_env(fn ->
      System.put_env("MIX_COREX_IGNITER_INTERACTIVE", "1")
      System.put_env("CI", "1")
      assert PhxWrapper.igniter_install_yes_argv() == ["--yes", "--yes-to-deps"]
    end)
  end

  test "igniter_new_yes_argv is just --yes by default (igniter.new auto-forwards --yes-to-deps)" do
    in_fixture_env(fn ->
      System.delete_env("MIX_COREX_IGNITER_INTERACTIVE")
      System.delete_env("CI")
      assert PhxWrapper.igniter_new_yes_argv() == ["--yes"]
    end)
  end

  test "igniter_new_yes_argv omits --yes with MIX_COREX_IGNITER_INTERACTIVE=1 and no CI" do
    in_fixture_env(fn ->
      System.put_env("MIX_COREX_IGNITER_INTERACTIVE", "1")
      System.delete_env("CI")
      assert PhxWrapper.igniter_new_yes_argv() == []
    end)
  end

  test "build_with_args_string joins phx flags with spaces and POSIX-quotes risky values" do
    assert PhxWrapper.build_with_args_string([]) == ""

    assert PhxWrapper.build_with_args_string(["--no-ecto", "--no-html"]) ==
             "--no-ecto --no-html"

    assert PhxWrapper.build_with_args_string(["--app", "my_app", "--module", "MyApp"]) ==
             "--app my_app --module MyApp"

    assert PhxWrapper.build_with_args_string(["--with spaces"]) == "'--with spaces'"

    assert PhxWrapper.build_with_args_string(["it's"]) == "'it'\\''s'"
  end

  test "build_igniter_new_argv produces igniter.new command with --install/--with/--with-args" do
    in_fixture_env(fn ->
      System.delete_env("MIX_COREX_IGNITER_INTERACTIVE")
      System.delete_env("CI")

      argv =
        PhxWrapper.build_igniter_new_argv(
          "/tmp/my_app",
          "corex",
          "phx.new",
          "--no-ecto --no-html",
          ["--corex.lang", "--corex.replace"]
        )

      assert argv == [
               "igniter.new",
               "/tmp/my_app",
               "--install",
               "corex",
               "--with",
               "phx.new",
               "--with-args",
               "--no-ecto --no-html",
               "--yes",
               "--no-installer-version-check",
               "--corex.lang",
               "--corex.replace"
             ]
    end)
  end

  test "build_igniter_new_argv omits --with-args when empty" do
    in_fixture_env(fn ->
      System.delete_env("MIX_COREX_IGNITER_INTERACTIVE")
      System.delete_env("CI")

      argv =
        PhxWrapper.build_igniter_new_argv(
          "/tmp/my_app",
          "corex@path:../corex",
          "phx.new",
          "",
          []
        )

      assert argv == [
               "igniter.new",
               "/tmp/my_app",
               "--install",
               "corex@path:../corex",
               "--with",
               "phx.new",
               "--yes",
               "--no-installer-version-check"
             ]
    end)
  end

  test "build_igniter_new_argv accepts phx.new.web for --with" do
    in_fixture_env(fn ->
      System.delete_env("MIX_COREX_IGNITER_INTERACTIVE")
      System.delete_env("CI")

      argv =
        PhxWrapper.build_igniter_new_argv(
          "my_web",
          "corex",
          "phx.new.web",
          "--no-ecto",
          []
        )

      assert "--with" in argv
      assert "phx.new.web" in argv
      assert Enum.at(argv, Enum.find_index(argv, &(&1 == "--with")) + 1) == "phx.new.web"
    end)
  end

  test "shell_quote leaves safe arguments untouched" do
    assert PhxWrapper.shell_quote("--no-ecto") == "--no-ecto"
    assert PhxWrapper.shell_quote("/tmp/foo_bar.baz") == "/tmp/foo_bar.baz"
    assert PhxWrapper.shell_quote("corex@path:../corex") == "corex@path:../corex"
  end

  test "shell_quote single-quotes args containing whitespace or shell metacharacters" do
    assert PhxWrapper.shell_quote("a b") == "'a b'"
    assert PhxWrapper.shell_quote("a;b") == "'a;b'"
    assert PhxWrapper.shell_quote("a$b") == "'a$b'"
  end

  test "shell_quote escapes embedded single quotes" do
    assert PhxWrapper.shell_quote("it's") == "'it'\\''s'"
  end

  test "shell_join joins arguments with safe quoting" do
    assert PhxWrapper.shell_join(["mix", "igniter.new", "/tmp/x", "--with-args", "--no-ecto --no-html"]) ==
             "mix igniter.new /tmp/x --with-args '--no-ecto --no-html'"
  end

  defp in_fixture_env(fun) do
    a = System.get_env("MIX_COREX_IGNITER_INTERACTIVE")
    b = System.get_env("CI")

    on_exit(fn ->
      restore_env("MIX_COREX_IGNITER_INTERACTIVE", a)
      restore_env("CI", b)
    end)

    fun.()
  end

  defp restore_env(key, nil), do: System.delete_env(key)
  defp restore_env(key, v), do: System.put_env(key, v)
end
