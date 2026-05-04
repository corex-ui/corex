defmodule E2eWeb.DatePickerFormTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  alias E2eWeb.DatePickerModel, as: DatePicker

  feature "static form - submit empty/default includes date", %{session: session} do
    session
    |> DatePicker.goto_form(:static)
    |> DatePicker.submit_form()
    |> DatePicker.see_flash("Submitted (changeset): date=")
  end

  feature "static form - has no A11y violations", %{session: session} do
    session
    |> DatePicker.goto_form(:static)
    |> DatePicker.check_accessibility()
  end

  feature "live form - submit default date", %{session: session} do
    session
    |> DatePicker.goto_form(:live)
    |> DatePicker.submit_form(:live)
    |> DatePicker.see_flash("date=")
  end

  feature "live form - has no A11y violations", %{session: session} do
    session
    |> DatePicker.goto_form(:live)
    |> DatePicker.check_accessibility()
  end
end
