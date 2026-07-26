defmodule Corex.Design.Keys do
  @moduledoc """
  Key handling for the theme spec maps that arrive from user config.

  A spec written in `config.exs` may use atom or string keys at any level, and
  before this module each consumer carried its own `map_get/3`. Everything that
  reads a spec goes through here instead.
  """

  @doc """
  Reads `key` from a spec map, accepting either an atom or a string key.
  """
  @spec get(term(), atom(), term()) :: term()
  def get(map, key, default \\ nil)

  def get(map, key, default) when is_map(map) and is_atom(key) do
    case Map.fetch(map, key) do
      {:ok, value} ->
        value

      :error ->
        case Map.fetch(map, Atom.to_string(key)) do
          {:ok, value} -> value
          :error -> default
        end
    end
  end

  def get(_map, _key, default), do: default

  @doc """
  Recursively converts string keys to atoms using `allowed` as the allowlist.

  Unknown string keys are left as strings. Converting them would let a typo in
  user config grow the atom table, and a wrong key should surface as a validation
  error rather than a new atom.
  """
  @spec to_known_atoms(map(), %{optional(String.t()) => atom()}) :: map()
  def to_known_atoms(map, allowed) when is_map(map) and is_map(allowed) do
    Map.new(map, fn {key, value} ->
      value = if is_map(value), do: to_known_atoms(value, allowed), else: value
      {known_atom(key, allowed), value}
    end)
  end

  @doc """
  Converts one key to its known atom, leaving unknown strings alone.
  """
  @spec known_atom(term(), %{optional(String.t()) => atom()}) :: term()
  def known_atom(key, _allowed) when is_atom(key), do: key
  def known_atom(key, allowed) when is_binary(key), do: Map.get(allowed, key, key)
  def known_atom(key, _allowed), do: key

  @doc """
  Builds the allowlist map an atom list implies, for `to_known_atoms/2`.
  """
  @spec allowlist([atom()]) :: %{optional(String.t()) => atom()}
  def allowlist(atoms) when is_list(atoms) do
    Map.new(atoms, &{Atom.to_string(&1), &1})
  end

  @doc """
  Rewrites a map's keys to strings, one level deep.
  """
  @spec to_strings(map()) :: map()
  def to_strings(map) when is_map(map) do
    Map.new(map, fn {key, value} -> {to_string(key), value} end)
  end

  @doc """
  Converts a key from a closed set to its atom, raising on anything outside it.

  For the parts of a spec whose key set is fixed (font steps, radius steps) a key
  outside the set is a typo. Interning it would silently produce a token nobody
  emits, so this raises and names the keys that are valid.
  """
  @spec closed_atom!(term(), [atom()], String.t()) :: atom()
  def closed_atom!(key, allowed, context) when is_list(allowed) do
    case Enum.find(allowed, &(to_string(&1) == to_string(key))) do
      nil ->
        raise ArgumentError,
              "#{context}: unknown key #{inspect(key)}; allowed: #{inspect(Enum.map(allowed, &to_string/1))}"

      found ->
        found
    end
  end

  @doc """
  Recursively converts a spec map's keys to atoms.

  Surface, role and on-color names are open: a theme may name a surface anything,
  and the emitters turn the name straight back into a CSS custom property. The
  atoms interned here are therefore bounded by the size of `config.exs`, which is
  read once at build time. That is not the case for the values a component
  receives at runtime, which is why `Corex.Value` coerces instead.
  """
  @spec to_atom_map(map()) :: map()
  def to_atom_map(map) when is_map(map) do
    Map.new(map, fn {key, value} ->
      value = if is_map(value), do: to_atom_map(value), else: value
      {to_atom(key), value}
    end)
  end

  defp to_atom(key) when is_atom(key), do: key
  defp to_atom(key) when is_binary(key), do: String.to_atom(key)
end
