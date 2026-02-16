defmodule Corex.Timer do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Timer](https://zagjs.com/components/react/timer).

  ## Examples

  ### Basic

  ```heex
  <.timer id="t" start_ms={60_000} class="timer" />
  ```

  ### Countdown

  ```heex
  <.timer id="t" countdown start_ms={90_000} target_ms={0} auto_start class="timer" />
  ```

  ## Styling

  Use data attributes: `[data-scope="timer"][data-part="root"]`, `area`, `item`, `separator`, `control`, `action-trigger`.
  '''

  @doc type: :component
  use Phoenix.Component

  alias Corex.Timer.Anatomy.{Props, Root, Area, Control, Item, Separator, ActionTrigger}
  alias Corex.Timer.Connect

  attr(:id, :string, required: false)
  attr(:countdown, :boolean, default: false)
  attr(:start_ms, :integer, default: 0)
  attr(:target_ms, :integer, default: nil)
  attr(:auto_start, :boolean, default: false)
  attr(:interval, :integer, default: 1000)
  attr(:on_tick, :string, default: nil)
  attr(:on_complete, :string, default: nil)
  attr(:rest, :global)

  def timer(assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> "timer-#{System.unique_integer([:positive])}" end)
      |> assign(:time_values, time_values(assigns.start_ms))
      |> assign(:running, assigns.auto_start)
      |> assign(:paused, false)

    ~H"""
    <div
      id={@id}
      phx-hook="Timer"
      {@rest}
      {Connect.props(%Props{
        id: @id,
        countdown: @countdown,
        start_ms: @start_ms,
        target_ms: @target_ms,
        auto_start: @auto_start,
        interval: @interval,
        on_tick: @on_tick,
        on_complete: @on_complete
      })}
    >
      <div phx-update="ignore" {Connect.root(%Root{id: @id})}>
        <div {Connect.area(%Area{id: @id})}>
          <div {Connect.item(%Item{type: "days", value: @time_values.days})}></div>
          <div {Connect.separator(%Separator{})}>:</div>
          <div {Connect.item(%Item{type: "hours", value: @time_values.hours})}></div>
          <div {Connect.separator(%Separator{})}>:</div>
          <div {Connect.item(%Item{type: "minutes", value: @time_values.minutes})}></div>
          <div {Connect.separator(%Separator{})}>:</div>
          <div {Connect.item(%Item{type: "seconds", value: @time_values.seconds})}></div>
        </div>
        <div {Connect.control(%Control{id: @id})}>
          <button type="button" {Connect.action_trigger(%ActionTrigger{action: "start", hidden: @running or @paused})}>
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" d="M5.25 5.653c0-.856.917-1.398 1.667-.986l11.54 6.347a1.125 1.125 0 0 1 0 1.972l-11.54 6.347a1.125 1.125 0 0 1-1.667-.986V5.653Z" />
            </svg>
          </button>
          <button type="button" {Connect.action_trigger(%ActionTrigger{action: "pause", hidden: not @running})}>
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 5.25v13.5m-7.5-13.5v13.5" />
            </svg>
          </button>
          <button type="button" {Connect.action_trigger(%ActionTrigger{action: "resume", hidden: not @paused})}>
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" d="M5.25 5.653c0-.856.917-1.398 1.667-.986l11.54 6.347a1.125 1.125 0 0 1 0 1.972l-11.54 6.347a1.125 1.125 0 0 1-1.667-.986V5.653Z" />
            </svg>
          </button>
          <button type="button" {Connect.action_trigger(%ActionTrigger{action: "reset", hidden: not @running and not @paused})}>
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" d="M19.5 12c0-1.232-.046-2.453-.138-3.662a4.006 4.006 0 0 0-3.7-3.7 48.678 48.678 0 0 0-7.324 0 4.006 4.006 0 0 0-3.7 3.7c-.017.22-.032.441-.046.662M19.5 12l3-3m-3 3-3-3m-12 3c0 1.232.046 2.453.138 3.662a4.006 4.006 0 0 0 3.7 3.7 48.656 48.656 0 0 0 7.324 0 4.006 4.006 0 0 0 3.7-3.7c.017-.22.032-.441.046-.662M4.5 12l3 3m-3-3-3 3" />
            </svg>
          </button>
        </div>
      </div>
    </div>
    """
  end

  defp time_values(ms) do
    ms = max(0, ms)
    seconds = div(rem(ms, 60_000), 1_000)
    minutes = div(rem(ms, 3_600_000), 60_000)
    hours = div(rem(ms, 86_400_000), 3_600_000)
    days = div(ms, 86_400_000)

    %{days: days, hours: hours, minutes: minutes, seconds: seconds}
  end
end
