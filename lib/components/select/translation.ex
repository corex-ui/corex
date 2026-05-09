defmodule Corex.Select.Translation do
  @moduledoc """
  Translation struct for Select component strings.

  Without gettext: `translation={%Corex.Select.Translation{placeholder: "Choose an option"}}`

  With gettext: `translation={%Corex.Select.Translation{placeholder: Corex.Gettext.gettext("Select")}}`
  """

  defstruct [:placeholder]
end
