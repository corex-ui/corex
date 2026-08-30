defmodule Corex.NativeAccordion.Trigger do
  @moduledoc false

  alias Corex.NativeAccordion.State

  defstruct [
    :id,
    :value,
    :next,
    :prev,
    :first,
    :last,
    disabled?: false,
    open?: false
  ]

  @type t :: %__MODULE__{
          id: String.t(),
          value: String.t(),
          next: String.t(),
          prev: String.t(),
          first: String.t(),
          last: String.t(),
          disabled?: boolean(),
          open?: boolean()
        }

  @spec new(String.t(), String.t(), list(String.t()), list(String.t()), keyword()) :: t()
  def new(id, value, item_values, disabled_values, opts \\ [])
      when is_binary(id) and is_binary(value) and is_list(item_values) and
             is_list(disabled_values) and is_list(opts) do
    %__MODULE__{
      id: id,
      value: value,
      next: neighbor(item_values, value, disabled_values, :next),
      prev: neighbor(item_values, value, disabled_values, :prev),
      first: neighbor(item_values, value, disabled_values, :first),
      last: neighbor(item_values, value, disabled_values, :last),
      disabled?: value in disabled_values,
      open?: Keyword.get(opts, :open?, false)
    }
  end

  defp neighbor(item_values, current, disabled, direction) do
    State.next_item(item_values, current, disabled, direction) || current
  end
end
