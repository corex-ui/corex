defmodule Corex.Select.Translation do
  @moduledoc """
  Translatable strings for [`Corex.Select`](Corex.Select.html).

  Pass `translation={%Corex.Select.Translation{}}` to override any field. Omitted fields use gettext defaults (see table).

  | Field | Default | Used for |
  | ----- | ------- | -------- |
  | `placeholder` | Select | Trigger label when nothing is selected |

  Partial override example:

      translation={%Corex.Select.Translation{placeholder: Corex.Gettext.gettext("Choose a country")}}
  """

  use Corex.Translation, fields: [placeholder: "Select"]
end
