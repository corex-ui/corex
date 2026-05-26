defmodule E2eWeb.TimerModel do
  use E2eWeb.Model, component: "timer"

  import Wallaby.Query

  @anatomy_sections ~W(
    timer-anatomy-minimal
    timer-anatomy-with-triggers
    timer-anatomy-countdown
    timer-anatomy-collapse
    timer-anatomy-interval
  )

  @anatomy_section_to_host_id %{
    "timer-anatomy-minimal" => "timer-anatomy-minimal",
    "timer-anatomy-with-triggers" => "timer-anatomy-controls",
    "timer-anatomy-countdown" => "timer-anatomy-countdown",
    "timer-anatomy-collapse" => "timer-anatomy-collapse",
    "timer-anatomy-interval" => "timer-anatomy-interval"
  }

  def anatomy_section_ids, do: @anatomy_sections

  def host_id_for_anatomy_section(section_id),
    do: Map.fetch!(@anatomy_section_to_host_id, section_id)

  def valid_dom_id?(dom_id) do
    String.match?(dom_id, ~r/^[a-zA-Z0-9_-]+$/) and String.length(dom_id) > 0
  end

  def wait_host_timer_ready(session, host_dom_id, opts \\ []) do
    if not valid_dom_id?(host_dom_id), do: raise(ArgumentError, "invalid host dom id")

    timeout = Keyword.get(opts, :timeout)

    q = css(~s|##{host_dom_id}[phx-hook="Timer"]:not([data-loading])|, visible: :any)

    case timeout do
      nil -> assert_has(session, q)
      max_ms when is_integer(max_ms) and max_ms > 0 -> wait_for_has(session, q, timeout: max_ms)
    end

    session
  end

  def wait_section_timer_ready(session, section_dom_id, opts \\ []) do
    if not valid_dom_id?(section_dom_id), do: raise(ArgumentError, "invalid section dom id")

    timeout = Keyword.get(opts, :timeout)

    q =
      css(~s|section##{section_dom_id} [phx-hook="Timer"]:not([data-loading])|, visible: :any)

    case timeout do
      nil -> assert_has(session, q)
      max_ms when is_integer(max_ms) and max_ms > 0 -> wait_for_has(session, q, timeout: max_ms)
    end

    session
  end

  def click_action_trigger_in_host(session, host_dom_id, action \\ "start") do
    if action not in ["start", "pause", "resume", "reset"] do
      raise ArgumentError, "invalid timer action"
    end

    click(session, action_trigger_query(host_dom_id, action))
    session
  end

  def click_start_trigger_in_host(session, host_dom_id) do
    click_action_trigger_in_host(session, host_dom_id, "start")
  end

  def click_pause_trigger_in_host(session, host_dom_id) do
    click_action_trigger_in_host(session, host_dom_id, "pause")
  end

  def action_trigger_query(host_dom_id, action) do
    css(
      ~s|##{host_dom_id} [data-scope="timer"][data-part="action-trigger"][data-action="#{action}"]|,
      visible: :any
    )
  end

  def timer_area_visible_in_host?(session, host_dom_id) do
    has?(
      session,
      css(~s|##{host_dom_id} [data-scope="timer"][data-part="area"]|, visible: :any)
    )
  end

  def click_button_in_section(session, section_id, button_label)
      when is_binary(section_id) and is_binary(button_label) do
    if String.contains?(button_label, "'") or String.contains?(button_label, "\"") do
      raise ArgumentError, "click_button_in_section/3 label must not include quotes"
    end

    click(
      session,
      xpath("(//*[@id=\'#{section_id}\']//button[normalize-space(.)=\'#{button_label}\'])[1]")
    )

    session
  end

  def timer_events_server_log_has_row?(session) do
    has?(session, css("#timer-events-log-server tr[data-part='row']", visible: :any))
  end

  def timer_events_client_log_has_row?(session) do
    has?(session, css("#timer-events-log-client tr[data-part='row']", visible: :any))
  end

  def wait_remounted_api_timer_ready(session, opts \\ []) do
    wait_for_has(
      session,
      css(
        "[id^='timer-api-remount-'][phx-hook='Timer']:not([data-loading])",
        visible: :any,
        minimum: 1
      ),
      opts
    )

    session
  end
end
