defmodule Corex.Design.Vocabulary do
  @moduledoc false

  alias Corex.Design.Theme

  def semantic_roles do
    Theme.resolved_themes()
    |> Map.values()
    |> Enum.flat_map(&component_roles/1)
    |> Enum.uniq()
    |> Enum.sort()
  end

  def semantic_strings, do: Enum.map(semantic_roles(), &Atom.to_string/1)

  defp component_roles(spec) do
    for mode <- Theme.modes(),
        roles = spec.colors |> Map.get(mode, %{}) |> Map.get(:roles, %{}),
        {role, cfg} <- roles,
        component?(cfg) do
      role
    end
  end

  defp component?(cfg) when is_map(cfg) do
    Map.get(cfg, :component, true) == true
  end
end
