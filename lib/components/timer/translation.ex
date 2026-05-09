defmodule Corex.Timer.Translation do
  @moduledoc """
  Strings for Zag timer [`translations`](https://zagjs.com/components/react/timer): `areaLabel` on the timer region.

  Without gettext: `translation={%Corex.Timer.Translation{area_label: "Countdown"}}`

  With gettext: `translation={%Corex.Timer.Translation{area_label: Corex.Gettext.gettext("Countdown")}}`
  """

  defstruct [:area_label]

  @type t :: %__MODULE__{
          area_label: String.t() | nil
        }

  def to_camel_map(%__MODULE__{} = t) do
    %{"areaLabel" => t.area_label}
  end
end
