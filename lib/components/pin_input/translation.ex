defmodule Corex.PinInput.Translation do
  @moduledoc """
  Translatable strings for [`Corex.PinInput`](Corex.PinInput.html).

  Pass `translation={%Corex.PinInput.Translation{}}` to override any field. Omitted fields use gettext defaults (see table).

  | Field | Default | Used for |
  | ----- | ------- | -------- |
  | `digit` | Digit %{digit} | Per-cell `aria-label` (`%{digit}` is the 1-based index at render) |

  Partial override example:

      translation={%Corex.PinInput.Translation{
        digit: Corex.Gettext.gettext("Cell %{digit}", digit: "%{digit}")
      }}
  """

  alias Corex.Gettext

  defstruct [:digit]

  @type t :: %__MODULE__{digit: String.t()}

  @doc "Merges partial fields with gettext defaults."
  def resolve(nil), do: default()

  def resolve(%__MODULE__{} = partial), do: merge(partial, default())

  defp default do
    %__MODULE__{digit: Gettext.gettext("Digit %{digit}", digit: "%{digit}")}
  end

  defp merge(%__MODULE__{} = partial, %__MODULE__{} = default) do
    %__MODULE__{digit: Corex.Translation.take(partial.digit, default.digit)}
  end
end
