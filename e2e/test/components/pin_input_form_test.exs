defmodule E2eWeb.PinInputFormTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  @moduletag :wallaby

  alias E2eWeb.PinInputModel, as: PinInput

  feature "static form - submit empty includes empty pin", %{session: session} do
    session
    |> PinInput.goto_form(:static)
    |> PinInput.submit_form()
    |> PinInput.wait_for_redirect()
    |> PinInput.see_flash("Submitted: pin=")
  end

  feature "static form - fill pin then submit includes pin", %{session: session} do
    session
    |> PinInput.goto_form(:static)
    |> PinInput.fill_pin_input("1234")
    |> PinInput.submit_form()
    |> PinInput.wait_for_redirect()
    |> PinInput.see_flash(~S|["1", "2", "3", "4"]|)
  end

  feature "static form - has no A11y violations", %{session: session} do
    session
    |> PinInput.goto_form(:static)
    |> PinInput.check_accessibility()
  end

  feature "live form - submit empty pin", %{session: session} do
    session
    |> PinInput.goto_form(:live)
    |> PinInput.submit_form(:live)
    |> PinInput.see_flash("pin=")
  end

  feature "live form - fill pin then submit shows submitted pin", %{session: session} do
    session
    |> PinInput.goto_form(:live)
    |> PinInput.fill_pin_input("1234", :live)
    |> PinInput.submit_form(:live)
    |> PinInput.see_flash(~S|["1", "2", "3", "4"]|)
  end

  feature "live form - has no A11y violations", %{session: session} do
    session
    |> PinInput.goto_form(:live)
    |> PinInput.check_accessibility()
  end
end
