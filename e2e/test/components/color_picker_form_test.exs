defmodule E2eWeb.ColorPickerFormTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  alias E2eWeb.ColorPickerModel, as: ColorPicker

  feature "static form - submit empty/default includes color", %{session: session} do
    session
    |> ColorPicker.goto_form(:static)
    |> ColorPicker.wait(500)
    |> ColorPicker.submit_form()
    |> ColorPicker.wait(500)
    |> ColorPicker.see_flash("Submitted: color=")
  end

  feature "static form - has no A11y violations", %{session: session} do
    session
    |> ColorPicker.goto_form(:static)
    |> ColorPicker.wait(500)
    |> ColorPicker.check_accessibility()
  end

  feature "live form - submit default color", %{session: session} do
    session
    |> ColorPicker.goto_form(:live)
    |> ColorPicker.wait(500)
    |> ColorPicker.submit_form(:live)
    |> ColorPicker.wait(2000)
    |> ColorPicker.see_flash("color=")
  end

  feature "live form - has no A11y violations", %{session: session} do
    session
    |> ColorPicker.goto_form(:live)
    |> ColorPicker.wait(500)
    |> ColorPicker.check_accessibility()
  end
end
