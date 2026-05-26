defmodule Mix.Tasks.Corex.HeroiconTest do
  use ExUnit.Case, async: false

  @moduletag capture_log: true

  setup do
    shell = Mix.shell()
    Mix.shell(Mix.Shell.Quiet)
    on_exit(fn -> Mix.shell(shell) end)
    :ok
  end

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
  @tag :tmp_dir
  test "skips existing file without force", %{tmp_dir: tmp_dir} do
    vendor_dir = Path.join(tmp_dir, "assets/vendor")
    File.mkdir_p!(vendor_dir)
    path = Path.join(vendor_dir, "heroicons.js")
    File.write!(path, "keep")

    cwd = File.cwd!()

    try do
      File.cd!(tmp_dir)
      Mix.Task.reenable("corex.heroicon")

      Mix.Task.run("corex.heroicon", [])
      assert File.read!(path) == "keep"
    after
      File.cd!(cwd)
    end
  end

  @tag :tmp_dir
  test "notes when app.css already contains the plugin", %{tmp_dir: tmp_dir} do
    css_dir = Path.join(tmp_dir, "assets/css")
    File.mkdir_p!(css_dir)
    File.write!(Path.join(css_dir, "app.css"), ~S|@plugin "../vendor/heroicons";|)

    cwd = File.cwd!()

    try do
      File.cd!(tmp_dir)
      Mix.Task.reenable("corex.heroicon")

      Mix.Task.run("corex.heroicon", [])
      assert File.exists?(Path.join(tmp_dir, "assets/vendor/heroicons.js"))
    after
      File.cd!(cwd)
    end
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
