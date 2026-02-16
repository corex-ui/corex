defmodule Corex.Timer do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Timer](https://zagjs.com/components/react/timer).

  ## Examples

  ### Basic

  ```heex
  <.timer id="t" start_ms={60_000} class="timer">
    <:start_trigger><.icon name="hero-play" class="icon" /></:start_trigger>
    <:pause_trigger><.icon name="hero-pause" class="icon" /></:pause_trigger>
    <:resume_trigger><.icon name="hero-play" class="icon" /></:resume_trigger>
    <:reset_trigger><.icon name="hero-arrow-path" class="icon" /></:reset_trigger>
  </.timer>
  ```

  ### Countdown

  ```heex
  <.timer id="t" countdown start_ms={90_000} target_ms={0} auto_start class="timer">
    <:start_trigger><.icon name="hero-play" class="icon" /></:start_trigger>
    <:pause_trigger><.icon name="hero-pause" class="icon" /></:pause_trigger>
    <:resume_trigger><.icon name="hero-play" class="icon" /></:resume_trigger>
    <:reset_trigger><.icon name="hero-arrow-path" class="icon" /></:reset_trigger>
  </.timer>
  ```

  Required slots: `:start_trigger`, `:pause_trigger`, `:resume_trigger`, `:reset_trigger`.

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

  slot(:start_trigger, required: true)
  slot(:pause_trigger, required: true)
  slot(:resume_trigger, required: true)
  slot(:reset_trigger, required: true)

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
            {render_slot(@start_trigger)}
          </button>
          <button type="button" {Connect.action_trigger(%ActionTrigger{action: "pause", hidden: not @running})}>
            {render_slot(@pause_trigger)}
          </button>
          <button type="button" {Connect.action_trigger(%ActionTrigger{action: "resume", hidden: not @paused})}>
            {render_slot(@resume_trigger)}
          </button>
          <button type="button" {Connect.action_trigger(%ActionTrigger{action: "reset", hidden: not @running and not @paused})}>
            {render_slot(@reset_trigger)}
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
