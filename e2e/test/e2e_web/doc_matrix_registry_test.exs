defmodule E2eWeb.DocMatrixRegistryTest do
  use ExUnit.Case, async: true

  test "DocPageMatrix components are registered Corex ids" do
    registry = MapSet.new(Corex.component_ids())

    for component <- E2eWeb.DocPageMatrix.all_components() do
      assert MapSet.member?(registry, component),
             "expected #{inspect(component)} in Corex.component_ids/0"
    end
  end
end
