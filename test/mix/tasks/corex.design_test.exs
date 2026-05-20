defmodule Mix.Tasks.Corex.DesignTest do
  use ExUnit.Case, async: false

  setup do
    shell = Mix.shell()
    Mix.shell(Mix.Shell.Quiet)

    on_exit(fn ->
      Mix.shell(shell)
    end)

    :ok
  end

  defp run_design(tmp, args) do
    File.cd!(tmp, fn ->
      Mix.Task.reenable("corex.design")
      Mix.Task.run("corex.design", args)
    end)
  end

  test "copies design tree and writes VERSION" do
    tmp = Path.join(System.tmp_dir!(), "corex_design_#{System.unique_integer([:positive])}")
    on_exit(fn -> File.rm_rf(tmp) end)
    File.mkdir_p!(tmp)

    run_design(tmp, ["--force"])

    dest = Path.join(tmp, "assets/corex")
    assert File.exists?(Path.join(dest, "components"))
    assert File.read!(Path.join(dest, "VERSION")) =~ ~r/^\d+\.\d+\.\d+/
  end

  test "skips copy when destination exists without force" do
    tmp = Path.join(System.tmp_dir!(), "corex_design_skip_#{System.unique_integer([:positive])}")
    on_exit(fn -> File.rm_rf(tmp) end)
    File.mkdir_p!(tmp)

    version_path = Path.join(tmp, "assets/corex/VERSION")
    run_design(tmp, ["--force"])
    before = File.read!(version_path)

    run_design(tmp, [])

    assert File.read!(version_path) == before
    assert before =~ ~r/^\d+\.\d+\.\d+/
  end

  test "copies designex tree with --designex --force" do
    tmp = Path.join(System.tmp_dir!(), "corex_designex_#{System.unique_integer([:positive])}")
    on_exit(fn -> File.rm_rf(tmp) end)
    File.mkdir_p!(tmp)

    run_design(tmp, ["--designex", "--force"])

    designex = Path.join(tmp, "assets/corex/design")
    assert File.dir?(designex)
    assert File.exists?(Path.join(designex, "tokens"))
  end
end
