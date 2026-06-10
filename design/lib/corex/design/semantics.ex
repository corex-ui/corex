defmodule Corex.Design.Semantics do
  @moduledoc false

  alias Corex.Design.Vocabulary

  @fallback ~W(accent brand alert info success selected neutral)a

  def atoms do
    if Corex.Design.configured?() do
      Vocabulary.semantic_roles()
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
