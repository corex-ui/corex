defmodule Corex.NumberInput.Translation do
  @moduledoc """
  Translatable strings for [`Corex.NumberInput`](Corex.NumberInput.html).

  Pass `translation={%Corex.NumberInput.Translation{}}` to override any field. Omitted fields use gettext defaults (see table).

  | Field | Default | Used for |
  | ----- | ------- | -------- |
  | `decrease` | Decrease value | Decrement trigger `aria-label` |
  | `increase` | Increase value | Increment trigger `aria-label` |

  Partial override example:

      translation={%Corex.NumberInput.Translation{
        decrease: Corex.Gettext.gettext("Decrease"),
        increase: Corex.Gettext.gettext("Increase")
      }}
  """

  use Corex.Translation,
    fields: [decrease: "Decrease value", increase: "Increase value"]
end
