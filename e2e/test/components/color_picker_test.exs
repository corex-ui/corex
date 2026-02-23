defmodule E2eWeb.ColorPickerTest do
  use ExUnit.Case, async: true
  use Wallaby.Feature

  alias E2eWeb.ColorPickerModel, as: ColorPicker

  feature "static - ColorPicker has no A11y violations", %{session: session} do
    session
    |> ColorPicker.goto(:static)
    |> ColorPicker.check_accessibility()
  end
end
