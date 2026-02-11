defmodule Corex.Tabs do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Tabs](https://zagjs.com/components/react/tabs).

  ## Examples

  <!-- tabs-open -->

  ### List

  You can use `Corex.Content.new/1` to create a list of content items.

  The `id` for each item is optional and will be auto-generated if not provided.

  You can specify `disabled` for each item.

  ```heex
  <.tabs
    class="tabs"
    items={Corex.Content.new([
      [trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."],
      [trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."],
      [trigger: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."]
    ])}
  />
  ```

  ### List Custom

  Similar to List but render custom trigger and content slots that will be used for all items.

  Use `:trigger` and `:content` slots to customize the rendering. Each slot receives the item data.

  ```heex
          <.tabs
    class="tabs"
    value="lorem"
    items={Corex.Content.new([
      [id: "lorem", trigger: "Lorem", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique.", meta: %{indicator: "hero-chevron-right"}],
      [trigger: "Duis", content: "Nullam eget vestibulum ligula, at interdum tellus.", meta: %{indicator: "hero-chevron-right"}],
      [id: "donec", trigger: "Donec", content: "Congue molestie ipsum gravida a. Sed ac eros luctus.", disabled: true]
    ])}
  >
    <:trigger :let={item}>
      {item.data.trigger}
    </:trigger>
    <:content :let={item}>
      {item.data.content}
    </:content>
  </.tabs>
  ```

  ### Custom

  Render custom trigger and content slots for each tab item manually.

  Use `:trigger` slot for the tab button and `:content` slot for the tab panel content.
  Each slot accepts a `value` attribute to identify the tab item.

  ```heex
  <.tabs id="my-tabs" value="duis" class="tabs">
    <:trigger value="lorem">
      Lorem ipsum dolor sit amet
    </:trigger>
    <:content value="lorem">
      Consectetur adipiscing elit. Sed sodales ullamcorper tristique. Proin quis risus feugiat tellus iaculis fringilla.
    </:content>
    <:trigger value="duis">
      Duis dictum gravida odio ac pharetra?
    </:trigger>
    <:content value="duis">
      Nullam eget vestibulum ligula, at interdum tellus. Quisque feugiat, dui ut fermentum sodales, lectus metus dignissim ex.
    </:content>
    <:trigger value="donec" disabled>
      Donec condimentum ex mi
    </:trigger>
    <:content value="donec">
      Congue molestie ipsum gravida a. Sed ac eros luctus.
    </:content>
  </.tabs>
  ```

  ### Controlled

  Render tabs controlled by the server.

  You must use the `on_value_change` event to update the value on the server and pass the value as a string.

  The event will receive the value as a map with the key `value` and the id of the tabs.

  ```elixir
  defmodule MyAppWeb.TabsLive do
  use MyAppWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :value, "lorem")}
  end

  def handle_event("on_value_change", %{"value" => value}, socket) do
    {:noreply, assign(socket, :value, value)}
  end

  def render(assigns) do
    ~H"""
    <.tabs controlled value={@value} on_value_change="on_value_change" class="tabs">
      <:trigger value="lorem">
        Lorem ipsum dolor sit amet
      </:trigger>
      <:content value="lorem">
        Consectetur adipiscing elit. Sed sodales ullamcorper tristique. Proin quis risus feugiat tellus iaculis fringilla.
      </:content>
      <:trigger value="duis">
        Duis dictum gravida odio ac pharetra?
      </:trigger>
      <:content value="duis">
        Nullam eget vestibulum ligula, at interdum tellus. Quisque feugiat, dui ut fermentum sodales, lectus metus dignissim ex.
      </:content>
    </.tabs>
  """
  end
  end

  ```

  ### Async

  When the initial props are not available on mount, you can use the `Phoenix.LiveView.assign_async` function to assign the props asynchronously

  You can use the optional `Corex.Tabs.tabs_skeleton/1` to render a loading or error state

  ```elixir
  defmodule MyAppWeb.TabsAsyncLive do
  use MyAppWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign_async(:tabs, fn ->
        Process.sleep(1000)

        items = Corex.Content.new([
          [id: "lorem", trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique.", disabled: true],
          [id: "duis", trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."],
          [id: "donec", trigger: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."]
        ])

        {:ok,
         %{
           tabs: %{
             items: items,
             value: "duis"
           }
         }}
      end)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
      <.async_result :let={tabs} assign={@tabs}>
        <:loading>
          <.tabs_skeleton count={3} class="tabs" />
        </:loading>

        <:failed>
          there was an error loading the tabs
        </:failed>

        <.tabs
          id="async-tabs"
          class="tabs"
          items={tabs.items}
          value={tabs.value}
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
  <button phx-click={Corex.Tabs.set_value("my-tabs", "item-1")}>
    Open Item 1
  </button>

  ```

  ***Server-side***

  ```elixir
  def handle_event("open_item", _, socket) do
    {:noreply, Corex.Tabs.set_value(socket, "my-tabs", "item-1")}
  end
  ```

  ## Styling

  Use data attributes to target elements:

  ```css
  [data-scope="tabs"][data-part="root"] {}
  [data-scope="tabs"][data-part="item"] {}
  [data-scope="tabs"][data-part="item-trigger"] {}
  [data-scope="tabs"][data-part="item-content"] {}
  [data-scope="tabs"][data-part="item-indicator"] {}
  ```

  If you wish to use the default Corex styling, you can use the class `tabs` on the component.
  This requires to install mix corex.design first and import the component css file.

  ```css
  @import "../corex/main.css";
  @import "../corex/tokens/themes/neo/light.css";
  @import "../corex/components/tabs.css";
  ```

  You can then use modifiers

  ```heex
  <.tabs class="tabs tabs--accent tabs--lg">
  ```

  Learn more about modifiers and [Corex Design](https://corex-ui.com/components/tabs#modifiers)

  '''

  @doc type: :component
  use Phoenix.Component

  alias Corex.Tabs.Anatomy.{Props, Root, List, Trigger, Content}
  alias Corex.Tabs.Connect

  @doc """
  Renders a tabs component.

  You can use either:
  - The `:trigger` and `:content` slots for manual tab definition with full control
  - The `:items` attribute for programmatic tab generation from a list of content items

  Use `Corex.Content.new/1` to create items.

  When using `:trigger` and `:content` slots:
  - Each `:trigger` slot should have a `value` attribute to identify the tab
  - Each `:content` slot should have a matching `value` attribute
  - Triggers are rendered in the list, content panels are rendered outside the list
  """

  attr(:id, :string,
    required: false,
    doc: "The id of the tabs, useful for API to identify the tabs"
  )

  attr(:items, :list,
    default: nil,
    doc: "The items of the tabs, must be a list of content items"
  )

  attr(:value, :string,
    default: nil,
    doc: "The initial value or the controlled value of the tabs, must be a string"
  )

  attr(:controlled, :boolean,
    default: false,
    doc: "Whether the tabs is controlled. Only in LiveView, the on_value_change event is required"
  )

  attr(:collapsible, :boolean, default: true, doc: "Whether the tabs is collapsible")

  attr(:multiple, :boolean,
    default: true,
    doc: "Whether the tabs allows multiple items to be selected"
  )

  attr(:orientation, :string,
    default: "horizontal",
    values: ["horizontal", "vertical"],
    doc: "The orientation of the tabs"
  )

  attr(:dir, :string,
    default: nil,
    values: [nil, "ltr", "rtl"],
    doc:
      "The direction of the tabs. When nil, derived from document (html lang + config :rtl_locales)"
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

  slot :trigger, required: false do
    attr(:value, :string,
      doc: "The value of the trigger, useful in controlled mode and for API to identify the item"
    )

    attr(:disabled, :boolean, doc: "Whether the trigger is disabled")
  end

  slot :content, required: false do
    attr(:value, :string,
      doc: "The value of the content, must match the corresponding trigger value"
    )

    attr(:disabled, :boolean, doc: "Whether the content is disabled")
  end

  def tabs(assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> "tabs-#{System.unique_integer([:positive])}" end)
      |> validate_items()
      |> assign(:items_list, build_items_list(assigns))
      |> assign(
        :values,
        if(is_binary(assigns.value), do: [assigns.value], else: [])
      )

    ~H"""
    <div id={@id} phx-hook="Tabs" data-items={Corex.Json.encode!(@items_list)} {@rest}
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
      <div {Connect.root(%Root{id: @id, orientation: @orientation, dir: @dir})}>
        <div {Connect.list(%List{id: @id, orientation: @orientation, dir: @dir})}>
            <button
            :if={@items && @trigger == []} :for={{item_entry, index} <- Enum.with_index(@items || [])}
             {Connect.trigger(%Trigger{
              id: @id,
              value: item_entry.id || item_entry.value || "item-#{index}",
              disabled: item_entry.disabled,
              values: @values,
              orientation: @orientation,
              dir: @dir
            })}>
              {item_entry.trigger}
            </button>

          <div :if={@items && @trigger != []} :for={{item_entry, index} <- Enum.with_index(@items || [])}>
            <div :for={trigger_slot <- @trigger || []}>
              <% item_data = %{
                id: @id,
                value: item_entry.id || item_entry.value || "item-#{index}",
                disabled: item_entry.disabled,
                values: @values,
                orientation: @orientation,
                dir: @dir,
                data: %{
                  trigger: Map.get(item_entry, :trigger, ""),
                  content: Map.get(item_entry, :content, ""),
                  meta: Map.get(item_entry, :meta, %{})
                }
              } %>
              <.tabs_trigger item={item_data}>
                {render_slot(trigger_slot, item_data)}
              </.tabs_trigger>
            </div>
          </div>

          <div :if={@items == nil && @trigger != []} :for={{trigger_entry, index} <- Enum.with_index(@trigger)}>
            <.tabs_trigger item={%{
              id: @id,
              value: Map.get(trigger_entry, :value, "item-#{index}"),
              disabled: Map.get(trigger_entry, :disabled, false),
              values: @values,
              orientation: @orientation,
              dir: @dir
            }}>
              {render_slot(trigger_entry)}
            </.tabs_trigger>
          </div>
        </div>

        <div :if={@items && @content == []} :for={{item_entry, index} <- Enum.with_index(@items || [])} {Connect.content(%Content{
          id: @id,
          value: item_entry.id || item_entry.value || "item-#{index}",
          disabled: item_entry.disabled,
          values: @values,
          orientation: @orientation,
          dir: @dir
        })}>
          {item_entry.content}
        </div>

        <div :if={@items && @content != []} :for={{item_entry, index} <- Enum.with_index(@items || [])}>
          <div :for={content_slot <- @content || []}>
            <% item_data = %{
              id: @id,
              value: item_entry.id || item_entry.value || "item-#{index}",
              disabled: item_entry.disabled,
              values: @values,
              orientation: @orientation,
              dir: @dir,
              data: %{
                trigger: Map.get(item_entry, :trigger, ""),
                content: Map.get(item_entry, :content, ""),
                meta: Map.get(item_entry, :meta, %{})
              }
            } %>
            <.tabs_content item={item_data}>
              {render_slot(content_slot, item_data)}
            </.tabs_content>
          </div>
        </div>

        <div :if={@items == nil && @content != []} :for={{content_entry, index} <- Enum.with_index(@content)}>
          <.tabs_content item={%{
            id: @id,
            value: Map.get(content_entry, :value, "item-#{index}"),
            disabled: Map.get(content_entry, :disabled, false),
            values: @values,
            orientation: @orientation,
            dir: @dir
          }}>
            {render_slot(content_entry)}
          </.tabs_content>
        </div>
      </div>
    </div>
    """
  end

  defp build_items_list(%{items: items}) when is_list(items) do
    Enum.map(Enum.with_index(items), fn {item_entry, index} ->
      %{
        value: item_entry.id || item_entry.value || "item-#{index}",
        disabled: Map.get(item_entry, :disabled, false)
      }
    end)
  end

  defp build_items_list(%{trigger: trigger_slots}) when is_list(trigger_slots) do
    Enum.map(Enum.with_index(trigger_slots), fn {trigger_entry, index} ->
      %{
        value: Map.get(trigger_entry, :value, "item-#{index}"),
        disabled: Map.get(trigger_entry, :disabled, false)
      }
    end)
  end

  defp build_items_list(_), do: []

  defp validate_items(%{items: nil} = assigns), do: assigns

  defp validate_items(%{items: items} = assigns) when is_list(items) do
    Enum.each(items, fn item ->
      unless is_map(item) do
        raise ArgumentError, """
        Invalid item in :items attribute. Expected a map, got: #{inspect(item)}

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

  @doc type: :component
  @doc """
  Renders the tabs trigger button.
  """
  attr(:item, :map, required: true)
  slot(:inner_block, required: true)

  def tabs_trigger(assigns) do
    ~H"""
      <button {Connect.trigger(%Trigger{
        id: @item.id,
        value: @item.value,
        disabled: @item.disabled,
        values: @item.values,
        orientation: @item.orientation,
        dir: @item.dir
      })}>
        {render_slot(@inner_block)}
      </button>
    """
  end

  @doc type: :component
  @doc """
  Renders the tabs content area.
  """

  attr(:item, :map, required: true)
  slot(:inner_block, required: true)

  def tabs_content(assigns) do
    ~H"""
    <div {Connect.content(%Content{
      id: @item.id,
      value: @item.value,
      disabled: @item.disabled,
      values: @item.values,
      orientation: @item.orientation,
      dir: @item.dir
    })}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc type: :component
  @doc """
  Renders a loading skeleton for the tabs component.
  """
  attr(:count, :integer, default: 3)
  attr(:rest, :global)
  slot(:trigger)
  slot(:indicator)
  slot(:content)

  def tabs_skeleton(assigns) do
    ~H"""
    <div {@rest}>
    <div data-scope="tabs" data-part="root" data-loading>
    <div :for={item <- 1..@count} data-scope="tabs" data-part="item">
      <div data-scope="tabs" data-part="item-trigger">
      <span data-scope="tabs" data-part="item-text">
      {render_slot(@trigger)}
      </span>
      <span data-scope="tabs" data-part="item-indicator">
      {render_slot(@indicator)}
      </span>
      </div>
      </div>
    </div>
    </div>
    """
  end

  defp validate_tabs_value!(nil), do: nil
  defp validate_tabs_value!(value) when is_binary(value), do: value

  defp validate_tabs_value!(value),
    do: raise(ArgumentError, "value must be a string or nil, got: #{inspect(value)}")

  @doc type: :api
  @doc """
  Sets the tabs value from client-side. Returns a `Phoenix.LiveView.JS` command.

  ## Examples

      <button phx-click={Corex.Tabs.set_value("my-tabs", "item-1")}>
        Open Item 1
      </button>

      <button phx-click={Corex.Tabs.set_value("my-tabs", nil)}>
        Close all Tabs
      </button>
  """
  def set_value(tabs_id, value) when is_binary(tabs_id) do
    Phoenix.LiveView.JS.dispatch("phx:tabs:set-value",
      to: "##{tabs_id}",
      detail: %{value: validate_tabs_value!(value)},
      bubbles: false
    )
  end

  @doc type: :api
  @doc """
  Sets the tabs value from server-side. Pushes a LiveView event.

  ## Examples

      def handle_event("open_item", _params, socket) do
        socket = Corex.Tabs.set_value(socket, "my-tabs", "item-1")
        {:noreply, socket}
      end

      def handle_event("close_tabs", _params, socket) do
        socket = Corex.Tabs.set_value(socket, "my-tabs", nil)
        {:noreply, socket}
      end
  """
  def set_value(socket, tabs_id, value)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(tabs_id) do
    Phoenix.LiveView.push_event(socket, "tabs_set_value", %{
      tabs_id: tabs_id,
      value: validate_tabs_value!(value)
    })
  end
end
