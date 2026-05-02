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

  ### Without arrow

  ```heex
  <.tooltip id="my-tooltip" show_arrow={false}>
    <:trigger>Hover me</:trigger>
    <:content>No arrow</:content>
  </.tooltip>
  ```

  ### Controlled

  ```heex
  <.tooltip
    id="my-tooltip"
    controlled
    open={@tooltip_open}
    on_open_change="tooltip_changed">
    <:trigger>Hover me</:trigger>
    <:content>Tooltip content</:content>
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
  '''

  @doc type: :component
  use Phoenix.Component

  alias Corex.Tooltip.Anatomy.{Arrow, ArrowTip, Content, Positioner, Props, Trigger}
  alias Corex.Tooltip.Connect
  alias Phoenix.LiveView
  alias Phoenix.LiveView.JS

  attr(:id, :string,
    required: false,
    doc: "The id of the tooltip, useful for API to identify the tooltip"
  )

  attr(:open, :boolean,
    default: false,
    doc: "The initial open state or the controlled open state"
  )

  attr(:controlled, :boolean,
    default: false,
    doc: "Whether the tooltip is controlled. In LiveView, on_open_change is required when true"
  )

  attr(:disabled, :boolean, default: false, doc: "Whether the tooltip is disabled")

  attr(:dir, :string,
    default: "ltr",
    values: ["ltr", "rtl"],
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

  attr(:placement, :string,
    default: "bottom",
    doc: "Placement of the tooltip (e.g. bottom, top-start). Uses floating-ui"
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
    doc: "Whether to close on pointer down. Default true"
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
    doc: "Trigger element content. Use :let={tooltip} for open state." do
    attr(:class, :string, required: false)
  end

  slot :content, required: true, doc: "Tooltip content. Use :let={tooltip} for open state." do
    attr(:class, :string, required: false)
  end

  def tooltip(assigns) do
    assigns = assign_new(assigns, :id, fn -> "tooltip-#{System.unique_integer([:positive])}" end)
    id = assigns.id

    assigns =
      assigns
      |> assign(:slot_assigns, %{open: assigns.open, disabled: assigns.disabled})
      |> assign(:tooltip_trigger, %Trigger{
        id: id,
        dir: assigns.dir,
        open: assigns.open,
        disabled: assigns.disabled,
        orientation: assigns.orientation,
        tag: assigns.trigger_tag
      })

    ~H"""
    <div
      id={@id}
      phx-hook="Tooltip"
      data-loading  
      phx-mounted={Phoenix.LiveView.JS.ignore_attributes(["data-loading"])}    
      {@rest}
      {Connect.props(%Props{
        id: @id,
        controlled: @controlled,
        open: @open,
        disabled: @disabled,
        dir: @dir,
        orientation: @orientation,
        open_delay: @open_delay,
        close_delay: @close_delay,
        placement: @placement,
        close_on_escape: @close_on_escape,
        close_on_click: @close_on_click,
        close_on_pointer_down: @close_on_pointer_down,
        close_on_scroll: @close_on_scroll,
        interactive: @interactive,
        on_open_change: @on_open_change,
        on_open_change_client: @on_open_change_client
      })}
    >
      <%= if @trigger_tag == :span do %>
        <span
          class={Map.get(Enum.at(@trigger, 0), :class, nil)}
          phx-mounted={Connect.ignore_trigger(@tooltip_trigger)}
          {Connect.trigger(@tooltip_trigger)}
        >
          {render_slot(Enum.at(@trigger, 0), @slot_assigns)}
        </span>
      <% else %>
        <button
          class={Map.get(Enum.at(@trigger, 0), :class, nil)}
          phx-mounted={Connect.ignore_trigger(@tooltip_trigger)}
          {Connect.trigger(@tooltip_trigger)}
        >
          {render_slot(Enum.at(@trigger, 0), @slot_assigns)}
        </button>
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
          phx-mounted={Connect.ignore_content(%Content{id: @id, dir: @dir, open: @open, orientation: @orientation})}
          {Connect.content(%Content{id: @id, dir: @dir, open: @open, orientation: @orientation})}
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
end
