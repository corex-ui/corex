defmodule Mix.Tasks.Corex.Gen.AuthTest do
  use ExUnit.Case, async: false

  @tag :tmp_dir
  test "raises when Corex templates not found", %{tmp_dir: tmp_dir} do
    File.cd!(tmp_dir, fn ->
      Mix.Task.reenable("corex.gen.auth")

      assert_raise Mix.Error, ~r/Corex templates not found/, fn ->
        Mix.Task.run("corex.gen.auth", [])
      end
    end)
  end

  test "runs phx.gen.auth when templates exist" do
    Mix.Task.reenable("corex.gen.auth")

    assert_raise Mix.Error, fn ->
      Mix.Task.run("corex.gen.auth", [])
    end
  end
end
