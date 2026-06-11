defmodule Corex.Design.LegacyConfigTest do
  use ExUnit.Case, async: false

  setup do
    original = CorexDesign.TestConfig.snapshot()

    on_exit(fn ->
      CorexDesign.TestConfig.restore(original)
    end)

    :ok
  end

  test "design_config ignores config :corex_design app env" do
    CorexDesign.TestConfig.reset()
    Application.put_env(:corex_design, :output, "legacy/path.css")
    Application.put_env(:corex_design, :recipes, include: [:button])

    assert Corex.Design.design_config() == %{}
    refute Corex.Design.configured?()
  end
end
