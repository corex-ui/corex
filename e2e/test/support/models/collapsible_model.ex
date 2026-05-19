defmodule E2eWeb.CollapsibleModel do
  use E2eWeb.Model, component: "collapsible"

  import Wallaby.Query

  @anatomy_sections ~W(
    collapsible-anatomy-basic
    collapsible-anatomy-with-indicator
    collapsible-anatomy-custom-slots
  )

  @anatomy_section_to_host_id %{
    "collapsible-anatomy-basic" => "collapsible-anatomy",
    "collapsible-anatomy-with-indicator" => "collapsible-anatomy-indicator",
    "collapsible-anatomy-custom-slots" => "collapsible-anatomy-custom"
  }

  def anatomy_section_ids, do: @anatomy_sections

  def host_id_for_anatomy_section(section_id),
    do: Map.fetch!(@anatomy_section_to_host_id, section_id)

  def valid_dom_id?(dom_id) do
    String.match?(dom_id, ~r/^[a-zA-Z0-9_-]+$/) and String.length(dom_id) > 0
  end

  def wait_host_collapsible_ready(session, host_dom_id, opts \\ []) do
    if not valid_dom_id?(host_dom_id), do: raise(ArgumentError, "invalid host dom id")

    timeout = Keyword.get(opts, :timeout)

    q =
      css(~s|##{host_dom_id}[phx-hook="Collapsible"]:not([data-loading])|, visible: :any)

    case timeout do
      nil -> assert_has(session, q)
      max_ms when is_integer(max_ms) and max_ms > 0 -> wait_for_has(session, q, timeout: max_ms)
    end

    session
  end

  def wait_section_collapsible_ready(session, section_dom_id, opts \\ []) do
    if not valid_dom_id?(section_dom_id), do: raise(ArgumentError, "invalid section dom id")

    timeout = Keyword.get(opts, :timeout)

    q =
      css(
        ~s|section##{section_dom_id} [phx-hook="Collapsible"]:not([data-loading])|,
        visible: :any
      )

    case timeout do
      nil -> assert_has(session, q)
      max_ms when is_integer(max_ms) and max_ms > 0 -> wait_for_has(session, q, timeout: max_ms)
    end

    session
  end

  def click_trigger_in_host(session, host_dom_id) do
    if not valid_dom_id?(host_dom_id), do: raise(ArgumentError, "invalid host dom id")

    click(
      session,
      css(~s|##{host_dom_id} [data-scope="collapsible"][data-part="trigger"]|, visible: :any)
    )

    session
  end

  def trigger_data_state_in_host(session, host_dom_id) do
    el =
      find(
        session,
        css(~s|##{host_dom_id} [data-scope="collapsible"][data-part="trigger"]|, visible: :any)
      )

    Wallaby.Element.attr(el, "data-state")
  end

  def wait_trigger_state_in_host(session, host_dom_id, state, opts \\ [])
      when state in ["open", "closed"] do
    wait_for_has(
      session,
      css(
        ~s|##{host_dom_id} [data-scope="collapsible"][data-part="trigger"][data-state="#{state}"]|,
        visible: :any
      ),
      opts
    )

    session
  end

  def click_in_section(session, section_id, button_label)
      when is_binary(section_id) and is_binary(button_label) do
    if String.contains?(button_label, "'") or String.contains?(button_label, "\"") do
      raise ArgumentError, "click_in_section/3 label must not include quotes"
    end

    click(
      session,
      xpath("(//*[@id=\'#{section_id}\']//button[normalize-space(.)=\'#{button_label}\'])[1]")
    )

    session
  end

  def wait_patterns_page(session) do
    assert_has(session, css("#collapsible-patterns-page", visible: :any))
    session
  end

  def collapsible_events_server_log_has_row?(session) do
    has?(session, css("#collapsible-events-log-server tr[data-part='row']"))
  end

  def collapsible_events_client_log_has_row?(session) do
    has?(session, css("#collapsible-events-log-client tr[data-part='row']"))
  end
end
