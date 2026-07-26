defmodule E2eWeb.ComboboxFormTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  @moduletag :wallaby

  import Wallaby.Query

  alias E2eWeb.ComboboxModel, as: Combobox

  feature "live form - select country then submit shows success", %{session: session} do
    session
    |> Combobox.goto_form(:live)
    |> Combobox.click_form_combobox_trigger(:live, :phoenix)
    |> Combobox.select_item("bel")
    |> Combobox.submit_form(:live, :phoenix)
    |> Combobox.see_flash(~s(country="bel"))
  end

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
