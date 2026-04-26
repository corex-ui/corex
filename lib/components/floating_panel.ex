defmodule Corex.FloatingPanel do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Floating Panel](https://zagjs.com/components/react/floating-panel).

  ## Examples

  ### Basic

  ```heex
  <.floating_panel id="my-floating-panel" class="floating-panel">
    <:open_trigger>Close panel</:open_trigger>
    <:closed_trigger>Open panel</:closed_trigger>
    <:minimize_trigger>
      <.heroicon name="hero-arrow-down-left" class="icon" />
    </:minimize_trigger>
    <:maximize_trigger>
      <.heroicon name="hero-arrows-pointing-out" class="icon" />
    </:maximize_trigger>
    <:default_trigger>
      <.heroicon name="hero-rectangle-stack" class="icon" />
    </:default_trigger>
    <:close_trigger>
      <.heroicon name="hero-x-mark" class="icon" />
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
  alias Phoenix.LiveView
  alias Phoenix.LiveView.JS

  @resize_axes ~w(n e w s ne se sw nw)
  @stages ~w(minimized maximized default)

  attr(:id, :string, required: false, doc: "The id of the floating panel")
  attr(:draggable, :boolean, default: true, doc: "Whether the panel can be dragged")
  attr(:resizable, :boolean, default: true, doc: "Whether the panel can be resized")
  attr(:allow_overflow, :boolean, default: true, doc: "Whether content can overflow")
  attr(:close_on_escape, :boolean, default: true, doc: "Whether Escape closes the panel")
  attr(:disabled, :boolean, default: false, doc: "Whether the panel is disabled")
  attr(:dir, :string, default: nil, values: [nil, "ltr", "rtl"], doc: "Text direction")

  attr(:orientation, :string,
    default: "vertical",
    values: ["horizontal", "vertical"],
    doc: "Layout orientation for CSS and ignored attribute lists."
  )

  attr(:size, :map, default: nil, doc: "Current size in Zag’s internal state")
  attr(:default_size, :map, default: nil, doc: "Initial size before user resize")
  attr(:position, :map, default: nil, doc: "Current position in Zag’s internal state")
  attr(:default_position, :map, default: nil, doc: "Initial position before user drag")
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
      |> assign_new(:translation, fn -> default_translation end)
      |> assign(:translation, merge_translation(assigns.translation, default_translation))
      |> assign(:resize_axes, @resize_axes)
      |> assign(:stages, @stages)

    ~H"""
    <div
      id={@id}
      phx-hook="FloatingPanel"
      data-loading
      phx-mounted={Phoenix.LiveView.JS.ignore_attributes(["data-loading"])}
      {@rest}
      {Connect.props(%Props{
        id: @id,
        draggable: @draggable,
        resizable: @resizable,
        allow_overflow: @allow_overflow,
        close_on_escape: @close_on_escape,
        disabled: @disabled,
        dir: @dir,
        orientation: @orientation,
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
      <div phx-mounted={Connect.ignore_root(%Root{id: @id, dir: @dir, orientation: @orientation})} {Connect.root(%Root{id: @id, dir: @dir, orientation: @orientation})}>
        <button type="button" phx-mounted={Connect.ignore_trigger(%Trigger{id: @id, dir: @dir, orientation: @orientation})} {Connect.trigger(%Trigger{id: @id, dir: @dir, orientation: @orientation})}>
          <span data-open>{render_slot(@open_trigger)}</span>
          <span data-closed>{render_slot(@closed_trigger)}</span>
        </button>
        <div phx-mounted={Connect.ignore_positioner(%Positioner{id: @id, dir: @dir, orientation: @orientation})} {Connect.positioner(%Positioner{id: @id, dir: @dir, orientation: @orientation})}>
          <div phx-mounted={Connect.ignore_content(%Content{id: @id, dir: @dir, orientation: @orientation})} {Connect.content(%Content{id: @id, dir: @dir, orientation: @orientation})}>
            <div phx-mounted={Connect.ignore_drag_trigger(%DragTrigger{id: @id, dir: @dir, orientation: @orientation})} {Connect.drag_trigger(%DragTrigger{id: @id, dir: @dir, orientation: @orientation})}>
              <div phx-mounted={Connect.ignore_header(%Header{id: @id, dir: @dir, orientation: @orientation})} {Connect.header(%Header{id: @id, dir: @dir, orientation: @orientation})}>
                <div phx-mounted={Connect.ignore_title(%Title{id: @id, dir: @dir, orientation: @orientation})} {Connect.title(%Title{id: @id, dir: @dir, orientation: @orientation})}>Panel</div>
                <div phx-mounted={Connect.ignore_control(%Control{id: @id, dir: @dir, orientation: @orientation})} {Connect.control(%Control{id: @id, dir: @dir, orientation: @orientation})}>
                  <button type="button" phx-mounted={Connect.ignore_stage_trigger(%StageTrigger{id: @id, stage: "minimized", dir: @dir, orientation: @orientation})} {Connect.stage_trigger(%StageTrigger{id: @id, stage: "minimized", dir: @dir, orientation: @orientation})} aria-label={@translation.minimize}>
                    {render_slot(@minimize_trigger)}
                  </button>
                  <button type="button" phx-mounted={Connect.ignore_stage_trigger(%StageTrigger{id: @id, stage: "maximized", dir: @dir, orientation: @orientation})} {Connect.stage_trigger(%StageTrigger{id: @id, stage: "maximized", dir: @dir, orientation: @orientation})} aria-label={@translation.maximize}>
                    {render_slot(@maximize_trigger)}
                  </button>
                  <button type="button" phx-mounted={Connect.ignore_stage_trigger(%StageTrigger{id: @id, stage: "default", dir: @dir, orientation: @orientation})} {Connect.stage_trigger(%StageTrigger{id: @id, stage: "default", dir: @dir, orientation: @orientation})} aria-label={@translation.restore}>
                    {render_slot(@default_trigger)}
                  </button>
                  <button type="button" phx-mounted={Connect.ignore_close_trigger(%CloseTrigger{id: @id, dir: @dir, orientation: @orientation})} {Connect.close_trigger(%CloseTrigger{id: @id, dir: @dir, orientation: @orientation})} aria-label={@translation.close}>
                    {render_slot(@close_trigger)}
                  </button>
                </div>
              </div>
            </div>
            <div phx-mounted={Connect.ignore_body(%Body{id: @id, dir: @dir, orientation: @orientation})} {Connect.body(%Body{id: @id, dir: @dir, orientation: @orientation})}>
              {render_slot(@content)}
            </div>
            <div
              :for={axis <- @resize_axes}
              phx-mounted={Connect.ignore_resize_trigger(%ResizeTrigger{id: @id, axis: axis, dir: @dir, orientation: @orientation})}
              {Connect.resize_trigger(%ResizeTrigger{id: @id, axis: axis, dir: @dir, orientation: @orientation})}
            />
          </div>
        </div>
      </div>
    </div>
    """
  end

  @doc type: :api
  @doc """
  Sets the panel open state from the browser. Returns a `Phoenix.LiveView.JS` command.

  ## Examples

      <.action phx-click={Corex.FloatingPanel.set_open("my-floating-panel", true)}>Open</.action>
  """
  def set_open(floating_panel_id, open)
      when is_binary(floating_panel_id) and is_boolean(open) do
    JS.dispatch("corex:floating-panel:set-open",
      to: "##{floating_panel_id}",
      detail: %{open: open},
      bubbles: false
    )
  end

  @doc type: :api
  @doc """
  Sets the panel open state from the server. Pushes a LiveView hook event.

  ## Examples

      def handle_event("open_panel", _, socket) do
        {:noreply, Corex.FloatingPanel.set_open(socket, "my-floating-panel", true)}
      end
  """
  def set_open(socket, floating_panel_id, open)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(floating_panel_id) and
             is_boolean(open) do
    LiveView.push_event(socket, "floating_panel_set_open", %{
      floating_panel_id: floating_panel_id,
      open: open
    })
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
