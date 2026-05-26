defmodule E2eWeb.TabsModel do
  use E2eWeb.Model, component: "tabs"

  import Wallaby.Query

  @anatomy_sections ~W(
    tabs-anatomy-basic
    tabs-anatomy-indicator
    tabs-anatomy-nested
  )

  @anatomy_section_to_host_id %{
    "tabs-anatomy-basic" => "tabs-basic",
    "tabs-anatomy-indicator" => "tabs-indicator",
    "tabs-anatomy-nested" => "tabs-nested-outer"
  }

  def anatomy_section_ids, do: @anatomy_sections

  def host_id_for_anatomy_section(section_id),
    do: Map.fetch!(@anatomy_section_to_host_id, section_id)

  def valid_dom_id?(dom_id) do
    String.match?(dom_id, ~r/^[a-zA-Z0-9_-]+$/) and String.length(dom_id) > 0
  end

  def wait_host_tabs_ready(session, host_dom_id, opts \\ []) do
    if not valid_dom_id?(host_dom_id), do: raise(ArgumentError, "invalid host dom id")

    timeout = Keyword.get(opts, :timeout)

    q = css(~s|##{host_dom_id}[phx-hook="Tabs"]:not([data-loading])|, visible: :any)

    case timeout do
      nil -> assert_has(session, q)
      max_ms when is_integer(max_ms) and max_ms > 0 -> wait_for_has(session, q, timeout: max_ms)
    end

    session
  end

  def wait_section_tabs_ready(session, section_dom_id, opts \\ []) do
    if not valid_dom_id?(section_dom_id), do: raise(ArgumentError, "invalid section dom id")

    timeout = Keyword.get(opts, :timeout)

    q =
      css(
        ~s|section##{section_dom_id} [phx-hook="Tabs"]:not([data-loading])|,
        visible: :any,
        minimum: 1
      )

    case timeout do
      nil -> assert_has(session, q)
      max_ms when is_integer(max_ms) and max_ms > 0 -> wait_for_has(session, q, timeout: max_ms)
    end

    session
  end

  def click_trigger_by_label_in_host(session, host_dom_id, label) when is_binary(label) do
    if String.contains?(label, "'") or String.contains?(label, "\"") do
      raise ArgumentError, "label must not contain quotes"
    end

    click(
      session,
      xpath(
        "//*[@id='#{host_dom_id}']//*[@data-scope='tabs'][@data-part='trigger'][normalize-space(.)='#{label}']"
      )
    )

    session
  end

  def wait_trigger_selected_by_label_in_host(session, host_dom_id, label, opts \\ [])
      when is_binary(label) do
    if String.contains?(label, "'") do
      raise ArgumentError, "label must not contain single quote"
    end

    wait_for_has(
      session,
      xpath(
        "//*[@id='#{host_dom_id}']//*[@data-scope='tabs'][@data-part='trigger'][normalize-space(.)='#{label}'][@data-selected]"
      ),
      opts
    )

    session
  end

  def trigger_selected_by_label_in_host?(session, host_dom_id, label) when is_binary(label) do
    if String.contains?(label, "'") do
      raise ArgumentError, "label must not contain single quote"
    end

    has?(
      session,
      xpath(
        "//*[@id='#{host_dom_id}']//*[@data-scope='tabs'][@data-part='trigger'][normalize-space(.)='#{label}'][@data-selected]"
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
      xpath("(//*[@id=\'#{section_id}\']//button[normalize-space(.)=\'#{button_label}\'])[1]")
    )

    session
  end

  def wait_patterns_page(session) do
    assert_has(session, css("#tabs-patterns-page", visible: :any))
    session
  end

  def tabs_events_server_log_has_row?(session) do
    has?(session, css("#tabs-events-log-server tr[data-part='row']"))
  end

  def tabs_events_client_log_has_row?(session) do
    has?(session, css("#tabs-events-log-client tr[data-part='row']"))
  end
end
