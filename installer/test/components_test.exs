defmodule Corex.New.ComponentsTest do
  use ExUnit.Case, async: true

  alias Corex.Design.Components, as: Registry
  alias Corex.New.Components

  test "every generated component id exists in the design registry" do
    registry_ids = Registry.ids()

    for id <- Components.installer_components() do
      assert Atom.to_string(id) in registry_ids,
             "installer writes components: [:#{id}] but corex_design has no such host"
    end
  end

  test "the list is a proper subset, so generated apps opt into a slice" do
    installer = Components.installer_components() |> Enum.map(&Atom.to_string/1)

    assert length(installer) < length(Registry.ids())
  end

  test "the list has no duplicates regardless of flags" do
    for opts <- [[], [theme: true], [lang: true], [theme: true, lang: true]] do
      ids = Components.installer_components(opts)
      assert ids == Enum.uniq(ids)
    end
  end
end
