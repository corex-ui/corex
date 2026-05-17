defmodule Corex.Select.Translation do
  @moduledoc """
  Translatable strings for the select control.

  Pass `translation={%Corex.Select.Translation{}}` to override any field. Omitted fields use gettext defaults (see table).

  | Field | Default | Used for |
  | ----- | ------- | -------- |
  | `placeholder` | Select | Trigger label when nothing is selected |

  Partial override example:

      translation={%Corex.Select.Translation{placeholder: Corex.Gettext.gettext("Choose a country")}}
  """

  alias Corex.Gettext

  defstruct [:placeholder]

  @type t :: %__MODULE__{placeholder: String.t()}

  @doc false
  def resolve(nil), do: default()

  def resolve(%__MODULE__{} = partial), do: merge(partial, default())

  defp default do
    %__MODULE__{placeholder: Gettext.gettext("Select")}
  end

  defp merge(%__MODULE__{} = partial, %__MODULE__{} = default) do
    %__MODULE__{
      placeholder: Corex.Translation.take(partial.placeholder, default.placeholder)
    }
  end
end
