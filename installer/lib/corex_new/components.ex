defmodule Corex.New.Components do
  @moduledoc """
  The `config :corex_design, components:` list written into generated apps.

  Hardcoded rather than derived from `Corex.Design.Components`: the installer is
  a Mix archive with no runtime access to `corex_design`. `test/components_test.exs`
  checks the list against the real registry so it cannot drift.
  """

  @default ~w(
    toast layout-heading typo icon link button button-group dialog password-input
    scrollbar checkbox data-list data-table date-picker native-input number-input
    select toggle toggle-group
  )a

  def installer_components(_opts \\ []), do: @default
end
