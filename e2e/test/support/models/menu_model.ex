defmodule E2eWeb.MenuModel do
  use E2eWeb.Model, component: "menu"

  @anatomy_sections ~W(
    menu-anatomy-minimal
    menu-anatomy-grouped
    menu-anatomy-nested
    menu-anatomy-nested-grouped
  )

  def anatomy_section_ids, do: @anatomy_sections

  defp menu_hook_selector(host_dom_id),
    do: ~s|[id="menu:#{host_dom_id}"][phx-hook="Menu"]:not([data-loading])|

  def wait_section_menu_ready(session, section_dom_id, opts \\ []) do
    if not (String.match?(section_dom_id, ~r/^[a-zA-Z0-9_-]+$/) and
              String.length(section_dom_id) > 0) do
      raise ArgumentError, "invalid section dom id"
    end

    wait_section_hook(session, section_dom_id, "Menu", opts)
  end

  def wait_root_menu_ready(session, host_dom_id, opts \\ []) when is_binary(host_dom_id) do
    if not (String.match?(host_dom_id, ~r/^[a-zA-Z0-9_-]+$/) and String.length(host_dom_id) > 0) do
      raise ArgumentError, "invalid menu host dom id"
    end

    timeout = Keyword.get(opts, :timeout)

    q = css(menu_hook_selector(host_dom_id), visible: :any)

    case timeout do
      nil -> assert_has(session, q)
      max_ms when is_integer(max_ms) and max_ms > 0 -> wait_for_has(session, q, timeout: max_ms)
    end

    session
  end

  def wait_playground_menu_ready(session) do
    wait_host_menu_ready(session, "menu-playground")
  end

  def wait_host_menu_ready(session, host_dom_id, opts \\ []) do
    wait_root_menu_ready(session, host_dom_id, opts)
  end

  def wait_patterns_page(session) do
    assert_has(session, css("#menu-patterns-page", visible: :any))
    session
  end

  def open_menu_in_section(session, section_dom_id) do
    if not (String.match?(section_dom_id, ~r/^[a-zA-Z0-9_-]+$/) and
              String.length(section_dom_id) > 0) do
      raise ArgumentError, "invalid section dom id"
    end

    click(
      session,
      css(
        ~s|section##{section_dom_id} [phx-hook="Menu"] [data-scope="menu"][data-part="trigger"]|,
        visible: :any
      )
    )
  end

  def open_menu_by_host_id(session, host_dom_id, opts \\ []) when is_binary(host_dom_id) do
    if not (String.match?(host_dom_id, ~r/^[a-zA-Z0-9_-]+$/) and String.length(host_dom_id) > 0) do
      raise ArgumentError, "invalid menu host dom id"
    end

    session =
      click(
        session,
        css(
          ~s|[id="menu:#{host_dom_id}"] [data-scope="menu"][data-part="trigger"]|,
          visible: :any
        )
      )

    if Keyword.get(opts, :wait_open, true) do
      wait_menu_content_open(session, host_dom_id, opts)
    else
      session
    end
  end

  def click_item_in_section(session, section_dom_id, value, opts \\ []) when is_binary(value) do
    if String.contains?(value, "'") or String.contains?(value, "\"") do
      raise ArgumentError, "value must not contain quotes"
    end

    timeout = Keyword.get(opts, :timeout, 8_000)

    wait_for_has(
      session,
      css(
        ~s|section##{section_dom_id} [data-scope="menu"][data-part="item"][data-value="#{value}"]|,
        visible: :any
      ),
      timeout: timeout
    )

    click(
      session,
      css(
        ~s|section##{section_dom_id} [data-scope="menu"][data-part="item"][data-value="#{value}"]|,
        visible: :any
      )
    )

    session
  end

  def wait_menu_content_open(session, host_dom_id, opts \\ []) do
    if not (String.match?(host_dom_id, ~r/^[a-zA-Z0-9_-]+$/) and host_dom_id != "") do
      raise ArgumentError, "invalid menu host dom id"
    end

    wait_for_has(
      session,
      css(~s|[id="menu:#{host_dom_id}:content"][data-state="open"]|, visible: :any),
      opts
    )

    session
  end

  def click_button_in_section(session, section_id, label) when is_binary(label) do
    if String.contains?(label, "'") or String.contains?(label, "\"") do
      raise ArgumentError, "click_button_in_section: label must not include quotes"
    end

    click(
      session,
      xpath("(//*[@id=\'#{section_id}\']//button[normalize-space(.)=\'#{label}\'])[1]")
    )

    session
  end

  def menu_events_server_log_has_row?(session) do
    has?(session, css("#menu-events-log-server tr[data-part='row']", visible: :any))
  end

  def menu_events_client_log_has_row?(session) do
    has?(session, css("#menu-events-log-client tr[data-part='row']", visible: :any))
  end
end
