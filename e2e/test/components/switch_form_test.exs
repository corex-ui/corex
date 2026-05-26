defmodule E2eWeb.SwitchFormTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  import Wallaby.Query

  alias E2eWeb.SwitchModel, as: Switch

  feature "static form - submit unchecked shows notifications=false", %{session: session} do
    session
    |> Switch.goto_form(:static)
    |> Switch.wait_for_has(css("#switch-form-page"), timeout: 15_000)
    |> Switch.submit_form()
    |> Switch.see_flash("notifications=false")
  end

  feature "static form - click switch then submit shows notifications=true", %{session: session} do
    session
    |> Switch.goto_form(:static)
    |> Switch.wait_for_has(css("#switch-form-page"), timeout: 15_000)
    |> Switch.click_switch()
    |> Switch.submit_form()
    |> Switch.see_flash("notifications=true")
  end

  feature "live form - submit without toggling then toggle and submit shows success",
          %{session: session} do
    session =
      session
      |> Switch.goto_form(:live)
      |> Switch.wait_for_has(css("#switch-form-live-page"), timeout: 15_000)

    session = Switch.submit_form(session, :live)
    Switch.see_error(session, "must be accepted")

    session =
      session
      |> Switch.click_switch(:live)
      |> Switch.submit_form(:live)

    Switch.see_flash(session, "notifications=true")
  end

  feature "static form - switch form has no A11y violations", %{session: session} do
    session
    |> Switch.goto_form(:static)
    |> Switch.wait_for_has(css("#switch-form-page"), timeout: 15_000)
    |> Switch.check_accessibility()
  end

  feature "live form - switch form has no A11y violations", %{session: session} do
    session
    |> Switch.goto_form(:live)
    |> Switch.wait_for_has(css("#switch-form-live-page"), timeout: 15_000)
    |> Switch.check_accessibility()
  end

  feature "live form - click switch then submit shows success", %{session: session} do
    session
    |> Switch.goto_form(:live)
    |> Switch.wait_for_has(css("#switch-form-live-page"), timeout: 15_000)
    |> Switch.click_switch(:live)
    |> Switch.submit_form(:live)
    |> Switch.see_flash("notifications=true")
  end
end
