defmodule Corex.HooksExportsContractTest do
  use ExUnit.Case, async: true

  @hook_ids Corex.component_ids()
            |> Enum.filter(fn id ->
              path = Application.app_dir(:corex, "priv/doc/component_wire.json")

              row =
                path
                |> File.read!()
                |> Jason.decode!()
                |> Enum.find(&(&1["id"] == Atom.to_string(id)))

              row && row["phx_hook"]
            end)

  defp kebab(id), do: id |> Atom.to_string() |> String.replace("_", "-")

  defp pascal(id) do
    id
    |> Atom.to_string()
    |> String.split("_")
    |> Enum.map_join("", &String.capitalize/1)
  end

  test "component_wire.json ids match registry" do
    path = Application.app_dir(:corex, "priv/doc/component_wire.json")
    wire_ids = path |> File.read!() |> Jason.decode!() |> Enum.map(& &1["id"]) |> Enum.sort()
    registry_ids = Corex.component_ids() |> Enum.map(&Atom.to_string/1) |> Enum.sort()
    assert wire_ids == registry_ids
  end

  test "each hooked component has npm export and static bundle" do
    exports = package_json_exports()

    for id <- @hook_ids do
      slug = kebab(id)
      export_key = "./#{slug}"
      assert Map.has_key?(exports, export_key), "missing package.json export #{export_key}"
      mjs = Application.app_dir(:corex, "priv/static/#{slug}.mjs")
      assert File.exists?(mjs), "missing priv/static/#{slug}.mjs at #{mjs}"
    end
  end

  test "hook PascalCase names match component_wire phx_hook" do
    path = Application.app_dir(:corex, "priv/doc/component_wire.json")
    by_id = path |> File.read!() |> Jason.decode!() |> Map.new(&{&1["id"], &1})

    for id <- @hook_ids do
      row = Map.fetch!(by_id, Atom.to_string(id))
      assert row["phx_hook"] == pascal(id)
    end
  end

  defp package_json_exports do
    root = Path.expand("../..", __DIR__)
    path = Path.join(root, "package.json")
    path |> File.read!() |> Jason.decode!() |> Map.get("exports", %{})
  end
end
