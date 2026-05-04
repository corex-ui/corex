defmodule E2eWeb.ListboxPatternsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias E2eWeb.Demos.ListboxDemo, as: Demo

  @initial_items [
    %{id: "1", label: "Apple"},
    %{id: "2", label: "Banana"},
    %{id: "3", label: "Cherry"}
  ]

  @initial_grouped_items [
    %{id: "g1", label: "France", group: "Europe"},
    %{id: "g2", label: "Japan", group: "Asia"},
    %{id: "g3", label: "Germany", group: "Europe"}
  ]

  def mount(_params, _session, socket) do
    if connected?(socket) do
      Process.send_after(self(), :add_timestamp_item, 3000)
    end

    {:ok,
     socket
     |> stream_configure(:items, dom_id: &"listbox:stream-listbox:item:#{&1.id}")
     |> stream(:items, @initial_items)
     |> assign(:items_list, @initial_items)
     |> stream_configure(:grouped_items, dom_id: &"listbox:stream-grouped-listbox:item:#{&1.id}")
     |> stream(:grouped_items, @initial_grouped_items)
     |> assign(:grouped_items_list, @initial_grouped_items)
     |> assign(:next_id, 4)
     |> assign(:next_grouped_id, 4)
     |> assign(:listbox_controlled_value, ["fra", "bel"])}
  end

  def handle_info(:add_timestamp_item, socket) do
    Process.send_after(self(), :add_timestamp_item, 10_000)

    id = to_string(socket.assigns.next_id)

    time =
      DateTime.utc_now()
      |> DateTime.truncate(:second)
      |> DateTime.to_time()
      |> Time.to_string()

    item = %{id: id, label: "Item #{id} @ #{time}"}

    {:noreply,
     socket
     |> stream_insert(:items, item)
     |> assign(:items_list, socket.assigns.items_list ++ [item])
     |> assign(:next_id, socket.assigns.next_id + 1)}
  end

  def handle_event("add_item", _params, socket) do
    id = to_string(socket.assigns.next_id)
    item = %{id: id, label: "Item #{id}"}

    {:noreply,
     socket
     |> stream_insert(:items, item)
     |> assign(:items_list, socket.assigns.items_list ++ [item])
     |> assign(:next_id, socket.assigns.next_id + 1)}
  end

  def handle_event("reset", _params, socket) do
    {:noreply,
     socket
     |> stream(:items, @initial_items, reset: true)
     |> assign(:items_list, @initial_items)
     |> assign(:next_id, 4)}
  end

  def handle_event("add_to_group", %{"group" => group}, socket) do
    id = "g#{socket.assigns.next_grouped_id}"
    item = %{id: id, label: "Item #{socket.assigns.next_grouped_id}", group: group}

    {:noreply,
     socket
     |> stream_insert(:grouped_items, item)
     |> assign(:grouped_items_list, socket.assigns.grouped_items_list ++ [item])
     |> assign(:next_grouped_id, socket.assigns.next_grouped_id + 1)}
  end

  def handle_event("reset_grouped", _params, socket) do
    {:noreply,
     socket
     |> stream(:grouped_items, @initial_grouped_items, reset: true)
     |> assign(:grouped_items_list, @initial_grouped_items)
     |> assign(:next_grouped_id, 4)}
  end

  def handle_event("listbox_patterns_controlled_value", %{"value" => value}, socket)
      when is_list(value) do
    {:noreply, assign(socket, :listbox_controlled_value, value)}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app
      flash={@flash}
      mode={@mode}
      theme={@theme}
      path={@path}
    >
      <.demo_page
        id="listbox-patterns-page"
        title="Listbox · Patterns"
        subtitle="Streaming items and server-controlled selection."
      >
        <.demo_section
          id="listbox-patterns-stream"
          title="Stream"
          code_tabs={[
            %{
              value: "listbox-demo",
              label: "Listbox demo",
              language: :heex,
              code: Demo.patterns_stream_demo_heex()
            },
            %{
              value: "myapp",
              label: "MyApp",
              language: :elixir,
              code: Demo.patterns_stream_my_app()
            }
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-3 w-full max-w-xl">
              <div class="flex flex-wrap gap-2">
                <.action phx-click="add_item" class="button button--sm button--accent">
                  <.heroicon name="hero-plus" /> Add item
                </.action>
                <.action phx-click="reset" class="button button--sm button--alert">
                  Reset
                </.action>
              </div>
              <.listbox id="stream-listbox" class="listbox" items={Corex.List.new(@items_list)}>
                <:label>Choose an item</:label>
                <:empty>No items</:empty>
                <:item_indicator><.heroicon name="hero-check" /></:item_indicator>
              </.listbox>
            </div>
          </:preview>
        </.demo_section>

        <.demo_section
          id="listbox-patterns-stream-grouped"
          title="Stream grouped"
          code_tabs={[
            %{
              value: "listbox-demo",
              label: "Listbox demo",
              language: :heex,
              code: Demo.patterns_stream_grouped_demo_heex()
            },
            %{
              value: "myapp",
              label: "MyApp",
              language: :elixir,
              code: Demo.patterns_stream_grouped_my_app()
            }
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-3 w-full max-w-xl">
              <div class="flex flex-wrap gap-2">
                <.action
                  phx-click="add_to_group"
                  phx-value-group="Europe"
                  class="button button--sm button--accent"
                >
                  <.heroicon name="hero-plus" /> Add to Europe
                </.action>
                <.action
                  phx-click="add_to_group"
                  phx-value-group="Asia"
                  class="button button--sm button--accent"
                >
                  <.heroicon name="hero-plus" /> Add to Asia
                </.action>
                <.action phx-click="reset_grouped" class="button button--sm button--alert">
                  Reset
                </.action>
              </div>
              <.listbox
                id="stream-grouped-listbox"
                class="listbox"
                items={Corex.List.new(@grouped_items_list)}
              >
                <:label>Choose a country</:label>
                <:empty>No items</:empty>
                <:item_indicator><.heroicon name="hero-check" /></:item_indicator>
              </.listbox>
            </div>
          </:preview>
        </.demo_section>

        <.demo_section
          id="listbox-patterns-controlled"
          title="Controlled (value)"
          code_tabs={[
            %{
              value: "listbox-demo",
              label: "Listbox demo",
              language: :heex,
              code: Demo.patterns_controlled_heex()
            },
            %{
              value: "myapp",
              label: "MyApp",
              language: :elixir,
              code: Demo.patterns_controlled_my_app()
            }
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-3 max-w-xl w-full">
              <.listbox
                id="listbox-patterns-controlled-field"
                class="listbox"
                items={Demo.items_minimal()}
                selection_mode="multiple"
                controlled
                value={@listbox_controlled_value}
                on_value_change="listbox_patterns_controlled_value"
              >
                <:label>Choose countries</:label>
                <:item_indicator><.heroicon name="hero-check" /></:item_indicator>
              </.listbox>
              <p class="text-sm text-ink-muted font-mono" id="listbox-patterns-controlled-state">
                value: {inspect(@listbox_controlled_value)}
              </p>
            </div>
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
