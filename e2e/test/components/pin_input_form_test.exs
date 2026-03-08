defmodule E2eWeb.PinInputFormTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  alias E2eWeb.PinInputModel, as: PinInput

  feature "static form - submit includes pin", %{session: session} do
    session
    |> PinInput.goto_form(:static)
    |> PinInput.wait(500)
    |> PinInput.submit_form()
    |> PinInput.wait(500)
    |> PinInput.see_flash("Submitted: pin=")
  end

  feature "static form - has no A11y violations", %{session: session} do
    session
    |> PinInput.goto_form(:static)
    |> PinInput.wait(500)
    |> PinInput.check_accessibility()
  end

  feature "live form - submit includes pin", %{session: session} do
    session
    |> PinInput.goto_form(:live)
    |> PinInput.wait(500)
    |> PinInput.submit_form(:live)
    |> PinInput.wait(2000)
    |> PinInput.see_flash("pin=")
  end

  feature "live form - has no A11y violations", %{session: session} do
    session
    |> PinInput.goto_form(:live)
    |> PinInput.wait(500)
    |> PinInput.check_accessibility()
  end
end
