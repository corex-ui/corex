defmodule Corex.New.PhxWrapperTest do
  use ExUnit.Case, async: false

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

    test "never emits --no-live, --no-html, --no-esbuild, --no-assets" do
      argv =
        PhxWrapper.build_phx_new_argv(
          [design: false, tailwind: false, ecto: false, database: "postgres"],
          "/tmp/x"
        )

      refute "--no-live" in argv
      refute "--no-html" in argv
      refute "--no-esbuild" in argv
      refute "--no-assets" in argv
    end

    test "includes --no-tailwind only when design off and tailwind off" do
      argv = PhxWrapper.build_phx_new_argv([design: false, tailwind: false], "/tmp/x")
      assert "--no-tailwind" in argv
    end

    test "omits --no-tailwind when design on even if tailwind off" do
      argv = PhxWrapper.build_phx_new_argv([design: true, tailwind: false], "/tmp/x")
      refute "--no-tailwind" in argv
    end

    test "omits --no-tailwind when design off and tailwind on" do
      argv = PhxWrapper.build_phx_new_argv([design: false, tailwind: true], "/tmp/x")
      refute "--no-tailwind" in argv
    end
  end

  describe "project paths" do
    test "phx_project_path/2 returns umbrella path when umbrella is true" do
      path = PhxWrapper.phx_project_path("/tmp/my_app", umbrella: true)
      assert path == "/tmp/my_app_umbrella"
    end

    test "web_project_path/2 returns inner web app for umbrellas" do
      path = PhxWrapper.web_project_path("/tmp/foo_umbrella", umbrella: true)
      assert path == "/tmp/foo_umbrella/apps/foo_web"
    end

    test "web_project_path/2 returns phx root for standard apps" do
      path = PhxWrapper.web_project_path("/tmp/my_app", [])
      assert path == "/tmp/my_app"
    end
  end

  describe "port_cmd_stream!/2" do
    test "runs mix --version in the given directory" do
      Corex.New.MixHelper.in_tmp("port mix version", fn ->
        assert :ok = PhxWrapper.port_cmd_stream!(["--version"], File.cwd!())
      end)
    end

    test "raises when mix exits with a non-zero status" do
      Corex.New.MixHelper.in_tmp("port mix fail", fn ->
        Corex.New.MixHelper.with_fake_mix!(fn ->
          assert_raise Mix.Error, ~r/failed \(exit 2/, fn ->
            PhxWrapper.port_cmd_stream!(["anything"], File.cwd!())
          end
        end)
      end)
    end
  end

  describe "ensure_phx_new!/0" do
    test "returns ok when phx.new is available" do
      case System.cmd("mix", ["help", "phx.new"], stderr_to_stdout: true) do
        {_, 0} -> assert :ok = PhxWrapper.ensure_phx_new!()
        _ -> :ok
      end
    end

    test "raises when mix exits with an error" do
      Corex.New.MixHelper.in_tmp("fake mix", fn ->
        bin = Path.join(File.cwd!(), "bin")
        File.mkdir_p!(bin)
        mix = Path.join(bin, "mix")
        File.write!(mix, "#!/bin/sh\necho 'phx_new missing'\nexit 1\n")
        File.chmod!(mix, 0o755)

        previous = System.get_env("PATH")

        try do
          System.put_env("PATH", "#{bin}:#{previous}")

          assert_raise Mix.Error, ~r/phx_new missing/, fn ->
            PhxWrapper.ensure_phx_new!()
          end
        after
          if previous, do: System.put_env("PATH", previous), else: System.delete_env("PATH")
        end
      end)
    end
  end

  describe "pty_cmd_stream!/2" do
    test "runs mix via the pty shim" do
      Corex.New.MixHelper.in_tmp("pty mix version", fn ->
        Corex.New.MixHelper.write_minimal_mix!()
        assert :ok = PhxWrapper.pty_cmd_stream!(["--version"], File.cwd!())
      end)
    end

    test "raises when mix exits with a non-zero status" do
      Corex.New.MixHelper.in_tmp("pty mix fail", fn ->
        Corex.New.MixHelper.with_fake_mix!(fn ->
          assert_raise Mix.Error, ~r/failed \(exit 2/, fn ->
            PhxWrapper.pty_cmd_stream!(["anything"], File.cwd!())
          end
        end)
      end)
    end
  end

  describe "run_deps_get!/1" do
    test "runs mix deps.get in the project directory" do
      Corex.New.MixHelper.in_tmp("deps get", fn ->
        Corex.New.MixHelper.write_minimal_mix!()

        assert :ok = PhxWrapper.run_deps_get!(File.cwd!())
      end)
    end
  end

  describe "build_phx_new_argv/2 extra flags" do
    test "forwards umbrella, gettext, and dashboard flags" do
      argv =
        PhxWrapper.build_phx_new_argv(
          [umbrella: true, gettext: false, dashboard: false, prefix: "api"],
          "/tmp/x"
        )

      assert "--umbrella" in argv
      assert "--no-gettext" in argv
      assert "--no-dashboard" in argv
      assert Enum.at(argv, Enum.find_index(argv, &(&1 == "--prefix")) + 1) == "api"
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
