defmodule Corex.ComponentWireJsonTest do
  use ExUnit.Case, async: true

  test "component wire index ids match Corex registry" do
    path = Application.app_dir(:corex, "priv/doc/component_wire.json")
    assert File.exists?(path)
    list = Jason.decode!(File.read!(path))
    wire_ids = list |> Enum.map(& &1["id"]) |> Enum.sort()
    registry_ids = Corex.component_ids() |> Enum.map(&Atom.to_string/1) |> Enum.sort()
    assert wire_ids == registry_ids
  end
end
