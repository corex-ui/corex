defmodule Corex.Drawer do
  @moduledoc ~S'''
  Drawer (bottom sheet) for Phoenix LiveView. Behavior follows [Zag.js Drawer](https://zagjs.com/components/react/drawer).

  This Zag machine is marked **beta**. The Corex API tracks Zag 1.43.x.

  ## Anatomy

  <!-- tabs-open -->

  ### Minimal

    ```heex
    <.drawer class="drawer">
      <:trigger>Open</:trigger>
      <:content>
        <p>Sheet content.</p>
      </:content>
    </.drawer>
    ```

  ### With title

    ```heex
    <.drawer class="drawer">
      <:trigger>Open</:trigger>
      <:title>Details</:title>
      <:content>
        <p>Sheet content.</p>
      </:content>
    </.drawer>
    ```

  ### Snap points

    ```heex
    <.drawer class="drawer" snap_points="0.3,0.6,1" default_snap_point="0.6">
      <:trigger>Open</:trigger>
      <:content>
        <p>Drag between snap points.</p>
      </:content>
    </.drawer>
    ```

  <!-- tabs-close -->

  ## API

  Requires a stable `id` on `<.drawer>`.

  | Function | Action | Returns |
  | -------- | ------ | ------- |
  | [`set_open/2`](#set_open/2) | Set open state (client) | `%Phoenix.LiveView.JS{}` |
  | [`set_open/3`](#set_open/3) | Set open state (server) | `socket` |

  ## Events

  ### Server events

  | Event | When | Payload |
  | ----- | ---- | ------- |
  | `on_open_change="drawer_open_changed"` | Open state changes | `%{"id" => id, "open" => boolean}` |
  | `on_snap_point_change="drawer_snap_changed"` | Snap point changes | `%{"id" => id, "snap_point" => point}` |

  <!-- tabs-open -->

  ### on_open_change

    ```heex
    <.drawer class="drawer" on_open_change="drawer_open_changed">
      <:trigger>Open</:trigger>
      <:content>Sheet</:content>
    </.drawer>
    ```

    ```elixir
    def handle_event("drawer_open_changed", %{"id" => _id, "open" => open}, socket) do
      {:noreply, assign(socket, :drawer_open, open)}
    end
    ```

  <!-- tabs-close -->

  ### Client events

  | Event | When | `event.detail` |
  | ----- | ---- | -------------- |
  | `on_open_change_client="drawer-open-changed"` | Open state changes | `id`, `open` |
  | `on_snap_point_change_client="drawer-snap-changed"` | Snap point changes | `id`, `snap_point` |

  ## Style

  Target parts with `data-scope` and `data-part`, or use Corex Design: `class="drawer"` on `<.drawer>`.

    ```css
    [data-scope="drawer"][data-part="content"] {}
    [data-scope="drawer"][data-part="backdrop"] {}
    ```

  Axes: **Semantic**, **Variant** (`ui-solid`), **Size**, **Radius**. See the [modifier guide](modifiers.html).

  <!-- tabs-open -->

  ### Semantic

  | Modifier | Classes |
  | -------- | ------- |
  | Default | `drawer` |
  | Accent | `drawer ui-accent` |

  ### Variant

  | Modifier | Classes |
  | -------- | ------- |
  | Subtle (default) | `drawer` |
  | Solid | `drawer ui-solid` |

  <!-- tabs-close -->

  '''

  @doc type: :component
  use Phoenix.Component

  import Corex.Api.Doc

  alias Corex.Selectors

  alias Corex.Drawer.Anatomy.{
    Backdrop,
    CloseTrigger,
    Content,
    Description,
    Grabber,
    GrabberIndicator,
    Positioner,
    Props,
    Title,
    Trigger
  }

  alias Corex.Drawer.Connect
  alias Phoenix.LiveView
  alias Phoenix.LiveView.JS

  attr(:id, :string, required: false)
  attr(:dir, :string, default: nil, values: [nil, "ltr", "rtl"])
  attr(:modal, :boolean, default: true)
  attr(:trap_focus, :boolean, default: true)
  attr(:prevent_scroll, :boolean, default: true)
  attr(:close_on_interact_outside, :boolean, default: true)
  attr(:close_on_escape, :boolean, default: true)
  attr(:swipe_direction, :string, default: "down", values: ["up", "down", "start", "end"])

  attr(:snap_points, :string,
    default: nil,
    doc: "Comma-separated snap points, e.g. \"0.3,0.6,1\""
  )

  attr(:default_snap_point, :string, default: nil)
  attr(:prevent_drag_on_scroll, :boolean, default: true)
  attr(:on_open_change, :string, default: nil)
  attr(:on_open_change_client, :string, default: nil)
  attr(:on_snap_point_change, :string, default: nil)
  attr(:on_snap_point_change_client, :string, default: nil)
  attr(:on_trigger_value_change, :string, default: nil)
  attr(:on_trigger_value_change_client, :string, default: nil)
  attr(:rest, :global)

  slot :trigger, required: true do
    attr(:class, :string, required: false)
    attr(:value, :string, required: false)
  end

  slot :content, required: true do
    attr(:class, :string, required: false)
  end

  slot(:title, required: false)
  slot(:description, required: false)
  slot(:close_trigger, required: false)

  def drawer(assigns) do
    assigns = Corex.FormField.assign_stable_id(assigns, "drawer")
    validate_triggers!(assigns.trigger)

    ~H"""
    <div
      id={@id}
      phx-hook="Drawer"
      {Corex.Hook.loading()}
      {@rest}
      {Connect.props(%Props{
        id: @id,
        dir: @dir,
        modal: @modal,
        trap_focus: @trap_focus,
        prevent_scroll: @prevent_scroll,
        close_on_interact_outside: @close_on_interact_outside,
        close_on_escape: @close_on_escape,
        swipe_direction: @swipe_direction,
        snap_points: @snap_points,
        default_snap_point: @default_snap_point,
        prevent_drag_on_scroll: @prevent_drag_on_scroll,
        on_open_change: @on_open_change,
        on_open_change_client: @on_open_change_client,
        on_snap_point_change: @on_snap_point_change,
        on_snap_point_change_client: @on_snap_point_change_client,
        on_trigger_value_change: @on_trigger_value_change,
        on_trigger_value_change_client: @on_trigger_value_change_client
      })}
    >
      <%= for t <- @trigger do %>
        <button
          class={Map.get(t, :class, nil)}
          {Connect.mounted_trigger(%Trigger{id: @id, dir: @dir, open: false, value: Map.get(t, :value)})}
        >
          {render_slot(t)}
        </button>
      <% end %>
      <div {Connect.mounted_backdrop(%Backdrop{id: @id, dir: @dir, open: false})}></div>
      <div {Connect.mounted_positioner(%Positioner{id: @id, dir: @dir, open: false})}>
        <div
          class={Map.get(Enum.at(@content, 0), :class, nil)}
          {Connect.mounted_content(%Content{id: @id, dir: @dir, open: false})}
        >
          <div {Connect.mounted_grabber(%Grabber{id: @id, dir: @dir})}>
            <div {Connect.mounted_grabber_indicator(%GrabberIndicator{id: @id, dir: @dir})}></div>
          </div>
          <div :if={@title != [] or @close_trigger != []} data-scope="drawer" data-part="header">
            <h2 :if={@title != []} {Connect.mounted_title(%Title{id: @id, dir: @dir})}>
              {render_slot(Enum.at(@title, 0))}
            </h2>
            <button
              :if={@close_trigger != []}
              {Connect.mounted_close_trigger(%CloseTrigger{id: @id, dir: @dir})}
            >
              {render_slot(Enum.at(@close_trigger, 0))}
            </button>
          </div>
          <p :if={@description != []} {Connect.mounted_description(%Description{id: @id, dir: @dir})}>
            {render_slot(Enum.at(@description, 0))}
          </p>
          {render_slot(Enum.at(@content, 0))}
        </div>
      </div>
    </div>
    """
  end

  api_doc(~S"""
  Set drawer open state from a control (`phx-click`).
  """)

  @spec set_open(String.t(), boolean()) :: Phoenix.LiveView.JS.t()
  @spec set_open(Phoenix.LiveView.Socket.t(), String.t(), boolean()) ::
          Phoenix.LiveView.Socket.t()
  def set_open(drawer_id, open) when is_binary(drawer_id) and is_boolean(open) do
    JS.dispatch("corex:drawer:set-open",
      to: Selectors.css_id(drawer_id),
      detail: %{open: open},
      bubbles: false
    )
  end

  api_doc(~S"""
  Set open state from `handle_event`.
  """)

  def set_open(socket, drawer_id, open)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(drawer_id) and
             is_boolean(open) do
    LiveView.push_event(socket, "drawer_set_open", %{
      drawer_id: drawer_id,
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
                "Corex.Drawer: each <:trigger> must include a non-empty value attribute when there are multiple triggers"
        end

        if length(Enum.uniq(values)) != length(values) do
          raise ArgumentError, "Corex.Drawer: trigger value attributes must be unique"
        end
    end
  end
end
