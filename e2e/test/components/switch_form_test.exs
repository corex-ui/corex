defmodule E2eWeb.SwitchFormTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  alias E2eWeb.SwitchModel, as: Switch

  feature "static form - submit unchecked shows notifications=false", %{session: session} do
    session
    |> Switch.goto_form(:static)
    |> Switch.submit_form()
    |> Switch.see_flash("notifications=false")
  end

  feature "static form - click switch then submit shows notifications=true", %{session: session} do
    session
    |> Switch.goto_form(:static)
    |> Switch.click_switch()
    |> Switch.submit_form()
    |> Switch.see_flash("notifications=true")
  end

  feature "live form - submit without toggling then toggle and submit shows success",
          %{session: session} do
    session
    |> Switch.goto_form(:live)
    |> Switch.submit_form(:live)
    |> Switch.see_error("must be accepted", :live)
    |> Switch.click_switch(:live)
    |> Switch.submit_form(:live)
    |> Switch.see_flash("notifications=true")
  end

  feature "static form - switch form has no A11y violations", %{session: session} do
    session
    |> Switch.goto_form(:static)
    |> Switch.check_accessibility()
  end

  feature "live form - switch form has no A11y violations", %{session: session} do
    session
    |> Switch.goto_form(:live)
    |> Switch.check_accessibility()
  end

  feature "live form - click switch then submit shows success", %{session: session} do
    session
    |> Switch.goto_form(:live)
    |> Switch.click_switch(:live)
    |> Switch.submit_form(:live)
    |> Switch.see_flash("notifications=true")
  end
end
