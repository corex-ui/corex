defmodule E2eWeb.ComboboxModel do
  @moduledoc """
  Behavior map:
    anatomy   - open + select item, assert hidden input value
    api       - set value (binding/server/js), assert hidden input
    playground - mount, patch anchoring
    patterns  - server filter interactive
    events    - server/client log growth + value mention
    form      - submit, validation
  """

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

  def close_combobox_by_host_id(session, host_dom_id, opts \\ []) when is_binary(host_dom_id) do
    if not (String.match?(host_dom_id, ~r/^[a-zA-Z0-9_-]+$/) and String.length(host_dom_id) > 0) do
      raise ArgumentError, "invalid combobox host dom id"
    end

    open_q =
      css(
        ~s|##{host_dom_id} [data-scope="combobox"][data-part="content"][data-state="open"]|,
        visible: :any
      )

    session =
      if has?(session, open_q) do
        click(
          session,
          css(
            ~s|##{host_dom_id}[phx-hook="Combobox"] [data-scope="combobox"][data-part="trigger"]|,
            visible: :any
          )
        )
      else
        session
      end

    wait_for_has(
      session,
      css(
        ~s|##{host_dom_id} [data-scope="combobox"][data-part="content"][data-state="open"]|,
        count: 0,
        visible: :any
      ),
      opts
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

  def close_combobox_by_host_id(session, host_dom_id, opts \\ []) when is_binary(host_dom_id) do
    if not (String.match?(host_dom_id, ~r/^[a-zA-Z0-9_-]+$/) and String.length(host_dom_id) > 0) do
      raise ArgumentError, "invalid combobox host dom id"
    end

    open_q =
      css(
        ~s|##{host_dom_id} [data-scope="combobox"][data-part="content"][data-state="open"]|,
        visible: :any,
        timeout: 250
      )

    if has?(session, open_q) do
      _ =
        execute_script(
          session,
          """
          const root = document.getElementById(arguments[0]);
          const trigger = root?.querySelector(
            '[data-scope="combobox"][data-part="trigger"]'
          );
          if (trigger) trigger.click();
          """,
          [host_dom_id]
        )

      wait_for_has(
        session,
        css(
          ~s|##{host_dom_id} [data-scope="combobox"][data-part="content"]:not([data-state="open"])|,
          visible: :any
        ),
        opts
      )
    end

    session
  end

  def disable_playground_item(session, value) when is_binary(value) do
    if not safe_dom_token?(value), do: raise(ArgumentError, "invalid item value")

    session
    |> close_combobox_by_host_id("combobox-playground", timeout: 8_000)
    |> assert_has(
      css(
        ~S|#combobox-playground-disabled-items[phx-hook="Select"]:not([data-loading])|,
        visible: :any
      )
    )
    |> click(
      css(
        ~S|#combobox-playground-disabled-items [data-scope="select"][data-part="trigger"]|,
        visible: :any
      )
    )
    |> wait_for_has(
      css(
        ~S|#combobox-playground-disabled-items [data-scope="select"][data-part="content"][data-state="open"]|,
        visible: :any
      ),
      timeout: 8_000
    )
    |> click(
      css(
        ~s|#combobox-playground-disabled-items [data-scope="select"][data-part="item"][data-value="#{value}"]|,
        visible: :any
      )
    )
    |> click(
      css(
        ~S|#combobox-playground-disabled-items [data-scope="select"][data-part="trigger"]|,
        visible: :any
      )
    )
    |> wait_for_has(
      css(
        ~S|#combobox-playground-disabled-items [data-scope="select"][data-part="content"][data-state="open"]|,
        count: 0,
        visible: :any
      ),
      timeout: 8_000
    )
  end

  def assert_playground_item_keeps_custom_slot(session, host_dom_id, value)
      when is_binary(host_dom_id) and is_binary(value) do
    if not (safe_dom_token?(host_dom_id) and safe_dom_token?(value)) do
      raise ArgumentError, "invalid host or value"
    end

    key = {:e2e_combobox_slot, self(), make_ref()}

    _ =
      execute_script(
        session,
        """
        const root = document.getElementById(arguments[0]);
        const item = root?.querySelector(
          '[data-scope="combobox"][data-part="item"][data-value="' + arguments[1] + '"]:not([data-template])'
        );
        const text = item?.querySelector('[data-scope="combobox"][data-part="item-text"]');
        const hasMedia = !!(text && (text.querySelector('svg') || text.querySelector('img') || text.children.length > 0));
        const label = (text?.textContent || '').trim();
        return hasMedia && label.length > 0;
        """,
        [host_dom_id, value],
        fn ok -> Process.put(key, ok == true) end
      )

    assert Process.get(key, false),
           "expected ##{host_dom_id} item #{value} to keep custom slot media + label"

    session
  end

  def first_item_value(session, host_dom_id) when is_binary(host_dom_id) do
    key = {:e2e_combobox_first_item, self(), make_ref()}

    _ =
      execute_script(
        session,
        """
        const root = document.getElementById(arguments[0]);
        const item = root?.querySelector('[data-scope="combobox"][data-part="item"]:not([data-template])');
        return item?.getAttribute('data-value') ?? '';
        """,
        [host_dom_id],
        fn value -> Process.put(key, to_string(value || "")) end
      )

    Process.get(key, "")
  end

  def assert_positioner_anchored(session, host_dom_id, _opts \\ []) when is_binary(host_dom_id) do
    if not (String.match?(host_dom_id, ~r/^[a-zA-Z0-9_-]+$/) and host_dom_id != "") do
      raise ArgumentError, "invalid combobox host dom id"
    end

    wait_combobox_content_open(session, host_dom_id)
  end

  def events_server_log_has_row?(session) do
    has?(session, css("#combobox-events-log-server tr[data-part='row']"))
  end

  def events_client_log_has_row?(session) do
    has?(session, css("#combobox-events-log-client tr[data-part='row']"))
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

  defp safe_dom_token?(token), do: String.match?(token, ~r/^[a-zA-Z0-9_-]+$/) and token != ""

  def focus_trigger_in_section(session, section_dom_id) when is_binary(section_dom_id) do
    if not safe_dom_token?(section_dom_id),
      do: raise(ArgumentError, "invalid section id")

    execute_script(
      session,
      """
      const section = document.getElementById('#{section_dom_id}');
      const trigger = section && section.querySelector(
        '[data-scope="combobox"][data-part="trigger"]'
      );
      if (trigger) trigger.focus();
      return !!(trigger && document.activeElement === trigger);
      """,
      [],
      fn v -> assert v == true, "expected focus on combobox trigger in ##{section_dom_id}" end
    )

    session
  end

  def press_key_on_active(session, key) do
    press_key(session, key, 1)
  end

  def content_open_in_section?(session, section_dom_id) do
    has?(
      session,
      css(
        ~s|section##{section_dom_id} [data-scope="combobox"][data-part="content"][data-state="open"]|,
        visible: :any
      )
    )
  end

  def assert_highlighted_item_in_section(session, section_dom_id, value) do
    if not safe_dom_token?(section_dom_id), do: raise(ArgumentError, "invalid section id")

    execute_script(
      session,
      """
      const section = document.getElementById('#{section_dom_id}');
      if (!section) return false;
      const item = section.querySelector(
        '[data-scope="combobox"][data-part="item"][data-value="#{value}"][data-highlighted]'
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

  def goto_form(session, mode) do
    {path, page_id} =
      case mode do
        :static -> {"/en/combobox/form", "combobox-form-page"}
        :live -> {"/en/combobox/live-form", "combobox-form-live-page"}
      end

    goto_form_page(session, path, page_id, mode)
  end

  defp form_dom_id(:static, :ecto), do: "combobox-form-ecto"
  defp form_dom_id(:static, _), do: "combobox-form-phoenix"
  defp form_dom_id(:live, :ecto), do: "combobox-live-form-ecto"
  defp form_dom_id(:live, _), do: "combobox-live-form-phoenix"

  def click_form_combobox_trigger(session, mode \\ :live, form \\ :phoenix) do
    form_id = form_dom_id(mode, form)

    session =
      if mode == :live do
        assert_has(session, css("##{form_id} [phx-hook='Combobox']:not([data-loading])"))
      else
        session
      end

    click(session, css("##{form_id} [data-scope='combobox'][data-part='trigger']"))
  end

  def submit_form(session, mode \\ :live, form \\ :phoenix) do
    case {mode, form} do
      {:live, :ecto} ->
        click(session, css("#combobox-live-form-ecto button[type='submit']"))

      {:live, _} ->
        click(session, css("#combobox-live-form-phoenix-submit"))

      {:static, :ecto} ->
        click(session, css("#combobox-form-ecto button[type='submit']"))

      {:static, _} ->
        click(session, css("#combobox-form-phoenix button[type='submit']"))
    end
  end

  def select_item(session, value) when is_binary(value) do
    session
    |> assert_has(css(~S([data-scope='combobox'][data-part='content'][data-state='open'])))
    |> click(css("[data-scope='combobox'][data-part='item'][data-value='#{value}']"))
  end
end
