defmodule Corex.NativeAccordion.Keymap do
  @moduledoc false

  alias Corex.NativeAccordion.State

  defstruct orientation: "vertical", dir: nil

  @type t :: %__MODULE__{orientation: String.t(), dir: String.t() | nil}

  @keys ~W(ArrowDown ArrowUp ArrowLeft ArrowRight Home End)

  @spec new(String.t() | nil, String.t() | nil) :: t()
  def new(orientation, dir) do
    %__MODULE__{
      orientation: orientation || "vertical",
      dir: dir
    }
  end

  @doc """
  Compiled key → direction pairs for this orientation and text direction.

  Vertical: ArrowDown/ArrowUp. Horizontal: ArrowRight/ArrowLeft (swapped in RTL).
  Home/End always map to first/last.
  """
  @spec bindings(t()) :: list({String.t(), :next | :prev | :first | :last})
  def bindings(%__MODULE__{orientation: orientation, dir: dir}) do
    Enum.flat_map(@keys, fn key ->
      case State.key_direction(key, orientation, dir) do
        nil -> []
        direction -> [{key, direction}]
      end
    end)
  end
end
