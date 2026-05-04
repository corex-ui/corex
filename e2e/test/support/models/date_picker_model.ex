defmodule E2eWeb.DatePickerModel do
  use E2eWeb.Model, component: "date-picker"

  def goto_form(session, mode) do
    path =
      case mode do
        :static -> "/en/date-picker/form"
        :live -> "/en/date-picker/live-form"
      end

    session = visit_path(session, path)
    if mode == :live, do: prepare_live_form(session), else: session
  end

  def submit_form(session, mode \\ :static) do
    id =
      if mode == :live,
        do: "date-picker-basic-form-live-submit",
        else: "date-picker-changeset-form-submit"

    click(session, css("##{id}"))
  end

  def see_flash(session, flash_text) do
    assert_toast(session, flash_text)
  end
end
