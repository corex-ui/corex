defmodule Corex.HoverCard do
  @moduledoc ~S'''
  Hover card for Phoenix LiveView. Behavior follows [Zag.js Hover Card](https://zagjs.com/components/react/hover-card).
  ## Anatomy

  <!-- tabs-open -->

  ### Minimal

    ```heex
    <.hover_card class="hover-card" show_arrow={false}>
      <:trigger>corex-ui</:trigger>
      <:content>
        <div class="flex gap-space items-start">
          <.avatar class="avatar ui-size-lg">
            <:fallback>Cx</:fallback>
          </.avatar>
          <div>
            <p class="font-semibold">corex-ui/corex</p>
            <p>Phoenix LiveView components with Zag.js behavior.</p>
            <p>Elixir · TypeScript · 1.2k stars</p>
          </div>
        </div>
      </:content>
    </.hover_card>
    ```

  ### With arrow

    ```heex
    <.hover_card class="hover-card">
      <:trigger>Hover me</:trigger>
      <:content>Preview content</:content>
    </.hover_card>
    ```

  ### Placement

    ```heex
    <.hover_card class="hover-card" positioning={%Corex.Positioning{placement: "bottom"}}>
      <:trigger>Bottom</:trigger>
      <:content>Card below</:content>
    </.hover_card>
    ```

  <!-- tabs-close -->

  ## API

  Requires a stable `id` on `<.hover_card>`.

  | Function | Action | Returns |
  | -------- | ------ | ------- |
  | [`set_open/2`](#set_open/2) | Set open state (client) | `%Phoenix.LiveView.JS{}` |
  | [`set_open/3`](#set_open/3) | Set open state (server) | `socket` |

  ## Events

  Pick an event name and pass it to `on_*` on `<.hover_card>`.

  ### Server events

  | Event | When | Payload |
  | ----- | ---- | ------- |
  | `on_open_change="hover_card_open_changed"` | Open state changes | `%{"id" => id, "open" => boolean}` |
  | `on_trigger_value_change="hover_card_trigger_changed"` | Active trigger changes | `%{"id" => id, "value" => value}` |

  <!-- tabs-open -->

  ### on_open_change

    ```heex
    <.hover_card class="hover-card" on_open_change="hover_card_open_changed">
      <:trigger>Hover me</:trigger>
      <:content>Preview content</:content>
    </.hover_card>
    ```

    ```elixir
    def handle_event("hover_card_open_changed", %{"id" => _id, "open" => open}, socket) do
      {:noreply, assign(socket, :hover_card_open, open)}
    end
    ```

  <!-- tabs-close -->

  ### Client events

  | Event | When | `event.detail` |
  | ----- | ---- | -------------- |
  | `on_open_change_client="hover-card-open-changed"` | Open state changes | `id`, `open` |
  | `on_trigger_value_change_client="hover-card-trigger-changed"` | Active trigger changes | `id`, `value` |

  ## Patterns

  <!-- tabs-open -->

  ### Multi-trigger

    ```heex
    <.hover_card class="hover-card" on_trigger_value_change="hover_card_trigger_changed">
      <:trigger value="a">First</:trigger>
      <:trigger value="b">Second</:trigger>
      <:content>Active: {@active_trigger}</:content>
    </.hover_card>
    ```

  <!-- tabs-close -->

  ## Style

  Target parts with `data-scope` and `data-part`, or use Corex Design: `class="hover-card"` on `<.hover_card>`.

    ```css
    [data-scope="hover-card"][data-part="trigger"] {}
    [data-scope="hover-card"][data-part="content"] {}
    ```

  Axes: **Semantic**, **Variant** (`ui-solid`), **Size**, **Radius**. See the [modifier guide](modifiers.html).

  <!-- tabs-open -->

  ### Semantic

  | Modifier | Classes |
  | -------- | ------- |
  | Default | `hover-card` |
  | Accent | `hover-card ui-accent` |

  ### Variant

  | Modifier | Classes |
  | -------- | ------- |
  | Subtle (default) | `hover-card` |
  | Solid | `hover-card ui-solid` |

  <!-- tabs-close -->

  '''

  @doc type: :component
  use Phoenix.Component

  import Corex.Api.Doc

  alias Corex.HoverCard.Anatomy.{Arrow, ArrowTip, Content, Positioner, Props, Trigger}
  alias Corex.HoverCard.Connect
  alias Corex.Positioning
  alias Corex.Selectors
  alias Phoenix.LiveView
  alias Phoenix.LiveView.JS

  attr(:id, :string, required: false)
  attr(:disabled, :boolean, default: false)
  attr(:dir, :string, default: nil, values: [nil, "ltr", "rtl"])
  attr(:open_delay, :integer, default: nil)
  attr(:close_delay, :integer, default: nil)
  attr(:positioning, Positioning, default: %Positioning{})
  attr(:show_arrow, :boolean, default: true)
  attr(:on_open_change, :string, default: nil)
  attr(:on_open_change_client, :string, default: nil)
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

  def hover_card(assigns) do
    assigns = Corex.FormField.assign_stable_id(assigns, "hover-card")
    validate_triggers!(assigns.trigger)

    ~H"""
    <div
      id={@id}
      phx-hook="HoverCard"
      {Corex.Hook.loading()}
      {@rest}
      {Connect.props(%Props{
        id: @id,
        positioning: @positioning,
        disabled: @disabled,
        dir: @dir,
        open_delay: @open_delay,
        close_delay: @close_delay,
        on_open_change: @on_open_change,
        on_open_change_client: @on_open_change_client,
        on_trigger_value_change: @on_trigger_value_change,
        on_trigger_value_change_client: @on_trigger_value_change_client
      })}
    >
      <%= for t <- @trigger do %>
        <button
          class={Map.get(t, :class, nil)}
          {Connect.mounted_trigger(%Trigger{
            id: @id,
            dir: @dir,
            open: false,
            disabled: @disabled,
            value: Map.get(t, :value)
          })}
        >
          {render_slot(t)}
        </button>
      <% end %>
      <div {Connect.mounted_positioner(%Positioner{id: @id, dir: @dir})}>
        <div :if={@show_arrow} {Connect.mounted_arrow(%Arrow{id: @id, dir: @dir})}>
          <div {Connect.mounted_arrow_tip(%ArrowTip{id: @id, dir: @dir})}></div>
        </div>
        <div
          class={Map.get(Enum.at(@content, 0), :class, nil)}
          {Connect.mounted_content(%Content{id: @id, dir: @dir, open: false})}
        >
          {render_slot(Enum.at(@content, 0))}
        </div>
      </div>
    </div>
    """
  end

  api_doc(~S"""
  Set hover card open state from a control (`phx-click`).
  """)

  @spec set_open(String.t(), boolean()) :: Phoenix.LiveView.JS.t()
  @spec set_open(Phoenix.LiveView.Socket.t(), String.t(), boolean()) ::
          Phoenix.LiveView.Socket.t()
  def set_open(hover_card_id, open) when is_binary(hover_card_id) and is_boolean(open) do
    JS.dispatch("corex:hover-card:set-open",
      to: Selectors.css_id(hover_card_id),
      detail: %{open: open},
      bubbles: false
    )
  end

  api_doc(~S"""
  Set open state from `handle_event`.
  """)

  def set_open(socket, hover_card_id, open)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(hover_card_id) and
             is_boolean(open) do
    LiveView.push_event(socket, "hover_card_set_open", %{
      hover_card_id: hover_card_id,
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
                "Corex.HoverCard: each <:trigger> must include a non-empty value attribute when there are multiple triggers"
        end

        if length(Enum.uniq(values)) != length(values) do
          raise ArgumentError, "Corex.HoverCard: trigger value attributes must be unique"
        end
    end
  end
end
