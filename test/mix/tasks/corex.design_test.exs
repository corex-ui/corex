defmodule Mix.Tasks.Corex.DesignTest do
  use ExUnit.Case, async: false

  @tag :tmp_dir
  test "copies design files to given path", %{tmp_dir: tmp_dir} do
    target = Path.join(tmp_dir, "assets/corex")
    Mix.Task.reenable("corex.design")
    Mix.Task.run("corex.design", [target])
    assert File.exists?(target)
    assert File.exists?(Path.join(target, "components"))
    assert File.exists?(Path.join(target, "main.css"))
  end

  @tag :tmp_dir
  test "copies design files to custom path", %{tmp_dir: tmp_dir} do
    target = Path.join(tmp_dir, "custom/design")
    Mix.Task.reenable("corex.design")
    Mix.Task.run("corex.design", [target])
    assert File.exists?(target)
    assert File.exists?(Path.join(target, "main.css"))
  end

  @tag :tmp_dir
  test "overwrites existing target with --force", %{tmp_dir: tmp_dir} do
    target = Path.join(tmp_dir, "design")
    File.mkdir_p!(target)
    File.write!(Path.join(target, "marker"), "before")
    Mix.Task.reenable("corex.design")
    Mix.Task.run("corex.design", [target, "--force"])
    assert File.exists?(target)
    assert File.exists?(Path.join(target, "main.css"))
  end

  @tag :tmp_dir
  test "raises when target exists without --force", %{tmp_dir: tmp_dir} do
    target = Path.join(tmp_dir, "existing")
    File.mkdir_p!(target)
    Mix.Task.reenable("corex.design")

    assert_raise Mix.Error, ~r/already exists/, fn ->
      Mix.Task.run("corex.design", [target])
    end
  end

  @tag :tmp_dir
  test "accepts --designex option", %{tmp_dir: tmp_dir} do
    target = Path.join(tmp_dir, "design_with_tokens")
    Mix.Task.reenable("corex.design")
    Mix.Task.run("corex.design", [target, "--designex"])
    assert File.exists?(target)
    assert File.exists?(Path.join(target, "design"))
  end

  @tag :tmp_dir
  test "excludes design tokens when run without --designex", %{tmp_dir: tmp_dir} do
    target = Path.join(tmp_dir, "design_no_tokens")
    Mix.Task.reenable("corex.design")
    Mix.Task.run("corex.design", [target])
    assert File.exists?(target)
    assert File.exists?(Path.join(target, "main.css"))
    design_path = Path.join(target, "design")
    refute File.dir?(design_path)
  end
end
