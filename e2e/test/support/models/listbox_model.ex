defmodule E2eWeb.ListboxModel do
  import Wallaby.Query
  import Wallaby.Browser
  import ExUnit.Assertions

  use E2eWeb.Model, component: "listbox"

  @anatomy_sections ~w(
    listbox-anatomy-minimal
    listbox-anatomy-with-indicator
    listbox-anatomy-grouped
    listbox-anatomy-extended
    listbox-anatomy-extended-grouped
  )

  @anatomy_section_to_host_id %{
    "listbox-anatomy-minimal" => "listbox-anatomy-minimal",
    "listbox-anatomy-with-indicator" => "listbox-anatomy-indicator",
    "listbox-anatomy-grouped" => "listbox-anatomy-grouped",
    "listbox-anatomy-extended" => "listbox-anatomy-extended",
    "listbox-anatomy-extended-grouped" => "listbox-anatomy-extended-grouped"
  }

  def anatomy_section_ids, do: @anatomy_sections

  def listbox_host_id_for_anatomy_section(section_id) do
    Map.fetch!(@anatomy_section_to_host_id, section_id)
  end

  def wait_root_no_loading(session, id_selector, opts \\ []) do
    q = css(~s(#{id_selector}[data-loading]), count: 0, visible: :any)

    case Keyword.get(opts, :timeout) do
      nil ->
        assert_has(session, q)

      max_ms when is_integer(max_ms) and max_ms > 0 ->
        deadline = System.monotonic_time(:millisecond) + max_ms
        busy_wait_listbox_root(session, q, deadline)
        assert_has(session, q)
    end
  end

  defp busy_wait_listbox_root(session, q, deadline) do
    if has?(session, q) do
      :ok
    else
      if System.monotonic_time(:millisecond) >= deadline do
        :ok
      else
        Process.sleep(50)
        busy_wait_listbox_root(session, q, deadline)
      end
    end
  end

  def wait_section_listbox_ready(session, section_dom_id, _opts \\ []) do
    assert_has(
      session,
      css(~s(##{section_dom_id} [phx-hook="Listbox"][data-loading]), count: 0, visible: :any)
    )
  end

  def click_item_by_value(session, listbox_dom_id, value) when is_binary(value) do
    if String.contains?(value, "'") or String.contains?(value, "\"") do
      raise ArgumentError, "click_item_by_value: value must not contain quotes"
    end

    _ =
      execute_script(
        session,
        "document.getElementById(#{Jason.encode!(listbox_dom_id)})?.scrollIntoView({block: 'center'})"
      )

    text_sel =
      css(
        ~s|##{listbox_dom_id} [data-scope="listbox"][data-part="item"][data-value="#{value}"] [data-part="item-text"]|
      )

    item_sel =
      css(~s|##{listbox_dom_id} [data-scope="listbox"][data-part="item"][data-value="#{value}"]|)

    q = if has?(session, text_sel), do: text_sel, else: item_sel
    click(session, q)
  end

  def wait_item_aria_selected(session, listbox_dom_id, value, opts \\ []) do
    wait_for_has(
      session,
      css(
        ~s|##{listbox_dom_id} [data-scope="listbox"][data-part="item"][data-value="#{value}"][aria-selected="true"]|
      ),
      opts
    )
  end

  def item_aria_selected?(session, listbox_dom_id, value, expected \\ "true") do
    has?(
      session,
      css(
        ~s|##{listbox_dom_id} [data-scope="listbox"][data-part="item"][data-value="#{value}"][aria-selected="#{expected}"]|
      )
    )
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

  def click_events_server_item(session, listbox_dom_id, value) do
    click_item_by_value(session, listbox_dom_id, value)
  end

  def click_events_client_item(session, listbox_dom_id, value) do
    click_item_by_value(session, listbox_dom_id, value)
  end

  def events_server_log_has_row?(session) do
    has?(session, css("#listbox-events-log-server tr[data-part='row']"))
  end

  def events_client_log_has_row?(session) do
    has?(session, css("#listbox-events-log-client tr[data-part='row']"))
  end

  def controlled_state_text(session) do
    el = find(session, css("#listbox-patterns-controlled-state"))
    Wallaby.Element.text(el)
  end

  def assert_active_element_inside_id(session, dom_id) when is_binary(dom_id) do
    if not (String.match?(dom_id, ~r/^[a-zA-Z0-9_-]+$/) and String.length(dom_id) > 0) do
      raise ArgumentError, "only safe id strings for assert_active_element_inside_id/2"
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
