defmodule Corex.Tabs do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Tabs](https://zagjs.com/components/react/tabs).

  ## Examples

  <!-- tabs-open -->

  ### Basic

  You can use `Corex.Content.new/1` to create a list of content items.

  The `id` for each item is optional and will be auto-generated if not provided.

  You can specify `disabled` for each item.

  ```heex
  <.tabs
    class="tabs"
    items={Corex.Content.new([
      [trigger: "Lorem", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."],
      [trigger: "Duis", content: "Nullam eget vestibulum ligula, at interdum tellus."],
      [trigger: "Donec", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."]
    ])}
  />
  ```

  ### With indicator

  Use the optional `:indicator` slot to add an icon after each trigger.

  ```heex
  <.tabs
    class="tabs"
    items={Corex.Content.new([
      [id: "lorem", trigger: "Lorem", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."],
      [trigger: "Duis", content: "Nullam eget vestibulum ligula, at interdum tellus."],
      [id: "donec", trigger: "Donec", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."]
    ])}
  >
    <:indicator>
      <.icon name="hero-chevron-right" />
    </:indicator>
  </.tabs>
  ```

  ### Custom

  Use `:trigger` and `:content` together to fully customize how each item is rendered. Add the `:indicator` slot to show an icon after each trigger. Use `:let={item}` on slots to access the item and its `data` (including `meta` for per-item customization).

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
    <:indicator :let={item}>
      <.icon name={item.data.meta.indicator} />
    </:indicator>
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
    <.tabs
      controlled
      value={@value}
      on_value_change="on_value_change"
      class="tabs"
      items={Corex.Content.new([
        [id: "lorem", trigger: "Lorem", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique. Proin quis risus feugiat tellus iaculis fringilla."],
        [id: "duis", trigger: "Duis", content: "Nullam eget vestibulum ligula, at interdum tellus. Quisque feugiat, dui ut fermentum sodales, lectus metus dignissim ex."]
      ])}
    />
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
          [id: "lorem", trigger: "Lorem", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique.", disabled: true],
          [id: "duis", trigger: "Duis", content: "Nullam eget vestibulum ligula, at interdum tellus."],
          [id: "donec", trigger: "Donec", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."]
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
  This requires to install `Mix.Tasks.Corex.Design` first and import the component css file.

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

  alias Corex.Tabs.Anatomy.{Content, List, Props, Root, Trigger}
  alias Corex.Tabs.Connect
  alias Phoenix.LiveView
  alias Phoenix.LiveView.JS
  import Corex.Helpers, only: [validate_tabs_value!: 1, validate_content_items_required!: 2, content_items_data_json: 1]

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

  slot :indicator,
    required: false,
    doc:
      "Optional slot for content after each trigger. Use :let={item} for per-item customization." do
    attr(:class, :string, required: false)
  end

  slot :trigger,
    required: false,
    doc:
      "Optional slot for custom trigger rendering. When provided with content, replaces default item rendering. Use :let={item} to access the item." do
    attr(:class, :string, required: false)
  end

  slot :content,
    required: false,
    doc:
      "Optional slot for custom content rendering. When provided with trigger, replaces default item rendering. Use :let={item} to access the item." do
    attr(:class, :string, required: false)
  end

  def tabs(assigns) do
    values = if is_binary(assigns[:value]), do: [assigns.value], else: []
    assigns =
      assign_new(assigns, :id, fn -> "tabs-#{System.unique_integer([:positive])}" end)
      |> validate_content_items_required!("Tabs")
      |> assign(:values, values)

    ~H"""
    <div id={@id} phx-hook="Tabs" data-items={content_items_data_json(@items)} data-js="pending" {@rest}
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
            :if={@trigger == []} :for={{item_entry, index} <- Enum.with_index(@items)}
             {Connect.trigger(%Trigger{
              id: @id,
              value: item_entry.id || "item-#{index}",
              disabled: item_entry.disabled,
              values: @values,
              orientation: @orientation,
              dir: @dir
            })}>
              <span data-scope="tabs" data-part="item-text">
                {item_entry.trigger}
              </span>
              <span :if={@indicator != []} {Connect.indicator(%Trigger{
                id: @id,
                value: item_entry.id || "item-#{index}",
                disabled: item_entry.disabled,
                values: @values,
                orientation: @orientation,
                dir: @dir
              })}>
                <%= for indicator <- @indicator do %>
                  <%= render_slot(indicator, %{
                    id: @id,
                    value: item_entry.id || "item-#{index}",
                    disabled: item_entry.disabled,
                    values: @values,
                    orientation: @orientation,
                    dir: @dir,
                    data: %{
                      trigger: item_entry.trigger,
                      content: item_entry.content,
                      meta: item_entry.meta || %{}
                    }
                  }) %>
                <% end %>
              </span>
            </button>

          <div :if={@trigger != []} :for={{item_entry, index} <- Enum.with_index(@items)}>
            <div :for={trigger_slot <- @trigger}>
              <% item_data = %{
                id: @id,
                value: item_entry.id || "item-#{index}",
                disabled: item_entry.disabled,
                values: @values,
                orientation: @orientation,
                dir: @dir,
                data: %{
                  trigger: item_entry.trigger,
                  content: item_entry.content,
                  meta: item_entry.meta || %{}
                }
              } %>
              <.tabs_trigger item={item_data} indicator={@indicator}>
                {render_slot(trigger_slot, item_data)}
              </.tabs_trigger>
            </div>
          </div>

        </div>

        <div :if={@content == []} :for={{item_entry, index} <- Enum.with_index(@items)} {Connect.content(%Content{
          id: @id,
          value: item_entry.id || "item-#{index}",
          disabled: item_entry.disabled,
          values: @values,
          orientation: @orientation,
          dir: @dir
        })}>
          {item_entry.content}
        </div>

        <div :if={@content != []} :for={{item_entry, index} <- Enum.with_index(@items)}>
          <div :for={content_slot <- @content}>
            <% item_data = %{
              id: @id,
              value: item_entry.id || "item-#{index}",
              disabled: item_entry.disabled,
              values: @values,
              orientation: @orientation,
              dir: @dir,
              data: %{
                trigger: item_entry.trigger,
                content: item_entry.content,
                meta: item_entry.meta || %{}
              }
            } %>
            <.tabs_content item={item_data}>
              {render_slot(content_slot, item_data)}
            </.tabs_content>
          </div>
        </div>

      </div>
    </div>
    """
  end

  @doc type: :component
  @doc """
  Renders the tabs trigger button.
  """
  attr(:item, :map, required: true)
  attr(:indicator, :list, default: [])
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
      <span data-scope="tabs" data-part="item-text">
        {render_slot(@inner_block)}
      </span>
      <span :if={@indicator != []} {Connect.indicator(%Trigger{
        id: @item.id,
        value: @item.value,
        disabled: @item.disabled,
        values: @item.values,
        orientation: @item.orientation,
        dir: @item.dir
      })}>
        <%= for indicator <- @indicator do %>
          <%= render_slot(indicator, Map.put(@item, :data, Map.get(@item, :data, %{}))) %>
        <% end %>
      </span>
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
  slot :trigger do
    attr(:class, :string, required: false)
  end

  slot :indicator do
    attr(:class, :string, required: false)
  end

  slot :content do
    attr(:class, :string, required: false)
  end

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
    JS.dispatch("phx:tabs:set-value",
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
    LiveView.push_event(socket, "tabs_set_value", %{
      tabs_id: tabs_id,
      value: validate_tabs_value!(value)
    })
  end
end
