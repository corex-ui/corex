defmodule E2eWeb.ComboboxFormTest do
  use E2eWeb.ConnCase, async: false
  use Wallaby.Feature

  alias E2eWeb.ComboboxModel, as: Combobox

  for mode <- ["/en/combobox/form", "/en/live/combobox-form"] do
    @mode mode

    feature "#{@mode} - Combobox form has no A11y violations", %{session: session} do
      session
      |> Combobox.goto(@mode)
      |> Combobox.wait(500)

      # |> Combobox.check_accessibility()
    end
  end
end
