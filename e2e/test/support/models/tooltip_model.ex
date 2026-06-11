defmodule E2eWeb.TooltipModel do
  use E2eWeb.Model, component: "tooltip"

  import Wallaby.Query

  @anatomy_sections ~W(
    tooltip-anatomy-minimal
    tooltip-anatomy-with-arrow
    tooltip-anatomy-placement
    tooltip-anatomy-positioning
  )

  def anatomy_section_ids, do: @anatomy_sections

  def valid_dom_id?(dom_id) do
    String.match?(dom_id, ~r/^[a-zA-Z0-9_-]+$/) and String.length(dom_id) > 0
  end

  def wait_section_tooltip_ready(session, section_dom_id, opts \\ []) do
    if not valid_dom_id?(section_dom_id), do: raise(ArgumentError, "invalid section dom id")

    timeout = Keyword.get(opts, :timeout)

    q =
      css(
        ~s|section##{section_dom_id} [phx-hook="Tooltip"]:not([data-loading])|,
        visible: :any
      )

    case timeout do
      nil -> assert_has(session, q)
      max_ms when is_integer(max_ms) and max_ms > 0 -> wait_for_has(session, q, timeout: max_ms)
    end

    session
  end

  def wait_host_tooltip_ready(session, host_dom_id, opts \\ []) do
    if not valid_dom_id?(host_dom_id), do: raise(ArgumentError, "invalid host dom id")

    timeout = Keyword.get(opts, :timeout)

    q = css(~s|##{host_dom_id}[phx-hook="Tooltip"]:not([data-loading])|, visible: :any)

    case timeout do
      nil -> assert_has(session, q)
      max_ms when is_integer(max_ms) and max_ms > 0 -> wait_for_has(session, q, timeout: max_ms)
    end

    session
  end

  def open_first_tooltip_in_section(session, section_dom_id) do
    if not valid_dom_id?(section_dom_id), do: raise(ArgumentError, "invalid section dom id")

    _ =
      execute_script(
        session,
        """
        const section = document.querySelector(arguments[0]);
        const host = section?.querySelector('[phx-hook="Tooltip"]');
        if (!host) return;
        host.dispatchEvent(
          new CustomEvent("corex:tooltip:set-open", { detail: { open: true }, bubbles: false })
        );
        """,
        ["section#" <> section_dom_id]
      )

    session
  end

  def open_tooltip_by_host_id(session, host_dom_id) do
    if not valid_dom_id?(host_dom_id), do: raise(ArgumentError, "invalid host dom id")

    _ =
      execute_script(
        session,
        """
        const host = document.getElementById(arguments[0]);
        host?.dispatchEvent(
          new CustomEvent("corex:tooltip:set-open", { detail: { open: true }, bubbles: false })
        );
        """,
        [host_dom_id]
      )

    session
  end

  def hover_first_trigger_in_section(session, section_dom_id) do
    if not valid_dom_id?(section_dom_id), do: raise(ArgumentError, "invalid section dom id")

    hover(
      session,
      css(
        ~s|section##{section_dom_id} [data-scope="tooltip"][data-part="trigger"]|,
        visible: :any
      )
    )

    session
  end

  def wait_open_content_in_section(session, section_dom_id, opts \\ []) do
    wait_for_has(
      session,
      css(
        ~s|section##{section_dom_id} [data-scope="tooltip"][data-part="content"][data-state="open"]|,
        visible: :any
      ),
      opts
    )

    session
  end

  def refute_open_content_in_section(session, section_dom_id) do
    if not valid_dom_id?(section_dom_id), do: raise(ArgumentError, "invalid section dom id")

    refute_has(
      session,
      css(
        ~s|section##{section_dom_id} [data-scope="tooltip"][data-part="content"][data-state="open"]|,
        visible: :any
      )
    )

    session
  end

  def wait_open_content_in_host(session, host_dom_id, opts \\ []) do
    wait_for_has(
      session,
      css(
        ~s|##{host_dom_id} [data-scope="tooltip"][data-part="content"][data-state="open"]|,
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

  def wait_patterns_page(session) do
    assert_has(session, css("#tooltip-patterns-page", visible: :any))
    session
  end

  def tooltip_events_log_has_row?(session) do
    has?(session, css("#tooltip-events-log tr[data-part='row']"))
  end
end
