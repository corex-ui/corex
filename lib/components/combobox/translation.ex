defmodule Corex.Combobox.Translation do
  @moduledoc """
  Translatable strings for the combobox.

  Pass `translation={%Corex.Combobox.Translation{}}` to override any field. Omitted fields use gettext defaults from [`default/0`](#default/0).

  | Field | Default | Used for |
  | ----- | ------- | -------- |
  | `placeholder` | Select | Input placeholder |
  | `empty` | No results | Empty list message |
  | `trigger` | Open options | Trigger button `aria-label` |
  | `clear_selection` | Clear selection | Clear button `aria-label` |
  """

  alias Corex.Gettext
  alias Corex.Translation, as: T

  defstruct [:placeholder, :empty, :trigger, :clear_selection]

  @type t :: %__MODULE__{
          placeholder: String.t(),
          empty: String.t(),
          trigger: String.t(),
          clear_selection: String.t()
        }

  def default do
    %__MODULE__{
      placeholder: Gettext.gettext("Select"),
      empty: Gettext.gettext("No results"),
      trigger: Gettext.gettext("Open options"),
      clear_selection: Gettext.gettext("Clear selection")
    }
  end

  def merge(nil, default), do: default

  def merge(%__MODULE__{} = partial, %__MODULE__{} = default) do
    %__MODULE__{
      placeholder: T.take(partial.placeholder, default.placeholder),
      empty: T.take(partial.empty, default.empty),
      trigger: T.take(partial.trigger, default.trigger),
      clear_selection: T.take(partial.clear_selection, default.clear_selection)
    }
  end

  def merge(map, default) when is_map(map) do
    sm = Map.new(map, fn {k, v} -> {to_string(k), v} end)

    merge(
      %__MODULE__{
        placeholder: Map.get(sm, "placeholder"),
        empty: Map.get(sm, "empty"),
        trigger: Map.get(sm, "trigger"),
        clear_selection: Map.get(sm, "clear_selection")
      },
      default
    )
  end
end
