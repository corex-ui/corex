defmodule E2eWeb.NumberInputFormTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  alias E2eWeb.NumberInputModel, as: NumberInput

  feature "static form - submit empty includes default value", %{session: session} do
    session
    |> NumberInput.goto_form(:static)
    |> NumberInput.submit_form()
    |> NumberInput.see_flash("Submitted: value=1234")
  end

  feature "static form - fill value then submit includes value", %{session: session} do
    session
    |> NumberInput.goto_form(:static)
    |> NumberInput.fill_number_input("42", :static)
    |> NumberInput.submit_form()
    |> NumberInput.see_flash("42")
  end

  feature "static form - has no A11y violations", %{session: session} do
    session
    |> NumberInput.goto_form(:static)
    |> NumberInput.check_accessibility()
  end

  feature "live form - submit default value", %{session: session} do
    session
    |> NumberInput.goto_form(:live)
    |> NumberInput.submit_form(:live)
    |> NumberInput.see_flash("Submitted: 1234")
  end

  feature "live form - fill value then submit shows submitted value", %{session: session} do
    session
    |> NumberInput.goto_form(:live)
    |> NumberInput.fill_number_input("42", :live)
    |> NumberInput.submit_form(:live)
    |> NumberInput.see_flash("42", timeout: 12_000)
  end

  feature "live form - has no A11y violations", %{session: session} do
    session
    |> NumberInput.goto_form(:live)
    |> NumberInput.check_accessibility()
  end
end
