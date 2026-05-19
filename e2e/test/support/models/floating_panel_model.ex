defmodule E2eWeb.FloatingPanelModel do
  use E2eWeb.Model, component: "floating-panel"

  import Wallaby.Query

  @anatomy_sections ~W(
    floating-panel-anatomy-basic
    floating-panel-anatomy-no-trigger
    floating-panel-anatomy-positioning
    floating-panel-anatomy-size
  )

  @anatomy_section_to_host_id %{
    "floating-panel-anatomy-basic" => "floating-panel-anatomy",
    "floating-panel-anatomy-no-trigger" => "floating-panel-anatomy-no-trigger",
    "floating-panel-anatomy-positioning" => "floating-panel-anatomy-positioning",
    "floating-panel-anatomy-size" => "floating-panel-anatomy-size"
  }

  def anatomy_section_ids, do: @anatomy_sections

  def host_id_for_anatomy_section(section_id),
    do: Map.fetch!(@anatomy_section_to_host_id, section_id)

  def valid_dom_id?(dom_id) do
    String.match?(dom_id, ~r/^[a-zA-Z0-9_-]+$/) and String.length(dom_id) > 0
  end

  def wait_host_floating_panel_ready(session, host_dom_id, opts \\ []) do
    if not valid_dom_id?(host_dom_id), do: raise(ArgumentError, "invalid host dom id")

    timeout = Keyword.get(opts, :timeout)

    q =
      css(~s|##{host_dom_id}[phx-hook="FloatingPanel"]:not([data-loading])|, visible: :any)

    case timeout do
      nil -> assert_has(session, q)
      max_ms when is_integer(max_ms) and max_ms > 0 -> wait_for_has(session, q, timeout: max_ms)
    end

    session
  end

  def wait_section_floating_panel_ready(session, section_dom_id, opts \\ []) do
    if not valid_dom_id?(section_dom_id), do: raise(ArgumentError, "invalid section dom id")

    timeout = Keyword.get(opts, :timeout)

    q =
      css(
        ~s|section##{section_dom_id} [phx-hook="FloatingPanel"]:not([data-loading])|,
        visible: :any
      )

    case timeout do
      nil -> assert_has(session, q)
      max_ms when is_integer(max_ms) and max_ms > 0 -> wait_for_has(session, q, timeout: max_ms)
    end

    session
  end

  def set_open_host(session, host_dom_id, open) when is_boolean(open) do
    if not valid_dom_id?(host_dom_id), do: raise(ArgumentError, "invalid host dom id")

    _ =
      execute_script(
        session,
        """
        const panel = document.getElementById(arguments[0]);
        panel?.dispatchEvent(new CustomEvent("corex:floating-panel:set-open", {
          detail: { open: arguments[1] },
          bubbles: false
        }));
        """,
        [host_dom_id, open]
      )

    session
  end

  def click_trigger_in_host(session, host_dom_id) do
    click(
      session,
      css(~s|##{host_dom_id} [data-scope="floating-panel"][data-part="trigger"]|, visible: :any)
    )

    session
  end

  def wait_trigger_open_in_host(session, host_dom_id, opts \\ []) do
    wait_for_has(
      session,
      css(
        ~s|##{host_dom_id} [data-scope="floating-panel"][data-part="trigger"][data-state="open"]|,
        visible: :any
      ),
      opts
    )

    session
  end

  def wait_content_open_in_host(session, host_dom_id, opts \\ []) do
    wait_for_has(
      session,
      css(
        ~s|##{host_dom_id} [data-scope="floating-panel"][data-part="content"][data-state="open"]|,
        visible: :any
      ),
      opts
    )

    session
  end

  def wait_trigger_closed_in_host(session, host_dom_id, opts \\ []) do
    wait_for_has(
      session,
      css(
        ~s|##{host_dom_id} [data-scope="floating-panel"][data-part="trigger"][data-state="closed"]|,
        visible: :any
      ),
      opts
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

  def floating_panel_events_log_has_row?(session) do
    has?(session, css("#floating-panel-events-log tr[data-part='row']"))
  end
end
