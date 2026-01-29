defmodule Corex.Accordion do
  @moduledoc """
  Phoenix implementation of [Zag.js Accordion](https://zagjs.com/components/react/accordion).

  ## Basic Usage

  ```heex
  <.accordion>
  <:item :let={item}>
    <.accordion_trigger item={item}>
      Lorem ipsum dolor sit amet
    </.accordion_trigger>
    <.accordion_content item={item}>
      Consectetur adipiscing elit. Sed sodales ullamcorper tristique. Proin quis risus feugiat tellus iaculis fringilla.
    </.accordion_content>
  </:item>
  <:item :let={item}>
    <.accordion_trigger item={item}>
      Duis dictum gravida odio ac pharetra?
    </.accordion_trigger>
    <.accordion_content item={item}>
      Nullam eget vestibulum ligula, at interdum tellus. Quisque feugiat, dui ut fermentum sodales, lectus metus dignissim ex.
    </.accordion_content>
  </:item>
  </.accordion>
  ```

  ## Controlled Mode

  ```heex
  <.accordion controlled value={@accordion_value} on_value_change="accordion_changed">
  <:item :let={item}>
    <.accordion_trigger item={item}>
      Lorem ipsum dolor sit amet
    </.accordion_trigger>
    <.accordion_content item={item}>
      Consectetur adipiscing elit. Sed sodales ullamcorper tristique. Proin quis risus feugiat tellus iaculis fringilla.
    </.accordion_content>
  </:item>
  <:item :let={item}>
    <.accordion_trigger item={item}>
      Duis dictum gravida odio ac pharetra?
    </.accordion_trigger>
    <.accordion_content item={item}>
      Nullam eget vestibulum ligula, at interdum tellus. Quisque feugiat, dui ut fermentum sodales, lectus metus dignissim ex.
    </.accordion_content>
  </:item>
  </.accordion>
  ```

  ```elixir
  def handle_event("accordion_changed", %{"value" => values}, socket) do
    {:noreply, assign(socket, :accordion_value, values)}
  end
  ```

  ## Programmatic Control

  ```heex
  # Client-side
  <button phx-click={Corex.Accordion.set_value("my-accordion", ["item-1"])}>
    Open Item 1
  </button>

  # Server-side
  def handle_event("open_item", _, socket) do
    {:noreply, Corex.Accordion.set_value(socket, "my-accordion", ["item-1"])}
  end
  ```

  ## Styling

  Use data attributes to target elements:
  - `[data-scope="accordion"][data-part="root"]` - Container
  - `[data-scope="accordion"][data-part="item"]` - Item wrapper
  - `[data-scope="accordion"][data-part="item-trigger"]` - Trigger button
  - `[data-scope="accordion"][data-part="item-content"]` - Content area
  - `[data-scope="accordion"][data-part="item-indicator"]` - Optional indicator
  """

  @doc type: :component
  use Phoenix.Component

  alias Corex.Accordion.Anatomy.{Props, Root, Item}
  alias Corex.Accordion.Connect

  @doc """
  Renders an accordion component.
  """

  attr(:id, :string,
    required: false,
    doc: "The id of the accordion, useful for API to identify the accordion"
  )

  attr(:value, :list,
    default: [],
    doc: "The initial value or the controlled value of the accordion, must be a list of strings"
  )

  attr(:controlled, :boolean, default: false, doc: "Whether the accordion is controlled")
  attr(:collapsible, :boolean, default: true, doc: "Whether the accordion is collapsible")
  attr(:disabled, :boolean, default: false, doc: "Whether the accordion is disabled")

  attr(:multiple, :boolean,
    default: true,
    doc: "Whether the accordion allows multiple items to be selected"
  )

  attr(:orientation, :string,
    default: "vertical",
    values: ["horizontal", "vertical"],
    doc: "The orientation of the accordion"
  )

  attr(:dir, :string,
    default: "ltr",
    values: ["ltr", "rtl"],
    doc: "The direction of the accordion"
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
  end

  def accordion(assigns) do
    assigns =
      assign_new(assigns, :id, fn -> "accordion-#{System.unique_integer([:positive])}" end)

    ~H"""
    <div id={@id} phx-hook="Accordion" {@rest}
    {Connect.props(%Props{
      id: assigns.id,
      controlled: assigns.controlled,
      value: assigns.value,
      collapsible: assigns.collapsible,
      disabled: assigns.disabled,
      multiple: assigns.multiple,
      orientation: assigns.orientation,
      dir: assigns.dir,
      on_value_change: assigns.on_value_change,
      on_value_change_client: assigns.on_value_change_client
    })}>
      <div {Connect.root(%Root{id: assigns.id, orientation: assigns.orientation, dir: assigns.dir, changed: if(assigns.__changed__, do: true, else: false)})}>
        <div :for={{item_entry, index} <- Enum.with_index(@item)}
        {Connect.item(%Item{
          id: assigns.id,
          changed: if(assigns.__changed__, do: true, else: false),
          value: Map.get(item_entry, :value, "item-#{index}"),
          disabled: Map.get(item_entry, :disabled, false),
          values: assigns.value, orientation: assigns.orientation,
          dir: assigns.dir,
          disabled_root: assigns.disabled})}>
        <%= render_slot(item_entry, %Item{
          id: assigns.id,
          changed: if(assigns.__changed__, do: true, else: false),
          value: Map.get(item_entry, :value, "item-#{index}"),
          disabled: Map.get(item_entry, :disabled, false),
          values: assigns.value,
          orientation: assigns.orientation,
          dir: assigns.dir,
          disabled_root: assigns.disabled})
          %>
        </div>
      </div>
    </div>
    """
  end

  @doc type: :component
  @doc """
  Renders the accordion trigger button. Includes optional `:indicator` slot.
  """
  attr(:item, :map, required: true)
  slot(:inner_block, required: true)
  slot(:indicator, required: false)

  def accordion_trigger(assigns) do
    ~H"""
    <h3>
      <button {Connect.trigger(assigns.item)}>
      <span data-scope="accordion" data-part="item-text">
      {render_slot(@inner_block)}
      </span>
        <span :if={@indicator} {Connect.indicator(assigns.item)}>
          {render_slot(@indicator)}
        </span>
      </button>
    </h3>
    """
  end

  @doc type: :component
  @doc """
  Renders the accordion content area.
  """

  attr(:item, :map, required: true)
  slot(:inner_block, required: true)

  def accordion_content(assigns) do
    ~H"""
    <div {Connect.content(assigns.item)} >
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc type: :component
  @doc """
  Renders a loading skeleton for the accordion component.
  """
  attr(:count, :integer, default: 3)
  attr(:rest, :global)
  slot(:trigger)
  slot(:indicator)
  slot(:content)

  def accordion_skeleton(assigns) do
    ~H"""
    <div class="accordion loading" {@rest}>
    <div data-scope="accordion" data-part="root">
    <div :for={item <- 1..@count} data-scope="accordion" data-part="item">
      <div data-scope="accordion" data-part="item-trigger">
      <span data-scope="accordion" data-part="item-text">
      {render_slot(@trigger)}
      </span>
      <span data-scope="accordion" data-part="item-indicator">
      {render_slot(@indicator)}
      </span>
      </div>
      </div>
    </div>
    </div>
    """
  end

  @doc type: :api
  @doc """
  Sets the accordion value from client-side. Returns a `Phoenix.LiveView.JS` command.

  ## Examples

      <button phx-click={Corex.Accordion.set_value("my-accordion", ["item-1"])}>
        Open Item 1
      </button>
  """
  def set_value(accordion_id, value) when is_binary(accordion_id) do
    Phoenix.LiveView.JS.dispatch("phx:accordion:set-value",
      to: "##{accordion_id}",
      detail: %{value: Connect.validate_value!(value)},
      bubbles: false
    )
  end

  @doc type: :api
  @doc """
  Sets the accordion value from server-side. Pushes a LiveView event.

  ## Examples

      def handle_event("open_item", _params, socket) do
        socket = Corex.Accordion.set_value(socket, "my-accordion", ["item-1"])
        {:noreply, socket}
      end
  """
  def set_value(socket, accordion_id, value)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(accordion_id) do
    Phoenix.LiveView.push_event(socket, "accordion_set_value", %{
      accordion_id: accordion_id,
      value: Connect.validate_value!(value)
    })
  end
end
