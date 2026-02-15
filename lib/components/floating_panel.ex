defmodule Corex.FloatingPanel do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Floating Panel](https://zagjs.com/components/react/floating-panel).

  ## Examples

  ### Basic

  ```heex
  <.floating_panel id="fp" default_open={false} class="floating-panel">
    <:trigger>Open panel</:trigger>
    <:content>Panel content</:content>
  </.floating_panel>
  ```

  With different label when open vs closed:

  ```heex
  <.floating_panel id="fp" default_open={false} class="floating-panel">
    <:open_trigger>Close panel</:open_trigger>
    <:closed_trigger>Open panel</:closed_trigger>
    <:content>Panel content</:content>
  </.floating_panel>
  ```

  Optional header control slots: `:minimize_trigger`, `:maximize_trigger`, `:default_trigger`, `:close_trigger` (icons or text).

  ## Styling

  Use data attributes: `[data-scope="floating-panel"][data-part="root"]`, `trigger`, `positioner`, `content`, `title`, `header`, `body`, `drag-trigger`, `resize-trigger`, `close-trigger`, `control`, `stage-trigger`.
  '''

  @doc type: :component
  use Phoenix.Component

  alias Corex.FloatingPanel.Anatomy.{Props, Root, Trigger, Positioner, Content, Title, Header, Body, DragTrigger, ResizeTrigger, CloseTrigger, Control, StageTrigger}
  alias Corex.FloatingPanel.Connect

  @resize_axes ~w(n e w s ne se sw nw)
  @stages ~w(minimized maximized default)

  attr(:id, :string, required: false)
  attr(:open, :boolean, default: nil)
  attr(:default_open, :boolean, default: false)
  attr(:controlled, :boolean, default: false)
  attr(:draggable, :boolean, default: true)
  attr(:resizable, :boolean, default: true)
  attr(:allow_overflow, :boolean, default: true)
  attr(:close_on_escape, :boolean, default: true)
  attr(:disabled, :boolean, default: false)
  attr(:dir, :string, default: nil, values: [nil, "ltr", "rtl"])
  attr(:size, :map, default: nil)
  attr(:default_size, :map, default: nil)
  attr(:position, :map, default: nil)
  attr(:default_position, :map, default: nil)
  attr(:min_size, :map, default: nil)
  attr(:max_size, :map, default: nil)
  attr(:persist_rect, :boolean, default: false)
  attr(:grid_size, :integer, default: 1)
  attr(:on_open_change, :string, default: nil)
  attr(:on_open_change_client, :string, default: nil)
  attr(:on_position_change, :string, default: nil)
  attr(:on_size_change, :string, default: nil)
  attr(:on_stage_change, :string, default: nil)
  attr(:rest, :global)

  slot(:trigger, required: false)
  slot(:open_trigger, required: false)
  slot(:closed_trigger, required: false)
  slot(:minimize_trigger, required: false)
  slot(:maximize_trigger, required: false)
  slot(:default_trigger, required: false)
  slot(:close_trigger, required: false)
  slot(:content, required: true)

  def floating_panel(assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> "floating-panel-#{System.unique_integer([:positive])}" end)
      |> assign_new(:dir, fn -> "ltr" end)
      |> assign_new(:open, fn -> false end)
      |> assign(:resize_axes, @resize_axes)
      |> assign(:stages, @stages)

    ~H"""
    <div
      id={@id}
      phx-hook="FloatingPanel"
      {@rest}
      {Connect.props(%Props{
        id: @id,
        open: @open,
        default_open: @default_open,
        controlled: @controlled,
        draggable: @draggable,
        resizable: @resizable,
        allow_overflow: @allow_overflow,
        close_on_escape: @close_on_escape,
        disabled: @disabled,
        dir: @dir,
        size: @size,
        default_size: @default_size,
        position: @position,
        default_position: @default_position,
        min_size: @min_size,
        max_size: @max_size,
        persist_rect: @persist_rect,
        grid_size: @grid_size,
        on_open_change: @on_open_change,
        on_open_change_client: @on_open_change_client,
        on_position_change: @on_position_change,
        on_size_change: @on_size_change,
        on_stage_change: @on_stage_change
      })}
    >
      <div phx-update="ignore" {Connect.root(%Root{id: @id, dir: @dir})}>
        <button type="button" {Connect.trigger(%Trigger{id: @id})}>
          <%= if @open_trigger != [] and @closed_trigger != [] do %>
            <span data-open><%= render_slot(@open_trigger) %></span>
            <span data-closed><%= render_slot(@closed_trigger) %></span>
          <% else %>
            <%= if @trigger != [] do %>
              <%= render_slot(@trigger) %>
            <% else %>
              Open panel
            <% end %>
          <% end %>
        </button>
        <div {Connect.positioner(%Positioner{id: @id})}>
          <div {Connect.content(%Content{id: @id})}>
            <div {Connect.drag_trigger(%DragTrigger{id: @id})}>
              <div {Connect.header(%Header{id: @id})}>
                <div {Connect.title(%Title{id: @id})}>Panel</div>
                <div {Connect.control(%Control{id: @id})}>
                  <button type="button" {Connect.stage_trigger(%StageTrigger{id: @id, stage: "minimized"})} aria-label="Minimize window">
                    <%= if @minimize_trigger != [] do %>
                      <%= render_slot(@minimize_trigger) %>
                    <% else %>
                      −
                    <% end %>
                  </button>
                  <button type="button" {Connect.stage_trigger(%StageTrigger{id: @id, stage: "maximized"})} aria-label="Maximize window">
                    <%= if @maximize_trigger != [] do %>
                      <%= render_slot(@maximize_trigger) %>
                    <% else %>
                      ⊞
                    <% end %>
                  </button>
                  <button type="button" {Connect.stage_trigger(%StageTrigger{id: @id, stage: "default"})} aria-label="Restore window">
                    <%= if @default_trigger != [] do %>
                      <%= render_slot(@default_trigger) %>
                    <% else %>
                      ⊟
                    <% end %>
                  </button>
                  <button type="button" {Connect.close_trigger(%CloseTrigger{id: @id})} aria-label="Close window">
                    <%= if @close_trigger != [] do %>
                      <%= render_slot(@close_trigger) %>
                    <% else %>
                      ×
                    <% end %>
                  </button>
                </div>
              </div>
            </div>
            <div {Connect.body(%Body{id: @id})}>
              <%= render_slot(@content) %>
            </div>
            <div :for={axis <- @resize_axes} {Connect.resize_trigger(%ResizeTrigger{id: @id, axis: axis})} />
          </div>
        </div>
      </div>
    </div>
    """
  end
end
