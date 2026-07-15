defmodule E2eWeb.ComboboxFormTest do
  use E2eWeb.ConnCase, async: false
  use Wallaby.Feature

  @moduletag :wallaby

  import Wallaby.Query

  alias E2eWeb.ComboboxModel, as: Combobox

  for {path, ready} <- [
        {"/en/combobox/form", "#combobox-form-phoenix button[type='submit']"},
        {"/en/combobox/live-form", "#combobox-live-form-phoenix-submit"}
      ] do
    @path path
    @ready ready

    feature "a11y #{@path}", %{session: session} do
      Combobox.visit_and_check_a11y(session, @path, css(@ready))
    end
  end
end
