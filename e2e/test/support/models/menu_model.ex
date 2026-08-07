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

  def events_log_text(session, log_dom_id) when is_binary(log_dom_id) do
    el = find(session, css("##{log_dom_id}", visible: :any))
    Wallaby.Element.text(el)
  end

  def assert_events_log_mentions(session, log_dom_id, substring)
      when is_binary(log_dom_id) and is_binary(substring) do
    text = events_log_text(session, log_dom_id)

    assert String.contains?(text, substring),
           "expected ##{log_dom_id} to mention #{inspect(substring)}, got: #{inspect(text)}"

    session
  end

  def click_item_by_host_id(session, host_dom_id, value, opts \\ []) when is_binary(value) do
    if not (String.match?(host_dom_id, ~r/^[a-zA-Z0-9_-]+$/) and String.length(host_dom_id) > 0) do
      raise ArgumentError, "invalid menu host dom id"
    end

    if String.contains?(value, "'") or String.contains?(value, "\"") do
      raise ArgumentError, "value must not contain quotes"
    end

    timeout = Keyword.get(opts, :timeout, 8_000)

    wait_for_has(
      session,
      css(
        ~s|[id="menu:#{host_dom_id}"] [data-scope="menu"][data-part="item"][data-value="#{value}"]|,
        visible: :any
      ),
      timeout: timeout
    )

    click(
      session,
      css(
        ~s|[id="menu:#{host_dom_id}"] [data-scope="menu"][data-part="item"][data-value="#{value}"]|,
        visible: :any
      )
    )

    session
  end

  def wait_playground_selected(session, value, opts \\ []) when is_binary(value) do
    wait_for_has(
      session,
      css(~s|#menu-playground-selected[data-value="#{value}"]|, visible: :any),
      opts
    )

    session
  end

  def assert_positioner_anchored(session, host_dom_id, _opts \\ []) when is_binary(host_dom_id) do
    if not (String.match?(host_dom_id, ~r/^[a-zA-Z0-9_-]+$/) and host_dom_id != "") do
      raise ArgumentError, "invalid menu host dom id"
    end

    wait_menu_content_open(session, host_dom_id)
  end

  defp trigger_selector(host_dom_id) do
    ~s|[id="menu:#{host_dom_id}:trigger"]|
  end

  def assert_trigger_disabled(session, host_dom_id, opts \\ []) when is_binary(host_dom_id) do
    if not (String.match?(host_dom_id, ~r/^[a-zA-Z0-9_-]+$/) and host_dom_id != "") do
      raise ArgumentError, "invalid menu host dom id"
    end

    wait_for_has(
      session,
      css(
        ~s|#{trigger_selector(host_dom_id)}[disabled][aria-disabled="true"][tabindex="-1"]|,
        visible: :any
      ),
      opts
    )

    session
  end

  def assert_trigger_enabled(session, host_dom_id, opts \\ []) when is_binary(host_dom_id) do
    if not (String.match?(host_dom_id, ~r/^[a-zA-Z0-9_-]+$/) and host_dom_id != "") do
      raise ArgumentError, "invalid menu host dom id"
    end

    wait_for_has(
      session,
      css(
        ~s|#{trigger_selector(host_dom_id)}:not([disabled])[aria-disabled="false"][tabindex="0"]|,
        visible: :any
      ),
      opts
    )

    session
  end

  def click_playground_disabled_switch(session) do
    click(
      session,
      css("#menu-playground-disabled [data-scope='switch'][data-part='control']", visible: :any)
    )

    session
  end

  defp safe_dom_token?(token), do: String.match?(token, ~r/^[a-zA-Z0-9_-]+$/) and token != ""

  def focus_trigger(session, host_dom_id) when is_binary(host_dom_id) do
    if not safe_dom_token?(host_dom_id), do: raise(ArgumentError, "invalid menu host dom id")

    tid = "menu:#{host_dom_id}:trigger"

    execute_script(
      session,
      """
      const el = document.getElementById('#{tid}');
      if (el) el.focus();
      return !!(el && document.activeElement === el);
      """,
      [],
      fn v -> assert v == true, "expected focus on ##{tid}" end
    )

    session
  end

  def press_key_on_active(session, key) do
    press_key(session, key, 1)
  end

  def content_open?(session, host_dom_id) when is_binary(host_dom_id) do
    has?(
      session,
      css(~s|[id="menu:#{host_dom_id}:content"][data-state="open"]|, visible: :any)
    )
  end

  def assert_highlighted_item(session, host_dom_id, value)
      when is_binary(host_dom_id) and is_binary(value) do
    if not safe_dom_token?(host_dom_id), do: raise(ArgumentError, "invalid menu host dom id")

    execute_script(
      session,
      """
      const item = document.querySelector(
        '[id="menu:#{host_dom_id}"] [data-scope="menu"][data-part="item"][data-value="#{value}"][data-highlighted], ' +
        '[id="menu:#{host_dom_id}:content"] [data-scope="menu"][data-part="item"][data-value="#{value}"][data-highlighted]'
      );
      return !!item;
      """,
      [],
      fn v -> assert v == true, "expected highlighted item #{value} in menu ##{host_dom_id}" end
    )

    session
  end
end
