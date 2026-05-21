defmodule Corex.Dialog.Translation do
  @moduledoc """
  Translatable strings for [`Corex.Dialog`](Corex.Dialog.html).

  Pass `translation={%Corex.Dialog.Translation{}}` to override any field. Omitted fields use gettext defaults (see table).

  | Field | Default | Used for |
  | ----- | ------- | -------- |
  | `close` | Close | Close trigger `aria-label` |
  | `label` | Dialog | Accessible name when no visible title (`data-dialog-default-label`) |

  Partial override example:

      translation={%Corex.Dialog.Translation{
        close: Corex.Gettext.gettext("Dismiss"),
        label: Corex.Gettext.gettext("Modal")
      }}
  """

  use Corex.Translation, fields: [close: "Close", label: "Dialog"]
end
