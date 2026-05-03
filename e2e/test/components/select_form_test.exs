defmodule E2eWeb.SelectFormTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  alias E2eWeb.SelectModel, as: Select

  feature "static form - submit without selection includes empty country", %{session: session} do
    session
    |> Select.goto_form(:static)
    |> Select.submit_form()
    |> Select.wait_for_select_field_error(:static)
  end

  feature "static form - select country then submit includes country", %{session: session} do
    session
    |> Select.goto_form(:static)
    |> Select.click_form_select_trigger(:static)
    |> Select.select_item("bel")
    |> Select.submit_form()
    |> Select.see_flash("Submitted (changeset): country=\"bel\"")
  end

  feature "live form - select country then submit shows success", %{session: session} do
    session
    |> Select.goto_form(:live)
    |> Select.click_form_select_trigger(:live)
    |> Select.select_item("bel")
    |> Select.submit_form(:live)
    |> Select.see_flash("Submitted: country=bel")
  end

  feature "live form - submit without selection does not show success", %{
    session: session
  } do
    session =
      session
      |> Select.goto_form(:live)
      |> Select.submit_form(:live)

    refute_has(session, Wallaby.Query.text("country=bel"))
    assert_has(session, Wallaby.Query.css("#select-form", text: "Country"))
  end

  feature "static form - select form has no A11y violations", %{session: session} do
    session
    |> Select.goto_form(:static)
    |> Select.check_accessibility()
  end

  feature "live form - select form has no A11y violations", %{session: session} do
    session
    |> Select.goto_form(:live)
    |> Select.check_accessibility()
  end
end
