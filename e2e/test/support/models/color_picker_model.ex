defmodule E2eWeb.ColorPickerModel do
  use E2eWeb.Model, component: "color-picker"

  def goto_form(session, mode) do
    path =
      case mode do
        :static -> "/en/color-picker/form"
        :live -> "/en/live/color-picker/form"
      end

    visit(session, path)
  end

  def submit_form(session, mode \\ :static) do
    id = if mode == :live, do: "color-picker-form-live-submit", else: "color-picker-form-submit"
    click(session, css("##{id}"))
  end

  def see_flash(session, flash_text) do
    wait_for_text(session, flash_text)
  end
end
