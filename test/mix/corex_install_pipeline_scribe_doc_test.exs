defmodule Mix.Corex.Install.PipelineScribeDocTest do
  use ExUnit.Case, async: true

  test "Install.Pipeline moduledoc describes Igniter.Scribe and --scribe" do
    path = Path.join(["lib", "mix", "corex", "install", "pipeline.ex"])
    text = File.read!(path)

    assert text =~ "Igniter.Scribe"
    assert text =~ "--scribe"
  end
end
