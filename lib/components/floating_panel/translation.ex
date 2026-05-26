defmodule Corex.FloatingPanel.Translation do
  @moduledoc """
  Translatable strings for [`Corex.FloatingPanel`](Corex.FloatingPanel.html).

  Pass `translation={%Corex.FloatingPanel.Translation{}}` to override any field. Omitted fields use gettext defaults (see table).

  | Field | Default | Used for |
  | ----- | ------- | -------- |
  | `minimize` | Minimize window | Minimize trigger `aria-label` |
  | `maximize` | Maximize window | Maximize trigger `aria-label` |
  | `restore` | Restore window | Restore trigger `aria-label` |
  | `close` | Close window | Close trigger `aria-label` |

  Partial override example:

      translation={%Corex.FloatingPanel.Translation{
        minimize: Corex.Gettext.gettext("Minimize"),
        close: Corex.Gettext.gettext("Close panel")
      }}
  """

  use Corex.Translation,
    fields: [
      minimize: "Minimize window",
      maximize: "Maximize window",
      restore: "Restore window",
      close: "Close window"
    ]
end
