defmodule E2eWeb.ToggleGroupModel do
  use E2eWeb.Model, component: "toggle-group"

  import Wallaby.Query

  @anatomy_sections ~w(
    toggle-group-anatomy-minimal
    toggle-group-anatomy-indicator
  )

  def anatomy_section_ids, do: @anatomy_sections

  def valid_dom_id?(dom_id) do
    String.match?(dom_id, ~r/^[a-zA-Z0-9_-]+$/) and String.length(dom_id) > 0
  end

  def wait_host_toggle_group_ready(session, host_dom_id, opts \\ []) do
    if not valid_dom_id?(host_dom_id), do: raise(ArgumentError, "invalid host dom id")

    timeout = Keyword.get(opts, :timeout)

    q =
      css(~s|##{host_dom_id}[phx-hook="ToggleGroup"]:not([data-loading])|, visible: :any)

    case timeout do
      nil -> assert_has(session, q)
      max_ms when is_integer(max_ms) and max_ms > 0 -> wait_for_has(session, q, timeout: max_ms)
    end

    session
  end

  def wait_section_toggle_group_ready(session, section_dom_id, opts \\ []) do
    if not valid_dom_id?(section_dom_id), do: raise(ArgumentError, "invalid section dom id")

    timeout = Keyword.get(opts, :timeout)

    q =
      css(
        ~s|section##{section_dom_id} [phx-hook="ToggleGroup"]:not([data-loading])|,
        visible: :any
      )

    case timeout do
      nil -> assert_has(session, q)
      max_ms when is_integer(max_ms) and max_ms > 0 -> wait_for_has(session, q, timeout: max_ms)
    end

    session
  end

  def click_item_by_value_in_host(session, host_dom_id, value) when is_binary(value) do
    if String.contains?(value, "'") or String.contains?(value, "\"") do
      raise ArgumentError, "value must not contain quotes"
    end

    click(
      session,
      css(
        ~s|##{host_dom_id} [data-scope="toggle-group"][data-part="item"][data-value="#{value}"]|,
        visible: :any
      )
    )

    session
  end

  def wait_item_on_in_host(session, host_dom_id, value, opts \\ []) when is_binary(value) do
    wait_for_has(
      session,
      css(
        ~s|##{host_dom_id} [data-scope="toggle-group"][data-part="item"][data-value="#{value}"][data-state="on"]|,
        visible: :any
      ),
      opts
    )

    session
  end

  def item_on_in_host?(session, host_dom_id, value) when is_binary(value) do
    has?(
      session,
      css(
        ~s|##{host_dom_id} [data-scope="toggle-group"][data-part="item"][data-value="#{value}"][data-state="on"]|,
        visible: :any
      )
    )
  end

  def click_in_section(session, section_id, button_label)
      when is_binary(section_id) and is_binary(button_label) do
    if String.contains?(button_label, "'") or String.contains?(button_label, "\"") do
      raise ArgumentError, "click_in_section/3 label must not include quotes"
    end

    click(
      session,
      xpath("//*[@id='#{section_id}']//button[normalize-space(.)='#{button_label}']")
    )

    session
  end

  def wait_patterns_page(session) do
    assert_has(session, css("#toggle-group-patterns-page", visible: :any))
    session
  end

  def toggle_group_events_server_log_has_row?(session) do
    has?(session, css("#toggle-group-events-log-server tr[data-part='row']"))
  end

  def toggle_group_events_client_log_has_row?(session) do
    has?(session, css("#toggle-group-events-log-client tr[data-part='row']"))
  end
end
