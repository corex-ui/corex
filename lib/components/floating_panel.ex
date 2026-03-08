defmodule Corex.FloatingPanel do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Floating Panel](https://zagjs.com/components/react/floating-panel).

  ## Examples

  ### Basic

  ```heex
  <.floating_panel id="my-floating-panel" default_open={false} class="floating-panel">
    <:open_trigger>Close panel</:open_trigger>
    <:closed_trigger>Open panel</:closed_trigger>
    <:minimize_trigger>
      <.icon name="hero-arrow-down-left" class="icon" />
    </:minimize_trigger>
    <:maximize_trigger>
      <.icon name="hero-arrows-pointing-out" class="icon" />
    </:maximize_trigger>
    <:default_trigger>
      <.icon name="hero-rectangle-stack" class="icon" />
    </:default_trigger>
    <:close_trigger>
      <.icon name="hero-x-mark" class="icon" />
    </:close_trigger>
    <:content>
      <p>
        Congue molestie ipsum gravida a. Sed ac eros luctus, cursus turpis
        non, pellentesque elit. Pellentesque sagittis fermentum.
      </p>
    </:content>
  </.floating_panel>
  ```

  Required slots: `:open_trigger`, `:closed_trigger`, `:minimize_trigger`, `:maximize_trigger`, `:default_trigger`, `:close_trigger`, `:content`.

  ## Styling

  Use data attributes to target elements:

  ```css
  [data-scope="floating-panel"][data-part="root"] {}
  [data-scope="floating-panel"][data-part="trigger"] {}
  [data-scope="floating-panel"][data-part="positioner"] {}
  [data-scope="floating-panel"][data-part="content"] {}
  [data-scope="floating-panel"][data-part="title"] {}
  [data-scope="floating-panel"][data-part="header"] {}
  [data-scope="floating-panel"][data-part="body"] {}
  [data-scope="floating-panel"][data-part="drag-trigger"] {}
  [data-scope="floating-panel"][data-part="resize-trigger"] {}
  [data-scope="floating-panel"][data-part="close-trigger"] {}
  [data-scope="floating-panel"][data-part="control"] {}
  [data-scope="floating-panel"][data-part="stage-trigger"] {}
  ```

  If you wish to use the default Corex styling, you can use the class `floating-panel` on the component.
  This requires to install `Mix.Tasks.Corex.Design` first and import the component css file.

  ```css
  @import "../corex/main.css";
  @import "../corex/tokens/themes/neo/light.css";
  @import "../corex/components/floating-panel.css";
  ```

  You can then use modifiers

  ```heex
  <.floating_panel class="floating-panel floating-panel--accent floating-panel--lg">
  </.floating_panel>
  ```

  Learn more about modifiers and [Corex Design](https://corex-ui.com/components/floating-panel#modifiers)
  '''

  defmodule Translation do
    @moduledoc """
    Translation struct for FloatingPanel component strings.

    Without gettext: `translation={%FloatingPanel.Translation{ close: "Close window" }}`

    With gettext: `translation={%FloatingPanel.Translation{ close: gettext("Close window") }}`
    """
    defstruct [:minimize, :maximize, :restore, :close]
  end

  @doc type: :component
  use Phoenix.Component

  import Corex.Gettext, only: [gettext: 1]

  alias Corex.FloatingPanel.Anatomy.{
    Body,
    CloseTrigger,
    Content,
    Control,
    DragTrigger,
    Header,
    Positioner,
    Props,
    ResizeTrigger,
    Root,
    StageTrigger,
    Title,
    Trigger
  }

  alias Corex.FloatingPanel.Connect

  @resize_axes ~w(n e w s ne se sw nw)
  @stages ~w(minimized maximized default)

  attr(:id, :string, required: false, doc: "The id of the floating panel")
  attr(:open, :boolean, default: nil, doc: "Controlled open state when controlled is true")
  attr(:default_open, :boolean, default: false, doc: "Initial open state when uncontrolled")
  attr(:controlled, :boolean, default: false, doc: "Whether open state is controlled externally")
  attr(:draggable, :boolean, default: true, doc: "Whether the panel can be dragged")
  attr(:resizable, :boolean, default: true, doc: "Whether the panel can be resized")
  attr(:allow_overflow, :boolean, default: true, doc: "Whether content can overflow")
  attr(:close_on_escape, :boolean, default: true, doc: "Whether Escape closes the panel")
  attr(:disabled, :boolean, default: false, doc: "Whether the panel is disabled")
  attr(:dir, :string, default: nil, values: [nil, "ltr", "rtl"], doc: "Text direction")
  attr(:size, :map, default: nil, doc: "Controlled size when controlled")
  attr(:default_size, :map, default: nil, doc: "Initial size when uncontrolled")
  attr(:position, :map, default: nil, doc: "Controlled position when controlled")
  attr(:default_position, :map, default: nil, doc: "Initial position when uncontrolled")
  attr(:min_size, :map, default: nil, doc: "Minimum size constraints")
  attr(:max_size, :map, default: nil, doc: "Maximum size constraints")
  attr(:persist_rect, :boolean, default: false, doc: "Whether to persist position and size")
  attr(:grid_size, :integer, default: 1, doc: "Grid snapping size for drag and resize")
  attr(:on_open_change, :string, default: nil, doc: "Server event when open state changes")
  attr(:on_open_change_client, :string, default: nil, doc: "Client event when open state changes")
  attr(:on_position_change, :string, default: nil, doc: "Server event when position changes")
  attr(:on_size_change, :string, default: nil, doc: "Server event when size changes")

  attr(:on_stage_change, :string,
    default: nil,
    doc: "Server event when stage (minimized/maximized) changes"
  )

  attr(:translation, Corex.FloatingPanel.Translation,
    default: nil,
    doc: "Override translatable strings"
  )

  attr(:rest, :global)

  slot :open_trigger, required: true do
    attr(:class, :string, required: false)
  end

  slot :closed_trigger, required: true do
    attr(:class, :string, required: false)
  end

  slot :minimize_trigger, required: true do
    attr(:class, :string, required: false)
  end

  slot :maximize_trigger, required: true do
    attr(:class, :string, required: false)
  end

  slot :default_trigger, required: true do
    attr(:class, :string, required: false)
  end

  slot :close_trigger, required: true do
    attr(:class, :string, required: false)
  end

  slot :content, required: true do
    attr(:class, :string, required: false)
  end

  def floating_panel(assigns) do
    initial_open = if assigns[:controlled], do: assigns[:open], else: assigns[:default_open]

    default_translation = %Translation{
      minimize: gettext("Minimize window"),
      maximize: gettext("Maximize window"),
      restore: gettext("Restore window"),
      close: gettext("Close window")
    }

    assigns =
      assigns
      |> assign_new(:id, fn -> "floating-panel-#{System.unique_integer([:positive])}" end)
      |> assign_new(:dir, fn -> "ltr" end)
      |> assign_new(:open, fn -> false end)
      |> assign_new(:translation, fn -> default_translation end)
      |> assign(:translation, merge_translation(assigns.translation, default_translation))
      |> assign(:initial_open, initial_open)
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
        <button type="button" {Connect.trigger(%Trigger{id: @id, initial_open: @initial_open})}>
          <span data-open>{render_slot(@open_trigger)}</span>
          <span data-closed>{render_slot(@closed_trigger)}</span>
        </button>
        <div {Connect.positioner(%Positioner{id: @id})}>
          <div {Connect.content(%Content{id: @id, initial_open: @initial_open})}>
            <div {Connect.drag_trigger(%DragTrigger{id: @id})}>
              <div {Connect.header(%Header{id: @id})}>
                <div {Connect.title(%Title{id: @id})}>Panel</div>
                <div {Connect.control(%Control{id: @id})}>
                  <button type="button" {Connect.stage_trigger(%StageTrigger{id: @id, stage: "minimized"})} aria-label={@translation.minimize}>
                    {render_slot(@minimize_trigger)}
                  </button>
                  <button type="button" {Connect.stage_trigger(%StageTrigger{id: @id, stage: "maximized"})} aria-label={@translation.maximize}>
                    {render_slot(@maximize_trigger)}
                  </button>
                  <button type="button" {Connect.stage_trigger(%StageTrigger{id: @id, stage: "default"})} aria-label={@translation.restore}>
                    {render_slot(@default_trigger)}
                  </button>
                  <button type="button" {Connect.close_trigger(%CloseTrigger{id: @id})} aria-label={@translation.close}>
                    {render_slot(@close_trigger)}
                  </button>
                </div>
              </div>
            </div>
            <div {Connect.body(%Body{id: @id})}>
              {render_slot(@content)}
            </div>
            <div :for={axis <- @resize_axes} {Connect.resize_trigger(%ResizeTrigger{id: @id, axis: axis})} />
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp merge_translation(nil, default), do: default

  defp merge_translation(partial, default) do
    %Translation{
      minimize: partial.minimize || default.minimize,
      maximize: partial.maximize || default.maximize,
      restore: partial.restore || default.restore,
      close: partial.close || default.close
    }
  end
end
