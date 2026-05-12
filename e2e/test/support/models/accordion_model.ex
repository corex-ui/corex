defmodule E2eWeb.AccordionModel do
  import ExUnit.Assertions
  import Wallaby.Query
  import Wallaby.Browser

  use E2eWeb.Model, component: "accordion"

  @anatomy_sections ~w(
    accordion-anatomy-minimal
    accordion-anatomy-with-indicator
    accordion-anatomy-custom-slots
    accordion-anatomy-manual-slots
    accordion-anatomy-compound
  )

  def anatomy_section_ids, do: @anatomy_sections

  def wait_root_no_loading(session, id_selector, opts \\ []) do
    q = css(~s(#{id_selector}[data-loading]), count: 0, visible: :any)

    case Keyword.get(opts, :timeout) do
      nil ->
        assert_has(session, q)

      max_ms when is_integer(max_ms) and max_ms > 0 ->
        deadline = System.monotonic_time(:millisecond) + max_ms
        busy_wait_root(session, q, deadline)
        assert_has(session, q)
    end
  end

  defp busy_wait_root(session, q, deadline) do
    if Wallaby.Browser.has?(session, q) do
      :ok
    else
      if System.monotonic_time(:millisecond) >= deadline do
        :ok
      else
        Process.sleep(50)
        busy_wait_root(session, q, deadline)
      end
    end
  end

  def wait_section_accordion_ready(session, section_dom_id, _opts \\ []) do
    assert_has(
      session,
      css(~s(##{section_dom_id} [phx-hook="Accordion"][data-loading]),
        count: 0,
        visible: :any
      )
    )
  end

  def click_item(session, trigger_text) do
    click(session, button(trigger_text))
  end

  defp first_item_trigger_query(section_dom_id) do
    css(
      ~s|##{section_dom_id} [data-scope="accordion"][data-part="item-trigger"]|,
      at: 0
    )
  end

  defp nth_item_trigger_query(section_dom_id, n) when is_integer(n) and n > 0 do
    css(
      ~s|##{section_dom_id} [data-scope="accordion"][data-part="item-trigger"]|,
      at: n - 1
    )
  end

  def first_trigger_aria_expanded(session, section_dom_id) do
    el = find(session, first_item_trigger_query(section_dom_id))
    Wallaby.Element.attr(el, "aria-expanded")
  end

  def trigger_aria_expanded_at(session, section_dom_id, n) when is_integer(n) and n > 0 do
    el = find(session, nth_item_trigger_query(section_dom_id, n))
    Wallaby.Element.attr(el, "aria-expanded")
  end

  def click_first_trigger_in_section(session, section_dom_id) do
    click(session, first_item_trigger_query(section_dom_id))
    session
  end

  def click_trigger_in_section_at(session, section_dom_id, n) when is_integer(n) and n > 0 do
    click(session, nth_item_trigger_query(section_dom_id, n))
    session
  end

  def assert_first_trigger_toggles(session, section_dom_id) do
    session = wait_section_accordion_ready(session, section_dom_id)
    before = first_trigger_aria_expanded(session, section_dom_id)

    session = click_first_trigger_in_section(session, section_dom_id)

    flipped = if before == "true", do: "false", else: "true"

    assert_has(
      session,
      css(
        ~s|##{section_dom_id} [data-scope="accordion"][data-part="item-trigger"][aria-expanded="#{flipped}"]|,
        count: :any,
        visible: :any
      )
    )

    after_exp = first_trigger_aria_expanded(session, section_dom_id)
    assert before != after_exp
    session
  end

  def see_content(session, content_text) do
    assert_has(session, css("body", text: content_text))
  end

  def dont_see_content(session, content_text) do
    dont_see(session, content_text)
  end

  def content_visible?(session, content_text) do
    has?(session, css("body", text: content_text))
  end

  def click_open_lorem_api(session) do
    click(
      session,
      xpath(
        "//*[@id='accordion-api-set-value-binding']//button[contains(normalize-space(), 'Open Lorem')]"
      )
    )

    session
  end

  def lorem_trigger_expanded?(session) do
    has?(
      session,
      css(~s([id="accordion:api-set-value-client:trigger:lorem"][aria-expanded="true"]))
    )
  end

  def click_in_section(session, section_id, button_label) when is_binary(button_label) do
    if String.contains?(button_label, "'") or String.contains?(button_label, "\"") do
      raise ArgumentError,
            "click_in_section/3 label must not include quotes (use a different matcher)"
    end

    click(
      session,
      xpath("//*[@id='#{section_id}']//button[normalize-space(.)='#{button_label}']")
    )

    session
  end

  def trigger_expanded?(session, accordion_id, value, expected \\ "true") do
    has?(
      session,
      css(~s([id="accordion:#{accordion_id}:trigger:#{value}"][aria-expanded="#{expected}"]))
    )
  end

  def trigger_aria_disabled?(session, accordion_id, value) do
    has?(
      session,
      css(~s([id="accordion:#{accordion_id}:trigger:#{value}"][aria-disabled="true"]))
    )
  end

  def item_data_disabled?(session, accordion_id, value) do
    has?(
      session,
      css(~s([id="accordion:#{accordion_id}:item:#{value}"][data-disabled="true"]))
    )
  end

  def my_accordion_attribute(session, attr) do
    el = find(session, css("#my-accordion"))
    Wallaby.Element.attr(el, attr)
  end

  def my_accordion_inner_orientation(session) do
    el =
      find(
        session,
        css(~s(#my-accordion [data-scope="accordion"][data-part="root"]))
      )

    Wallaby.Element.attr(el, "data-orientation")
  end

  def click_events_server_duis(session) do
    click(
      session,
      css(
        ~s|#accordion-events-server [data-scope="accordion"][data-part="item"][data-value="duis"] [data-part="item-trigger"]|
      )
    )

    session
  end

  def click_events_server_lorem(session) do
    click(
      session,
      css(
        ~s|#accordion-events-server [data-scope="accordion"][data-part="item"][data-value="lorem"] [data-part="item-trigger"]|
      )
    )

    session
  end

  def click_events_client_duis(session) do
    _ =
      execute_script(
        session,
        "document.getElementById('accordion-events-client')?.scrollIntoView({block: 'center'})"
      )

    click(
      session,
      css(
        ~s|#accordion-events-client [data-part="item"][data-value="duis"] [data-part="item-trigger"]|
      )
    )

    session
  end

  def events_server_log_has_row?(session) do
    has?(session, css("#accordion-events-log-server tr[data-part='row']"))
  end

  def events_client_log_has_row?(session) do
    has?(session, css("#accordion-events-log-client tr[data-part='row']"))
  end

  def assert_active_element_inside_id(session, dom_id) when is_binary(dom_id) do
    if not (String.match?(dom_id, ~r/^[a-zA-Z0-9_-]+$/) and String.length(dom_id) > 0) do
      raise ArgumentError,
            "only safe id strings are allowed for assert_active_element_inside_id/2"
    end

    execute_script(
      session,
      """
      const r = document.getElementById('#{dom_id}');
      return !!(r && r.contains(document.activeElement));
      """,
      [],
      fn v -> assert v == true end
    )

    session
  end
end
