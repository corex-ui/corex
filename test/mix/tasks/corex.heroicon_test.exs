defmodule Mix.Tasks.Corex.HeroiconTest do
  use ExUnit.Case, async: false

  @tag :tmp_dir
  test "creates plugin in assets/vendor", %{tmp_dir: tmp_dir} do
    File.mkdir_p!(Path.join(tmp_dir, "assets"))
    cwd = File.cwd!()

    try do
      File.cd!(tmp_dir)
      Mix.Task.reenable("corex.heroicon")
      Mix.Task.run("corex.heroicon", [])
    after
      File.cd!(cwd)
    end

    path = Path.join(tmp_dir, "assets/vendor/heroicons.js")
    assert File.exists?(path)
    content = File.read!(path)
    assert content =~ "deps/heroicons/optimized"
    assert content =~ "../../deps"
    assert content =~ "tailwindcss/plugin"
    assert content =~ "matchComponents"
  end

  @tag :tmp_dir
  test "overwrites existing file with --force", %{tmp_dir: tmp_dir} do
    vendor_dir = Path.join(tmp_dir, "assets/vendor")
    File.mkdir_p!(vendor_dir)
    path = Path.join(vendor_dir, "heroicons.js")
    File.write!(path, "old")

    cwd = File.cwd!()

    try do
      File.cd!(tmp_dir)
      Mix.Task.reenable("corex.heroicon")
      Mix.Task.run("corex.heroicon", ["--force"])
    after
      File.cd!(cwd)
    end

    content = File.read!(path)
    assert content =~ "matchComponents"
    refute content == "old"
  end

  @tag :tmp_dir
  test "raises when no assets directory exists", %{tmp_dir: tmp_dir} do
    cwd = File.cwd!()

    try do
      File.cd!(tmp_dir)
      Mix.Task.reenable("corex.heroicon")

      assert_raise Mix.Error, ~r/No assets directory found/, fn ->
        Mix.Task.run("corex.heroicon", [])
      end
    after
      File.cd!(cwd)
    end
  end
end
