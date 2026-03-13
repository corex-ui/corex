defmodule E2eWeb.SignatureModel do
  use E2eWeb.Model, component: "signature"

  def goto_form(session, mode) do
    path =
      case mode do
        :static -> "/en/signature/form"
        :live -> "/en/live/signature/form"
      end

    visit(session, path)
  end

  def submit_form(session, mode \\ :static) do
    id = if mode == :live, do: "signature-form-live-submit", else: "signature-form-submit"
    click(session, css("##{id}"))
  end

  def see_flash(session, flash_text) do
    wait_for_text(session, flash_text)
  end
end
