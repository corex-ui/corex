defmodule Corex.Timer do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Timer](https://zagjs.com/components/react/timer).

  ## Examples

  ### Basic

  ```heex
  <.timer id="t" start_ms={60_000} class="timer">
    <:start_trigger><.heroicon name="hero-play" class="icon" /></:start_trigger>
    <:pause_trigger><.heroicon name="hero-pause" class="icon" /></:pause_trigger>
    <:resume_trigger><.heroicon name="hero-play" class="icon" /></:resume_trigger>
    <:reset_trigger><.heroicon name="hero-arrow-path" class="icon" /></:reset_trigger>
  </.timer>
  ```

  ### Countdown

  ```heex
  <.timer id="t" countdown start_ms={90_000} target_ms={0} auto_start class="timer">
    <:start_trigger><.heroicon name="hero-play" class="icon" /></:start_trigger>
    <:pause_trigger><.heroicon name="hero-pause" class="icon" /></:pause_trigger>
    <:resume_trigger><.heroicon name="hero-play" class="icon" /></:resume_trigger>
    <:reset_trigger><.heroicon name="hero-arrow-path" class="icon" /></:reset_trigger>
  </.timer>
  ```

  Required slots: `:start_trigger`, `:pause_trigger`, `:resume_trigger`, `:reset_trigger`.

  ## Styling

  Use data attributes to target elements:

  ```css
  [data-scope="timer"][data-part="root"] {}
  [data-scope="timer"][data-part="area"] {}
  [data-scope="timer"][data-part="item"] {}
  [data-scope="timer"][data-part="separator"] {}
  [data-scope="timer"][data-part="control"] {}
  [data-scope="timer"][data-part="action-trigger"] {}
  ```

  If you wish to use the default Corex styling, you can use the class `timer` on the component.
  This requires to install `Mix.Tasks.Corex.Design` first and import the component css file.

  ```css
  @import "../corex/main.css";
  @import "../corex/tokens/themes/neo/light.css";
  @import "../corex/components/timer.css";
  ```

  You can then use modifiers

  ```heex
  <.timer class="timer timer--accent timer--lg">
  </.timer>
  ```

  '''

  @doc type: :component
  use Phoenix.Component

  alias Corex.Timer.Anatomy.{ActionTrigger, Area, Control, Item, Props, Root, Separator}
  alias Corex.Timer.Connect

  attr(:id, :string, required: false)
  attr(:countdown, :boolean, default: false)
  attr(:start_ms, :integer, default: 0)
  attr(:target_ms, :integer, default: nil)
  attr(:auto_start, :boolean, default: false)
  attr(:interval, :integer, default: 1000)
  attr(:on_tick, :string, default: nil)
  attr(:on_tick_client, :string, default: nil)
  attr(:on_complete, :string, default: nil)
  attr(:on_complete_client, :string, default: nil)

  attr(:dir, :string,
    default: "ltr",
    values: ["ltr", "rtl"],
    doc: "Text direction for styling; nil follows the document."
  )

  attr(:orientation, :string,
    default: "horizontal",
    values: ["horizontal", "vertical"],
    doc: "Layout orientation for CSS."
  )

  attr(:rest, :global)

  slot :start_trigger, required: true do
    attr(:class, :string, required: false)
  end

  slot :pause_trigger, required: true do
    attr(:class, :string, required: false)
  end

  slot :resume_trigger, required: true do
    attr(:class, :string, required: false)
  end

  slot :reset_trigger, required: true do
    attr(:class, :string, required: false)
  end

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
      data-loading
      phx-mounted={Phoenix.LiveView.JS.ignore_attributes(["data-loading"])}
      {@rest}
      {Connect.props(%Props{
        id: @id,
        countdown: @countdown,
        start_ms: @start_ms,
        target_ms: @target_ms,
        auto_start: @auto_start,
        interval: @interval,
        on_tick: @on_tick,
        on_tick_client: @on_tick_client,
        on_complete: @on_complete,
        on_complete_client: @on_complete_client,
        dir: @dir,
        orientation: @orientation
      })}
    >
      <div phx-mounted={Connect.ignore_root(%Root{id: @id, dir: @dir, orientation: @orientation})} {Connect.root(%Root{id: @id, dir: @dir, orientation: @orientation})}>
        <div phx-mounted={Connect.ignore_area(%Area{id: @id, dir: @dir, orientation: @orientation})} {Connect.area(%Area{id: @id, dir: @dir, orientation: @orientation})}>
          <div phx-mounted={Connect.ignore_item(%Item{id: @id, type: "days", value: @time_values.days, dir: @dir, orientation: @orientation})} {Connect.item(%Item{id: @id, type: "days", value: @time_values.days, dir: @dir, orientation: @orientation})}></div>
          <div phx-mounted={Connect.ignore_separator(%Separator{id: "timer:#{@id}:sep:0", dir: @dir, orientation: @orientation})} {Connect.separator(%Separator{id: "timer:#{@id}:sep:0", dir: @dir, orientation: @orientation})}>:</div>
          <div phx-mounted={Connect.ignore_item(%Item{id: @id, type: "hours", value: @time_values.hours, dir: @dir, orientation: @orientation})} {Connect.item(%Item{id: @id, type: "hours", value: @time_values.hours, dir: @dir, orientation: @orientation})}></div>
          <div phx-mounted={Connect.ignore_separator(%Separator{id: "timer:#{@id}:sep:1", dir: @dir, orientation: @orientation})} {Connect.separator(%Separator{id: "timer:#{@id}:sep:1", dir: @dir, orientation: @orientation})}>:</div>
          <div phx-mounted={Connect.ignore_item(%Item{id: @id, type: "minutes", value: @time_values.minutes, dir: @dir, orientation: @orientation})} {Connect.item(%Item{id: @id, type: "minutes", value: @time_values.minutes, dir: @dir, orientation: @orientation})}></div>
          <div phx-mounted={Connect.ignore_separator(%Separator{id: "timer:#{@id}:sep:2", dir: @dir, orientation: @orientation})} {Connect.separator(%Separator{id: "timer:#{@id}:sep:2", dir: @dir, orientation: @orientation})}>:</div>
          <div phx-mounted={Connect.ignore_item(%Item{id: @id, type: "seconds", value: @time_values.seconds, dir: @dir, orientation: @orientation})} {Connect.item(%Item{id: @id, type: "seconds", value: @time_values.seconds, dir: @dir, orientation: @orientation})}></div>
        </div>
        <div phx-mounted={Connect.ignore_control(%Control{id: @id, dir: @dir, orientation: @orientation})} {Connect.control(%Control{id: @id, dir: @dir, orientation: @orientation})}>
          <button type="button" phx-mounted={Connect.ignore_action_trigger(%ActionTrigger{id: @id, action: "start", hidden: @running or @paused, dir: @dir, orientation: @orientation})} {Connect.action_trigger(%ActionTrigger{id: @id, action: "start", hidden: @running or @paused, dir: @dir, orientation: @orientation})}>
            {render_slot(@start_trigger)}
          </button>
          <button type="button" phx-mounted={Connect.ignore_action_trigger(%ActionTrigger{id: @id, action: "pause", hidden: not @running, dir: @dir, orientation: @orientation})} {Connect.action_trigger(%ActionTrigger{id: @id, action: "pause", hidden: not @running, dir: @dir, orientation: @orientation})}>
            {render_slot(@pause_trigger)}
          </button>
          <button type="button" phx-mounted={Connect.ignore_action_trigger(%ActionTrigger{id: @id, action: "resume", hidden: not @paused, dir: @dir, orientation: @orientation})} {Connect.action_trigger(%ActionTrigger{id: @id, action: "resume", hidden: not @paused, dir: @dir, orientation: @orientation})}>
            {render_slot(@resume_trigger)}
          </button>
          <button type="button" phx-mounted={Connect.ignore_action_trigger(%ActionTrigger{id: @id, action: "reset", hidden: not @running and not @paused, dir: @dir, orientation: @orientation})} {Connect.action_trigger(%ActionTrigger{id: @id, action: "reset", hidden: not @running and not @paused, dir: @dir, orientation: @orientation})}>
            {render_slot(@reset_trigger)}
          </button>
        </div>
      </div>
    </div>
    """
  end

  @doc type: :component
  attr(:id, :string, required: false)
  attr(:rest, :global)

  def timer_skeleton(assigns) do
    assigns = assign_new(assigns, :id, fn -> "timer-#{System.unique_integer([:positive])}" end)

    ~H"""
    <div id={@id} {@rest}>
      <div {Connect.root(%Root{id: @id, dir: "ltr", orientation: "horizontal"})}>
        <div {Connect.area(%Area{id: @id, dir: "ltr", orientation: "horizontal"})}>
          <div {Connect.item(%Item{id: @id, type: "days", value: 0, dir: "ltr", orientation: "horizontal"})}></div>
          <div {Connect.separator(%Separator{id: "timer:#{@id}:sep:0", dir: "ltr", orientation: "horizontal"})}>:</div>
          <div {Connect.item(%Item{id: @id, type: "hours", value: 0, dir: "ltr", orientation: "horizontal"})}></div>
          <div {Connect.separator(%Separator{id: "timer:#{@id}:sep:1", dir: "ltr", orientation: "horizontal"})}>:</div>
          <div {Connect.item(%Item{id: @id, type: "minutes", value: 0, dir: "ltr", orientation: "horizontal"})}></div>
          <div {Connect.separator(%Separator{id: "timer:#{@id}:sep:2", dir: "ltr", orientation: "horizontal"})}>:</div>
          <div {Connect.item(%Item{id: @id, type: "seconds", value: 0, dir: "ltr", orientation: "horizontal"})}></div>
        </div>
        <div {Connect.control(%Control{id: @id, dir: "ltr", orientation: "horizontal"})}>
          <div class="timer-skeleton__btn" data-scope="timer" data-part="action-trigger" aria-hidden="true"></div>
          <div class="timer-skeleton__btn" data-scope="timer" data-part="action-trigger" aria-hidden="true"></div>
          <div class="timer-skeleton__btn" data-scope="timer" data-part="action-trigger" aria-hidden="true"></div>
          <div class="timer-skeleton__btn" data-scope="timer" data-part="action-trigger" aria-hidden="true"></div>
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
