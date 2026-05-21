defmodule Corex.PasswordInput.Translation do
  @moduledoc """
  Translatable strings for [`Corex.PasswordInput`](Corex.PasswordInput.html).

  Pass `translation={%Corex.PasswordInput.Translation{}}` to override any field. Omitted fields use gettext defaults (see table).

  | Field | Default | Used for |
  | ----- | ------- | -------- |
  | `toggle_visibility` | Toggle password visibility | Visibility trigger `aria-label` |

  Partial override example:

      translation={%Corex.PasswordInput.Translation{
        toggle_visibility: Corex.Gettext.gettext("Show password")
      }}
  """

  use Corex.Translation, fields: [toggle_visibility: "Toggle password visibility"]
end
