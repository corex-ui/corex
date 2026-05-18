defmodule E2eWeb.SelectModel do
  use E2eWeb.Model, component: "select"

  @anatomy_sections ~w(
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
    el =
      find(
        session,
        css(
          ~s|section##{section_dom_id} [phx-hook="Select"] input|,
          visible: :any
        )
      )

    Wallaby.Element.attr(el, "value")
  end

  def hidden_input_value_by_host_id(session, host_dom_id) do
    el =
      find(
        session,
        css(~s|##{host_dom_id} input|, visible: :any)
      )

    Wallaby.Element.attr(el, "value")
  end

  def wait_hidden_value_in_anatomy_section(session, section_dom_id, expected, opts \\ [])
      when is_binary(expected) do
    wait_for_has(
      session,
      css(
        ~s|section##{section_dom_id} [phx-hook="Select"] input[value="#{expected}"]|,
        visible: :any
      ),
      opts
    )

    session
  end

  def wait_hidden_value_by_host_id(session, host_dom_id, expected, opts \\ [])
      when is_binary(expected) do
    wait_for_has(
      session,
      css(~s|##{host_dom_id} input[value="#{expected}"]|, visible: :any),
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
      xpath("//*[@id='#{section_id}']//button[normalize-space(.)='#{label}']")
    )

    session
  end

  def select_events_server_log_has_row?(session) do
    has?(session, css("#select-events-log-server tr[data-part='row']"))
  end

  def select_events_client_log_has_row?(session) do
    has?(session, css("#select-events-log-client tr[data-part='row']"))
  end

  def goto_form(session, mode) do
    path =
      case mode do
        :static -> "/en/select/form"
        :live -> "/en/select/live-form"
      end

    session = visit_path(session, path)

    if mode == :live do
      prepare_live_form(session)
    else
      session
    end
  end

  def wait_for_select_field_error(session, mode \\ :static, _opts \\ []) do
    form_id =
      case mode do
        :live -> "select-form"
        :static -> "select-changeset-form"
      end

    q =
      css(~s(##{form_id} [data-scope="select"][data-part="error"]),
        text: "blank"
      )

    assert_has(session, q)
  end

  def click_select_trigger(session) do
    session
    |> assert_has(css("[phx-hook='Select']:not([data-loading])"))
    |> click(css("[data-scope='select'][data-part='trigger']"))
  end

  def click_form_select_trigger(session, mode \\ :static) do
    form_id = if mode == :live, do: "select-form", else: "select-changeset-form"

    session
    |> assert_has(css("##{form_id} [phx-hook='Select']:not([data-loading])"))
    |> click(css("##{form_id} [data-scope='select'][data-part='trigger']"))
  end

  def select_item(session, value) when is_binary(value) do
    session
    |> assert_has(css(~s([data-scope='select'][data-part='content'][data-state='open'])))
    |> click(css("[data-scope='select'][data-part='item'][data-value='#{value}']"))
  end

  def set_select_value(session, id, value) do
    hidden_id = if String.ends_with?(id, "-value"), do: id, else: "#{id}-value"

    script = """
    (function() {
      var el = document.getElementById('#{hidden_id}');
      if (!el) return 'not found';
      el.value = '#{value}';
      el.dispatchEvent(new Event('input', { bubbles: true }));
      el.dispatchEvent(new Event('change', { bubbles: true }));
      return 'ok';
    })()
    """

    Wallaby.Browser.execute_script(session, script)
    session
  end

  def submit_form(session, mode \\ :static) do
    id = if mode == :live, do: "select-form-live-submit", else: "select-changeset-submit"
    click(session, css("##{id}"))
  end

  def see_submitted_value(session, key, value) do
    assert_has(session, css("body", text: "#{key}=#{value}"))
  end

  def see_flash(session, flash_text, _opts \\ []) do
    assert_toast(session, flash_text)
  end
end
