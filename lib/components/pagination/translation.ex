defmodule Corex.Pagination.Translation do
  @moduledoc """
  Strings for Zag pagination [`translations`](https://zagjs.com/components/react/pagination).

  Without gettext: `translation={%Corex.Pagination.Translation{prev_trigger_label: "Previous page"}}`

  With gettext: `translation={%Corex.Pagination.Translation{prev_trigger_label: Corex.Gettext.gettext("Previous page")}}`

  `item_label` supports `%{page}` and `%{total_pages}` placeholders.
  """

  defstruct [
    :root_label,
    :prev_trigger_label,
    :next_trigger_label,
    :item_label
  ]

  @type t :: %__MODULE__{
          root_label: String.t() | nil,
          prev_trigger_label: String.t() | nil,
          next_trigger_label: String.t() | nil,
          item_label: String.t() | nil
        }

  @doc false
  def to_camel_map(%__MODULE__{} = t) do
    %{
      "rootLabel" => t.root_label,
      "prevTriggerLabel" => t.prev_trigger_label,
      "nextTriggerLabel" => t.next_trigger_label,
      "itemLabel" => t.item_label
    }
  end
end
