defmodule Corex.DataTable.Translation do
  @moduledoc """
  Translatable strings for [`Corex.DataTable`](Corex.DataTable.html).

  Pass `translation={%Corex.DataTable.Translation{}}` to override any field. Omitted fields use gettext defaults (see table).

  | Field | Default | Used for |
  | ----- | ------- | -------- |
  | `actions` | Actions | Actions column header |
  | `select_all` | Select all | Select-all checkbox `aria-label` |
  | `select_row` | Select row | Row checkbox `aria-label` |

  Partial override example:

      translation={%Corex.DataTable.Translation{
        actions: Corex.Gettext.gettext("Options"),
        select_all: Corex.Gettext.gettext("Select every row")
      }}
  """

  use Corex.Translation,
    fields: [actions: "Actions", select_all: "Select all", select_row: "Select row"]
end
