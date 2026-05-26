defmodule Corex.Editable.Translation do
  @moduledoc """
  Translatable strings for [`Corex.Editable`](Corex.Editable.html).

  Pass `translation={%Corex.Editable.Translation{}}` to override any field. Omitted fields use gettext defaults (see table).

  | Field | Default | Used for |
  | ----- | ------- | -------- |
  | `input` | editable input | Input `aria-label` while editing |
  | `edit` | edit | Preview and edit trigger `aria-label` |
  | `submit` | submit | Submit trigger `aria-label` |
  | `cancel` | cancel | Cancel trigger `aria-label` |

  Partial override example:

      translation={%Corex.Editable.Translation{
        edit: Corex.Gettext.gettext("Edit text"),
        submit: Corex.Gettext.gettext("Save")
      }}
  """

  use Corex.Translation,
    fields: [
      input: "editable input",
      edit: "edit",
      submit: "submit",
      cancel: "cancel"
    ]
end
