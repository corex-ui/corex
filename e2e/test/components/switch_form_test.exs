defmodule E2eWeb.SwitchFormTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  alias E2eWeb.SwitchModel, as: Switch

  feature "static form - submit unchecked includes notifications", %{session: session} do
    session
    |> Switch.goto_form(:static)
    |> Switch.wait(500)
    |> Switch.submit_form()
    |> Switch.wait(500)
    |> Switch.see_flash("Submitted: notifications=")
  end

  feature "static form - click switch then submit includes notifications", %{session: session} do
    session
    |> Switch.goto_form(:static)
    |> Switch.wait(500)
    |> Switch.click_switch()
    |> Switch.wait(200)
    |> Switch.submit_form()
    |> Switch.wait(500)
    |> Switch.see_flash("Submitted: notifications=")
  end

  feature "live form (controlled) - submit without toggling then toggle and submit shows success",
          %{session: session} do
    session =
      session
      |> Switch.goto_form(:live)
      |> Switch.wait(500)
      |> Switch.click_terms_checkbox()
      |> Switch.wait(200)

    session = Switch.submit_form(session, :live)
    session = Switch.wait(session, 500)
    Switch.see_submitted_value(session, "notifications", "false")

    session =
      session
      |> Switch.click_switch()
      |> Switch.wait(200)
      |> Switch.submit_form(:live)
      |> Switch.wait(500)

    Switch.see_submitted_value(session, "notifications", "true")
  end

  feature "static form - switch form has no A11y violations", %{session: session} do
    session
    |> Switch.goto_form(:static)
    |> Switch.wait(500)
    |> Switch.check_accessibility()
  end

  feature "live form - switch form has no A11y violations", %{session: session} do
    session
    |> Switch.goto_form(:live)
    |> Switch.wait(500)
    |> Switch.check_accessibility()
  end

  feature "live form - Space toggles switch", %{session: session} do
    session =
      session
      |> Switch.goto_form(:live)
      |> Switch.wait(500)

    session = Switch.press_space_on_switch(session)
    session = Switch.wait(session, 500)
    session = Switch.submit_form(session, :live)
    session = Switch.wait(session, 1500)
    Switch.see_submitted_value(session, "notifications", "true")
  end
end
