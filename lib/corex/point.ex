defmodule Corex.Point do
  @moduledoc "Two-dimensional point as numeric x and y."

  @enforce_keys [:x, :y]
  defstruct [:x, :y]

  @type t :: %__MODULE__{x: number(), y: number()}

  @spec to_map(t() | %{x: number(), y: number()} | nil) :: %{x: number(), y: number()} | nil
  def to_map(nil), do: nil

  def to_map(%__MODULE__{x: x, y: y}) when is_number(x) and is_number(y), do: %{x: x, y: y}

  def to_map(%{x: x, y: y}) when is_number(x) and is_number(y), do: %{x: x, y: y}

  def to_map(_), do: raise(ArgumentError, "expected %Corex.Point{} or %{x: _, y: _}")
end
