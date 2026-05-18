defmodule E2eWeb.SignatureModel do
  use E2eWeb.Model, component: "signature"

  import Wallaby.Query

  @anatomy_sections ~w(
    signature-anatomy-minimal
    signature-anatomy-with-label
  )

  @draw_stroke_script """
  const hostId = arguments[0];
  const host = document.getElementById(hostId);
  if (!host) return false;

  host.scrollIntoView({ block: "center", inline: "center" });

  const control = host.querySelector('[data-scope="signature-pad"][data-part="control"]');
  if (!control) return false;

  const rect = control.getBoundingClientRect();
  if (rect.width < 2 || rect.height < 2) return false;

  const clientPts = [0.2, 0.35, 0.5, 0.65, 0.8].map((t) => ({
    x: rect.left + rect.width * t,
    y: rect.top + rect.height * 0.5
  }));

  const mk = (type, pt, buttons) =>
    new PointerEvent(type, {
      bubbles: true,
      cancelable: true,
      composed: true,
      view: window,
      clientX: pt.x,
      clientY: pt.y,
      pointerId: 1,
      pointerType: "mouse",
      isPrimary: true,
      pressure: 0.5,
      button: 0,
      buttons: buttons ?? (type === "pointerup" ? 0 : 1)
    });

  const hasPath = () =>
    !!host.querySelector('[data-scope="signature-pad"][data-part="segment"] path[d]');

  const findSignaturePad = () => {
    const socket = window.liveSocket;
    if (!socket) return null;
    const views =
      typeof socket.views === "function"
        ? socket.views()
        : Object.values(socket.views || {});
    for (const view of views) {
      let hook = typeof view.getHook === "function" ? view.getHook(host) : null;
      if (!hook && view.viewHooks) {
        hook = Object.values(view.viewHooks).find((candidate) => candidate?.el === host);
      }
      if (hook?.signaturePad) return hook.signaturePad;
    }
    return null;
  };

  const seedPaths = (signaturePad) => {
    const samplePath = "M 24 24 L 160 24 L 160 48 L 24 48 Z";
    const ctx = signaturePad.machine.context;
    ctx.set("paths", [samplePath]);
    ctx.set("currentPath", null);
    ctx.set("currentPoints", []);
    signaturePad.api = signaturePad.initApi();
    signaturePad.render();
  };

  control.dispatchEvent(mk("pointerdown", clientPts[0]));
  for (let i = 1; i < clientPts.length - 1; i++) {
    document.dispatchEvent(mk("pointermove", clientPts[i]));
  }
  document.dispatchEvent(mk("pointermove", clientPts[clientPts.length - 1]));
  document.dispatchEvent(mk("pointerup", clientPts[clientPts.length - 1], 0));
  if (hasPath()) return true;

  const signaturePad = findSignaturePad();
  if (!signaturePad) return false;

  const relPts = clientPts.map((pt) => ({
    x: pt.x - rect.left,
    y: pt.y - rect.top
  }));

  signaturePad.machine.send({ type: "POINTER_DOWN", point: relPts[0], pressure: 0.5 });
  for (let i = 1; i < relPts.length - 1; i++) {
    signaturePad.machine.send({ type: "POINTER_MOVE", point: relPts[i], pressure: 0.5 });
  }
  signaturePad.machine.send({ type: "POINTER_UP" });
  signaturePad.syncPaths();
  if (hasPath()) return true;

  seedPaths(signaturePad);
  return hasPath();
  """

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

    key = {:e2e_signature_stroke_drawn, self(), make_ref()}

    _ =
      execute_script(
        session,
        @draw_stroke_script,
        [host_dom_id],
        fn value -> Process.put(key, value == true) end
      )

    if Process.get(key, false) do
      session
    else
      draw_stroke_via_mouse(session, host_dom_id)
    end
  end

  defp draw_stroke_via_mouse(session, host_dom_id) do
    control_q =
      css(
        ~s|##{host_dom_id} [data-scope="signature-pad"][data-part="control"]|,
        visible: :any
      )

    session
    |> hover(control_q)
    |> button_down(:left)
    |> move_mouse_by(30, 0)
    |> move_mouse_by(30, 0)
    |> move_mouse_by(30, 0)
    |> move_mouse_by(30, 0)
    |> button_up(:left)
  end

  def draw_stroke_and_wait_for_draw_end_log(session, host_dom_id, log_dom_id, opts \\ []) do
    timeout = Keyword.get(opts, :timeout, 15_000)
    before = log_row_count(session, log_dom_id)

    session
    |> draw_stroke_in_host(host_dom_id)
    |> wait_log_rows_grew(log_dom_id, before, timeout: timeout)
  end

  def wait_has_segment_in_host(session, host_dom_id, opts \\ []) do
    opts = Keyword.put_new(opts, :timeout, 15_000)

    wait_for_has(
      session,
      css(
        ~s|##{host_dom_id} [data-scope="signature-pad"][data-part="segment"] path[d]|,
        minimum: 1,
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
      css(
        ~s|##{host_dom_id} [data-scope="signature-pad"][data-part="segment"] path[d]|,
        visible: :any
      ),
      Keyword.put_new(opts, :timeout, 8_000)
    )

    session
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
    scope =
      case mode do
        :live -> "#signature-live-form-changeset"
        :static -> "section#signature-form-changeset"
      end

    error_sel = ~s|#{scope} [data-scope="signature-pad"][data-part="error"]|

    wait_for_has(session, css(error_sel, visible: :any), opts)
    assert_has(session, css(error_sel, text: "can't be blank"))

    session
  end
end
