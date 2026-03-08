defmodule E2eWeb.RadioGroupModel do
  use E2eWeb.Model, component: "radio-group"

  def goto_form(session, mode) do
    path =
      case mode do
        :static -> "/en/radio-group/form"
        :live -> "/en/live/radio-group/form"
      end

    visit(session, path)
  end

  def submit_form(session, mode \\ :static) do
    id = if mode == :live, do: "radio-group-form-live-submit", else: "radio-group-form-submit"
    click(session, css("##{id}"))
  end

  def see_flash(session, flash_text) do
    wait_for_text(session, flash_text)
  end
end
