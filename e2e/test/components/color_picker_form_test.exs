defmodule E2eWeb.ColorPickerFormTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  import Wallaby.Query

  alias E2eWeb.ColorPickerModel, as: ColorPicker

  feature "static form - submit empty/default includes color", %{session: session} do
    session
    |> ColorPicker.goto_form(:static)
    |> ColorPicker.wait_for_has(Wallaby.Query.css("#color-picker-form-page"), timeout: 15_000)
    |> ColorPicker.wait(200)
    |> ColorPicker.submit_form()
    |> ColorPicker.wait(500)
    |> ColorPicker.see_flash("Submitted: color=")
  end

  feature "static form - has no A11y violations", %{session: session} do
    session
    |> ColorPicker.goto_form(:static)
    |> ColorPicker.wait_for_has(Wallaby.Query.css("#color-picker-form-page"), timeout: 15_000)
    |> ColorPicker.wait(200)
    |> ColorPicker.check_accessibility()
  end

  feature "live form - submit default color", %{session: session} do
    session
    |> ColorPicker.goto_form(:live)
    |> ColorPicker.wait_for_has(css("#color-picker-form-live-page"), timeout: 15_000)
    |> ColorPicker.wait(200)
    |> ColorPicker.submit_form(:live)
    |> ColorPicker.wait(2000)
    |> ColorPicker.see_flash("color=")
  end

  feature "live form - has no A11y violations", %{session: session} do
    session
    |> ColorPicker.goto_form(:live)
    |> ColorPicker.wait_for_has(css("#color-picker-form-live-page"), timeout: 15_000)
    |> ColorPicker.wait(200)
    |> ColorPicker.check_accessibility()
  end
end
