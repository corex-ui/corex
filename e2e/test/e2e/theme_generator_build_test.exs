defmodule E2e.ThemeGeneratorBuildTest do
  use ExUnit.Case, async: false

  @moduletag :integration

  setup do
    _ = Application.ensure_all_started(:corex_web)
    :ok
  end

  test "isolated build writes only under tmp and leaves repo design dir untouched" do
    design = Path.expand("../../assets/corex/design", __DIR__)
    marker = Path.join(design, "tokens/semantic/color.json")
    before = marker |> File.read!()

    assert {:ok, workspace} =
             E2e.ThemeGenerator.Build.run(E2e.DesignPalette.Config.defaults())

    assert String.starts_with?(workspace.root, System.tmp_dir!())
    assert File.dir?(workspace.design_dir)
    assert File.exists?(Path.join(workspace.tokens_out, "themes/neo/color/light.css"))

    after_read = marker |> File.read!()
    assert after_read == before

    E2e.ThemeGenerator.Workspace.delete!(workspace)
  end
end
