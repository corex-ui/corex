defmodule Corex.Timer.Translation do
  @moduledoc """
  Strings for Zag timer [`translations`](https://zagjs.com/components/react/timer).

  Pass `translation={%Corex.Timer.Translation{}}` to override any field. Omitted fields use gettext defaults (see table).

  | Field | Default | Used for |
  | ----- | ------- | -------- |
  | `area_label` | Timer | Timer region `aria-label` |

  Partial override example:

      translation={%Corex.Timer.Translation{area_label: Corex.Gettext.gettext("Countdown")}}
  """

  alias Corex.Gettext

  defstruct [:area_label]

  @type t :: %__MODULE__{area_label: String.t()}

  @doc false
  def resolve(nil), do: default()

  def resolve(%__MODULE__{} = partial), do: merge(partial, default())

  defp default do
    %__MODULE__{area_label: Gettext.gettext("Timer")}
  end


  defp merge(%__MODULE__{} = partial, %__MODULE__{} = default) do
    %__MODULE__{
      area_label: Corex.Translation.take(partial.area_label, default.area_label)
    }
  end

  def to_camel_map(%__MODULE__{} = t) do
    %{"areaLabel" => t.area_label}
  end
end
