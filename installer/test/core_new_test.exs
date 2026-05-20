defmodule Mix.Tasks.Corex.NewTest do
  use ExUnit.Case, async: false
  import MixHelper
  import ExUnit.CaptureIO

  test "returns the version" do
    Mix.Tasks.Corex.New.run(["-v"])
    assert_received {:mix_shell, :info, ["Corex installer v" <> _]}
  end

  test "returns version with --version" do
    Mix.Tasks.Corex.New.run(["--version"])
    assert_received {:mix_shell, :info, ["Corex installer v" <> _]}
  end

  test "designex conflicts with --no-design" do
    in_tmp("new designex no design", fn ->
      assert_raise Mix.Error, ~r/--designex requires design/, fn ->
        Mix.Tasks.Corex.New.run(["phx_blog", "--no-design", "--designex"])
      end
    end)
  end

  test "new without args shows help" do
    assert capture_io(fn -> Mix.Tasks.Corex.New.run([]) end) =~ "mix phx.new"
  end

  test "new with reserved name" do
    in_tmp("reserved server", fn ->
      assert_raise Mix.Error, ~r/Application name cannot be "server" as it is reserved/, fn ->
        Mix.Tasks.Corex.New.run(["server"])
      end
    end)

    in_tmp("reserved table", fn ->
      assert_raise Mix.Error, ~r/Application name cannot be "table" as it is reserved/, fn ->
        Mix.Tasks.Corex.New.run(["table"])
      end
    end)
  end

  test "new with invalid args" do
    in_tmp("007", fn ->
      assert_raise Mix.Error, ~r"Application name must start with a letter and ", fn ->
        Mix.Tasks.Corex.New.run(["007invalid"])
      end
    end)

    in_tmp("app flag", fn ->
      assert_raise Mix.Error, ~r"Application name must start with a letter and ", fn ->
        Mix.Tasks.Corex.New.run(["valid", "--app", "007invalid"])
      end
    end)

    in_tmp("exInvalid", fn ->
      assert_raise Mix.Error, ~r"Application name must start with a letter and ", fn ->
        Mix.Tasks.Corex.New.run(["exInvalidAppName"])
      end
    end)

    in_tmp("module", fn ->
      assert_raise Mix.Error, ~r"Module name must be a valid Elixir alias", fn ->
        Mix.Tasks.Corex.New.run(["valid", "--module", "not.valid"])
      end
    end)

    in_tmp("string mod", fn ->
      assert_raise Mix.Error, ~r"Module name \w+ is already taken", fn ->
        Mix.Tasks.Corex.New.run(["string"])
      end
    end)

    in_tmp("mix app", fn ->
      assert_raise Mix.Error, ~r"Module name \w+ is already taken", fn ->
        Mix.Tasks.Corex.New.run(["valid", "--app", "mix"])
      end
    end)

    in_tmp("String module", fn ->
      assert_raise Mix.Error, ~r"Module name \w+ is already taken", fn ->
        Mix.Tasks.Corex.New.run(["valid", "--module", "String"])
      end
    end)
  end

  test "invalid options" do
    assert_raise OptionParser.ParseError, fn ->
      Mix.Tasks.Corex.New.run(["valid", "-database", "mysql"])
    end
  end

  test "runs hex version check when generating without --no-version-check" do
    if match?({_, 0}, System.cmd("mix", ["help", "phx.new"], stderr_to_stdout: true)) do
      name = "corexver#{:rand.uniform(999_999)}"

      in_tmp("corex new version", fn ->
        send(self(), {:mix_shell_input, :yes?, false})

        capture_io(fn ->
          Mix.Tasks.Corex.New.run([name, "--no-install"])
        end)

        assert File.dir?(Path.join(name, "assets/corex"))
      end)
    end
  end

  test "installs corex into phx.new output when phx_new is available" do
    if match?({_, 0}, System.cmd("mix", ["help", "phx.new"], stderr_to_stdout: true)) do
      name = "corexcov#{:rand.uniform(999_999)}"

      in_tmp("corex new scaffold", fn ->
        send(self(), {:mix_shell_input, :yes?, false})

        capture_io(fn ->
          Mix.Tasks.Corex.New.run([
            name,
            "--no-version-check",
            "--no-install",
            "--mode",
            "--theme",
            "--lang",
            "--designex"
          ])
        end)

        assert File.dir?(Path.join(name, "assets/corex"))
        assert [_ | _] = Path.wildcard(Path.join([name, "lib", "*_web", "plugs", "mode.ex"]))
        assert File.regular?(Path.join(name, "mix.exs"))
        assert [_ | _] = Path.wildcard(Path.join([name, "lib", "**", "layouts.ex"]))
      end)
    end
  end

  @tag :integration
  test "integration: new project with archives" do
    unless match?({_, 0}, System.cmd("mix", ["phx.new", "-v"], stderr_to_stdout: true)) do
      flunk("Install the phx_new archive to run this test. Then: mix test --include integration")
    end

    send(self(), {:mix_shell_input, :yes?, false})

    in_tmp("integration corex new", fn ->
      Mix.Tasks.Corex.New.run(["corex_integration_app", "--no-version-check", "--no-install"])
      assert File.dir?("corex_integration_app")
      assert File.regular?("corex_integration_app/mix.exs")
    end)
  end

  test "umbrella flag is rejected" do
    in_tmp("umbrella", fn ->
      assert_raise Mix.Error, ~r/not supported yet/, fn ->
        Mix.Tasks.Corex.New.run(["my_app", "--umbrella"])
      end
    end)
  end

  test "lang with no-gettext is rejected" do
    in_tmp("lang gettext", fn ->
      assert_raise Mix.Error, ~r/--no-gettext/, fn ->
        Mix.Tasks.Corex.New.run(["my_app", "--lang", "--no-gettext"])
      end
    end)
  end

  test "ecto false is rejected" do
    in_tmp("no ecto", fn ->
      assert_raise Mix.Error, ~r/--no-ecto/, fn ->
        Mix.Tasks.Corex.New.run(["my_app", "--no-ecto"])
      end
    end)
  end

  test "check_directory_existence aborts when user says no" do
    in_tmp("new directory exists", fn ->
      File.mkdir_p!("phx_blog")
      send(self(), {:mix_shell_input, :yes?, false})

      assert_raise Mix.Error, ~r/Please select another directory for installation/, fn ->
        Mix.Tasks.Corex.New.run(["phx_blog", "--no-version-check"])
      end
    end)
  end
end
