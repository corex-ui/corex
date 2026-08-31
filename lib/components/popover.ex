defmodule Corex.Popover do
  @moduledoc ~S'''
  Popover for Phoenix LiveView. Behavior follows [Zag.js Popover](https://zagjs.com/components/react/popover).
  ## Anatomy

  <!-- tabs-open -->

  ### Minimal

    ```heex
    <.popover class="popover">
      <:trigger>Open</:trigger>
      <:content>Popover content</:content>
    </.popover>
    ```

  ### With title

    ```heex
    <.popover class="popover">
      <:trigger>Open</:trigger>
      <:title>Details</:title>
      <:content>Popover content</:content>
    </.popover>
    ```

  ### Placement

    ```heex
    <.popover class="popover" positioning={%Corex.Positioning{placement: "bottom"}}>
      <:trigger>Bottom</:trigger>
      <:content>Anchored below</:content>
    </.popover>
    ```

  <!-- tabs-close -->

  ## API

  Requires a stable `id` on `<.popover>`.

  | Function | Action | Returns |
  | -------- | ------ | ------- |
  | [`set_open/2`](#set_open/2) | Set open state (client) | `%Phoenix.LiveView.JS{}` |
  | [`set_open/3`](#set_open/3) | Set open state (server) | `socket` |

  ## Events

  Pick an event name and pass it to `on_*` on `<.popover>`.

  ### Server events

  | Event | When | Payload |
  | ----- | ---- | ------- |
  | `on_open_change="popover_open_changed"` | Open state changes | `%{"id" => id, "open" => boolean}` |
  | `on_trigger_value_change="popover_trigger_changed"` | Active trigger changes (multi-trigger) | `%{"id" => id, "value" => value}` |

  <!-- tabs-open -->

  ### on_open_change

    ```heex
    <.popover class="popover" on_open_change="popover_open_changed">
      <:trigger>Open</:trigger>
      <:content>Popover content</:content>
    </.popover>
    ```

    ```elixir
    def handle_event("popover_open_changed", %{"id" => _id, "open" => open}, socket) do
      {:noreply, assign(socket, :popover_open, open)}
    end
    ```

  <!-- tabs-close -->

  ### Client events

  | Event | When | `event.detail` |
  | ----- | ---- | -------------- |
  | `on_open_change_client="popover-open-changed"` | Open state changes | `id`, `open` |
  | `on_trigger_value_change_client="popover-trigger-changed"` | Active trigger changes | `id`, `value` |

  ## Patterns

  <!-- tabs-open -->

  ### Multi-trigger

  One content panel, several triggers. Each trigger `value` must be unique.

    ```heex
    <.popover class="popover" on_trigger_value_change="popover_trigger_changed">
      <:trigger value="a">First</:trigger>
      <:trigger value="b">Second</:trigger>
      <:content>Active: {@active_trigger}</:content>
    </.popover>
    ```

  <!-- tabs-close -->

  ## Style

  Target parts with `data-scope` and `data-part`, or use Corex Design: import tokens and `popover.css`, then set `class="popover"` on `<.popover>`.

    ```css
    [data-scope="popover"][data-part="trigger"] {}
    [data-scope="popover"][data-part="positioner"] {}
    [data-scope="popover"][data-part="content"] {}
    ```

  Stack modifiers on the host (`class` on `<.popover>`).

  Axes: **Semantic** (`ui-accent`, `ui-brand`, `ui-alert`, `ui-info`, `ui-success`), **Variant** (`ui-solid`), **Size** (`ui-size-sm` … `ui-size-xl`), **Radius** (`ui-rounded-*`). See the [modifier guide](modifiers.html).

  <!-- tabs-open -->

  ### Semantic

  | Modifier | Classes |
  | -------- | ------- |
  | Default | `popover` |
  | Accent | `popover ui-accent` |

  ### Variant

  | Modifier | Classes |
  | -------- | ------- |
  | Subtle (default) | `popover` |
  | Solid | `popover ui-solid` |

  <!-- tabs-close -->

  '''

  @doc type: :component
  use Phoenix.Component

  import Corex.Api.Doc

  alias Corex.Positioning
  alias Corex.Selectors

  alias Corex.Popover.Anatomy.{
    Arrow,
    ArrowTip,
    CloseTrigger,
    Content,
    Description,
    Positioner,
    Props,
    Title,
    Trigger
  }

  alias Corex.Popover.Connect
  alias Phoenix.LiveView
  alias Phoenix.LiveView.JS

  attr(:id, :string, required: false, doc: "Stable id for API helpers")
  attr(:dir, :string, default: nil, values: [nil, "ltr", "rtl"])
  attr(:modal, :boolean, default: false)
  attr(:portalled, :boolean, default: true)
  attr(:auto_focus, :boolean, default: true)
  attr(:restore_focus, :boolean, default: true)
  attr(:close_on_interact_outside, :boolean, default: true)
  attr(:close_on_escape, :boolean, default: true)
  attr(:positioning, Positioning, default: %Positioning{})
  attr(:show_arrow, :boolean, default: false)
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

  slot :title, required: false do
    attr(:class, :string, required: false)
  end

  slot :description, required: false do
    attr(:class, :string, required: false)
  end

  slot :close_trigger, required: false do
    attr(:class, :string, required: false)
  end

  def popover(assigns) do
    assigns = Corex.FormField.assign_stable_id(assigns, "popover")
    validate_triggers!(assigns.trigger)

    ~H"""
    <div
      id={@id}
      phx-hook="Popover"
      {Corex.Hook.loading()}
      {@rest}
      {Connect.props(%Props{
        id: @id,
        positioning: @positioning,
        dir: @dir,
        modal: @modal,
        portalled: @portalled,
        auto_focus: @auto_focus,
        restore_focus: @restore_focus,
        close_on_interact_outside: @close_on_interact_outside,
        close_on_escape: @close_on_escape,
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
            value: Map.get(t, :value)
          })}
        >
          {render_slot(t)}
        </button>
      <% end %>
      <div {Connect.mounted_positioner(%Positioner{id: @id, dir: @dir})}>
        <div
          :if={@show_arrow}
          {Connect.mounted_arrow(%Arrow{id: @id, dir: @dir})}
        >
          <div {Connect.mounted_arrow_tip(%ArrowTip{id: @id, dir: @dir})}></div>
        </div>
        <div
          class={Map.get(Enum.at(@content, 0), :class, nil)}
          {Connect.mounted_content(%Content{id: @id, dir: @dir, open: false})}
        >
          <div :if={@title != [] or @close_trigger != []} data-scope="popover" data-part="header">
            <h2 :if={@title != []} {Connect.mounted_title(%Title{id: @id, dir: @dir})}>
              {render_slot(Enum.at(@title, 0))}
            </h2>
            <button
              :if={@close_trigger != []}
              class={Map.get(Enum.at(@close_trigger, 0), :class, nil)}
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
  Set popover open state from a control (`phx-click`).

  ```heex
  <.action phx-click={Corex.Popover.set_open("my-popover", true)}>Show</.action>
  ```
  """)

  @spec set_open(String.t(), boolean()) :: Phoenix.LiveView.JS.t()
  @spec set_open(Phoenix.LiveView.Socket.t(), String.t(), boolean()) ::
          Phoenix.LiveView.Socket.t()
  def set_open(popover_id, open) when is_binary(popover_id) and is_boolean(open) do
    JS.dispatch("corex:popover:set-open",
      to: Selectors.css_id(popover_id),
      detail: %{open: open},
      bubbles: false
    )
  end

  api_doc(~S"""
  Set open state from `handle_event`.
  """)

  def set_open(socket, popover_id, open)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(popover_id) and
             is_boolean(open) do
    LiveView.push_event(socket, "popover_set_open", %{
      popover_id: popover_id,
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
                "Corex.Popover: each <:trigger> must include a non-empty value attribute when there are multiple triggers"
        end

        if length(Enum.uniq(values)) != length(values) do
          raise ArgumentError, "Corex.Popover: trigger value attributes must be unique"
        end
    end
  end
end
