defmodule E2eWeb.TagsInputModel do
  use E2eWeb.Model, component: "tags-input"

  import Wallaby.Query

  @anatomy_sections ~W(
    tags-input-anatomy-minimal
    tags-input-anatomy-label
    tags-input-anatomy-translation
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

  def wait_section_tags_input_ready(session, section_dom_id, opts \\ []) do
    if not valid_section_dom_id?(section_dom_id) do
      raise ArgumentError, "invalid section dom id"
    end

    timeout = Keyword.get(opts, :timeout)

    q =
      css(
        ~s|section##{section_dom_id} [phx-hook="TagsInput"]:not([data-loading])|,
        visible: :any
      )

    session = scroll_section_into_view(session, section_dom_id)

    case timeout do
      nil -> assert_has(session, q)
      max_ms when is_integer(max_ms) and max_ms > 0 -> wait_for_has(session, q, timeout: max_ms)
    end

    session
  end

  def wait_playground_tags_input_ready(session, opts \\ []) do
    timeout = Keyword.get(opts, :timeout)

    _ =
      execute_script(
        session,
        """
        const el = document.getElementById('tags-input-playground');
        if (el) el.scrollIntoView({block: 'center'});
        """,
        []
      )

    q =
      css(
        ~S|#tags-input-playground[phx-hook="TagsInput"]:not([data-loading])|,
        visible: :any
      )

    case timeout do
      nil -> assert_has(session, q)
      max_ms when is_integer(max_ms) and max_ms > 0 -> wait_for_has(session, q, timeout: max_ms)
    end

    session
  end

  def wait_patterns_page(session) do
    assert_has(session, css("#tags-input-patterns-page", visible: :any))
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

  def focus_control_input_in_section(session, section_dom_id) do
    if not valid_section_dom_id?(section_dom_id) do
      raise ArgumentError, "invalid section dom id"
    end

    session = scroll_section_into_view(session, section_dom_id)

    sel = "section#" <> section_dom_id

    _ =
      execute_script(
        session,
        """
        const s = document.querySelector(arguments[0]);
        if (!s) return;
        const inp = s.querySelector('[data-scope="tags-input"][data-part="input"]');
        if (inp) inp.focus();
        """,
        [sel]
      )

    session
  end

  def type_in_focused_input(session, text) when is_binary(text) do
    type(session, text)
  end

  def press_enter_on_focused(session) do
    press_enter(session)
  end

  def click_first_item_delete_in_section(session, section_dom_id) do
    if not valid_section_dom_id?(section_dom_id) do
      raise ArgumentError, "invalid section dom id"
    end

    session = scroll_section_into_view(session, section_dom_id)

    click(
      session,
      css(
        ~s|##{section_dom_id} [data-scope="tags-input"][data-part="item"]:not([data-template]) [data-part="item-delete-trigger"]|,
        at: 0,
        visible: :any
      )
    )

    session
  end

  def click_delete_for_item_text_in_section(session, section_dom_id, item_text)
      when is_binary(item_text) do
    if not valid_section_dom_id?(section_dom_id) do
      raise ArgumentError, "invalid section dom id"
    end

    if String.contains?(item_text, "'") or String.contains?(item_text, "\"") do
      raise ArgumentError, "item_text must not include quotes"
    end

    session = scroll_section_into_view(session, section_dom_id)

    click(
      session,
      xpath(
        "//section[@id='#{section_dom_id}']//*[@data-scope='tags-input' and @data-part='item' and not(@data-template)]//*[@data-part='item-text' and normalize-space(.)='#{item_text}']/ancestor::*[@data-part='item'][1]//*[@data-part='item-delete-trigger']"
      )
    )

    session
  end

  def assert_item_text_in_section(session, section_dom_id, text, opts \\ []) do
    if not valid_section_dom_id?(section_dom_id) do
      raise ArgumentError, "invalid section dom id"
    end

    timeout = Keyword.get(opts, :timeout)

    session = scroll_section_into_view(session, section_dom_id)

    q =
      css(
        ~s|##{section_dom_id} [data-part="item-text"]|,
        text: text
      )

    case timeout do
      nil -> assert_has(session, q)
      max_ms when is_integer(max_ms) and max_ms > 0 -> wait_for_has(session, q, timeout: max_ms)
    end

    session
  end

  def refute_item_text_in_section(session, section_dom_id, text) do
    if not valid_section_dom_id?(section_dom_id) do
      raise ArgumentError, "invalid section dom id"
    end

    session = scroll_section_into_view(session, section_dom_id)

    refute_has(
      session,
      css(
        ~s|##{section_dom_id} [data-part="item-text"]|,
        text: text
      )
    )

    session
  end

  def tags_input_events_server_log_has_row?(session) do
    has?(session, css("#tags-input-events-log-server tr[data-part='row']"))
  end

  def tags_input_events_client_log_has_row?(session) do
    has?(session, css("#tags-input-events-log-client tr[data-part='row']"))
  end
end
