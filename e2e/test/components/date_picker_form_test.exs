defmodule E2eWeb.DatePickerFormTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  alias E2eWeb.DatePickerModel, as: DatePicker

  feature "static form - submit empty/default includes date", %{session: session} do
    session
    |> DatePicker.goto_form(:static)
    |> DatePicker.wait(500)
    |> DatePicker.submit_form()
    |> DatePicker.wait(500)
    |> DatePicker.see_flash("Submitted: date=")
  end

  feature "static form - has no A11y violations", %{session: session} do
    session
    |> DatePicker.goto_form(:static)
    |> DatePicker.wait(500)
    |> DatePicker.check_accessibility()
  end

  feature "live form - submit default date", %{session: session} do
    session
    |> DatePicker.goto_form(:live)
    |> DatePicker.wait(500)
    |> DatePicker.submit_form(:live)
    |> DatePicker.wait(2000)
    |> DatePicker.see_flash("date=")
  end

  feature "live form - has no A11y violations", %{session: session} do
    session
    |> DatePicker.goto_form(:live)
    |> DatePicker.wait(500)
    |> DatePicker.check_accessibility()
  end
end
