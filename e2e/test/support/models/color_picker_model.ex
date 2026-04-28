defmodule E2eWeb.ColorPickerModel do
  use E2eWeb.Model, component: "color-picker"

  def goto_form(session, mode) do
    path =
      case mode do
        :static -> "/en/color-picker/form"
        :live -> "/en/color-picker/live-form"
      end

    session = visit_path(session, path)
    if mode == :live, do: prepare_live_form(session), else: session
  end

  def submit_form(session, mode \\ :static) do
    id =
      if mode == :live,
        do: "color-picker-basic-form-live-submit",
        else: "color-picker-form-submit"

    click(session, css("##{id}"))
  end

  def see_flash(session, flash_text) do
    assert_toast(session, flash_text)
  end
end
