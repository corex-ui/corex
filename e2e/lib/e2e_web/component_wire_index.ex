defmodule E2eWeb.ComponentWireIndex do
  @moduledoc false

  @path Application.app_dir(:corex, "priv/doc/component_wire.json")

  @by_id @path |> File.read!() |> Jason.decode!() |> Map.new(fn row -> {row["id"], row} end)

  def hook_for_id(id) when is_binary(id), do: Map.get(@by_id, id) |> hook_from_row()
  def hook_for_id(id) when is_atom(id), do: hook_for_id(Atom.to_string(id))

  def hookless?(id), do: is_nil(hook_for_id(id))

  defp hook_from_row(%{"phx_hook" => hook}) when is_binary(hook), do: hook
  defp hook_from_row(_), do: nil
end
