defmodule Corex.ComponentEventsContractTest do
  use ExUnit.Case, async: true

  @components_root Path.expand("../../lib/components", __DIR__)

  @server_only ~w(
    on_draw_end
    on_select
    on_select_all
    on_sort
  )a

  test "on_* server events have matching on_*_client unless server-only" do
    for path <- component_files(), event <- server_event_attrs(path), event not in @server_only do
      client = :"#{event}_client"

      assert has_attr?(path, client),
             "missing attr(:#{client}) in #{path} for server event :#{event}"
    end
  end

  defp component_files do
    @components_root
    |> File.ls!()
    |> Enum.filter(&String.ends_with?(&1, ".ex"))
    |> Enum.map(&Path.join(@components_root, &1))
  end

  defp server_event_attrs(path) do
    path
    |> File.read!()
    |> then(fn source ->
      ~r/attr\(:(on_[a-z_]+),\s*:/
      |> Regex.scan(source)
      |> Enum.map(fn [_, name] -> String.to_atom(name) end)
    end)
    |> Enum.reject(&String.ends_with?(Atom.to_string(&1), "_client"))
  end

  defp has_attr?(path, attr) do
    path
    |> File.read!()
    |> String.contains?("attr(:#{attr},")
  end
end
