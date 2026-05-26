defmodule Corex.Combobox.Translation do
  @moduledoc """
  Translatable strings for [`Corex.Combobox`](Corex.Combobox.html).

  Pass `translation={%Corex.Combobox.Translation{}}` to override any field. Omitted fields use gettext defaults (see table).

  | Field | Default | Used for |
  | ----- | ------- | -------- |
  | `placeholder` | Select | Input placeholder |
  | `empty` | No results | Empty list message |
  | `trigger` | Open options | Trigger button `aria-label` |
  | `clear_selection` | Clear selection | Clear button `aria-label` |

  Partial override example:

      translation={%Corex.Combobox.Translation{
        placeholder: Corex.Gettext.gettext("Country"),
        empty: Corex.Gettext.gettext("No matches")
      }}
  """

  use Corex.Translation,
    map_merge: true,
    fields: [
      placeholder: "Select",
      empty: "No results",
      trigger: "Open options",
      clear_selection: "Clear selection"
    ]
end
