defmodule Corex.Design.Semantics do
  @moduledoc false

  def atoms, do: Corex.Scales.semantic_atoms()

  def strings, do: Enum.map(atoms(), &Atom.to_string/1)

  def style_values, do: [nil | strings()]

  def validate_key!(key) when is_atom(key) do
    if key in atoms() do
      :ok
    else
      raise ArgumentError,
            "unknown semantic role #{inspect(key)}; allowed: #{inspect(atoms())}"
    end
  end

  def validate_key!(key) when is_binary(key) do
    if key in strings() do
      :ok
    else
      raise ArgumentError,
            "unknown semantic role #{inspect(key)}; allowed: #{inspect(atoms())}"
    end
  end
end
