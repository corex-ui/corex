defmodule Mix.Tasks.Corex.Gen.LiveTest do
  use ExUnit.Case, async: false

  @tag :tmp_dir
  test "raises when Corex templates not found", %{tmp_dir: tmp_dir} do
    File.cd!(tmp_dir, fn ->
      Mix.Task.reenable("corex.gen.live")

      assert_raise Mix.Error, ~r/Corex templates not found/, fn ->
        Mix.Task.run("corex.gen.live", [])
      end
    end)
  end

  test "runs phx.gen.live when templates exist" do
    Mix.Task.reenable("corex.gen.live")

    assert_raise Mix.Error, fn ->
      Mix.Task.run("corex.gen.live", [])
    end
  end
end
