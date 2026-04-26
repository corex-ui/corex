defmodule E2eWeb.EditableModel do
  use E2eWeb.Model, component: "editable"

  def goto_form(session, mode) do
    path =
      case mode do
        :static -> "/en/editable/form"
        :live -> "/en/editable/live-form"
      end

    session = visit_path(session, path)
    if mode == :live, do: prepare_live_form_for_push_toast(session), else: session
  end

  def submit_form(session, mode \\ :static) do
    id = if mode == :live, do: "editable-form-live-submit", else: "editable-form-submit"
    click(session, css("##{id}"))
  end

  def see_flash(session, flash_text) do
    wait_for_flash(session, flash_text)
  end
end
