defmodule Corex.Pagination.Translation do
  @moduledoc """
  Strings for Zag pagination [`translations`](https://zagjs.com/components/react/pagination).

  Pass `translation={%Corex.Pagination.Translation{}}` to override any field. Omitted fields use gettext defaults (see table).

  | Field | Default | Used for |
  | ----- | ------- | -------- |
  | `root_label` | Pagination | Root `aria-label` |
  | `prev_trigger_label` | Previous page | Previous control |
  | `next_trigger_label` | Next page | Next control |
  | `item_label` | Page %{page} of %{total_pages} | Page button `aria-label` (`%{page}`, `%{total_pages}` at runtime) |

  Partial override example:

      translation={%Corex.Pagination.Translation{prev_trigger_label: Corex.Gettext.gettext("Previous page")}}
  """

  alias Corex.Gettext

  defstruct [
    :root_label,
    :prev_trigger_label,
    :next_trigger_label,
    :item_label
  ]

  @type t :: %__MODULE__{
          root_label: String.t(),
          prev_trigger_label: String.t(),
          next_trigger_label: String.t(),
          item_label: String.t()
        }

  @doc false
  def resolve(nil), do: default()

  def resolve(%__MODULE__{} = partial), do: merge(partial, default())

  defp default do
    %__MODULE__{
      root_label: Gettext.gettext("Pagination"),
      prev_trigger_label: Gettext.gettext("Previous page"),
      next_trigger_label: Gettext.gettext("Next page"),
      item_label:
        Gettext.gettext("Page %{page} of %{total_pages}",
          page: "%{page}",
          total_pages: "%{total_pages}"
        )
    }
  end

  defp merge(%__MODULE__{} = partial, %__MODULE__{} = default) do
    %__MODULE__{
      root_label: Corex.Translation.take(partial.root_label, default.root_label),
      prev_trigger_label:
        Corex.Translation.take(partial.prev_trigger_label, default.prev_trigger_label),
      next_trigger_label:
        Corex.Translation.take(partial.next_trigger_label, default.next_trigger_label),
      item_label: Corex.Translation.take(partial.item_label, default.item_label)
    }
  end

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
