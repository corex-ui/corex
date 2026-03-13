defmodule E2eWeb.DatePickerModel do
  use E2eWeb.Model, component: "date-picker"

  def goto_form(session, mode) do
    path =
      case mode do
        :static -> "/en/date-picker/form"
        :live -> "/en/live/date-picker/form"
      end

    visit(session, path)
  end

  def submit_form(session, mode \\ :static) do
    id = if mode == :live, do: "date-picker-form-live-submit", else: "date-picker-form-submit"
    click(session, css("##{id}"))
  end

  def see_flash(session, flash_text) do
    wait_for_text(session, flash_text)
  end
end
