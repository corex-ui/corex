defmodule E2eWeb.PinInputModel do
  use E2eWeb.Model, component: "pin-input"

  def goto_form(session, mode) do
    path =
      case mode do
        :static -> "/en/pin-input/form"
        :live -> "/en/live/pin-input/form"
      end

    visit(session, path)
  end

  def submit_form(session, mode \\ :static) do
    id = if mode == :live, do: "pin-input-form-live-submit", else: "pin-input-form-submit"
    click(session, css("##{id}"))
  end

  def see_flash(session, flash_text) do
    wait_for_text(session, flash_text)
  end
end
