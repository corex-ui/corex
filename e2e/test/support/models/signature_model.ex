defmodule E2eWeb.SignatureModel do
  use E2eWeb.Model, component: "signature"

  def goto_form(session, mode) do
    path =
      case mode do
        :static -> "/en/signature/form"
        :live -> "/en/signature/live-form"
      end

    session = visit_path(session, path)
    if mode == :live, do: prepare_live_form(session), else: session
  end

  def wait_for_signature_field_error(session, _opts \\ []) do
    assert_has(
      session,
      css(~s([data-scope="signature-pad"][data-part="error"]),
        text: "blank"
      )
    )
  end

  def submit_form(session, mode \\ :static) do
    id =
      if mode == :live,
        do: "signature-form-live-submit",
        else: "signature-changeset-submit"

    click(session, css("##{id}"))
  end

  def see_flash(session, flash_text) do
    assert_toast(session, flash_text)
  end
end
