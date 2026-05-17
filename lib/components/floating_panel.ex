defmodule Corex.FloatingPanel do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Floating Panel](https://zagjs.com/components/react/floating-panel).

  ## Anatomy

  ### Basic

  ```heex
  <.floating_panel id="my-floating-panel" class="floating-panel">
    <:trigger class="button button--ghost button--sm">
      <span data-closed>Open panel</span>
      <span data-open>Close panel</span>
    </:trigger>
    <:title>Panel</:title>
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

  Required slots: `:trigger`, `:title`, `:close_trigger`, `:content`.

  Set **`class`** on **`:trigger`** to style the outer trigger button (e.g. `button button--ghost button--sm`).

  Use **`data-open`** and **`data-closed`** on elements inside `:trigger` to swap label when the panel is open vs closed (see default rules in `floating-panel.css`). You can also target **`[data-part="trigger"][data-state="open"]`** / **`closed`** with your own selectors.

  Optional slots: `:minimize_trigger`, `:maximize_trigger`, `:default_trigger`. Omit them to hide the minimize, maximize, and restore controls.

  Set **`position={%Corex.Point{}}` or `position={%{x: n, y: n}}`** for a fixed initial Zag `Point` (**`data-default-position`** / **`defaultPosition`**). If **`position`** is set, it overrides anchor placement.

  Set **`size={%{width:, height:}}`** for initial dimensions (**`data-default-size`** / Zag **`defaultSize`**). Use **`value_size`** for a controlled current size (**`data-size`** / Zag **`size`**).

  Optional **`positioning={%Corex.Positioning{}}`** sets **`data-position-*`** for the client hook. When **`position`** is omitted, the hook passes Zag **`getAnchorPosition`** from placement and boundary (e.g. **`placement: "bottom-start"`** and **`gutter: 16`** for a bottom corner). Do not rely on both **`position`** and **`positioning`** for the same panel; prefer **`position`** for explicit pixels, **`positioning`** for placement rules.

  ## API

  Requires a stable `id` on `<.floating_panel>`.

  | Function | Action | Returns |
  | -------- | ------ | ------- |
  | [`set_open/2`](#set_open/2) | Set open state (client) | `%Phoenix.LiveView.JS{}` |
  | [`set_open/3`](#set_open/3) | Set open state (server) | `socket` |

  ## Events

  Pick an event name and pass it to `on_*` on `<.floating_panel>`.

  ### Server events

  | Event | When | Payload |
  | ----- | ---- | ------- |
  | `on_open_change="panel_open_changed"` | Open state changes | `%{"id" => id, "open" => boolean}` |
  | `on_position_change="panel_position_changed"` | Position changes | `%{"id" => id, ...}` |
  | `on_size_change="panel_size_changed"` | Size changes | `%{"id" => id, ...}` |
  | `on_stage_change="panel_stage_changed"` | Stage changes | `%{"id" => id, ...}` |

  ### Client events

  | Event | When | `event.detail` |
  | ----- | ---- | -------------- |
  | `on_open_change_client="panel-open-changed"` | Open state changes | `id`, `open` |

  ## Style

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
    <:trigger>
      <span data-closed>Closed</span>
      <span data-open>Open</span>
    </:trigger>
    <:title>Title</:title>
    <:close_trigger>Close</:close_trigger>
    <:content>Body</:content>
  </.floating_panel>
  ```

  '''

  defmodule Translation do
    @moduledoc """
    Translatable strings for the floating panel window controls.

    Pass `translation={%Corex.FloatingPanel.Translation{}}` to override any field. Omitted fields use gettext defaults from [`default/0`](#default/0).

    | Field | Default | Used for |
    | ----- | ------- | -------- |
    | `minimize` | Minimize window | Minimize trigger `aria-label` |
    | `maximize` | Maximize window | Maximize trigger `aria-label` |
    | `restore` | Restore window | Restore trigger `aria-label` |
    | `close` | Close window | Close trigger `aria-label` |
    """

    alias Corex.Gettext

    defstruct [:minimize, :maximize, :restore, :close]

    @type t :: %__MODULE__{
            minimize: String.t(),
            maximize: String.t(),
            restore: String.t(),
            close: String.t()
          }

    def default do
      %__MODULE__{
        minimize: Gettext.gettext("Minimize window"),
        maximize: Gettext.gettext("Maximize window"),
        restore: Gettext.gettext("Restore window"),
        close: Gettext.gettext("Close window")
      }
    end

    def merge(nil, default), do: default

    def merge(%__MODULE__{} = partial, %__MODULE__{} = default) do
      %__MODULE__{
        minimize: Corex.Translation.take(partial.minimize, default.minimize),
        maximize: Corex.Translation.take(partial.maximize, default.maximize),
        restore: Corex.Translation.take(partial.restore, default.restore),
        close: Corex.Translation.take(partial.close, default.close)
      }
    end
  end

  @doc type: :component
  use Phoenix.Component

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
  alias Corex.Gettext
  alias Corex.Point
  alias Corex.Positioning
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

  attr(:size, :map, default: nil, doc: "Zag defaultSize; sets data-default-size on the hook root")
  attr(:value_size, :map, default: nil, doc: "Zag controlled size; sets data-size when present")

  attr(:position, :any,
    default: nil,
    doc:
      "Initial Zag `Point` (`defaultPosition` / `data-default-position`). `%Corex.Point{}` or `%{x:, y:}`"
  )

  attr(:positioning, Corex.Positioning,
    default: nil,
    doc:
      "Optional placement for `getAnchorPosition` on the client (`data-position-*`). Ignored for anchor math when `position` is set."
  )

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

  slot :trigger, required: true do
    attr(:class, :string, required: false)
  end

  slot :title, required: true do
    attr(:class, :string, required: false)
  end

  slot :minimize_trigger, required: false do
    attr(:class, :string, required: false)
  end

  slot :maximize_trigger, required: false do
    attr(:class, :string, required: false)
  end

  slot :default_trigger, required: false do
    attr(:class, :string, required: false)
  end

  slot :close_trigger, required: true do
    attr(:class, :string, required: false)
  end

  slot :content, required: true do
    attr(:class, :string, required: false)
  end

  def floating_panel(assigns) do
    translation = Translation.merge(assigns.translation, Translation.default())

    assigns =
      assigns
      |> assign_new(:id, fn -> "floating-panel-#{System.unique_integer([:positive])}" end)
      |> assign_new(:dir, fn -> "ltr" end)
      |> assign(:translation, translation)
      |> assign(:resize_axes, @resize_axes)
      |> assign(:stages, @stages)
      |> assign(:default_position, Point.to_map(assigns.position))
      |> assign(:trigger_entry, List.first(assigns.trigger))

    ~H"""
    <div
      id={@id}
      phx-hook="FloatingPanel"
      data-loading
      phx-mounted={Phoenix.LiveView.JS.ignore_attributes(["data-loading"])}
      {@rest}
      {Positioning.to_dataset(@positioning)}
      {Connect.props(%Props{
        id: @id,
        draggable: @draggable,
        resizable: @resizable,
        allow_overflow: @allow_overflow,
        close_on_escape: @close_on_escape,
        disabled: @disabled,
        dir: @dir,
        orientation: @orientation,
        size: @value_size,
        default_size: @size,
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
        <button
          type="button"
          class={Map.get(@trigger_entry || %{}, :class)}
          phx-mounted={Connect.ignore_trigger(%Trigger{id: @id, dir: @dir, orientation: @orientation})}
          {Connect.trigger(%Trigger{id: @id, dir: @dir, orientation: @orientation})}
        >
          {render_slot(@trigger_entry)}
        </button>
        <div phx-mounted={Connect.ignore_positioner(%Positioner{id: @id, dir: @dir, orientation: @orientation})} {Connect.positioner(%Positioner{id: @id, dir: @dir, orientation: @orientation})}>
          <div phx-mounted={Connect.ignore_content(%Content{id: @id, dir: @dir, orientation: @orientation})} {Connect.content(%Content{id: @id, dir: @dir, orientation: @orientation})}>
            <div phx-mounted={Connect.ignore_drag_trigger(%DragTrigger{id: @id, dir: @dir, orientation: @orientation})} {Connect.drag_trigger(%DragTrigger{id: @id, dir: @dir, orientation: @orientation})}>
              <div phx-mounted={Connect.ignore_header(%Header{id: @id, dir: @dir, orientation: @orientation})} {Connect.header(%Header{id: @id, dir: @dir, orientation: @orientation})}>
                <div phx-mounted={Connect.ignore_title(%Title{id: @id, dir: @dir, orientation: @orientation})} {Connect.title(%Title{id: @id, dir: @dir, orientation: @orientation})} class={Map.get(Enum.at(@title, 0), :class)}>
                  {render_slot(@title)}
                </div>
                <div phx-mounted={Connect.ignore_control(%Control{id: @id, dir: @dir, orientation: @orientation})} {Connect.control(%Control{id: @id, dir: @dir, orientation: @orientation})}>
                  <button :if={@minimize_trigger != []} type="button" phx-mounted={Connect.ignore_stage_trigger(%StageTrigger{id: @id, stage: "minimized", dir: @dir, orientation: @orientation})} {Connect.stage_trigger(%StageTrigger{id: @id, stage: "minimized", dir: @dir, orientation: @orientation})} aria-label={@translation.minimize}>
                    {render_slot(@minimize_trigger)}
                  </button>
                  <button :if={@maximize_trigger != []} type="button" phx-mounted={Connect.ignore_stage_trigger(%StageTrigger{id: @id, stage: "maximized", dir: @dir, orientation: @orientation})} {Connect.stage_trigger(%StageTrigger{id: @id, stage: "maximized", dir: @dir, orientation: @orientation})} aria-label={@translation.maximize}>
                    {render_slot(@maximize_trigger)}
                  </button>
                  <button :if={@default_trigger != []} type="button" phx-mounted={Connect.ignore_stage_trigger(%StageTrigger{id: @id, stage: "default", dir: @dir, orientation: @orientation})} {Connect.stage_trigger(%StageTrigger{id: @id, stage: "default", dir: @dir, orientation: @orientation})} aria-label={@translation.restore}>
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
  def set_open(floating_panel_id, open)
      when is_binary(floating_panel_id) and is_boolean(open) do
    JS.dispatch("corex:floating-panel:set-open",
      to: "##{floating_panel_id}",
      detail: %{open: open},
      bubbles: false
    )
  end

  @doc type: :api
  def set_open(socket, floating_panel_id, open)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(floating_panel_id) and
             is_boolean(open) do
    LiveView.push_event(socket, "floating_panel_set_open", %{
      floating_panel_id: floating_panel_id,
      open: open
    })
  end
end
