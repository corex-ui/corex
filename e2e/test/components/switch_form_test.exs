defmodule E2eWeb.SwitchFormTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  import Wallaby.Query

  alias E2eWeb.SwitchModel, as: Switch

  feature "static form - submit unchecked includes notifications", %{session: session} do
    session
    |> Switch.goto_form(:static)
    |> Switch.wait_for_has(css("#switch-form-page"), timeout: 15_000)
    |> Switch.wait(200)
    |> Switch.submit_form()
    |> Switch.wait(500)
    |> Switch.see_flash("Submitted (changeset): notifications=")
  end

  feature "static form - click switch then submit includes notifications", %{session: session} do
    session
    |> Switch.goto_form(:static)
    |> Switch.wait_for_has(css("#switch-form-page"), timeout: 15_000)
    |> Switch.wait(200)
    |> Switch.click_switch()
    |> Switch.wait(200)
    |> Switch.submit_form()
    |> Switch.wait(500)
    |> Switch.see_flash("Submitted (changeset): notifications=")
  end

  feature "live form (controlled) - submit without toggling then toggle and submit shows success",
          %{session: session} do
    session =
      session
      |> Switch.goto_form(:live)
      |> Switch.wait_for_has(css("#switch-form-live-page"), timeout: 15_000)
      |> Switch.wait(200)

    session = Switch.submit_form(session, :live)
    session = Switch.wait(session, 500)
    Switch.see_flash(session, "notifications=false")

    session =
      session
      |> Switch.click_switch(:live)
      |> Switch.wait(200)
      |> Switch.submit_form(:live)
      |> Switch.wait(500)

    Switch.see_flash(session, "notifications=true")
  end

  feature "static form - switch form has no A11y violations", %{session: session} do
    session
    |> Switch.goto_form(:static)
    |> Switch.wait_for_has(css("#switch-form-page"), timeout: 15_000)
    |> Switch.wait(200)
    |> Switch.check_accessibility()
  end

  feature "live form - switch form has no A11y violations", %{session: session} do
    session
    |> Switch.goto_form(:live)
    |> Switch.wait_for_has(css("#switch-form-live-page"), timeout: 15_000)
    |> Switch.wait(200)
    |> Switch.check_accessibility()
  end

  feature "live form - click switch then submit shows success", %{session: session} do
    session
    |> Switch.goto_form(:live)
    |> Switch.wait_for_has(css("#switch-form-live-page"), timeout: 15_000)
    |> Switch.wait(200)
    |> Switch.click_switch(:live)
    |> Switch.wait(200)
    |> Switch.submit_form(:live)
    |> Switch.wait(1500)
    |> Switch.see_flash("notifications=true")
  end
end
