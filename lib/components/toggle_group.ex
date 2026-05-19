defmodule Corex.ToggleGroup do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Toggle Group](https://zagjs.com/components/react/toggle-group).

  ## Anatomy

  <!-- tabs-open -->

  ### Minimal

  ```heex
  <.toggle_group class="toggle-group">
    <:item value="lorem">Lorem</:item>
    <:item value="duis">Duis</:item>
    <:item value="donec">Donec</:item>
  </.toggle_group>
  ```

  ### With indicator

  ```heex
  <.toggle_group class="toggle-group">
    <:item value="bold">
      <.heroicon name="hero-bold" />
      Bold
    </:item>
  </.toggle_group>

  <.toggle_group class="toggle-group">
    <:item value="bold" aria_label="Bold">
      <.heroicon name="hero-bold" />
      <span class="sr-only">Bold</span>
    </:item>
  </.toggle_group>
  ```

  ### Single selection

  Set `multiple={false}` so only one item can be selected at a time.

  ```heex
  <.toggle_group
    class="toggle-group"
    multiple={false}
    value={["duis"]}
  >
    <:item value="lorem">Lorem</:item>
    <:item value="duis">Duis</:item>
    <:item value="donec">Donec</:item>
  </.toggle_group>
  ```

  <!-- tabs-close -->

  ## API

  Requires a stable `id` on `<.toggle_group>`.

  | Function | Action | Returns |
  | -------- | ------ | ------- |
  | [`set_value/2`](#set_value/2) | Set selected values (client) | `%Phoenix.LiveView.JS{}` |
  | [`set_value/3`](#set_value/3) | Set selected values (server) | `socket` |

  ## Events

  Pick an event name and pass it to `on_*` on `<.toggle_group>`.

  ### Server events

  | Event | When | Payload |
  | ----- | ---- | ------- |
  | `on_value_change="toggle_group_changed"` | Selected values change | `%{"id" => id, "value" => values}` — list of selected item `value` strings |

  <!-- tabs-open -->

  ### on_value_change

  ```heex
  <.toggle_group
    class="toggle-group"
    on_value_change="toggle_group_changed"
    multiple
  >
    <:item value="lorem">Lorem</:item>
    <:item value="duis">Duis</:item>
    <:item value="donec">Donec</:item>
  </.toggle_group>
  ```

  ```elixir
  def handle_event("toggle_group_changed", %{"id" => id, "value" => value}, socket) do
    {:noreply, assign(socket, :toggle_group_value, value)}
  end
  ```

  <!-- tabs-close -->

  ### Client events

  | Event | When | `event.detail` |
  | ----- | ---- | -------------- |
  | `on_value_change_client="toggle-group-changed"` | Selected values change | `id`, `value` |

  <!-- tabs-open -->

  ### on_value_change_client

  ```heex
  <.toggle_group
    id="toggle-group-events-client"
    class="toggle-group"
    on_value_change_client="toggle-group-changed"
    multiple
  >
    <:item value="lorem">Lorem</:item>
    <:item value="duis">Duis</:item>
    <:item value="donec">Donec</:item>
  </.toggle_group>
  ```

  ```javascript
  const el = document.getElementById("toggle-group-events-client");
  el?.addEventListener("toggle-group-changed", (event) => console.log(event.detail));
  ```

  <!-- tabs-close -->

  ## Patterns

  <!-- tabs-open -->

  ### Controlled

  For server-owned selection, set `controlled`, bind `value`, and handle `on_value_change` in LiveView.

  ```heex
  <.toggle_group
    class="toggle-group"
    value={@value}
    multiple
    controlled
    on_value_change="toggle_group_pattern"
  >
    <:item value="lorem">Lorem</:item>
    <:item value="duis">Duis</:item>
    <:item value="donec">Donec</:item>
  </.toggle_group>
  ```

  ```elixir
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :value, ["lorem"])}
  end

  def handle_event("toggle_group_pattern", %{"value" => v}, socket) do
    {:noreply, assign(socket, :value, v || [])}
  end
  ```

  <!-- tabs-close -->

  ## Style

  Target parts with `data-scope` and `data-part`, or use Corex Design: import tokens and `toggle-group.css`, then set `class="toggle-group"` on `<.toggle_group>`.

  ```css
  [data-scope="toggle-group"][data-part="root"] {}
  [data-scope="toggle-group"][data-part="item"] {}
  ```

  ```css
  @import "../corex/main.css";
  @import "../corex/tokens/themes/neo/light.css";
  @import "../corex/components/toggle-group.css";
  ```

  Stack modifiers on the host (`class` on `<.toggle_group>`).

  <!-- tabs-open -->

  ### Color

  | Modifier | Classes |
  | -------- | ------- |
  | Default | `toggle-group` |
  | Accent | `toggle-group toggle-group--accent` |
  | Brand | `toggle-group toggle-group--brand` |
  | Alert | `toggle-group toggle-group--alert` |
  | Info | `toggle-group toggle-group--info` |
  | Success | `toggle-group toggle-group--success` |

  ### Size

  | Modifier | Classes |
  | -------- | ------- |
  | SM | `toggle-group toggle-group--sm` |
  | MD | `toggle-group toggle-group--md` |
  | LG | `toggle-group toggle-group--lg` |
  | XL | `toggle-group toggle-group--xl` |

  ### Rounded

  | Modifier | Classes |
  | -------- | ------- |
  | None | `toggle-group toggle-group--rounded-none` |
  | SM | `toggle-group toggle-group--rounded-sm` |
  | MD | `toggle-group toggle-group--rounded-md` |
  | LG | `toggle-group toggle-group--rounded-lg` |
  | XL | `toggle-group toggle-group--rounded-xl` |
  | Full | `toggle-group toggle-group--rounded-full` |

  <!-- tabs-close -->

  '''

  @doc type: :component
  use Phoenix.Component

  alias Corex.ToggleGroup.Anatomy.{Item, Props, Root}
  alias Corex.ToggleGroup.Connect
  alias Phoenix.LiveView
  alias Phoenix.LiveView.JS

  @doc """
  Renders a toggle group component.
  """

  attr(:id, :string,
    required: false,
    doc: "The id of the toggle group, useful for API to identify the toggle group"
  )

  attr(:value, :list,
    default: [],
    doc:
      "The initial value or the controlled value of the toggle group, must be a list of strings"
  )

  attr(:controlled, :boolean, default: false, doc: "Whether the toggle group is controlled")
  attr(:deselectable, :boolean, default: false, doc: "Whether the toggle group is deselectable")
  attr(:loopFocus, :boolean, default: true, doc: "Whether the toggle group is loopFocus")
  attr(:rovingFocus, :boolean, default: true, doc: "Whether the toggle group is rovingFocus")
  attr(:disabled, :boolean, default: false, doc: "Whether the toggle group is disabled")

  attr(:multiple, :boolean,
    default: true,
    doc: "Whether the toggle group allows multiple items to be selected"
  )

  attr(:orientation, :string,
    default: "horizontal",
    values: ["horizontal", "vertical"],
    doc: "The orientation of the toggle group"
  )

  attr(:dir, :string,
    default: nil,
    values: [nil, "ltr", "rtl"],
    doc:
      "The direction of the toggle group. When nil, derived from document (html lang + config :rtl_locales)"
  )

  attr(:on_value_change, :string,
    default: nil,
    doc: "The server event name when the value change"
  )

  attr(:on_value_change_client, :string,
    default: nil,
    doc: "The client event name when the value change"
  )

  attr(:rest, :global)

  slot :label, required: false, doc: "Optional visible or screen-reader label for the group" do
    attr(:class, :string, required: false)
  end

  slot :item, required: true do
    attr(:value, :string,
      doc: "The value of the item, useful in controlled mode and for API to identify the item"
    )

    attr(:disabled, :boolean, doc: "Whether the item is disabled")
    attr(:class, :string, doc: "The class of the item")

    attr(:aria_label, :string,
      doc:
        "Accessibility label for the item button. If not provided, the value will be used as a fallback."
    )
  end

  def toggle_group(assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> "toggle-group-#{System.unique_integer([:positive])}" end)
      |> assign_new(:dir, fn -> "ltr" end)

    label_id =
      case Map.get(assigns, :label, []) do
        [] -> nil
        _ -> "#{assigns.id}-label"
      end

    assigns = assign(assigns, :label_id, label_id)

    ~H"""
    <div id={@id} phx-hook="ToggleGroup" data-loading phx-mounted={Phoenix.LiveView.JS.ignore_attributes(["data-loading"])} {@rest}
    {Connect.props(%Props{
      id: @id,
      controlled: @controlled,
      value: @value,
      deselectable: @deselectable,
      loopFocus: @loopFocus,
      rovingFocus: @rovingFocus,
      disabled: @disabled,
      multiple: @multiple,
      orientation: @orientation,
      dir: @dir,
      on_value_change: @on_value_change,
      on_value_change_client: @on_value_change_client
    })}>
      <span :if={@label != []} id={@label_id} class={Map.get(Enum.at(@label, 0), :class)}>
        {render_slot(@label)}
      </span>
      <div phx-mounted={Connect.ignore_root(%Root{id: @id, disabled: @disabled, orientation: @orientation, dir: @dir, aria_labelledby: @label_id})} {Connect.root(%Root{id: @id, disabled: @disabled, orientation: @orientation, dir: @dir, aria_labelledby: @label_id})}>
        <button :for={{item_entry, index} <- Enum.with_index(@item)}
        phx-mounted={Connect.ignore_item(%Item{
          id: @id,
          value: Map.get(item_entry, :value, "item-#{index}"),
          disabled: Map.get(item_entry, :disabled, false),
          aria_label: Map.get(item_entry, :aria_label),
          values: @value, orientation: @orientation,
          dir: @dir,
          disabled_root: @disabled})}
        {Connect.item(%Item{
          id: @id,
          value: Map.get(item_entry, :value, "item-#{index}"),
          disabled: Map.get(item_entry, :disabled, false),
          aria_label: Map.get(item_entry, :aria_label),
          values: @value, orientation: @orientation,
          dir: @dir,
          disabled_root: @disabled})}
          class={Map.get(item_entry, :class, nil)}>
        {render_slot(item_entry)}
        </button>
      </div>
    </div>
    """
  end

  @doc type: :api
  @doc ~S"""
  Set selected values from a control (`phx-click`). Pass a list of item `value` strings (or compatible input validated by the component).

  ```heex
  <.action phx-click={Corex.ToggleGroup.set_value("my-toggle-group", ["a"])}>Pick A</.action>
  <.toggle_group id="my-toggle-group" class="toggle-group" multiple={false} value={[]}>
    <:item value="a">A</:item>
    <:item value="b">B</:item>
  </.toggle_group>
  ```

  ```javascript
  document.getElementById("my-toggle-group")?.dispatchEvent(
    new CustomEvent("corex:toggle-group:set-value", {
      detail: { value: ["a"] },
    })
  );
  ```
  """
  def set_value(toggle_group_id, value) when is_binary(toggle_group_id) do
    JS.dispatch("corex:toggle-group:set-value",
      to: "##{toggle_group_id}",
      detail: %{value: Connect.validate_value!(value)}
    )
  end

  @doc type: :api
  @doc ~S"""
  Set selected values from `handle_event`.

  ```heex
  <.action phx-click="pick_a">Pick A</.action>
  <.toggle_group id="my-toggle-group" class="toggle-group" multiple={false} value={[]}>
    <:item value="a">A</:item>
    <:item value="b">B</:item>
  </.toggle_group>
  ```

  ```elixir
  def handle_event("pick_a", _, socket) do
    {:noreply, Corex.ToggleGroup.set_value(socket, "my-toggle-group", ["a"])}
  end
  ```
  """
  def set_value(socket, toggle_group_id, value)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(toggle_group_id) do
    LiveView.push_event(socket, "toggle-group_set_value", %{
      id: toggle_group_id,
      value: Connect.validate_value!(value)
    })
  end
end
