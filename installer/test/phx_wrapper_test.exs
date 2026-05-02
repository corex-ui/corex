defmodule Corex.New.PhxWrapperTest do
  use ExUnit.Case, async: true

  alias Corex.New.PhxWrapper

  describe "build_phx_new_argv/2" do
    test "always appends --no-install" do
      argv = PhxWrapper.build_phx_new_argv([], "/tmp/my_app")
      assert "--no-install" in argv
      assert List.last(argv) == "/tmp/my_app"
    end

    test "forwards --no-ecto, --no-version-check, --database" do
      opts = [ecto: false, no_version_check: true, database: "sqlite3"]
      argv = PhxWrapper.build_phx_new_argv(opts, "/tmp/x")

      assert "--no-ecto" in argv
      assert "--no-version-check" in argv
      assert Enum.at(argv, Enum.find_index(argv, &(&1 == "--database")) + 1) == "sqlite3"
    end

    test "includes --app, --module, --web-module when provided" do
      opts = [app: "foo", module: "Bar", web_module: "BarWeb"]
      argv = PhxWrapper.build_phx_new_argv(opts, "/tmp/x")

      assert "--app" in argv
      assert "foo" in argv
      assert "--module" in argv
      assert "Bar" in argv
      assert "--web-module" in argv
      assert "BarWeb" in argv
    end

    test "does not forward Corex --dev path to phx.new" do
      argv = PhxWrapper.build_phx_new_argv([dev: "../corex"], "/tmp/x")
      refute "--dev" in argv
      refute "../corex" in argv
    end
  end

  describe "shell_quote/1" do
    test "leaves safe characters unquoted" do
      assert PhxWrapper.shell_quote("foo") == "foo"
      assert PhxWrapper.shell_quote("foo/bar") == "foo/bar"
      assert PhxWrapper.shell_quote("foo-bar") == "foo-bar"
    end

    test "quotes strings with spaces or quotes" do
      assert PhxWrapper.shell_quote("foo bar") == "'foo bar'"
      assert PhxWrapper.shell_quote("foo'bar") == "'foo'\\''bar'"
    end
  end
end
