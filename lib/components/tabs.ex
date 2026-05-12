defmodule Corex.Tabs do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Tabs](https://zagjs.com/components/react/tabs).

  ## Examples

  <!-- tabs-open -->

  ### Basic

  You can use `Corex.Content.new/1` to create a list of content items.

  The `value` for each item is optional and will be auto-generated if not provided.

  You can specify `disabled` for each item.

  ```heex
  <.tabs
    class="tabs"
    items={Corex.Content.new([
      [label: "Lorem", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."],
      [label: "Duis", content: "Nullam eget vestibulum ligula, at interdum tellus."],
      [label: "Donec", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."]
    ])}
  />
  ```

  ### With indicator

  Set the boolean `indicator` attribute to render the single shared item indicator (Zag) after the tab triggers.

  ```heex
  <.tabs
    class="tabs"
    indicator
    items={Corex.Content.new([
      [value: "lorem", label: "Lorem", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."],
      [label: "Duis", content: "Nullam eget vestibulum ligula, at interdum tellus."],
      [value: "donec", label: "Donec", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."]
    ])}
  >
  </.tabs>
  ```

  ### Custom

  Use `:trigger` and `:content` together to fully customize how each item is rendered. Render icons or extras inside each `:trigger` slot. Use `:let={item}` on slots to access the item and its `data` (including `meta` for per-item customization). Use `tabs_indicator` once inside `tabs_list` when you need the shared indicator in compound mode.

  ```heex
  <.tabs
    class="tabs"
    value="lorem"
    items={Corex.Content.new([
      [value: "lorem", label: "Lorem", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique.", meta: %{indicator: "hero-chevron-right"}],
      [label: "Duis", content: "Nullam eget vestibulum ligula, at interdum tellus.", meta: %{indicator: "hero-chevron-right"}],
      [value: "donec", label: "Donec", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."]
    ])}
  >
    <:trigger :let={item}>
      {item.label}
    </:trigger>
    <:content :let={item}>
      {item.content}
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
    <.tabs
      controlled
      value={@value}
      on_value_change="on_value_change"
      class="tabs"
      items={Corex.Content.new([
        [value: "lorem", label: "Lorem", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique. Proin quis risus feugiat tellus iaculis fringilla."],
        [value: "duis", label: "Duis", content: "Nullam eget vestibulum ligula, at interdum tellus. Quisque feugiat, dui ut fermentum sodales, lectus metus dignissim ex."]
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
          [value: "lorem", label: "Lorem", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique.", disabled: true],
          [value: "duis", label: "Duis", content: "Nullam eget vestibulum ligula, at interdum tellus."],
          [value: "donec", label: "Donec", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."]
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


  '''

  @doc type: :component
  use Phoenix.Component

  alias Corex.Tabs.Anatomy.{Content, Indicator, List, Props, Root, Trigger}
  alias Corex.Tabs.Connect
  alias Phoenix.LiveView
  alias Phoenix.LiveView.JS

  import Corex.Helpers,
    only: [
      validate_tabs_value!: 1
    ]

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

  attr(:compound, :boolean,
    default: false,
    doc:
      "Enable compound mode. Use with :let={ctx} and tabs_root, tabs_list, tabs_trigger, tabs_content, tabs_indicator once inside tabs_list."
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

  attr(:indicator, :boolean,
    default: true,
    doc: "Whether to show an indicator on the trigger list"
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

  slot(:inner_block,
    required: false,
    doc: """
    Compound mode inner content. Use with the `compound` attribute and `:let={ctx}`.
    `ctx` is a map with keys: `id`, `values`, `orientation`, `dir`.
    """
  )

  slot :trigger,
    required: false,
    doc:
      "Optional slot for custom trigger rendering. When provided with content, replaces default item rendering. Use :let={item} to access the item." do
    attr(:value, :string, required: false)
    attr(:class, :string, required: false)
  end

  slot :content,
    required: false,
    doc:
      "Optional slot for custom content rendering. When provided with trigger, replaces default item rendering. Use :let={item} to access the item." do
    attr(:class, :string, required: false)
    attr(:value, :string, required: false)
  end

  def tabs(assigns) do
    values = if is_binary(assigns[:value]), do: [assigns.value], else: []

    assigns =
      assigns
      |> assign_new(:id, fn -> "tabs-#{System.unique_integer([:positive])}" end)
      |> assign(:values, values)
      |> tabs_assign_panels()

    ctx = %{
      id: assigns.id,
      values: values,
      orientation: assigns.orientation,
      dir: assigns.dir
    }

    assigns = assign(assigns, :ctx, ctx)

    ~H"""
    <div id={@id} phx-hook="Tabs" data-loading phx-mounted={Phoenix.LiveView.JS.ignore_attributes(["data-loading"])}  {@rest}
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
      {if @compound do
        render_slot(@inner_block, @ctx)
      end}
      <div :if={not @compound}
        phx-mounted={Connect.ignore_root(%Root{id: @id, orientation: @orientation, dir: @dir})}
        {Connect.root(%Root{id: @id, orientation: @orientation, dir: @dir})}
      >
        <div
          phx-mounted={Connect.ignore_list(%List{id: @id, orientation: @orientation, dir: @dir})}
          {Connect.list(%List{id: @id, orientation: @orientation, dir: @dir})}
        >
          <button
            :for={panel <- @panels}
            class={tabs_panel_class(panel, :trigger_slot)}
            phx-mounted={Connect.ignore_trigger(tabs_panel_trigger(panel, @id, @values, @orientation, @dir))}
            {Connect.trigger(tabs_panel_trigger(panel, @id, @values, @orientation, @dir))}
          >
            {cond do
              panel.source == :slots -> render_slot(panel.trigger_slot)
              @trigger != [] -> render_slot(@trigger, %{label: panel.item_entry.label, meta: panel.item_entry.meta || %{}})
              true -> panel.item_entry.label
            end}
          </button>
        </div>
        <span
          :if={@indicator}
          phx-mounted={Connect.ignore_indicator(%Indicator{
            id: @id,
            values: @values,
            orientation: @orientation,
            dir: @dir
          })}
          {Connect.indicator(%Indicator{
            id: @id,
            values: @values,
            orientation: @orientation,
            dir: @dir
          })}
        ></span>

        <div
          :for={panel <- @panels}
          class={tabs_panel_class(panel, :content_slot)}
          phx-mounted={Connect.ignore_content(tabs_panel_content(panel, @id, @values, @orientation, @dir))}
          {Connect.content(tabs_panel_content(panel, @id, @values, @orientation, @dir))}
        >
          {cond do
            panel.source == :slots -> render_slot(panel.content_slot)
            @content != [] -> render_slot(@content, %{content: panel.item_entry.content, meta: panel.item_entry.meta || %{}})
            true -> panel.item_entry.content
          end}
        </div>
      </div>
    </div>
    """
  end

  defp tabs_assign_panels(assigns) do
    panels =
      cond do
        assigns.compound ->
          []

        is_list(assigns.items) and assigns.items != [] ->
          assigns.items
          |> Enum.with_index()
          |> Enum.map(fn
            {%Corex.Content.Item{} = entry, index} ->
              %{
                source: :items,
                value: entry.value || "item-#{index}",
                disabled: entry.disabled,
                item_entry: entry
              }

            {other, _index} ->
              raise ArgumentError,
                    "items must be a list of Corex.Content.Item structs, got: #{inspect(other)}"
          end)

        is_nil(assigns.items) and (assigns.trigger != [] or assigns.content != []) ->
          Corex.Slot.resolve_panels!(
            %{trigger: assigns.trigger, content: assigns.content},
            required: [:trigger, :content],
            component: "Tabs"
          )
          |> Enum.map(fn p ->
            %{
              source: :slots,
              value: p.value,
              disabled: p.disabled,
              trigger_slot: p.trigger,
              content_slot: p.content
            }
          end)

        true ->
          []
      end

    assign(assigns, :panels, panels)
  end

  defp tabs_panel_class(%{source: :items, item_entry: e}, _slot_key), do: Map.get(e, :class, nil)

  defp tabs_panel_class(%{source: :slots} = panel, slot_key),
    do: Map.get(panel[slot_key], :class, nil)

  defp tabs_panel_trigger(panel, id, values, orientation, dir) do
    %Trigger{
      id: id,
      value: panel.value,
      disabled: panel.disabled,
      values: values,
      orientation: orientation,
      dir: dir,
      data: %{}
    }
  end

  defp tabs_panel_content(panel, id, values, orientation, dir) do
    %Content{
      id: id,
      value: panel.value,
      disabled: panel.disabled,
      values: values,
      orientation: orientation,
      dir: dir,
      data: %{}
    }
  end

  attr(:ctx, :map, required: true)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def tabs_root(assigns) do
    root = %Root{
      id: assigns.ctx.id,
      orientation: assigns.ctx.orientation,
      dir: assigns.ctx.dir
    }

    assigns = assign(assigns, :root, root)

    ~H"""
    <div phx-mounted={Connect.ignore_root(@root)} {Connect.root(@root)} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:ctx, :map, required: true)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def tabs_list(assigns) do
    list = %List{
      id: assigns.ctx.id,
      orientation: assigns.ctx.orientation,
      dir: assigns.ctx.dir
    }

    assigns = assign(assigns, :list, list)

    ~H"""
    <div phx-mounted={Connect.ignore_list(@list)} {Connect.list(@list)} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:ctx, :map, required: true)
  attr(:value, :string, required: true)
  attr(:disabled, :boolean, default: false)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def tabs_trigger(assigns) do
    trigger = %Trigger{
      id: assigns.ctx.id,
      value: assigns.value,
      disabled: assigns.disabled,
      values: assigns.ctx.values,
      orientation: assigns.ctx.orientation,
      dir: assigns.ctx.dir,
      data: %{}
    }

    assigns = assign(assigns, :trigger, trigger)

    ~H"""
    <button
      type="button"
      phx-mounted={Connect.ignore_trigger(@trigger)}
      {Connect.trigger(@trigger)}
      {@rest}
    >
      {render_slot(@inner_block)}
    </button>
    """
  end

  attr(:ctx, :map, required: true)
  attr(:rest, :global)
  slot(:inner_block, required: false)

  def tabs_indicator(assigns) do
    indicator = %Indicator{
      id: assigns.ctx.id,
      values: assigns.ctx.values,
      orientation: assigns.ctx.orientation,
      dir: assigns.ctx.dir
    }

    assigns = assign(assigns, :indicator, indicator)

    ~H"""
    <span phx-mounted={Connect.ignore_indicator(@indicator)} {Connect.indicator(@indicator)} {@rest}>
      {render_slot(@inner_block)}
    </span>
    """
  end

  attr(:ctx, :map, required: true)
  attr(:value, :string, required: true)
  attr(:disabled, :boolean, default: false)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def tabs_content(assigns) do
    content = %Content{
      id: assigns.ctx.id,
      value: assigns.value,
      disabled: assigns.disabled,
      values: assigns.ctx.values,
      orientation: assigns.ctx.orientation,
      dir: assigns.ctx.dir,
      data: %{}
    }

    assigns = assign(assigns, :content, content)

    ~H"""
    <div phx-mounted={Connect.ignore_content(@content)} {Connect.content(@content)} {@rest}>
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
    JS.dispatch("corex:tabs:set-value",
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
