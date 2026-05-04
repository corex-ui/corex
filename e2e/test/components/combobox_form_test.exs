defmodule E2eWeb.ComboboxFormTest do
  use E2eWeb.ConnCase, async: false
  use Wallaby.Feature

  import Wallaby.Query

  alias E2eWeb.ComboboxModel, as: Combobox

  for {path, ready} <- [
        {"/en/combobox/form", "#combobox-form-submit"},
        {"/en/combobox/live-form", "#airport-combobox"}
      ] do
    @path path
    @ready ready

    feature "a11y #{@path}", %{session: session} do
      Combobox.visit_and_check_a11y(session, @path, css(@ready))
    end
  end
end
