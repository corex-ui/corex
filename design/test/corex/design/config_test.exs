defmodule Corex.Design.ConfigTest do
  use ExUnit.Case, async: false

  alias Corex.Design.Config

  setup do
    original = CorexDesign.TestConfig.snapshot()

    on_exit(fn ->
      CorexDesign.TestConfig.restore(original)
    end)

    :ok
  end

  test "validate!/0 accepts empty design config" do
    CorexDesign.TestConfig.put([])
    assert :ok = Config.validate!()
  end

  test "customization_map lists core namespaces" do
    map = Config.customization_map()
    assert Keyword.has_key?(map, :corex)
    assert Keyword.has_key?(map, :corex_design)
  end
end
