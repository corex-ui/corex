defmodule Corex.Timer do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Timer](https://zagjs.com/components/react/timer).

  ## Examples

  ### Basic

  ```heex
  <.timer id="t" start_ms={60_000} class="timer">
    <:label>Elapsed</:label>
  </.timer>
  ```

  ## Styling

  Use data attributes: `[data-scope="timer"][data-part="root"]`, `area`, `control`, `item`, `item-value`, `item-label`, `separator`, `action-trigger`.
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

  slot(:label, required: false)

  def timer(assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> "timer-#{System.unique_integer([:positive])}" end)

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
          <div {Connect.control(%Control{id: @id})}>
            <span :for={type <- ["days", "hours", "minutes", "seconds", "milliseconds"]} {Connect.item(%Item{id: @id, type: type})} data-type={type}></span>
            <span {Connect.separator(%Separator{id: @id})} />
            <button type="button" {Connect.action_trigger(%ActionTrigger{id: @id, action: "start"})}>Start</button>
            <button type="button" {Connect.action_trigger(%ActionTrigger{id: @id, action: "pause"})}>Pause</button>
            <button type="button" {Connect.action_trigger(%ActionTrigger{id: @id, action: "reset"})}>Reset</button>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
