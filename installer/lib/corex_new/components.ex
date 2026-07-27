defmodule Corex.New.Components do
  @moduledoc """
  The `config :corex_design, components:` list written into generated apps.

  Hardcoded rather than derived from `Corex.Design.Components`: the installer is
  a Mix archive with no runtime access to `corex_design`. `test/components_test.exs`
  checks the list against the real registry so it cannot drift.
  """

  @default ~w(
    toast layout-heading typo icon link button dialog
    scrollbar checkbox native-input select toggle badge menu accordion
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
