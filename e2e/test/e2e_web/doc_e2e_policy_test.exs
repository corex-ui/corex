defmodule E2eWeb.DocE2ePolicyTest do
  use ExUnit.Case, async: true

  test "Wallaby interaction skip slugs are registered Corex ids" do
    allowed = MapSet.new(Corex.component_ids())

    for slug_str <- E2eWeb.E2eBehaviorExceptions.wallaby_interaction_skip_slugs() do
      id = String.to_existing_atom(slug_str)
      assert MapSet.member?(allowed, id)
    end
  end

  test "Wallaby interaction skip slugs are hook-less in wire index" do
    path = Application.app_dir(:corex, "priv/doc/component_wire.json")
    by_id = path |> File.read!() |> Jason.decode!() |> Map.new(fn row -> {row["id"], row} end)

    for slug_str <- E2eWeb.E2eBehaviorExceptions.wallaby_interaction_skip_slugs() do
      row = Map.fetch!(by_id, slug_str)
      assert is_nil(row["phx_hook"])
    end
  end
end
