defmodule Corex.ComponentSpecSnapshotTest do
  use ExUnit.Case, async: true

  @snapshot Application.app_dir(:corex, "priv/test/component_spec_snapshot.txt")

  test "component_spec function names match frozen snapshot" do
    lines =
      Corex.component_ids()
      |> Enum.map(fn id ->
        spec =
          case Corex.component_spec(id) do
            {:ok, spec} -> spec
            :error -> flunk("missing component_spec for #{id}")
          end

        names =
          spec.function_components
          |> Enum.map(& &1.name)
          |> Enum.sort()
          |> Enum.map_join(",", &Atom.to_string/1)

        "#{id}:#{names}"
      end)
      |> Enum.sort()
      |> Enum.join("\n")
      |> Kernel.<>("\n")

    if File.exists?(@snapshot) do
      assert File.read!(@snapshot) == lines
    else
      File.mkdir_p!(Path.dirname(@snapshot))
      File.write!(@snapshot, lines)
      flunk("created #{@snapshot}; re-run test to lock snapshot")
    end
  end
end
