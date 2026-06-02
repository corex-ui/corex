defmodule Mix.Tasks.Corex.CodeTest do
  use ExUnit.Case, async: false

  @tmp_path Path.join(__DIR__, "../../tmp/corex_code")

  setup do
    File.rm_rf!(@tmp_path)
    File.mkdir_p!(@tmp_path)

    on_exit(fn ->
      File.rm_rf!(@tmp_path)
    end)

    :ok
  end

  test "generates stylesheet at given path" do
    path = Path.join(@tmp_path, "assets/css/code_highlight.css")
    Mix.Task.reenable("corex.code")
    Mix.Task.run("corex.code", [path])
    assert File.exists?(path)
    content = File.read!(path)
    assert content =~ ~r/\.highlight|\.token|pre/
  end

  test "generates stylesheet at custom path" do
    path = Path.join(@tmp_path, "custom/syntax.css")
    Mix.Task.reenable("corex.code")
    Mix.Task.run("corex.code", [path])
    assert File.exists?(path)
    content = File.read!(path)
    assert is_binary(content)
    assert byte_size(content) > 0
  end

  test "overwrites with --force" do
    path = Path.join(@tmp_path, "code_highlight.css")
    File.mkdir_p!(@tmp_path)
    File.write!(path, "old content")
    Mix.Task.reenable("corex.code")
    Mix.Task.run("corex.code", [path, "--force"])
    content = File.read!(path)
    refute content == "old content"
    assert byte_size(content) > 0
  end

  test "raises when file exists without --force" do
    path = Path.join(@tmp_path, "existing.css")
    File.mkdir_p!(@tmp_path)
    File.write!(path, "existing")
    Mix.Task.reenable("corex.code")

    assert_raise Mix.Error, ~r/already exists/, fn ->
      Mix.Task.run("corex.code", [path])
    end
  end

  test "raises when path escapes project root" do
    outside =
      Path.join(System.tmp_dir!(), "corex_code_outside_#{System.unique_integer([:positive])}.css")

    on_exit(fn -> File.rm(outside) end)

    Mix.Task.reenable("corex.code")

    assert_raise Mix.Error, ~r/within the project root/, fn ->
      Mix.Task.run("corex.code", [outside, "--force"])
    end
  end

  test "raises for relative path outside project root" do
    Mix.Task.reenable("corex.code")

    assert_raise Mix.Error, ~r/within the project root/, fn ->
      Mix.Task.run("corex.code", ["../../../corex_code_escape.css", "--force"])
    end
  end
end
