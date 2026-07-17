defmodule Mix.Tasks.Corex.Tableau.NewTest do
  use ExUnit.Case, async: false

  import Corex.New.MixHelper
  import ExUnit.CaptureIO

  test "prints version with -v" do
    Mix.Tasks.Corex.Tableau.New.run(["-v"])
    assert_received {:mix_shell, :info, [msg]}
    assert msg =~ "Corex installer v"
  end

  test "prints version with --version" do
    Mix.Tasks.Corex.Tableau.New.run(["--version"])
    assert_received {:mix_shell, :info, [msg]}
    assert msg =~ "Corex installer v"
  end

  test "without args shows help" do
    assert capture_io(fn -> Mix.Tasks.Corex.Tableau.New.run([]) end) =~ "corex.tableau.new"
  end

  test "raises when --lang is set" do
    assert_raise Mix.Error, ~r/not available yet/, fn ->
      Mix.Tasks.Corex.Tableau.New.run(["my_blog", "--lang"])
    end
  end

  test "mode conflicts with --no-design" do
    assert_raise Mix.Error, ~r/--mode requires design/, fn ->
      Mix.Tasks.Corex.Tableau.New.run(["my_blog", "--no-design", "--mode"])
    end
  end

  test "theme conflicts with --no-design" do
    assert_raise Mix.Error, ~r/--theme requires design/, fn ->
      Mix.Tasks.Corex.Tableau.New.run(["my_blog", "--no-design", "--theme"])
    end
  end

  test "raises on empty --dev path" do
    assert_raise Mix.Error, ~r/--dev requires a non-empty path/, fn ->
      Mix.Tasks.Corex.Tableau.New.run(["my_blog", "--dev", "  "])
    end
  end

  test "raises on invalid --dev path characters" do
    assert_raise Mix.Error, ~r/invalid characters/, fn ->
      Mix.Tasks.Corex.Tableau.New.run(["my_blog", "--dev", "evil\"path"])
    end
  end

  test "raises on reserved application names" do
    in_tmp("tableau reserved server", fn ->
      assert_raise Mix.Error, ~r/Application name cannot be "server" as it is reserved/, fn ->
        Mix.Tasks.Corex.Tableau.New.run(["server"])
      end
    end)

    in_tmp("tableau reserved table", fn ->
      assert_raise Mix.Error, ~r/Application name cannot be "table" as it is reserved/, fn ->
        Mix.Tasks.Corex.Tableau.New.run(["table"])
      end
    end)
  end

  test "raises on invalid application names" do
    in_tmp("tableau 007", fn ->
      assert_raise Mix.Error, ~r/Application name must start with a letter/, fn ->
        Mix.Tasks.Corex.Tableau.New.run(["007invalid"])
      end
    end)

    in_tmp("tableau exInvalid", fn ->
      assert_raise Mix.Error, ~r/Application name must start with a letter/, fn ->
        Mix.Tasks.Corex.Tableau.New.run(["exInvalidAppName"])
      end
    end)
  end

  test "raises on invalid option" do
    assert_raise OptionParser.ParseError, fn ->
      Mix.Tasks.Corex.Tableau.New.run(["my_blog", "-database", "mysql"])
    end
  end
end
