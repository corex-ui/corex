defmodule E2eWeb.SignatureModel do
  use E2eWeb.Model, component: "signature"

  import Wallaby.Query

  @anatomy_sections ~w(
    signature-anatomy-minimal
    signature-anatomy-with-label
  )

  def anatomy_section_ids, do: @anatomy_sections

  def valid_dom_id?(dom_id) do
    String.match?(dom_id, ~r/^[a-zA-Z0-9_-]+$/) and String.length(dom_id) > 0
  end

  def wait_host_signature_ready(session, host_dom_id, opts \\ []) do
    if not valid_dom_id?(host_dom_id), do: raise(ArgumentError, "invalid host dom id")

    timeout = Keyword.get(opts, :timeout)

    q =
      css(~s|##{host_dom_id}[phx-hook="SignaturePad"]:not([data-loading])|, visible: :any)

    case timeout do
      nil -> assert_has(session, q)
      max_ms when is_integer(max_ms) and max_ms > 0 -> wait_for_has(session, q, timeout: max_ms)
    end

    session
  end

  def wait_section_signature_ready(session, section_dom_id, opts \\ []) do
    if not valid_dom_id?(section_dom_id), do: raise(ArgumentError, "invalid section dom id")

    timeout = Keyword.get(opts, :timeout)

    q =
      css(
        ~s|section##{section_dom_id} [phx-hook="SignaturePad"]:not([data-loading])|,
        visible: :any
      )

    case timeout do
      nil -> assert_has(session, q)
      max_ms when is_integer(max_ms) and max_ms > 0 -> wait_for_has(session, q, timeout: max_ms)
    end

    session
  end

  def draw_stroke_in_host(session, host_dom_id) do
    if not valid_dom_id?(host_dom_id), do: raise(ArgumentError, "invalid host dom id")

    _ =
      execute_script(
        session,
        """
        (function () {
          const root = document.getElementById(arguments[0]);
          if (!root) return;
          const control = root.querySelector('[data-scope="signature-pad"][data-part="control"]');
          if (!control) return;
          const rect = control.getBoundingClientRect();
          const x = rect.left + rect.width * 0.3;
          const y = rect.top + rect.height * 0.5;
          const down = new PointerEvent('pointerdown', { bubbles: true, clientX: x, clientY: y, pointerId: 1, pointerType: 'pen' });
          const move = new PointerEvent('pointermove', { bubbles: true, clientX: x + 40, clientY: y + 10, pointerId: 1, pointerType: 'pen' });
          const up = new PointerEvent('pointerup', { bubbles: true, clientX: x + 40, clientY: y + 10, pointerId: 1, pointerType: 'pen' });
          control.dispatchEvent(down);
          control.dispatchEvent(move);
          control.dispatchEvent(up);
        })();
        """,
        [host_dom_id]
      )

    session
  end

  def wait_has_segment_in_host(session, host_dom_id, opts \\ []) do
    wait_for_has(
      session,
      css(
        ~s|##{host_dom_id} [data-scope="signature-pad"][data-part="segment"]|,
        visible: :any
      ),
      opts
    )

    session
  end

  def click_clear_trigger_in_host(session, host_dom_id) do
    click(
      session,
      css(
        ~s|##{host_dom_id} [data-scope="signature-pad"][data-part="clear-trigger"]|,
        visible: :any
      )
    )

    session
  end

  def refute_segment_in_host(session, host_dom_id, opts \\ []) do
    wait_for_refute_has(
      session,
      css(~s|##{host_dom_id} [data-scope="signature-pad"][data-part="segment"]|, visible: :any),
      opts
    )
  end

  def click_in_section(session, section_id, button_label)
      when is_binary(section_id) and is_binary(button_label) do
    if String.contains?(button_label, "'") or String.contains?(button_label, "\"") do
      raise ArgumentError, "click_in_section/3 label must not include quotes"
    end

    click(
      session,
      xpath("(//*[@id=\'#{section_id}\']//button[normalize-space(.)=\'#{button_label}\'])[1]")
    )

    session
  end

  def signature_events_server_log_has_row?(session) do
    has?(session, css("#signature-events-log-server tr[data-part='row']"))
  end

  def signature_events_client_log_has_row?(session) do
    has?(session, css("#signature-events-log-client tr[data-part='row']"))
  end

  def goto_form(session, mode) do
    path =
      case mode do
        :static -> "/en/signature/form"
        :live -> "/en/signature/live-form"
      end

    session = visit_path(session, path)
    if mode == :live, do: prepare_live_form(session), else: session
  end

  def submit_form(session, mode \\ :static) do
    id = if mode == :live, do: "signature-form-live-submit", else: "signature-changeset-submit"
    click(session, css("##{id}"))
    session
  end

  def wait_for_signature_field_error(session, mode \\ :static, opts \\ []) do
    form_id = if mode == :live, do: "signature-form", else: "signature-changeset-form"

    wait_for_has(
      session,
      xpath("//*[@id='#{form_id}']//*[contains(normalize-space(.), \"can't be blank\")]"),
      opts
    )

    session
  end
end
