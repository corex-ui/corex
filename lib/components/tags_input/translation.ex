defmodule Corex.TagsInput.Translation do
  @moduledoc """
  Translatable strings for the tags input.

  Used to merge defaults with the `translation` attribute; the result is applied as the HTML `placeholder` on `[data-part="input"]` only.

  Without gettext: `translation={%Corex.TagsInput.Translation{placeholder: "Keywords"}}`

  With gettext: `translation={%Corex.TagsInput.Translation{placeholder: Corex.Gettext.gettext("Keywords")}}`
  """

  defstruct [:placeholder]

  @type t :: %__MODULE__{
          placeholder: String.t() | nil
        }

  @doc false
  def default do
    %__MODULE__{
      placeholder: Corex.Gettext.gettext("Add a tag…")
    }
  end

  @doc false
  def merge(nil, %__MODULE__{} = default), do: default

  def merge(%__MODULE__{} = user, %__MODULE__{} = default) do
    %__MODULE__{
      placeholder: take_override(user.placeholder, default.placeholder)
    }
  end

  defp take_override(nil, fallback), do: fallback
  defp take_override("", fallback), do: fallback
  defp take_override(v, _), do: v
end
