defmodule E2eWeb.NumberInputFormTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  alias E2eWeb.NumberInputModel, as: NumberInput

  feature "static form - submit includes value", %{session: session} do
    session
    |> NumberInput.goto_form(:static)
    |> NumberInput.wait(500)
    |> NumberInput.submit_form()
    |> NumberInput.wait(500)
    |> NumberInput.see_flash("Submitted: value=")
  end

  feature "static form - has no A11y violations", %{session: session} do
    session
    |> NumberInput.goto_form(:static)
    |> NumberInput.wait(500)
    |> NumberInput.check_accessibility()
  end

  feature "live form - submit includes value", %{session: session} do
    session
    |> NumberInput.goto_form(:live)
    |> NumberInput.wait(500)
    |> NumberInput.submit_form(:live)
    |> NumberInput.wait(2000)
    |> NumberInput.see_flash("value=")
  end

  feature "live form - has no A11y violations", %{session: session} do
    session
    |> NumberInput.goto_form(:live)
    |> NumberInput.wait(500)
    |> NumberInput.check_accessibility()
  end
end
