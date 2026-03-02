defmodule Mix.Tasks.Corex.CodeTest do
  use ExUnit.Case, async: false

  @tag :tmp_dir
  test "generates stylesheet at given path", %{tmp_dir: tmp_dir} do
    path = Path.join(tmp_dir, "assets/css/code_highlight.css")
    Mix.Task.reenable("corex.code")
    Mix.Task.run("corex.code", [path])
    assert File.exists?(path)
    content = File.read!(path)
    assert content =~ ~r/\.highlight|\.token|pre/
  end

  @tag :tmp_dir
  test "generates stylesheet at custom path", %{tmp_dir: tmp_dir} do
    path = Path.join(tmp_dir, "custom/syntax.css")
    Mix.Task.reenable("corex.code")
    Mix.Task.run("corex.code", [path])
    assert File.exists?(path)
    content = File.read!(path)
    assert is_binary(content)
    assert byte_size(content) > 0
  end

  @tag :tmp_dir
  test "overwrites with --force", %{tmp_dir: tmp_dir} do
    path = Path.join(tmp_dir, "code_highlight.css")
    File.mkdir_p!(tmp_dir)
    File.write!(path, "old content")
    Mix.Task.reenable("corex.code")
    Mix.Task.run("corex.code", [path, "--force"])
    content = File.read!(path)
    refute content == "old content"
    assert byte_size(content) > 0
  end

  @tag :tmp_dir
  test "raises when file exists without --force", %{tmp_dir: tmp_dir} do
    path = Path.join(tmp_dir, "existing.css")
    File.mkdir_p!(tmp_dir)
    File.write!(path, "existing")
    Mix.Task.reenable("corex.code")

    assert_raise Mix.Error, ~r/already exists/, fn ->
      Mix.Task.run("corex.code", [path])
    end
  end
end
