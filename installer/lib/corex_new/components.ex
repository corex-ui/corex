defmodule Corex.New.Components do
  @moduledoc false

  @default ~w(
    toast layout-heading typo icon link button dialog
    scrollbar checkbox native-input select toggle badge menu accordion
    code clipboard
  )a

  def installer_components(opts \\ []) do
    if Keyword.get(opts, :a11y, false) do
      idx = Enum.find_index(@default, &(&1 == :toggle))
      List.insert_at(@default, idx + 1, :"toggle-group")
    else
      @default
    end
  end
end
