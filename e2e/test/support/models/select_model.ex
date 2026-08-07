defmodule E2eWeb.SelectModel do
  use E2eWeb.Model, component: "select"

  @anatomy_sections ~W(
    select-anatomy-minimal
    select-anatomy-translation
    select-anatomy-item-indicator
    select-anatomy-grouped
    select-anatomy-extended
    select-anatomy-extended-grouped
  )

  def anatomy_section_ids, do: @anatomy_sections

  def wait_section_select_ready(session, section_dom_id) do
    if not (String.match?(section_dom_id, ~r/^[a-zA-Z0-9_-]+$/) and
              String.length(section_dom_id) > 0) do
      raise ArgumentError, "invalid section dom id"
    end

    assert_has(
      session,
      css(
        ~s|section##{section_dom_id} [phx-hook="Select"]:not([data-loading])|,
        visible: :any
      )
    )

    session
  end

  def wait_root_select_ready(session, host_dom_id) when is_binary(host_dom_id) do
    if not (String.match?(host_dom_id, ~r/^[a-zA-Z0-9_-]+$/) and String.length(host_dom_id) > 0) do
      raise ArgumentError, "invalid select host dom id"
    end

    assert_has(
      session,
      css(~s|##{host_dom_id}[phx-hook="Select"]:not([data-loading])|, visible: :any)
    )

    session
  end

  def wait_playground_select_ready(session) do
    wait_root_select_ready(session, "select-playground")
  end

  def wait_patterns_page(session) do
    assert_has(session, css("#select-patterns-page", visible: :any))
    session
  end

  def open_select_in_anatomy_section(session, section_dom_id) do
    if not (String.match?(section_dom_id, ~r/^[a-zA-Z0-9_-]+$/) and
              String.length(section_dom_id) > 0) do
      raise ArgumentError, "invalid section dom id"
    end

    click(
      session,
      css(
        ~s|section##{section_dom_id} [phx-hook="Select"] [data-scope="select"][data-part="trigger"]|,
        visible: :any
      )
    )
  end

  def open_select_by_host_id(session, host_dom_id) when is_binary(host_dom_id) do
    if not (String.match?(host_dom_id, ~r/^[a-zA-Z0-9_-]+$/) and String.length(host_dom_id) > 0) do
      raise ArgumentError, "invalid select host dom id"
    end

    click(
      session,
      css(
        ~s|##{host_dom_id}[phx-hook="Select"] [data-scope="select"][data-part="trigger"]|,
        visible: :any
      )
    )
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
        ~s|section##{section_dom_id} [phx-hook="Select"] [data-scope="select"][data-part="item"][data-value="#{value}"]:not([data-template])|,
        visible: :any
      )

    session = wait_for_has(session, item_query, timeout: timeout)

    item_sel =
      ~s|[data-scope="select"][data-part="item"][data-value="#{value}"]:not([data-template])|

    _ =
      execute_script(
        session,
        """
        (function () {
          const section = document.querySelector(#{Jason.encode!("section#" <> section_dom_id)});
          if (!section) return;
          const root = section.querySelector('[phx-hook="Select"]');
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
      raise ArgumentError, "invalid select host dom id"
    end

    if String.contains?(value, "'") or String.contains?(value, "\"") do
      raise ArgumentError, "value must not contain quotes"
    end

    timeout = Keyword.get(opts, :timeout, 8_000)

    item_query =
      css(
        ~s|##{host_dom_id} [data-scope="select"][data-part="item"][data-value="#{value}"]:not([data-template])|,
        visible: :any
      )

    session = wait_for_has(session, item_query, timeout: timeout)

    item_sel =
      ~s|[data-scope="select"][data-part="item"][data-value="#{value}"]:not([data-template])|

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
    select_value(session, "section#" <> section_dom_id)
  end

  def hidden_input_value_by_host_id(session, host_dom_id) do
    select_value(session, "#" <> host_dom_id)
  end

  defp select_value(session, root_selector) do
    key = {:e2e_select_value, self(), make_ref()}

    _ =
      execute_script(
        session,
        """
        const root = document.querySelector(arguments[0]);
        const input =
          root?.querySelector('[data-part="value-input"]') ||
          root?.querySelector('input[type="text"][hidden]') ||
          root?.querySelector('input');
        return input?.value ?? "";
        """,
        [root_selector],
        fn value -> Process.put(key, to_string(value || "")) end
      )

    Process.get(key, "")
  end

  def wait_hidden_value_in_anatomy_section(session, section_dom_id, expected, opts \\ [])
      when is_binary(expected) do
    deadline = Keyword.get(opts, :timeout, 8_000) + System.monotonic_time(:millisecond)
    busy_wait_select_value(session, "section#" <> section_dom_id, expected, deadline)
    session
  end

  def wait_hidden_value_by_host_id(session, host_dom_id, expected, opts \\ [])
      when is_binary(expected) do
    deadline = Keyword.get(opts, :timeout, 8_000) + System.monotonic_time(:millisecond)
    busy_wait_select_value(session, "#" <> host_dom_id, expected, deadline)
    session
  end

  defp busy_wait_select_value(session, root_selector, expected, deadline) do
    actual = select_value(session, root_selector)

    if actual == expected do
      :ok
    else
      if System.monotonic_time(:millisecond) >= deadline do
        raise Wallaby.ExpectationNotMetError,
          message:
            "expected select value #{inspect(expected)} in #{root_selector}, got #{inspect(actual)}"
      else
        Process.sleep(50)
        busy_wait_select_value(session, root_selector, expected, deadline)
      end
    end
  end

  def wait_for_select_field_error(session, mode \\ :static, _opts \\ []) do
    form_id = if mode == :live, do: "select-live-form-ecto", else: "select-form-ecto"
    wait_for_field_error(session, form_id, "select", "can't be blank")
  end

  def wait_for_live_phoenix_form(session) do
    assert_has(session, css("#select-live-form-phoenix", text: "Country"))
    session
  end

  def click_form_select_trigger(session, mode \\ :static, form \\ :phoenix) do
    form_id = form_dom_id(mode, form)

    session =
      if mode == :live do
        assert_has(session, css("##{form_id} [phx-hook='Select']:not([data-loading])"))
      else
        session
      end

    click(session, css("##{form_id} [data-scope='select'][data-part='trigger']"))
  end

  def submit_form(session, mode \\ :static, form \\ :phoenix) do
    case {mode, form} do
      {:static, :ecto} ->
        click(session, css("#select-validate-submit"))

      {:live, :ecto} ->
        click(session, css("#select-live-form-ecto-submit"))

      {:live, _} ->
        click(session, css("#select-live-form-phoenix-submit"))

      {:static, _} ->
        click(session, css("#select-form-phoenix button[type='submit']"))
    end
  end

  defp form_dom_id(:static, :ecto), do: "select-form-ecto"
  defp form_dom_id(:static, _), do: "select-form-phoenix"
  defp form_dom_id(:live, :ecto), do: "select-live-form-ecto"
  defp form_dom_id(:live, _), do: "select-live-form-phoenix"

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

  def select_events_server_log_has_row?(session) do
    has?(session, css("#select-events-log-server tr[data-part='row']"))
  end

  def select_events_client_log_has_row?(session) do
    has?(session, css("#select-events-log-client tr[data-part='row']"))
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

  def goto_form(session, mode) do
    {path, page_id} =
      case mode do
        :static -> {"/en/select/form", "select-form-page"}
        :live -> {"/en/select/live-form", "select-form-live-page"}
      end

    goto_form_page(session, path, page_id, mode)
  end

  def click_select_trigger(session) do
    session
    |> assert_has(css("[phx-hook='Select']:not([data-loading])"))
    |> click(css("[data-scope='select'][data-part='trigger']"))
  end

  def select_item(session, value) when is_binary(value) do
    session
    |> assert_has(css(~S([data-scope='select'][data-part='content'][data-state='open'])))
    |> click(css("[data-scope='select'][data-part='item'][data-value='#{value}']"))
  end

  def set_select_value(session, id, value) do
    hidden_id = if String.ends_with?(id, "-value"), do: id, else: "#{id}-value"
    E2eWeb.FormInputHelpers.set_input_value(session, hidden_id, value)
  end

  defp safe_dom_token?(token), do: String.match?(token, ~r/^[a-zA-Z0-9_-]+$/) and token != ""

  def trigger_id(host_dom_id), do: "select:#{host_dom_id}:trigger"
  def content_id(host_dom_id), do: "select:#{host_dom_id}:content"

  def focus_trigger(session, host_dom_id) when is_binary(host_dom_id) do
    tid = trigger_id(host_dom_id)

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

  def focus_trigger_in_section(session, section_dom_id) when is_binary(section_dom_id) do
    if not safe_dom_token?(section_dom_id),
      do: raise(ArgumentError, "invalid section id")

    execute_script(
      session,
      """
      const section = document.getElementById('#{section_dom_id}');
      const trigger = section && section.querySelector(
        '[data-scope="select"][data-part="trigger"]'
      );
      if (trigger) trigger.focus();
      return !!(trigger && document.activeElement === trigger);
      """,
      [],
      fn v -> assert v == true, "expected focus on select trigger in ##{section_dom_id}" end
    )

    session
  end

  def press_key_on_active(session, key) do
    press_key(session, key, 1)
  end

  def assert_content_open(session, host_dom_id) when is_binary(host_dom_id) do
    assert_has(
      session,
      css(~s|[id="#{content_id(host_dom_id)}"][data-state="open"]|, visible: :any)
    )

    session
  end

  def assert_content_closed(session, host_dom_id) when is_binary(host_dom_id) do
    assert_has(
      session,
      css(~s|[id="#{content_id(host_dom_id)}"][data-state="closed"]|, visible: :any)
    )

    session
  end

  def content_open_in_section?(session, section_dom_id) do
    has?(
      session,
      css(
        ~s|section##{section_dom_id} [data-scope="select"][data-part="content"][data-state="open"]|,
        visible: :any
      )
    )
  end

  def assert_highlighted_item(session, host_dom_id, value)
      when is_binary(host_dom_id) and is_binary(value) do
    execute_script(
      session,
      """
      const root = document.getElementById('#{host_dom_id}');
      if (!root) return false;
      const item = root.querySelector(
        '[data-scope="select"][data-part="item"][data-value="#{value}"][data-highlighted]'
      );
      return !!item;
      """,
      [],
      fn v -> assert v == true, "expected highlighted item #{value} in ##{host_dom_id}" end
    )

    session
  end

  def assert_highlighted_item_in_section(session, section_dom_id, value) do
    if not safe_dom_token?(section_dom_id), do: raise(ArgumentError, "invalid section id")

    execute_script(
      session,
      """
      const section = document.getElementById('#{section_dom_id}');
      if (!section) return false;
      const item = section.querySelector(
        '[data-scope="select"][data-part="item"][data-value="#{value}"][data-highlighted]'
      );
      return !!item;
      """,
      [],
      fn v ->
        assert v == true, "expected highlighted item #{value} in section ##{section_dom_id}"
      end
    )

    session
  end

  def assert_trigger_aria_expanded(session, host_dom_id, expected)
      when expected in ["true", "false"] do
    tid = trigger_id(host_dom_id)
    trigger = find(session, css(~s|[id="#{tid}"]|, visible: :any))
    actual = Wallaby.Element.attr(trigger, "aria-expanded")
    assert actual == expected
    session
  end

  def assert_trigger_has_aria_controls(session, host_dom_id) do
    tid = trigger_id(host_dom_id)
    cid = content_id(host_dom_id)
    trigger = find(session, css(~s|[id="#{tid}"]|, visible: :any))
    controls = Wallaby.Element.attr(trigger, "aria-controls")
    assert controls == cid
    session
  end

  def assert_trigger_role_combobox(session, host_dom_id) do
    tid = trigger_id(host_dom_id)
    trigger = find(session, css(~s|[id="#{tid}"]|, visible: :any))
    role = Wallaby.Element.attr(trigger, "role")
    assert role == "combobox"
    session
  end

  def assert_content_role_listbox(session, host_dom_id) do
    cid = content_id(host_dom_id)
    content = find(session, css(~s|[id="#{cid}"]|, visible: :any))
    role = Wallaby.Element.attr(content, "role")
    assert role == "listbox"
    session
  end
end
