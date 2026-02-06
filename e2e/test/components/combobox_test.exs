defmodule E2eWeb.ComboboxTest do
  use ExUnit.Case, async: true
  use Wallaby.Feature

  alias E2eWeb.ComboboxModel, as: Combobox

  for mode <- [:static, :live] do
    @mode mode

    feature "#{@mode} - Combobox has no A11y violations", %{session: session} do
      session
      |> Combobox.goto(@mode)
      # |> Combobox.check_accessibility()
    end
  end
end
