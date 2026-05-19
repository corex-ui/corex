defmodule Corex.RegistryTest do
  use ExUnit.Case, async: true

  test "component_ids/0 returns sorted atoms" do
    ids = Corex.component_ids()

    assert is_list(ids)
    assert ids == Enum.sort(ids)
    assert :accordion in ids
    assert :code in ids
  end

  test "component_spec/1 for registered id" do
    case Corex.component_spec(:accordion) do
      {:ok, spec} ->
        assert spec.id == :accordion
        assert spec.module == "Corex.Accordion"
        assert Enum.any?(spec.function_components, &(&1.name == :accordion))

      other ->
        flunk("expected {:ok, spec}, got #{inspect(other)}")
    end
  end

  test "component_spec/1 for unknown id" do
    assert :error = Corex.component_spec(:not_a_corex_component)
  end

  test "component_module_for_mcp_id/1 for registered string id" do
    case Corex.component_module_for_mcp_id("accordion") do
      {:ok, Corex.Accordion} ->
        :ok

      other ->
        flunk("expected {:ok, Corex.Accordion}, got #{inspect(other)}")
    end
  end

  test "component_module_for_mcp_id/1 rejects unknown id" do
    assert :error = Corex.component_module_for_mcp_id("not_registered")
    assert :error = Corex.component_module_for_mcp_id("")
  end
end
