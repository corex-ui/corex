defmodule E2eWeb.SelectFormTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  alias E2eWeb.SelectModel, as: Select

  feature "static form - submit without selection includes empty country", %{session: session} do
    session
    |> Select.goto_form(:static)
    |> Select.wait(500)
    |> Select.submit_form()
    |> Select.wait(500)
    |> Select.see_flash("Submitted: country=")
  end

  feature "static form - select country then submit includes country", %{session: session} do
    session
    |> Select.goto_form(:static)
    |> Select.wait(500)
    |> Select.click_form_select_trigger()
    |> Select.wait(200)
    |> Select.select_item("bel")
    |> Select.wait(200)
    |> Select.submit_form()
    |> Select.wait(1000)
    |> Select.see_flash("Submitted: country=")
    |> Select.see_flash("bel")
  end

  feature "live form - select country then submit shows success", %{session: session} do
    session
    |> Select.goto_form(:live)
    |> Select.wait(500)
    |> Select.click_form_select_trigger()
    |> Select.wait(500)
    |> Select.select_item("bel")
    |> Select.wait(500)
    |> Select.submit_form(:live)
    |> Select.wait(2000)
    |> Select.see_flash("Submitted: country=", timeout: 10_000)
    |> Select.see_flash("bel", timeout: 10_000)
  end

  feature "live form - submit without selection does not show success", %{
    session: session
  } do
    session =
      session
      |> Select.goto_form(:live)
      |> Select.wait(500)
      |> Select.submit_form(:live)
      |> Select.wait(1500)

    refute_has(session, Wallaby.Query.text("country=bel"))
    assert_has(session, Wallaby.Query.text("Country"))
  end

  feature "static form - select form has no A11y violations", %{session: session} do
    session
    |> Select.goto_form(:static)
    |> Select.wait(500)
    |> Select.check_accessibility()
  end

  feature "live form - select form has no A11y violations", %{session: session} do
    session
    |> Select.goto_form(:live)
    |> Select.wait(500)
    |> Select.check_accessibility()
  end
end
