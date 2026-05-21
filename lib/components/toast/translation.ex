defmodule Corex.Toast.Translation do
  @moduledoc """
  Default titles for flash-driven toasts on [`Corex.Toast`](Corex.Toast.html).

  Pass `translation={%Corex.Toast.Translation{}}` to override any field. Omitted fields use gettext defaults (see table).

  | Field | Default | Used for |
  | ----- | ------- | -------- |
  | `info` | Info | Default title for `:info` flash toasts |
  | `error` | Error | Default title for `:error` flash toasts |

  Partial override example:

      translation={%Corex.Toast.Translation{
        info: Corex.Gettext.gettext("Notice"),
        error: Corex.Gettext.gettext("Something went wrong")
      }}
  """

  use Corex.Translation, fields: [info: "Info", error: "Error"]
end
