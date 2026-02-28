defmodule Mix.Tasks.Corex.Gen.HtmlTest do
  use ExUnit.Case, async: false

  @tag :tmp_dir
  test "raises when Corex templates not found", %{tmp_dir: tmp_dir} do
    File.cd!(tmp_dir, fn ->
      Mix.Task.reenable("corex.gen.html")

      assert_raise Mix.Error, ~r/Corex templates not found/, fn ->
        Mix.Task.run("corex.gen.html", [])
      end
    end)
  end

  test "runs phx.gen.html when templates exist" do
    Mix.Task.reenable("corex.gen.html")

    assert_raise Mix.Error, fn ->
      Mix.Task.run("corex.gen.html", [])
    end
  end
end
