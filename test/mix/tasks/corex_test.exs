defmodule Mix.Tasks.CorexTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  test "run/1 prints version" do
    assert capture_io(fn ->
             Mix.Tasks.Corex.run(["--version"])
           end) =~ "Corex v"

    assert capture_io(fn ->
             Mix.Tasks.Corex.run(["-v"])
           end) =~ "Corex v"
  end

  test "run/1 with no args prints general help" do
    # Help.run might print to stdout so we capture it
    output = capture_io(fn ->
      Mix.Tasks.Corex.run([])
    end)
    assert output =~ "Accessible and unstyled UI components library"
    assert output =~ "## Options"
  end
  
  test "run/1 with invalid args raises" do
    assert_raise Mix.Error, "Invalid arguments, expected: mix corex", fn ->
      Mix.Tasks.Corex.run(["invalid"])
    end
  end
end