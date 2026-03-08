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

  def click_radio_item(session, value) do
    click(session, css("[data-scope='radio-group'][data-part='item'][data-value='#{value}']"))
  end

  def wait_for_redirect(session) do
    wait_for_text(session, "Radio Group form")
  end

  def submit_form(session, mode \\ :static) do
    id = if mode == :live, do: "radio-group-form-live-submit", else: "radio-group-form-submit"
    click(session, css("##{id}"))
  end

  def see_flash(session, flash_text) do
    wait_for_text(session, flash_text)
  end
end
