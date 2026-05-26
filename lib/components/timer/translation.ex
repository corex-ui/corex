defmodule Corex.Timer.Translation do
  @moduledoc """
  Translatable strings for [`Corex.Timer`](Corex.Timer.html).

  Pass `translation={%Corex.Timer.Translation{}}` to override any field. Omitted fields use gettext defaults (see table).

  | Field | Default | Used for |
  | ----- | ------- | -------- |
  | `area_label` | Timer | Timer region `aria-label` |

  Partial override example:

      translation={%Corex.Timer.Translation{area_label: Corex.Gettext.gettext("Countdown")}}
  """

  use Corex.Translation,
    camel_keys: [area_label: "areaLabel"],
    fields: [area_label: "Timer"]
end
