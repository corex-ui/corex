defmodule Corex.Design.Semantics do
  @moduledoc false

  alias Corex.Design.Vocabulary

  @axis_atoms ~w(base accent brand alert info success)a
  @fallback @axis_atoms

  def axis_atoms, do: @axis_atoms

  def axis_strings, do: Enum.map(@axis_atoms, &Atom.to_string/1)

  def atoms do
    if Corex.Design.configured?() do
      case Vocabulary.semantic_roles() do
        [] -> @fallback
        roles -> roles
      end
    else
      @fallback
    end
  end

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
