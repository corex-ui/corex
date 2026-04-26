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

  test "verify_corex_esbuild_after_igniter! raises when igniter marks corex.install failed" do
    out = "compiling corex ✔\n`corex.install` x\n"

    assert_raise Mix.Error, ~r/corex\.install/, fn ->
      PhxWrapper.verify_corex_esbuild_after_igniter!("/nonexistent/install", out)
    end
  end

  test "IgniterArgv.to_argv passes --corex.no-mcp and --corex.no-skills" do
    alias Corex.New.IgniterArgv

    assert IgniterArgv.to_argv(mcp: false, skills: false) == [
             "--corex.no-mcp",
             "--corex.no-skills"
           ]

    assert IgniterArgv.to_argv(mcp: true, skills: true) == []
  end

  test "igniter_trailing_for_new appends Corex flags" do
    assert PhxWrapper.igniter_trailing_for_new("phx-new", ["--corex.replace", "--corex.mode"]) == [
             "--yes",
             "--yes-to-deps",
             "--from-igniter-new",
             "--new-with",
             "phx-new",
             "--corex.replace",
             "--corex.mode"
           ]
  end

  test "phx_new_content_flags passes Phoenix content flags" do
    o =
      PhxWrapper.phx_new_content_flags(
        no_version_check: true,
        assets: false,
        esbuild: false,
        tailwind: false,
        gettext: false,
        html: false,
        skills: false
      )

    assert o == [
             "--no-version-check",
             "--no-assets",
             "--no-esbuild",
             "--no-tailwind",
             "--no-gettext",
             "--no-html",
             "--no-agents-md"
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

  test "verify_corex_esbuild_after_igniter! raises on Igniter Issues block for missing file" do
    out = """
    Issues:

    * Required lib/foo but it did not exist
    """

    assert_raise Mix.Error, ~r/corex\.install/, fn ->
      PhxWrapper.verify_corex_esbuild_after_igniter!("/nonexistent/install", out)
    end
  end
end
