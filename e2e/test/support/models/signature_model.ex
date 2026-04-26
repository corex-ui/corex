defmodule E2eWeb.SignatureModel do
  use E2eWeb.Model, component: "signature"

  def goto_form(session, mode) do
    path =
      case mode do
        :static -> "/en/signature/form"
        :live -> "/en/signature/live-form"
      end

    session = visit_path(session, path)
    if mode == :live, do: prepare_live_form_for_push_toast(session), else: session
  end

  def wait_for_signature_field_error(session, opts \\ []) do
    timeout_ms = Keyword.get(opts, :timeout, 10_000)
    interval_ms = Keyword.get(opts, :interval, 200)
    deadline = System.monotonic_time(:millisecond) + timeout_ms
    q = css(~s([data-scope="signature-pad"][data-part="error"]), visible: :any)
    wait_until_signature_error(session, q, deadline, interval_ms)
    el = find(session, q)
    assert String.contains?(Wallaby.Element.text(el), "blank")
    session
  end

  defp wait_until_signature_error(session, q, deadline, interval_ms) do
    if has?(session, q) do
      el = find(session, q)

      if String.contains?(Wallaby.Element.text(el), "blank") do
        :ok
      else
        if System.monotonic_time(:millisecond) >= deadline do
          flunk(
            "expected signature pad error text to mention \"blank\", got #{inspect(Wallaby.Element.text(el))}"
          )
        else
          Process.sleep(interval_ms)
          wait_until_signature_error(session, q, deadline, interval_ms)
        end
      end
    else
      if System.monotonic_time(:millisecond) >= deadline do
        flunk("expected signature pad error [data-part=error] within timeout")
      else
        Process.sleep(interval_ms)
        wait_until_signature_error(session, q, deadline, interval_ms)
      end
    end
  end

  def submit_form(session, mode \\ :static) do
    id =
      if mode == :live,
        do: "signature-form-live-submit",
        else: "signature-changeset-submit"

    click(session, css("##{id}"))
  end

  def see_flash(session, flash_text) do
    wait_for_flash(session, flash_text)
  end
end
