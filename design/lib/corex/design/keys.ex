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
end
