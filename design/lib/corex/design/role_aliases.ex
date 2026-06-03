defmodule Corex.Design.RoleAliases do
  @moduledoc false

  @doc """
  Resolves a semantic/color role through `config :corex_design, role_aliases:`.
  """
  def resolve(role) when is_atom(role) do
    aliases = config()

    case Map.fetch(aliases, role) do
      {:ok, target} -> normalize_target(target)
      :error -> resolve_string_key(aliases, Atom.to_string(role), role)
    end
  end

  def resolve(role) when is_binary(role) do
    aliases = config()

    case Map.fetch(aliases, role) do
      {:ok, target} -> normalize_target(target)
      :error -> resolve_atom_key(aliases, role)
    end
  end

  defp config do
    :corex_design
    |> Application.get_env(:role_aliases, %{})
    |> normalize_map()
  end

  defp normalize_map(map) when is_map(map) do
    Map.new(map, fn {key, value} -> {normalize_key(key), normalize_target(value)} end)
  end

  defp normalize_key(key) when is_atom(key), do: key
  defp normalize_key(key) when is_binary(key), do: key

  defp normalize_target(target) when is_atom(target), do: target

  defp normalize_target(target) when is_binary(target) do
    try do
      String.to_existing_atom(target)
    rescue
      ArgumentError -> String.to_atom(target)
    end
  end

  defp resolve_string_key(aliases, role, fallback) do
    case Map.fetch(aliases, role) do
      {:ok, target} -> normalize_target(target)
      :error -> fallback
    end
  end

  defp resolve_atom_key(aliases, role) do
    try do
      atom = String.to_existing_atom(role)
      Map.get(aliases, atom, String.to_atom(role))
    rescue
      ArgumentError -> String.to_atom(role)
    end
  end
end
