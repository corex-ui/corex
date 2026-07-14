defmodule Corex.Tooltip do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Tooltip](https://zagjs.com/components/react/tooltip).

  ## Anatomy

  <!-- tabs-open -->

  ### Minimal

  ```heex
  <.tooltip class="tooltip" show_arrow={false}>
    <:trigger>Hover me</:trigger>
    <:content>Tooltip content</:content>
  </.tooltip>
  ```

  ### With arrow

  ```heex
  <.tooltip class="tooltip">
    <:trigger>Hover me</:trigger>
    <:content>Tooltip content</:content>
  </.tooltip>
  ```

  ### Placement

  ```heex
  <.tooltip class="tooltip" positioning={%Corex.Positioning{placement: "bottom"}}>
    <:trigger>Bottom</:trigger>
    <:content>Tooltip below</:content>
  </.tooltip>
  ```

  <!-- tabs-close -->

  ## API

  Requires a stable `id` on `<.tooltip>`.

  | Function | Action | Returns |
  | -------- | ------ | ------- |
  | [`set_open/2`](#set_open/2) | Set open state (client) | `%Phoenix.LiveView.JS{}` |
  | [`set_open/3`](#set_open/3) | Set open state (server) | `socket` |

  ## Events

  Pick an event name and pass it to `on_*` on `<.tooltip>`.

  ### Server events

  | Event | When | Payload |
  | ----- | ---- | ------- |
  | `on_open_change="tooltip_open_changed"` | Open state changes | `%{"id" => id, "open" => boolean}` |
  | `on_trigger_value_change="tooltip_trigger_changed"` | Active trigger changes (multi-trigger) | `%{"id" => id, "value" => value}` |

  <!-- tabs-open -->

  ### on_open_change

  ```heex
  <.tooltip class="tooltip" on_open_change="tooltip_open_changed">
    <:trigger>Hover me</:trigger>
    <:content>Tooltip content</:content>
  </.tooltip>
  ```

  ```elixir
  def handle_event("tooltip_open_changed", %{"id" => _id, "open" => open}, socket) do
    {:noreply, assign(socket, :tooltip_open, open)}
  end
  ```

  <!-- tabs-close -->

  ### Client events

  | Event | When | `event.detail` |
  | ----- | ---- | -------------- |
  | `on_open_change_client="tooltip-open-changed"` | Open state changes | `id`, `open` |
  | `on_trigger_value_change_client="tooltip-trigger-changed"` | Active trigger changes | `id`, `value` |

  ## Patterns

  <!-- tabs-open -->

  ### Multi-trigger

  One content panel, several triggers. Each trigger `value` must be unique.

  ```heex
  <.tooltip
    class="tooltip"
    on_trigger_value_change="tooltip_trigger_changed"
  >
    <:trigger value="a">First</:trigger>
    <:trigger value="b">Second</:trigger>
    <:content>Active: {@active_trigger}</:content>
  </.tooltip>
  ```

  ```elixir
  def handle_event("tooltip_trigger_changed", %{"value" => value}, socket) do
    {:noreply, assign(socket, :active_trigger, value)}
  end
  ```

  ### Inside menu (or other roving-focus containers)

  When a tooltip trigger sits inside a menu item, set `focusable={false}` on `<:trigger>` so
  open focus does not land on the trigger and open the tooltip. Prefer `trigger_tag={:span}`
  to avoid nested `<button>` elements inside `role="menuitem"`.

  ```heex
  <.menu_item disabled value="support">
    <.tooltip class="tooltip ui-size-sm" trigger_tag={:span}>
      <:trigger focusable={false}>Support</:trigger>
      <:content>Coming soon</:content>
    </.tooltip>
  </.menu_item>
  ```

  <!-- tabs-close -->

  ## Style

  Target parts with `data-scope` and `data-part`, or use Corex Design: import tokens and `tooltip.css`, then set `class="tooltip"` on `<.tooltip>`.

  ```css
  [data-scope="tooltip"][data-part="trigger"] {}
  [data-scope="tooltip"][data-part="positioner"] {}
  [data-scope="tooltip"][data-part="content"] {}
  [data-scope="tooltip"][data-part="arrow"] {}
  ```

  ```css
  @import "../corex/main.css";
  @import "../corex/tokens/themes/neo/light.css";
  @import "../corex/components.css";
  ```

  Stack modifiers on the host (`class` on `<.tooltip>`).

  Axes: **Semantic** (`ui-accent`, `ui-brand`, `ui-alert`, `ui-info`, `ui-success`), **Variant** (`ui-solid`), **Size** (`ui-size-sm` … `ui-size-xl`), **Radius** (`ui-rounded-*`). See the [modifier guide](modifiers.html).

  Semantic modifiers set palette variables on the content panel. Variant modifiers control tooltip panel surface treatment. Default is subtle; add `tooltip ui-solid` for a filled panel.

  <!-- tabs-open -->

  ### Semantic

  | Modifier | Classes |
  | -------- | ------- |
  | Default | `tooltip` |
  | Accent | `tooltip tooltip ui-accent` |
  | Brand | `tooltip tooltip ui-brand` |
  | Alert | `tooltip tooltip ui-alert` |
  | Info | `tooltip tooltip ui-info` |
  | Success | `tooltip tooltip ui-success` |

  ### Variant

  Visual treatment of `[data-part="content"]`.

  | Modifier | Classes |
  | -------- | ------- |
  | Subtle (default) | `tooltip` or `tooltip tooltip ui-accent` |
  | Solid | `tooltip tooltip ui-accent tooltip ui-solid` |

  ### Size

  | Modifier | Classes |
  | -------- | ------- |
  | SM | `tooltip tooltip ui-size-sm` |
  | MD | `tooltip tooltip ui-size-md` |
  | LG | `tooltip tooltip ui-size-lg` |
  | XL | `tooltip tooltip ui-size-xl` |

  <!-- tabs-close -->

  '''

  @doc type: :component
  use Phoenix.Component

  import Corex.Api.Doc

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

  attr(:on_trigger_value_change_client, :string,
    default: nil,
    doc: "The client event name when the active trigger value changes"
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

    attr(:focusable, :boolean,
      doc:
        "When false, the trigger is not tabbable (tabindex -1). Use inside menus or other roving-focus containers so focus does not open the tooltip. Defaults to true."
    )

    attr(:tabindex, :integer,
      doc:
        "Explicit tabindex for the trigger. Overrides focusable when set. Tooltip disabled still forces -1."
    )
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
        on_trigger_value_change: @on_trigger_value_change,
        on_trigger_value_change_client: @on_trigger_value_change_client
      })}
    >
      <%= for t <- @trigger do %>
        <%= if @trigger_tag == :span do %>
          <span
            class={Map.get(t, :class, nil)}
            phx-mounted={Connect.ignore_trigger(trigger_connect_assigns(@id, @dir, @orientation, @disabled, @trigger_tag, t))}
            {Connect.trigger(trigger_connect_assigns(@id, @dir, @orientation, @disabled, @trigger_tag, t))}
          >
            {render_slot(t, @slot_assigns)}
          </span>
        <% else %>
          <button
            class={Map.get(t, :class, nil)}
            phx-mounted={Connect.ignore_trigger(trigger_connect_assigns(@id, @dir, @orientation, @disabled, @trigger_tag, t))}
            {Connect.trigger(trigger_connect_assigns(@id, @dir, @orientation, @disabled, @trigger_tag, t))}
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

  api_doc(~S"""
  Set tooltip open state from a control (`phx-click`).

  ```heex
  <.action phx-click={Corex.Tooltip.set_open("my-tooltip", true)}>Show</.action>
  <.tooltip id="my-tooltip" class="tooltip">
    <:trigger>Target</:trigger>
    <:content>Hint</:content>
  </.tooltip>
  ```

  ```javascript
  document.getElementById("my-tooltip")?.dispatchEvent(
    new CustomEvent("corex:tooltip:set-open", {
      bubbles: false,
      detail: { open: true },
    })
  );
  ```
  """)

  def set_open(tooltip_id, open) when is_binary(tooltip_id) and is_boolean(open) do
    JS.dispatch("corex:tooltip:set-open",
      to: "##{tooltip_id}",
      detail: %{open: open},
      bubbles: false
    )
  end

  api_doc(~S"""
  Set open state from `handle_event`.

  ```heex
  <.action phx-click="show_tip">Show</.action>
  <.tooltip id="my-tooltip" class="tooltip">
    <:trigger>Target</:trigger>
    <:content>Hint</:content>
  </.tooltip>
  ```

  ```elixir
  def handle_event("show_tip", _, socket) do
    {:noreply, Corex.Tooltip.set_open(socket, "my-tooltip", true)}
  end
  ```
  """)

  def set_open(socket, tooltip_id, open)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(tooltip_id) and
             is_boolean(open) do
    LiveView.push_event(socket, "tooltip_set_open", %{
      tooltip_id: tooltip_id,
      open: open
    })
  end

  defp trigger_connect_assigns(id, dir, orientation, disabled, trigger_tag, trigger_slot) do
    %Trigger{
      id: id,
      dir: dir,
      open: false,
      disabled: disabled,
      orientation: orientation,
      tag: trigger_tag,
      value: Map.get(trigger_slot, :value),
      focusable: Map.get(trigger_slot, :focusable, true),
      tabindex: Map.get(trigger_slot, :tabindex)
    }
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
