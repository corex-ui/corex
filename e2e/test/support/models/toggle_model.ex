defmodule E2eWeb.ToggleModel do
  use E2eWeb.Model, component: "toggle"

  import Wallaby.Query

  import Wallaby.Browser

  @anatomy_sections ~w(
    toggle-anatomy-minimal
    toggle-anatomy-indicator
    toggle-anatomy-dual-label
  )

  def anatomy_section_ids, do: @anatomy_sections

  def valid_section_dom_id?(section_dom_id) do
    String.match?(section_dom_id, ~r/^[a-zA-Z0-9_-]+$/) and String.length(section_dom_id) > 0
  end

  def scroll_section_into_view(session, section_dom_id) do
    if not valid_section_dom_id?(section_dom_id) do
      raise ArgumentError, "invalid section dom id"
    end

    sel = "section#" <> section_dom_id

    _ =
      execute_script(
        session,
        """
        const el = document.querySelector(arguments[0]);
        if (el) el.scrollIntoView({block: 'center'});
        """,
        [sel]
      )

    session
  end

  def wait_section_toggle_ready(session, section_dom_id, opts \\ []) do
    if not valid_section_dom_id?(section_dom_id) do
      raise ArgumentError, "invalid section dom id"
    end

    timeout = Keyword.get(opts, :timeout)
    hook_count = Keyword.get(opts, :hook_count, 1)

    q =
      css(
        ~s|section##{section_dom_id} [phx-hook="Toggle"]:not([data-loading])|,
        count: hook_count,
        visible: :any
      )

    session = scroll_section_into_view(session, section_dom_id)

    case timeout do
      nil -> assert_has(session, q)
      max_ms when is_integer(max_ms) and max_ms > 0 -> wait_for_has(session, q, timeout: max_ms)
    end

    session
  end

  def wait_playground_toggle_ready(session, opts \\ []) do
    timeout = Keyword.get(opts, :timeout)

    _ =
      execute_script(
        session,
        """
        const el = document.getElementById('toggle-playground');
        if (el) el.scrollIntoView({block: 'center'});
        """,
        []
      )

    q =
      css(
        ~s|#toggle-playground[phx-hook="Toggle"]:not([data-loading])|,
        visible: :any
      )

    case timeout do
      nil -> assert_has(session, q)
      max_ms when is_integer(max_ms) and max_ms > 0 -> wait_for_has(session, q, timeout: max_ms)
    end

    session
  end

  def wait_patterns_page(session) do
    assert_has(session, css("#toggle-patterns-page", visible: :any))
    session
  end

  def wait_styling_page(session) do
    assert_has(session, css("#toggle-styling-page", visible: :any))
    session
  end

  def click_in_section(session, section_id, button_label)
      when is_binary(section_id) and is_binary(button_label) do
    if String.contains?(button_label, "'") or String.contains?(button_label, "\"") do
      raise ArgumentError, "click_in_section/3 label must not include quotes"
    end

    session = scroll_section_into_view(session, section_id)

    click(
      session,
      xpath("(//*[@id=\'#{section_id}\']//button[normalize-space(.)=\'#{button_label}\'])[1]")
    )

    session
  end

  def click_toggle_root_in_section(session, section_dom_id) do
    if not valid_section_dom_id?(section_dom_id) do
      raise ArgumentError, "invalid section dom id"
    end

    session = scroll_section_into_view(session, section_dom_id)

    click(
      session,
      css(
        ~s|section##{section_dom_id} [data-scope="toggle"][data-part="root"]|,
        visible: :any
      )
    )

    session
  end

  def toggle_root_data_state_in_section(session, section_dom_id) do
    if not valid_section_dom_id?(section_dom_id) do
      raise ArgumentError, "invalid section dom id"
    end

    session = scroll_section_into_view(session, section_dom_id)

    el =
      find(
        session,
        css(
          ~s|section##{section_dom_id} [data-scope="toggle"][data-part="root"]|,
          visible: :any
        )
      )

    Wallaby.Element.attr(el, "data-state")
  end

  def toggle_root_data_state_by_host_id(session, host_dom_id) when is_binary(host_dom_id) do
    if not valid_section_dom_id?(host_dom_id) do
      raise ArgumentError, "invalid host dom id"
    end

    el =
      find(
        session,
        css(~s|##{host_dom_id} [data-scope="toggle"][data-part="root"]|, visible: :any)
      )

    Wallaby.Element.attr(el, "data-state")
  end

  def click_playground_disabled_switch(session) do
    _ =
      execute_script(
        session,
        """
        const el = document.getElementById('disabled');
        if (el) el.scrollIntoView({block: 'center'});
        """,
        []
      )

    click(
      session,
      css("#disabled [data-scope='switch'][data-part='control']", visible: :any)
    )

    session
  end

  def toggle_events_server_log_has_row?(session) do
    has?(session, css("#toggle-events-log-server tr[data-part='row']"))
  end

  def toggle_events_client_log_has_row?(session) do
    has?(session, css("#toggle-events-log-client tr[data-part='row']"))
  end
end
