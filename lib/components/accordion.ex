defmodule Corex.Accordion do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Accordion](https://zagjs.com/components/react/accordion).

  ## Examples

  <!-- tabs-open -->

  ### List

  You can use `Corex.Content.new/1` to create a list of content items.

  The `id` for each item is optional and will be auto-generated if not provided.

  You can specify `disabled` for each item.

  ```heex
  <.accordion
    class="accordion"
    items={Corex.Content.new([
      [trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."],
      [trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."],
      [trigger: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."]
    ])}
  />
  ```

  ### List Custom

  Similar to List but render a custom item slot that will be used for all items.

  Use `{item.data.trigger}` and `{item.data.content}` to render the trigger and content for each item.

  This example assumes the import of `.icon` from `Core Components`

  ```heex
  <.accordion
    class="accordion"
    items={Corex.Content.new([
      [
        id: "lorem",
        trigger: "Lorem ipsum dolor sit amet",
        content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique.",
        meta: %{indicator: "hero-chevron-right"}
      ],
      [
        trigger: "Duis dictum gravida odio ac pharetra?",
        content: "Nullam eget vestibulum ligula, at interdum tellus.",
        meta: %{indicator: "hero-chevron-right"}
      ],
      [
        id: "donec",
        trigger: "Donec condimentum ex mi",
        content: "Congue molestie ipsum gravida a. Sed ac eros luctus.",
        disabled: true,
        meta: %{indicator: "hero-chevron-right"}
      ]
    ])}
  >
    <:item :let={item}>
      <.accordion_trigger item={item}>
        {item.data.trigger}
        <:indicator>
          <.icon name={item.data.meta.indicator} />
        </:indicator>
      </.accordion_trigger>

      <.accordion_content item={item}>
        {item.data.content}
      </.accordion_content>
    </:item>
  </.accordion>
  ```

  ### Controlled

  Render an accordion controlled by the server.

  You must use the `on_value_change` event to update the value on the server and pass the value as a list of strings.

  The event will receive the value as a map with the key `value` and the id of the accordion.

  ```elixir
  defmodule MyAppWeb.AccordionLive do
    use MyAppWeb, :live_view

    def mount(_params, _session, socket) do
      {:ok, assign(socket, :value, ["lorem"])}
    end

    def handle_event("on_value_change", %{"value" => value}, socket) do
      {:noreply, assign(socket, :value, value)}
    end

    def render(assigns) do
      ~H"""
      <.accordion
        controlled
        value={@value}
        on_value_change="on_value_change"
        class="accordion"
        items={Corex.Content.new([
          [id: "lorem", trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique. Proin quis risus feugiat tellus iaculis fringilla."],
          [id: "duis", trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus. Quisque feugiat, dui ut fermentum sodales, lectus metus dignissim ex."]
        ])}
      />
      """
    end
  end
  ```

  ### Async

  When the initial props are not available on mount, you can use the `Phoenix.LiveView.assign_async` function to assign the props asynchronously

  You can use the optional `Corex.Accordion.accordion_skeleton/1` to render a loading or error state

  ```elixir
  defmodule MyAppWeb.AccordionAsyncLive do
    use MyAppWeb, :live_view

    def mount(_params, _session, socket) do
      socket =
        socket
        |> assign_async(:accordion, fn ->
          Process.sleep(1000)

          items = Corex.Content.new([
            [
              id: "lorem",
              trigger: "Lorem ipsum dolor sit amet",
              content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique.",
              disabled: true
            ],
            [
              id: "duis",
              trigger: "Duis dictum gravida odio ac pharetra?",
              content: "Nullam eget vestibulum ligula, at interdum tellus."
            ],
            [
              id: "donec",
              trigger: "Donec condimentum ex mi",
              content: "Congue molestie ipsum gravida a. Sed ac eros luctus."
            ]
          ])

          {:ok,
           %{
             accordion: %{
               items: items,
               value: ["duis", "donec"]
             }
           }}
        end)

      {:ok, socket}
    end

    def render(assigns) do
      ~H"""
      <.async_result :let={accordion} assign={@accordion}>
        <:loading>
          <.accordion_skeleton count={3} class="accordion" />
        </:loading>

        <:failed>
          there was an error loading the accordion
        </:failed>

        <.accordion
          id="async-accordion"
          class="accordion"
          items={accordion.items}
          value={accordion.value}
        />
      </.async_result>
      """
    end
  end
  ```
  <!-- tabs-close -->

  ## API Control

  In order to use the API, you must use an id on the component

  ***Client-side***

  ```heex
  <button phx-click={Corex.Accordion.set_value("my-accordion", ["item-1"])}>
    Open Item 1
  </button>
  ```

  ***Server-side***

  ```elixir
  def handle_event("open_item", _, socket) do
    {:noreply, Corex.Accordion.set_value(socket, "my-accordion", ["item-1"])}
  end
  ```

  ## Styling

  Use data attributes to target elements:

  ```css
  [data-scope="accordion"][data-part="root"] {}
  [data-scope="accordion"][data-part="item"] {}
  [data-scope="accordion"][data-part="item-trigger"] {}
  [data-scope="accordion"][data-part="item-content"] {}
  [data-scope="accordion"][data-part="item-indicator"] {}
  ```

  If you wish to use the default Corex styling, you can use the class `accordion` on the component.
  This requires to install mix corex.design first and import the component css file.

  ```css
  @import "../corex/main.css";
  @import "../corex/tokens/themes/neo/light.css";
  @import "../corex/components/accordion.css";
  ```

  You can then use modifiers

  ```heex
  <.accordion class="accordion accordion--accent accordion--lg">
  ```

  Learn more about modifiers and [Corex Design](https://corex-ui.com/components/accordion#modifiers)
  '''

  @doc type: :component
  use Phoenix.Component

  alias Corex.Accordion.Anatomy.{Props, Root, Item}
  alias Corex.Accordion.Connect
  import Corex.Helpers, only: [validate_value!: 1]

  alias Phoenix.LiveView.JS

  @doc """
  Renders an accordion component.

  Pass `items` as a list of `%Corex.Content.Item{}` structs. Optionally provide an `:item` slot to customize how each item is rendered (trigger and content).

  Each item MUST be a `%Corex.Content.Item{}` struct with:
  - `:id` (optional, auto-generated) - unique identifier for the item
  - `:trigger` (required) - content for the trigger button
  - `:content` (required) - content for the accordion panel
  - `:disabled` (optional, default: false) - whether the item is disabled
  - `:meta` (optional) - additional metadata for the item
  """

  attr(:id, :string,
    required: false,
    doc: "The id of the accordion, useful for API to identify the accordion"
  )

  attr(:items, :list,
    required: true,
    doc: "The items of the accordion, must be a list of %Corex.Content.Item{} structs"
  )

  attr(:value, :list,
    default: [],
    doc: "The initial value or the controlled value of the accordion, must be a list of strings"
  )

  attr(:controlled, :boolean,
    default: false,
    doc:
      "Whether the accordion is controlled. Only in LiveView, the on_value_change event is required"
  )

  attr(:collapsible, :boolean, default: true, doc: "Whether the accordion is collapsible")

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
    default: nil,
    values: [nil, "ltr", "rtl"],
    doc:
      "The direction of the accordion. When nil, derived from document (html lang + config :rtl_locales)"
  )

  attr(:on_value_change, :string,
    default: nil,
    doc: "The server event name when the value change"
  )

  attr(:on_value_change_client, :string,
    default: nil,
    doc: "The client event name when the value change"
  )

  attr(:on_focus_change, :string,
    default: nil,
    doc: "The server event name when the focus change"
  )

  attr(:on_focus_change_client, :string,
    default: nil,
    doc: "The client event name when the focus change"
  )

  attr(:rest, :global)

  slot(:item,
    required: false,
    doc:
      "Optional slot to customize how each item is rendered. Receives the item (list entry) as argument."
  )

  def accordion(assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> "accordion-#{System.unique_integer([:positive])}" end)
      |> validate_items()

    ~H"""
    <div id={@id} phx-hook="Accordion" data-items={items_data_json(@items)} {@rest}
    {Connect.props(%Props{
      id: @id,
      controlled: @controlled,
      value: @value,
      collapsible: @collapsible,
      multiple: @multiple,
      orientation: @orientation,
      dir: @dir,
      on_value_change: @on_value_change,
      on_value_change_client: @on_value_change_client,
      on_focus_change: @on_focus_change,
      on_focus_change_client: @on_focus_change_client
    })}>
      <div phx-update="ignore" {Connect.root(%Root{id: @id, orientation: @orientation, dir: @dir})}>
        <div :if={@item == []} :for={{item_entry, index} <- Enum.with_index(@items)} phx-mounted={JS.ignore_attributes(["data-state"])} {Connect.item(%Item{
          id: @id,
          value: item_entry.id || "item-#{index}",
          disabled: item_entry.disabled,
          values: @value,
          orientation: @orientation,
          dir: @dir,
        })}>
          <.accordion_trigger item={%Item{
            id: @id,
            value: item_entry.id || "item-#{index}",
            disabled: item_entry.disabled,
            values: @value,
            orientation: @orientation,
            dir: @dir,
            data: %{
              trigger: item_entry.trigger,
              content: item_entry.content,
              meta: item_entry.meta
            }
          }}>
            {item_entry.trigger}
          </.accordion_trigger>
          <.accordion_content item={%Item{
            id: @id,
            value: item_entry.id || "item-#{index}",
            disabled: item_entry.disabled,
            values: @value,
            orientation: @orientation,
            dir: @dir,
            data: %{
              trigger: item_entry.trigger,
              content: item_entry.content,
              meta: item_entry.meta
            }
          }}>
            {item_entry.content}
          </.accordion_content>
        </div>

        <div :if={@item != []} :for={{item_entry, index} <- Enum.with_index(@items)} phx-mounted={JS.ignore_attributes(["data-state"])} {Connect.item(%Item{
          id: @id,
          value: item_entry.id || "item-#{index}",
          disabled: item_entry.disabled,
          values: @value,
          orientation: @orientation,
          dir: @dir,
          data: %{
            trigger: item_entry.trigger,
            content: item_entry.content,
            meta: item_entry.meta
          }
        })}>
          <%= for item_slot <- @item || [] do %>
            <%= render_slot(item_slot, %Item{
              id: @id,
              value: item_entry.id || "item-#{index}",
              disabled: Map.get(item_entry, :disabled, false),
              values: @value,
              orientation: @orientation,
              dir: @dir,
              data: %{
                trigger: item_entry.trigger,
                content: item_entry.content,
                meta: item_entry.meta
              }
            }) %>
          <% end %>
        </div>
      </div>
    </div>
    """
  end

  defp validate_items(%{items: nil} = _assigns) do
    raise ArgumentError, """
    accordion requires :items to be a list of %Corex.Content.Item{} structs.

    Example:

        items = Corex.Content.new([
          [trigger: "Trigger text", content: "Content text"],
          [trigger: "Another trigger", content: "More content", disabled: true]
        ])
        <.accordion items={items} />
    """
  end

  defp validate_items(%{items: items} = assigns) when is_list(items) do
    Enum.each(items, fn item ->
      unless is_struct(item, Corex.Content.Item) do
        raise ArgumentError, """
        Invalid item in :items attribute. Expected %Corex.Content.Item{} struct, got: #{inspect(item)}

        Please use Corex.Content.new/1:

        items = Corex.Content.new([
          [trigger: "Trigger text", content: "Content text"],
          [trigger: "Another trigger", content: "More content", disabled: true]
        ])
        """
      end
    end)

    assigns
  end

  defp validate_items(assigns), do: assigns

  defp items_data_json(items) when is_list(items) do
    items
    |> Enum.with_index()
    |> Enum.map(fn {item, i} ->
      %{"value" => item.id || "item-#{i}", "disabled" => !!item.disabled}
    end)
    |> Jason.encode!()
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
      <button {Connect.trigger(@item)}>
      <span data-scope="accordion" data-part="item-text">
      {render_slot(@inner_block)}
      </span>
        <span :if={@indicator} {Connect.indicator(@item)}>
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
    <div {Connect.content(@item)} >
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
    <div {@rest}>
    <div data-scope="accordion" data-part="root" data-loading>
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
      detail: %{value: validate_value!(value)},
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
      value: validate_value!(value)
    })
  end
end
