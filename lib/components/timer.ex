defmodule Corex.Timer do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Timer](https://zagjs.com/components/react/timer).

  Countdown leading-zero collapse is on by default when `countdown` is true. Override with `collapse_leading_zeros={false}` or fixed `segments`.

  ## Anatomy

  <!-- tabs-open -->

  ### Minimal

  ```heex
  <.timer id="timer-anatomy-minimal" start_ms={60_000} class="timer" />
  ```

  ### With triggers

  ```heex
  <.timer id="timer-anatomy-controls" start_ms={60_000} class="timer">
    <:start_trigger><.heroicon name="hero-play" /></:start_trigger>
    <:pause_trigger><.heroicon name="hero-pause" /></:pause_trigger>
    <:resume_trigger><.heroicon name="hero-play" /></:resume_trigger>
    <:reset_trigger><.heroicon name="hero-arrow-path" /></:reset_trigger>
  </.timer>
  ```

  ### Countdown

  ```heex
  <.timer id="timer-anatomy-countdown" countdown start_ms={60_000} target_ms={0} class="timer">
    <:start_trigger><.heroicon name="hero-play" /></:start_trigger>
    <:pause_trigger><.heroicon name="hero-pause" /></:pause_trigger>
    <:resume_trigger><.heroicon name="hero-play" /></:resume_trigger>
    <:reset_trigger><.heroicon name="hero-arrow-path" /></:reset_trigger>
  </.timer>
  ```

  ### Interval tick

  ```heex
  <.timer id="timer-anatomy-interval" start_ms={60_000} interval={2000} auto_start class="timer">
    <:start_trigger><.heroicon name="hero-play" /></:start_trigger>
    <:pause_trigger><.heroicon name="hero-pause" /></:pause_trigger>
    <:resume_trigger><.heroicon name="hero-play" /></:resume_trigger>
    <:reset_trigger><.heroicon name="hero-arrow-path" /></:reset_trigger>
  </.timer>
  ```

  <!-- tabs-close -->

  ## API

  Timer has no imperative Elixir helpers. Use trigger slots, `auto_start`, and event handlers.

  ## Events

  Pick an event name and pass it to `on_*` on `<.timer>`.

  ### Server events

  | Event | When | Payload |
  | ----- | ---- | ------- |
  | `on_tick="timer_tick"` | Each tick | `%{"id" => id, "formattedTime" => string, ...}` |
  | `on_complete="timer_complete"` | Countdown reaches target | `%{"id" => id}` |

  <!-- tabs-open -->

  ### on_tick

  ```heex
  <.timer
    id="timer-events-server"
    countdown
    start_ms={3_600_000}
    target_ms={0}
    class="timer"
    on_tick="timer_tick"
    on_complete="timer_complete"
  >
    <:start_trigger><.heroicon name="hero-play" /></:start_trigger>
    <:pause_trigger><.heroicon name="hero-pause" /></:pause_trigger>
    <:resume_trigger><.heroicon name="hero-play" /></:resume_trigger>
    <:reset_trigger><.heroicon name="hero-arrow-path" /></:reset_trigger>
  </.timer>
  ```

  ```elixir
  def handle_event("timer_tick", %{"id" => id} = params, socket) do
    {:noreply, assign(socket, :last_tick, Map.get(params, "formattedTime"))}
  end

  def handle_event("timer_complete", %{"id" => _id}, socket) do
    {:noreply, socket}
  end
  ```

  <!-- tabs-close -->

  ### Client events

  | Event | When | `event.detail` |
  | ----- | ---- | -------------- |
  | `on_tick_client="timer-tick"` | Each tick | `id`, formatted time fields |
  | `on_complete_client="timer-complete"` | Countdown completes | `id` |

  <!-- tabs-open -->

  ### on_tick_client

  ```heex
  <.timer
    id="timer-events-client"
    countdown
    start_ms={3_600_000}
    target_ms={0}
    class="timer"
    on_tick_client="timer-tick"
    on_complete_client="timer-complete"
  >
    <:start_trigger><.heroicon name="hero-play" /></:start_trigger>
    <:pause_trigger><.heroicon name="hero-pause" /></:pause_trigger>
    <:resume_trigger><.heroicon name="hero-play" /></:resume_trigger>
    <:reset_trigger><.heroicon name="hero-arrow-path" /></:reset_trigger>
  </.timer>
  ```

  ```javascript
  const el = document.getElementById("timer-events-client");
  el?.addEventListener("timer-tick", (e) => console.log(e.detail));
  el?.addEventListener("timer-complete", (e) => console.log(e.detail));
  ```

  <!-- tabs-close -->

  '''

  @doc type: :component
  use Phoenix.Component

  alias Corex.Timer.Anatomy.{
    ActionTrigger,
    Area,
    Control,
    Item,
    ItemLabel,
    Props,
    Root,
    Segment,
    Separator
  }

  alias Corex.Timer.Connect
  alias Corex.Timer.Translation, as: TimerTranslation

  @parts [:days, :hours, :minutes, :seconds]

  attr(:id, :string,
    required: false,
    doc: "DOM id for the timer root; required for imperative timer API helpers."
  )

  attr(:countdown, :boolean,
    default: false,
    doc: "Count toward zero using target_ms when set."
  )

  attr(:start_ms, :integer,
    default: 0,
    doc: "Initial elapsed or remaining milliseconds depending on mode."
  )

  attr(:target_ms, :integer,
    default: nil,
    doc: "Countdown stops at this millisecond value (often 0)."
  )

  attr(:auto_start, :boolean,
    default: true,
    doc: "Start the timer automatically on mount."
  )

  attr(:interval, :integer,
    default: 1000,
    doc: "Tick interval in milliseconds."
  )

  attr(:on_tick, :string,
    default: nil,
    doc: "LiveView event for each tick; see module Events section."
  )

  attr(:on_tick_client, :string,
    default: nil,
    doc: "Browser CustomEvent name for each tick."
  )

  attr(:on_complete, :string,
    default: nil,
    doc: "LiveView event when countdown or count-up reaches target."
  )

  attr(:on_complete_client, :string,
    default: nil,
    doc: "Browser CustomEvent name when the run completes."
  )

  attr(:collapse_leading_zeros, :boolean,
    default: nil,
    doc:
      "When nil and countdown without fixed segments, leading zero units are hidden (minimum minutes and seconds visible)."
  )

  attr(:segments, :list,
    default: nil,
    doc:
      "Fixed subset of [:days, :hours, :minutes, :seconds] in natural order; disables collapse when set."
  )

  attr(:translation, TimerTranslation,
    default: nil,
    doc: "Zag timer translations; supports area_label for the timer region aria-label."
  )

  attr(:dir, :string,
    default: nil,
    values: [nil, "ltr", "rtl"],
    doc: "Text direction for styling; nil follows the document."
  )

  attr(:orientation, :string,
    default: "horizontal",
    values: ["horizontal", "vertical"],
    doc: "Layout orientation for CSS."
  )

  attr(:rest, :global)

  slot(:separator, required: false)

  slot(:day_label, required: false)
  slot(:hour_label, required: false)
  slot(:minute_label, required: false)
  slot(:second_label, required: false)

  slot :start_trigger, required: false do
    attr(:class, :string, required: false)
  end

  slot :pause_trigger, required: false do
    attr(:class, :string, required: false)
  end

  slot :resume_trigger, required: false do
    attr(:class, :string, required: false)
  end

  slot :reset_trigger, required: false do
    attr(:class, :string, required: false)
  end

  def timer(assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> "timer-#{System.unique_integer([:positive])}" end)
      |> assign(
        :translation,
        TimerTranslation.merge(assigns.translation, TimerTranslation.default())
      )

    segments = normalize_segments(assigns.segments)
    time_values = time_values(assigns.start_ms)

    visibility_hidden =
      visibility_hidden(
        assigns.countdown,
        assigns.collapse_leading_zeros,
        segments,
        time_values
      )

    id = assigns.id
    dir = assigns.dir
    orientation = assigns.orientation
    running = assigns.auto_start

    assigns =
      assigns
      |> assign(:time_values, time_values)
      |> assign(:running, running)
      |> assign(:paused, false)
      |> assign(:segments, segments)
      |> assign(
        :has_timer_controls?,
        assigns.start_trigger != [] or assigns.pause_trigger != [] or assigns.resume_trigger != [] or
          assigns.reset_trigger != []
      )
      |> assign(:visibility_hidden, visibility_hidden)
      |> assign(:props_struct, props_struct(assigns, segments))
      |> assign(:root_struct, %Root{id: id, dir: dir, orientation: orientation})
      |> assign(:area_struct, %Area{id: id, dir: dir, orientation: orientation})
      |> assign(:control_struct, %Control{id: id, dir: dir, orientation: orientation})
      |> assign(
        :start_trigger_struct,
        %ActionTrigger{
          id: id,
          action: "start",
          hidden: running,
          dir: dir,
          orientation: orientation
        }
      )
      |> assign(
        :pause_trigger_struct,
        %ActionTrigger{
          id: id,
          action: "pause",
          hidden: not running,
          dir: dir,
          orientation: orientation
        }
      )
      |> assign(
        :resume_trigger_struct,
        %ActionTrigger{
          id: id,
          action: "resume",
          hidden: true,
          dir: dir,
          orientation: orientation
        }
      )
      |> assign(
        :reset_trigger_struct,
        %ActionTrigger{
          id: id,
          action: "reset",
          hidden: not running,
          dir: dir,
          orientation: orientation
        }
      )

    ~H"""
    <div
      id={@id}
      phx-hook="Timer"
      {@rest}
      {Connect.props(@props_struct)}
    >
      <div phx-mounted={Connect.ignore_root(@root_struct)} {Connect.root(@root_struct)}>
        <div phx-mounted={Connect.ignore_area(@area_struct)} {Connect.area(@area_struct)}>
          <%= for {part, i} <- Enum.with_index([:days, :hours, :minutes, :seconds]) do %>
            <% hv = Enum.at(@visibility_hidden, i) %>
            <% ls = label_slot(assigns, part) %>
            <% segment_struct = %Segment{id: @id, type: to_string(part), hidden: hv} %>
            <% item_struct = %Item{id: @id, type: to_string(part), value: Map.fetch!(@time_values, part), dir: @dir, orientation: @orientation, hidden: hv} %>
            <% item_label_struct = %ItemLabel{id: @id, type: to_string(part), dir: @dir, orientation: @orientation} %>
            <div
              phx-mounted={Connect.ignore_segment(segment_struct)}
              {Connect.segment(segment_struct)}
            >
              <div
                phx-mounted={Connect.ignore_item(item_struct)}
                {Connect.item(item_struct)}
              >
              </div>
              <%= if ls != [] do %>
                <span
                  phx-mounted={Connect.ignore_item_label(item_label_struct)}
                  {Connect.item_label(item_label_struct)}
                >
                  {render_slot(ls)}
                </span>
              <% end %>
            </div>
            <%= if i < 3 and @separator != [] do %>
              <% separator_struct = %Separator{id: "timer:#{@id}:sep:#{i}", dir: @dir, orientation: @orientation, hidden: hv} %>
              <div
                phx-mounted={Connect.ignore_separator(separator_struct)}
                {Connect.separator(separator_struct)}
              >
                {render_slot(@separator)}
              </div>
            <% end %>
          <% end %>
        </div>
        <div
          :if={@has_timer_controls?}
          phx-mounted={Connect.ignore_control(@control_struct)}
          {Connect.control(@control_struct)}
        >
          <button
            :if={@start_trigger != []}
            type="button"
            phx-mounted={Connect.ignore_action_trigger(@start_trigger_struct)}
            {Connect.action_trigger(@start_trigger_struct)}
          >
            {render_slot(@start_trigger)}
          </button>
          <button
            :if={@pause_trigger != []}
            type="button"
            phx-mounted={Connect.ignore_action_trigger(@pause_trigger_struct)}
            {Connect.action_trigger(@pause_trigger_struct)}
          >
            {render_slot(@pause_trigger)}
          </button>
          <button
            :if={@resume_trigger != []}
            type="button"
            phx-mounted={Connect.ignore_action_trigger(@resume_trigger_struct)}
            {Connect.action_trigger(@resume_trigger_struct)}
          >
            {render_slot(@resume_trigger)}
          </button>
          <button
            :if={@reset_trigger != []}
            type="button"
            phx-mounted={Connect.ignore_action_trigger(@reset_trigger_struct)}
            {Connect.action_trigger(@reset_trigger_struct)}
          >
            {render_slot(@reset_trigger)}
          </button>
        </div>
      </div>
    </div>
    """
  end

  defp label_slot(assigns, :days), do: assigns.day_label
  defp label_slot(assigns, :hours), do: assigns.hour_label
  defp label_slot(assigns, :minutes), do: assigns.minute_label
  defp label_slot(assigns, :seconds), do: assigns.second_label

  defp props_struct(assigns, segments) do
    %Props{
      id: assigns.id,
      countdown: assigns.countdown,
      start_ms: assigns.start_ms,
      target_ms: assigns.target_ms,
      auto_start: assigns.auto_start,
      interval: assigns.interval,
      on_tick: assigns.on_tick,
      on_tick_client: assigns.on_tick_client,
      on_complete: assigns.on_complete,
      on_complete_client: assigns.on_complete_client,
      dir: assigns.dir,
      orientation: assigns.orientation,
      collapse_leading_zeros: assigns.collapse_leading_zeros,
      segments: segments,
      translation: assigns.translation
    }
  end

  defp normalize_segments(nil), do: nil

  defp normalize_segments([]) do
    raise ArgumentError, "Corex.Timer: segments must not be empty when provided"
  end

  defp normalize_segments(list) when is_list(list) do
    allowed = MapSet.new(@parts)

    unless MapSet.subset?(MapSet.new(list), allowed) do
      raise ArgumentError, "Corex.Timer: segments must be a subset of #{inspect(@parts)}"
    end

    idx = fn atom -> Enum.find_index(@parts, &(&1 == atom)) end

    indexes =
      list
      |> Enum.map(fn a ->
        case idx.(a) do
          nil -> raise ArgumentError, "Corex.Timer: invalid segment #{inspect(a)}"
          i -> i
        end
      end)

    unless indexes == Enum.sort(indexes) do
      raise ArgumentError, "Corex.Timer: segments must follow order #{inspect(@parts)}"
    end

    list
  end

  defp visibility_hidden(_countdown, _collapse_opt, segments, _time_values)
       when is_list(segments) do
    Enum.map(@parts, fn atom -> atom not in segments end)
  end

  defp visibility_hidden(countdown, collapse_opt, nil, time_values) do
    vals = Enum.map(@parts, &Map.fetch!(time_values, &1))

    cond do
      collapse_opt == false ->
        [false, false, false, false]

      collapse_opt == true ->
        start_i = collapse_start_index(vals)
        Enum.map(0..3, fn i -> i < start_i end)

      countdown ->
        start_i = collapse_start_index(vals)
        Enum.map(0..3, fn i -> i < start_i end)

      true ->
        [false, false, false, false]
    end
  end

  defp collapse_start_index(vals) do
    collapse_start_index(vals, 0)
  end

  defp collapse_start_index(_vals, idx) when idx > 2 do
    idx
  end

  defp collapse_start_index(vals, idx) do
    rest_after = length(vals) - idx

    if idx < 3 && Enum.at(vals, idx) == 0 && rest_after > 2 do
      collapse_start_index(vals, idx + 1)
    else
      idx
    end
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
          <div {Connect.segment(%Segment{id: @id, type: "days", hidden: false})}>
            <div {Connect.item(%Item{id: @id, type: "days", value: 0, dir: "ltr", orientation: "horizontal", hidden: false})}></div>
          </div>
          <div {Connect.separator(%Separator{id: "timer:#{@id}:sep:0", dir: "ltr", orientation: "horizontal"})}>:</div>
          <div {Connect.segment(%Segment{id: @id, type: "hours", hidden: false})}>
            <div {Connect.item(%Item{id: @id, type: "hours", value: 0, dir: "ltr", orientation: "horizontal", hidden: false})}></div>
          </div>
          <div {Connect.separator(%Separator{id: "timer:#{@id}:sep:1", dir: "ltr", orientation: "horizontal"})}>:</div>
          <div {Connect.segment(%Segment{id: @id, type: "minutes", hidden: false})}>
            <div {Connect.item(%Item{id: @id, type: "minutes", value: 0, dir: "ltr", orientation: "horizontal", hidden: false})}></div>
          </div>
          <div {Connect.separator(%Separator{id: "timer:#{@id}:sep:2", dir: "ltr", orientation: "horizontal"})}>:</div>
          <div {Connect.segment(%Segment{id: @id, type: "seconds", hidden: false})}>
            <div {Connect.item(%Item{id: @id, type: "seconds", value: 0, dir: "ltr", orientation: "horizontal", hidden: false})}></div>
          </div>
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
