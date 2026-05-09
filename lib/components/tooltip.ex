defmodule Corex.Tooltip do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Tooltip](https://zagjs.com/components/react/tooltip).

  ## Examples

  ### Basic

  ```heex
  <.tooltip id="my-tooltip">
    <:trigger>Hover me</:trigger>
    <:content>Tooltip content</:content>
  </.tooltip>
  ```

  ### Multiple triggers (Zag)

  One tooltip content, several triggers. Each `value` must be a stable non-empty string and unique within the component.

  ```heex
  <.tooltip id="shared-tip" show_arrow={false}>
    <:trigger value="a">First anchor</:trigger>
    <:trigger value="b">Second anchor</:trigger>
    <:content>Same panel for both triggers</:content>
  </.tooltip>
  ```

  For **multi-trigger** tooltips whose `<:content>` should follow the active trigger in **LiveView**, set **`on_trigger_value_change`** to a `handle_event/3` name and update assigns used inside `<:content>` (see the e2e **Tooltip · Pattern** page).

  ### Without arrow

  ```heex
  <.tooltip id="my-tooltip" show_arrow={false}>
    <:trigger>Hover me</:trigger>
    <:content>No arrow</:content>
  </.tooltip>
  ```

  ## API Control

  Use an id on the component for API control.

  **Client-side**

  ```heex
  <button phx-click={Corex.Tooltip.set_open("my-tooltip", true)}>
    Open tooltip
  </button>
  ```

  **Server-side**

  ```elixir
  def handle_event("open_tooltip", _, socket) do
    {:noreply, Corex.Tooltip.set_open(socket, "my-tooltip", true)}
  end
  ```

  ## Styling

  Target parts with `data-scope="tooltip"` and `data-part`:

  ```css
  [data-scope="tooltip"][data-part="trigger"] {}
  [data-scope="tooltip"][data-part="positioner"] {}
  [data-scope="tooltip"][data-part="content"] {}
  [data-scope="tooltip"][data-part="arrow"] {}
  ```

  Trigger and content have `data-state="open"` or `data-state="closed"`.

  On the root element, optional modifier classes:

  - `tooltip--{semantic}` — surface and ink (for example `tooltip--accent`, `tooltip--brand`)
  - `tooltip--size-{sm|md|lg|xl}` — max width, padding, and arrow scale
  - `tooltip--text-{scale}` — content font size only (for example `tooltip--text-sm`, `tooltip--text-xl`)
  '''

  @doc type: :component
  use Phoenix.Component

  alias Corex.Positioning
  alias Corex.Tooltip.Anatomy.{Arrow, ArrowTip, Content, Positioner, Props, Trigger}
  alias Corex.Tooltip.Connect
  alias Phoenix.LiveView
  alias Phoenix.LiveView.JS

  attr(:id, :string,
    required: false,
    doc: "The id of the tooltip, useful for API to identify the tooltip"
  )

  attr(:disabled, :boolean, default: false, doc: "Whether the tooltip is disabled")

  attr(:dir, :string,
    default: nil,
    values: [nil, "ltr", "rtl"],
    doc: "The direction of the tooltip. When nil, derived from document"
  )

  attr(:orientation, :string,
    default: "horizontal",
    values: ["horizontal", "vertical"],
    doc: "Layout orientation for CSS."
  )

  attr(:open_delay, :integer,
    default: 0,
    doc: "Delay in ms before opening. Default from Zag is 400"
  )

  attr(:close_delay, :integer,
    default: 0,
    doc: "Delay in ms before closing. Default from Zag is 150"
  )

  attr(:positioning, Positioning,
    default: %Positioning{},
    doc: "Positioning options for the floating content"
  )

  attr(:close_on_escape, :boolean,
    default: true,
    doc: "Whether to close on Escape. Default true"
  )

  attr(:close_on_click, :boolean,
    default: true,
    doc: "Whether to close on click. Default true"
  )

  attr(:close_on_pointer_down, :boolean,
    default: false,
    doc: "Whether to close on pointer down on the trigger. Default false"
  )

  attr(:close_on_scroll, :boolean,
    default: false,
    doc: "Whether to close on scroll. Default false"
  )

  attr(:interactive, :boolean,
    default: true,
    doc: "Whether the tooltip content is interactive (stays open when hovering content)"
  )

  attr(:on_open_change, :string,
    default: nil,
    doc: "The server event name when the open state changes"
  )

  attr(:on_open_change_client, :string,
    default: nil,
    doc: "The client event name when the open state changes"
  )

  attr(:on_trigger_value_change, :string,
    default: nil,
    doc:
      "LiveView event when the active trigger value changes (multi-trigger). Params include id (tooltip root) and value (trigger value string)."
  )

  attr(:show_arrow, :boolean,
    default: true,
    doc: "Whether to show an arrow pointing to the trigger"
  )

  attr(:trigger_tag, :atom,
    default: :button,
    values: [:button, :span],
    doc:
      "Use :span when the tooltip sits inside another button-like control (e.g. tree view row) to avoid nested <button> elements."
  )

  attr(:rest, :global)

  slot :trigger,
    required: true,
    doc:
      "Trigger element content. Use :let={tooltip} for assigns such as disabled. With more than one <:trigger>, each must set value=\"…\" (unique, stable across LiveView patches)." do
    attr(:class, :string, required: false)
    attr(:value, :string, required: false)
  end

  slot :content,
    required: true,
    doc: "Tooltip content. Use :let={tooltip} for assigns such as disabled." do
    attr(:class, :string, required: false)
  end

  def tooltip(assigns) do
    assigns = assign_new(assigns, :id, fn -> "tooltip-#{System.unique_integer([:positive])}" end)
    validate_triggers!(assigns.trigger)

    assigns =
      assigns
      |> assign(:slot_assigns, %{disabled: assigns.disabled})

    ~H"""
    <div
      id={@id}
      phx-hook="Tooltip"
      data-loading  
      phx-mounted={Phoenix.LiveView.JS.ignore_attributes(["data-loading"])}    
      {@rest}
      {Connect.props(%Props{
        id: @id,
        positioning: @positioning,
        disabled: @disabled,
        dir: @dir,
        orientation: @orientation,
        open_delay: @open_delay,
        close_delay: @close_delay,
        close_on_escape: @close_on_escape,
        close_on_click: @close_on_click,
        close_on_pointer_down: @close_on_pointer_down,
        close_on_scroll: @close_on_scroll,
        interactive: @interactive,
        on_open_change: @on_open_change,
        on_open_change_client: @on_open_change_client,
        on_trigger_value_change: @on_trigger_value_change
      })}
    >
      <%= for t <- @trigger do %>
        <%= if @trigger_tag == :span do %>
          <span
            class={Map.get(t, :class, nil)}
            phx-mounted={
              Connect.ignore_trigger(%Trigger{
                id: @id,
                dir: @dir,
                open: false,
                disabled: @disabled,
                orientation: @orientation,
                tag: @trigger_tag,
                value: Map.get(t, :value)
              })
            }
            {Connect.trigger(%Trigger{
              id: @id,
              dir: @dir,
              open: false,
              disabled: @disabled,
              orientation: @orientation,
              tag: @trigger_tag,
              value: Map.get(t, :value)
            })}
          >
            {render_slot(t, @slot_assigns)}
          </span>
        <% else %>
          <button
            class={Map.get(t, :class, nil)}
            phx-mounted={
              Connect.ignore_trigger(%Trigger{
                id: @id,
                dir: @dir,
                open: false,
                disabled: @disabled,
                orientation: @orientation,
                tag: @trigger_tag,
                value: Map.get(t, :value)
              })
            }
            {Connect.trigger(%Trigger{
              id: @id,
              dir: @dir,
              open: false,
              disabled: @disabled,
              orientation: @orientation,
              tag: @trigger_tag,
              value: Map.get(t, :value)
            })}
          >
            {render_slot(t, @slot_assigns)}
          </button>
        <% end %>
      <% end %>
      <div phx-mounted={Connect.ignore_positioner(%Positioner{id: @id, dir: @dir, orientation: @orientation})} {Connect.positioner(%Positioner{id: @id, dir: @dir, orientation: @orientation})}>
        <div
          :if={@show_arrow}
          phx-mounted={Connect.ignore_arrow(%Arrow{id: @id, dir: @dir, orientation: @orientation})}
          {Connect.arrow(%Arrow{id: @id, dir: @dir, orientation: @orientation})}
        >
          <div phx-mounted={Connect.ignore_arrow_tip(%ArrowTip{id: @id, dir: @dir, orientation: @orientation})} {Connect.arrow_tip(%ArrowTip{id: @id, dir: @dir, orientation: @orientation})}>
          </div>
        </div>
        <div
          class={Map.get(Enum.at(@content, 0), :class, nil)}
          phx-mounted={Connect.ignore_content(%Content{id: @id, dir: @dir, open: false, orientation: @orientation})}
          {Connect.content(%Content{id: @id, dir: @dir, open: false, orientation: @orientation})}
        >
          {render_slot(Enum.at(@content, 0), @slot_assigns)}
        </div>
      </div>
    </div>
    """
  end

  @doc type: :api
  def set_open(tooltip_id, open) when is_binary(tooltip_id) and is_boolean(open) do
    JS.dispatch("corex:tooltip:set-open",
      to: "##{tooltip_id}",
      detail: %{open: open},
      bubbles: false
    )
  end

  @doc type: :api
  def set_open(socket, tooltip_id, open)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(tooltip_id) and
             is_boolean(open) do
    LiveView.push_event(socket, "tooltip_set_open", %{
      tooltip_id: tooltip_id,
      open: open
    })
  end

  defp validate_triggers!(triggers) when is_list(triggers) do
    case triggers do
      [] ->
        :ok

      [_] ->
        :ok

      many ->
        values = Enum.map(many, &Map.get(&1, :value))

        if Enum.any?(values, &(is_nil(&1) or &1 == "")) do
          raise ArgumentError,
                "Corex.Tooltip: each <:trigger> must include a non-empty value attribute when there are multiple triggers"
        end

        if length(Enum.uniq(values)) != length(values) do
          raise ArgumentError, "Corex.Tooltip: trigger value attributes must be unique"
        end
    end
  end
end
