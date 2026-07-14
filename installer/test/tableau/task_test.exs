defmodule Mix.Tasks.Corex.Tableau.NewTest do
  use ExUnit.Case, async: true

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
end
