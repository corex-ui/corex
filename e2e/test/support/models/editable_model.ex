defmodule E2eWeb.EditableModel do
  use E2eWeb.Model, component: "editable"

  def goto_form(session, mode) do
    path =
      case mode do
        :static -> "/en/editable/form"
        :live -> "/en/live/editable/form"
      end

    visit(session, path)
  end

  def submit_form(session, mode \\ :static) do
    id = if mode == :live, do: "editable-form-live-submit", else: "editable-form-submit"
    click(session, css("##{id}"))
  end

  def see_flash(session, flash_text) do
    wait_for_text(session, flash_text)
  end
end
