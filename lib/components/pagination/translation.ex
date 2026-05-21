defmodule Corex.Pagination.Translation do
  @moduledoc """
  Translatable strings for [`Corex.Pagination`](Corex.Pagination.html).

  Pass `translation={%Corex.Pagination.Translation{}}` to override any field. Omitted fields use gettext defaults (see table).

  | Field | Default | Used for |
  | ----- | ------- | -------- |
  | `root_label` | Pagination | Root `aria-label` |
  | `prev_trigger_label` | Previous page | Previous control |
  | `next_trigger_label` | Next page | Next control |
  | `item_label` | Page %{page} of %{total_pages} | Page button `aria-label` (`%{page}`, `%{total_pages}` at runtime) |

  Partial override example:

      translation={%Corex.Pagination.Translation{
        prev_trigger_label: Corex.Gettext.gettext("Previous page"),
        next_trigger_label: Corex.Gettext.gettext("Next page")
      }}
  """

  use Corex.Translation,
    camel_keys: [
      root_label: "rootLabel",
      prev_trigger_label: "prevTriggerLabel",
      next_trigger_label: "nextTriggerLabel",
      item_label: "itemLabel"
    ],
    fields: [
      root_label: "Pagination",
      prev_trigger_label: "Previous page",
      next_trigger_label: "Next page",
      item_label: "Page %{page} of %{total_pages}"
    ]
end
