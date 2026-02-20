defmodule Corex.ToggleGroup do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Toggle Group](https://zagjs.com/components/react/toggle-group).

  <!-- tabs-open -->

  ### Minimal

  ```heex
    <.toggle_group
        class="toggle-group">
        <:item value="a">
            A
        </:item>
        <:item value="b">
            B
        </:item>
        <:item value="c">
            C
        </:item>
      </.toggle_group>
  ```

  ### Extended

  This example assumes the import of `.icon` from `Core Components`

  ```heex

      <.toggle_group multiple={false}
      on_value_change="on_value_change"
      id="toggle-group-id"
      value=["center"]
      class="toggle-group">
      <:item value="left">
       <.icon name="hero-bars-3-bottom-left" />
      </:item>
      <:item value="center">
      <.icon name="hero-bars-3" />
      </:item>
      <:item value="right">
      <.icon name="hero-bars-3-bottom-right" />
      </:item>
    </.toggle_group>

  ```

  ### Controlled

  ```elixir
  defmodule MyAppWeb.ToggleGroupLive do
  use MyAppWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :value, ["lorem"])}
  end

  def handle_event("on_value_change", %{"value" => value}, socket) do
    {:noreply, assign(socket, :value, value)}
  end

  def render(assigns) do
    ~H"""
   <.toggle_group
        class="toggle-group"
        controlled
        value={@value} on_value_change="on_value_change" >
        <:item value="a">
            A
        </:item>
        <:item value="b">
            B
        </:item>
        <:item value="c">
            C
        </:item>
      </.toggle_group>
  """
  end
  end

  ```
  <!-- tabs-close -->

  ## Programmatic Control

  ***Client-side***

  ```heex
  <button phx-click={Corex.ToggleGroup.set_value("my-toggle-group", ["item-1"])}>
    Toggle Group Item 1
  </button>

  ```

    ***Server-side***

    ```elixir
  def handle_event("open_item", _, socket) do
    {:noreply, Corex.ToggleGroup.set_value(socket, "my-toggle-group", ["item-1"])}
  end
  ```

  ## Styling

  Use data attributes to target elements:

  ```css
  [data-scope="toggle-group"][data-part="root"] {}
  [data-scope="toggle-group"][data-part="item"] {}
  ```

  If you wish to use the default Corex styling, you can use the class `toggle-group` on the component.
  This requires to install `Mix.Tasks.Corex.Design` first and import the component css file.

  ```css
  @import "../corex/main.css";
  @import "../corex/tokens/themes/neo/light.css";
  @import "../corex/components/toggle-group.css";
  ```

  You can then use modifiers

  ```heex
  <.toggle_group class="toggle-group toggle-group--accent toggle-group--lg">
  ```

  Learn more about modifiers and [Corex Design](https://corex-ui.com/components/toggle-group#modifiers)
  '''

  @doc type: :component
  use Phoenix.Component

  alias Corex.ToggleGroup.Anatomy.{Props, Root, Item}
  alias Corex.ToggleGroup.Connect

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
      assign_new(assigns, :id, fn -> "toggle-group-#{System.unique_integer([:positive])}" end)

    ~H"""
    <div id={@id} phx-hook="ToggleGroup" {@rest}
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
      <div {Connect.root(%Root{id: @id, disabled: @disabled, orientation: @orientation, dir: @dir})}>
        <button :for={{item_entry, index} <- Enum.with_index(@item)}
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
  @doc """
  Sets the toggle group value from client-side. Returns a `Phoenix.LiveView.JS` command.

  ## Examples

      <button phx-click={Corex.ToggleGroup.set_value("my-toggle-group", ["item-1"])}>
        Open Item 1
      </button>
  """
  def set_value(toggle_group_id, value) when is_binary(toggle_group_id) do
    Phoenix.LiveView.JS.dispatch("phx:toggle-group:set-value",
      to: "##{toggle_group_id}",
      detail: %{value: Connect.validate_value!(value)}
    )
  end

  @doc type: :api
  @doc """
  Sets the toggle group value from server-side. Pushes a LiveView event.

  ## Examples

      def handle_event("open_item", _params, socket) do
        socket = Corex.ToggleGroup.set_value(socket, "my-toggle-group", ["item-1"])
        {:noreply, socket}
      end
  """
  def set_value(socket, toggle_group_id, value)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(toggle_group_id) do
    Phoenix.LiveView.push_event(socket, "toggle-group_set_value", %{
      id: toggle_group_id,
      value: Connect.validate_value!(value)
    })
  end
end
