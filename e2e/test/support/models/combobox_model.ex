defmodule E2eWeb.ComboboxModel do
  use E2eWeb.Model, component: "combobox"

  @anatomy_sections ~W(
    combobox-anatomy-minimal
    combobox-anatomy-slots
    combobox-anatomy-labeled
    combobox-anatomy-grouped
    combobox-anatomy-extended
    combobox-anatomy-extended-grouped
  )

  def anatomy_section_ids, do: @anatomy_sections

  def wait_section_combobox_ready(session, section_dom_id) do
    if not (String.match?(section_dom_id, ~r/^[a-zA-Z0-9_-]+$/) and
              String.length(section_dom_id) > 0) do
      raise ArgumentError, "invalid section dom id"
    end

    assert_has(
      session,
      css(
        ~s|section##{section_dom_id} [phx-hook="Combobox"]:not([data-loading])|,
        visible: :any
      )
    )

    session
  end

  def wait_root_combobox_ready(session, host_dom_id) when is_binary(host_dom_id) do
    if not (String.match?(host_dom_id, ~r/^[a-zA-Z0-9_-]+$/) and String.length(host_dom_id) > 0) do
      raise ArgumentError, "invalid combobox host dom id"
    end

    assert_has(
      session,
      css(~s|##{host_dom_id}[phx-hook="Combobox"]:not([data-loading])|, visible: :any)
    )

    session
  end

  def wait_playground_combobox_ready(session) do
    wait_root_combobox_ready(session, "combobox-playground")
  end

  def wait_patterns_page(session) do
    assert_has(session, css("#combobox-patterns-page", visible: :any))
    session
  end

  def open_combobox_in_anatomy_section(session, section_dom_id) do
    if not (String.match?(section_dom_id, ~r/^[a-zA-Z0-9_-]+$/) and
              String.length(section_dom_id) > 0) do
      raise ArgumentError, "invalid section dom id"
    end

    click(
      session,
      css(
        ~s|section##{section_dom_id} [phx-hook="Combobox"] [data-scope="combobox"][data-part="trigger"]|,
        visible: :any
      )
    )
  end

  def wait_combobox_content_open(session, host_dom_id, opts \\ []) when is_binary(host_dom_id) do
    if not (String.match?(host_dom_id, ~r/^[a-zA-Z0-9_-]+$/) and host_dom_id != "") do
      raise ArgumentError, "invalid combobox host dom id"
    end

    wait_for_has(
      session,
      css(
        ~s|##{host_dom_id} [data-scope="combobox"][data-part="content"][data-state="open"]|,
        visible: :any
      ),
      opts
    )

    session
  end

  def open_combobox_by_host_id(session, host_dom_id, opts \\ []) when is_binary(host_dom_id) do
    if not (String.match?(host_dom_id, ~r/^[a-zA-Z0-9_-]+$/) and String.length(host_dom_id) > 0) do
      raise ArgumentError, "invalid combobox host dom id"
    end

    session =
      click(
        session,
        css(
          ~s|##{host_dom_id}[phx-hook="Combobox"] [data-scope="combobox"][data-part="trigger"]|,
          visible: :any
        )
      )

    if Keyword.get(opts, :wait_open, true) do
      wait_combobox_content_open(session, host_dom_id, opts)
    else
      session
    end
  end

  def click_item_in_anatomy_section(session, section_dom_id, value, opts \\ [])
      when is_binary(value) do
    if not (String.match?(section_dom_id, ~r/^[a-zA-Z0-9_-]+$/) and
              String.length(section_dom_id) > 0) do
      raise ArgumentError, "invalid section dom id"
    end

    if String.contains?(value, "'") or String.contains?(value, "\"") do
      raise ArgumentError, "value must not contain quotes"
    end

    timeout = Keyword.get(opts, :timeout, 8_000)

    item_query =
      css(
        ~s|section##{section_dom_id} [phx-hook="Combobox"] [data-scope="combobox"][data-part="item"][data-value="#{value}"]:not([data-template])|,
        visible: :any
      )

    session = wait_for_has(session, item_query, timeout: timeout)

    item_sel =
      ~s|[data-scope="combobox"][data-part="item"][data-value="#{value}"]:not([data-template])|

    _ =
      execute_script(
        session,
        """
        (function () {
          const section = document.querySelector(#{Jason.encode!("section#" <> section_dom_id)});
          if (!section) return;
          const root = section.querySelector('[phx-hook="Combobox"]');
          if (!root) return;
          const item = root.querySelector(#{Jason.encode!(item_sel)});
          if (!item) return;
          item.scrollIntoView({block: 'center'});
          const text = item.querySelector('[data-part="item-text"]');
          (text || item).click();
        })();
        """,
        []
      )

    session
  end

  def click_item_by_host_id(session, host_dom_id, value, opts \\ []) when is_binary(value) do
    if not (String.match?(host_dom_id, ~r/^[a-zA-Z0-9_-]+$/) and String.length(host_dom_id) > 0) do
      raise ArgumentError, "invalid combobox host dom id"
    end

    if String.contains?(value, "'") or String.contains?(value, "\"") do
      raise ArgumentError, "value must not contain quotes"
    end

    timeout = Keyword.get(opts, :timeout, 8_000)

    item_query =
      css(
        ~s|##{host_dom_id} [data-scope="combobox"][data-part="item"][data-value="#{value}"]:not([data-template])|,
        visible: :any
      )

    session = wait_for_has(session, item_query, timeout: timeout)

    item_sel =
      ~s|[data-scope="combobox"][data-part="item"][data-value="#{value}"]:not([data-template])|

    _ =
      execute_script(
        session,
        """
        (function () {
          const root = document.getElementById(#{Jason.encode!(host_dom_id)});
          if (!root) return;
          root.scrollIntoView({block: 'center'});
          const item = root.querySelector(#{Jason.encode!(item_sel)});
          if (!item) return;
          item.scrollIntoView({block: 'center'});
          const text = item.querySelector('[data-part="item-text"]');
          (text || item).click();
        })();
        """,
        []
      )

    session
  end

  def hidden_input_value_in_anatomy_section(session, section_dom_id) do
    combobox_value(session, "section#" <> section_dom_id)
  end

  def hidden_input_value_by_host_id(session, host_dom_id) do
    combobox_value(session, "#" <> host_dom_id)
  end

  def wait_hidden_value_in_anatomy_section(session, section_dom_id, expected, opts \\ [])
      when is_binary(expected) do
    deadline = Keyword.get(opts, :timeout, 8_000) + System.monotonic_time(:millisecond)
    busy_wait_combobox_value(session, "section#" <> section_dom_id, expected, deadline)
    session
  end

  def wait_hidden_value_by_host_id(session, host_dom_id, expected, opts \\ [])
      when is_binary(expected) do
    deadline = Keyword.get(opts, :timeout, 8_000) + System.monotonic_time(:millisecond)
    busy_wait_combobox_value(session, "#" <> host_dom_id, expected, deadline)
    session
  end

  defp combobox_value(session, root_selector) do
    key = {:e2e_combobox_value, self(), make_ref()}

    _ =
      execute_script(
        session,
        """
        const root = document.querySelector(arguments[0]);
        const input = root?.querySelector('[data-scope="combobox"][data-part="hidden-input"]');
        return input?.value ?? "";
        """,
        [root_selector],
        fn value -> Process.put(key, to_string(value || "")) end
      )

    Process.get(key, "")
  end

  defp busy_wait_combobox_value(session, root_selector, expected, deadline) do
    actual = combobox_value(session, root_selector)

    if actual == expected do
      :ok
    else
      if System.monotonic_time(:millisecond) >= deadline do
        raise Wallaby.ExpectationNotMetError,
          message:
            "expected combobox value #{inspect(expected)} in #{root_selector}, got #{inspect(actual)}"
      else
        Process.sleep(50)
        busy_wait_combobox_value(session, root_selector, expected, deadline)
      end
    end
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

  def wait_playground_patch_rev(session, rev, opts \\ []) when is_integer(rev) do
    wait_for_has(
      session,
      css(~s|#combobox-playground-patch-rev[data-rev="#{rev}"]|, visible: :any),
      opts
    )

    session
  end

  def disable_playground_close_on_select(session) do
    q =
      css(
        ~S|#close_on_select [data-scope="switch"][data-part="control"][data-state="checked"]|,
        visible: :any
      )

    if has?(session, q) do
      click(session, q)
    end

    session
  end

  def assert_positioner_anchored(session, host_dom_id, _opts \\ []) when is_binary(host_dom_id) do
    if not (String.match?(host_dom_id, ~r/^[a-zA-Z0-9_-]+$/) and host_dom_id != "") do
      raise ArgumentError, "invalid combobox host dom id"
    end

    wait_combobox_content_open(session, host_dom_id)
  end
end
