defmodule Corex.ColorPicker.Translation do
  @moduledoc """
  Translatable strings for [`Corex.ColorPicker`](Corex.ColorPicker.html).

  Pass `translation={%Corex.ColorPicker.Translation{}}` to override any field. Omitted fields use gettext defaults (see table).

  | Field | Default | Used for |
  | ----- | ------- | -------- |
  | `hex` | Hex color value | Hex channel input `aria-label` |
  | `alpha` | Alpha (opacity) value | Alpha channel input `aria-label` |

  Partial override example:

      translation={%Corex.ColorPicker.Translation{
        hex: Corex.Gettext.gettext("Hex code"),
        alpha: Corex.Gettext.gettext("Opacity")
      }}
  """

  use Corex.Translation,
    fields: [hex: "Hex color value", alpha: "Alpha (opacity) value"]
end
