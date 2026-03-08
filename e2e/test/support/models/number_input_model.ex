defmodule E2eWeb.NumberInputModel do
  use E2eWeb.Model, component: "number-input"

  def goto_form(session, mode) do
    path =
      case mode do
        :static -> "/en/number-input/form"
        :live -> "/en/live/number-input/form"
      end

    visit(session, path)
  end

  def submit_form(session, mode \\ :static) do
    id = if mode == :live, do: "number-input-form-live-submit", else: "number-input-form-submit"
    click(session, css("##{id}"))
  end

  def see_flash(session, flash_text) do
    wait_for_text(session, flash_text)
  end
end
