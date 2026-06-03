defmodule E2eWeb.ListboxPatternsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias E2eWeb.Demos.ListboxDemo, as: Demo

  @initial_items [
    %{value: "1", label: "Apple"},
    %{value: "2", label: "Banana"},
    %{value: "3", label: "Cherry"}
  ]

  @initial_grouped_items [
    %{value: "g1", label: "France", group: "Europe"},
    %{value: "g2", label: "Japan", group: "Asia"},
    %{value: "g3", label: "Germany", group: "Europe"}
  ]

  def mount(_params, _session, socket) do
    if connected?(socket) do
      Process.send_after(self(), :add_timestamp_item, 3000)
    end

    {:ok,
     socket
     |> stream_configure(:items, dom_id: &"listbox:stream-listbox:item:#{&1.value}")
     |> stream(:items, @initial_items)
     |> assign(:items_list, @initial_items)
     |> stream_configure(:grouped_items,
       dom_id: &"listbox:stream-grouped-listbox:item:#{&1.value}"
     )
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

    item = %{value: id, label: ~t"Item #{id} @ #{time}"}

    {:noreply,
     socket
     |> stream_insert(:items, item)
     |> assign(:items_list, socket.assigns.items_list ++ [item])
     |> assign(:next_id, socket.assigns.next_id + 1)}
  end

  def handle_event("add_item", _params, socket) do
    id = to_string(socket.assigns.next_id)
    item = %{value: id, label: ~t"Item #{id}"}

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
    item = %{value: id, label: ~t"Item #{socket.assigns.next_grouped_id}", group: group}

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
        path={@path}
        id="listbox-patterns-page"
        title={~t"Listbox · Patterns"}
        subtitle={~t"Streaming items and server-controlled selection."}
      >
        <.demo_section
          id="listbox-patterns-stream"
          title={~t"Stream"}
          code_tabs={[
            %{
              value: "heex",
              label: ~t"Heex",
              language: :heex,
              code: Demo.patterns_stream_demo_heex()
            },
            %{
              value: "elixir",
              label: ~t"Elixir",
              language: :elixir,
              code: Demo.patterns_stream_elixir()
            }
          ]}
        >
          <:preview>
            <div class="flex flex-wrap gap-2 items-center w-full justify-center">
              <.action phx-click="add_item" size="sm" semantic="accent">
                <.heroicon name="hero-plus" /> Add item
              </.action>
              <.action phx-click="reset" size="sm" semantic="alert">
                Reset
              </.action>
            </div>
            <.listbox id="stream-listbox" items={Corex.List.new(@items_list)}>
              <:label>Choose an item</:label>
              <:empty>No items</:empty>
              <:item_indicator><.heroicon name="hero-check" /></:item_indicator>
            </.listbox>
          </:preview>
        </.demo_section>

        <.demo_section
          id="listbox-patterns-stream-grouped"
          title={~t"Stream grouped"}
          code_tabs={[
            %{
              value: "heex",
              label: ~t"Heex",
              language: :heex,
              code: Demo.patterns_stream_grouped_demo_heex()
            },
            %{
              value: "elixir",
              label: ~t"Elixir",
              language: :elixir,
              code: Demo.patterns_stream_grouped_elixir()
            }
          ]}
        >
          <:preview>
            <div class="flex flex-wrap gap-2 items-center w-full justify-center">
              <.action phx-click="add_to_group" phx-value-group="Europe" size="sm" semantic="accent">
                <.heroicon name="hero-plus" /> Add to Europe
              </.action>
              <.action phx-click="add_to_group" phx-value-group="Asia" size="sm" semantic="accent">
                <.heroicon name="hero-plus" /> Add to Asia
              </.action>
              <.action phx-click="reset_grouped" size="sm" semantic="alert">
                Reset
              </.action>
            </div>
            <.listbox
              id="stream-grouped-listbox"
              items={Corex.List.new(@grouped_items_list)}
            >
              <:label>Choose a country</:label>
              <:empty>No items</:empty>
              <:item_indicator><.heroicon name="hero-check" /></:item_indicator>
            </.listbox>
          </:preview>
        </.demo_section>

        <.demo_section
          id="listbox-patterns-controlled"
          title={~t"Controlled (value)"}
          code_tabs={[
            %{
              value: "heex",
              label: ~t"Heex",
              language: :heex,
              code: Demo.patterns_controlled_heex()
            },
            %{
              value: "elixir",
              label: ~t"Elixir",
              language: :elixir,
              code: Demo.patterns_controlled_elixir()
            }
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-3 w-full items-center">
              <div class="w-full max-w-md">
                <.listbox
                  id="listbox-patterns-controlled-field"
                  items={Demo.items_minimal()}
                  selection_mode="multiple"
                  controlled
                  value={@listbox_controlled_value}
                  on_value_change="listbox_patterns_controlled_value"
                >
                  <:label>Choose countries</:label>
                  <:item_indicator><.heroicon name="hero-check" /></:item_indicator>
                </.listbox>
              </div>
              <div class="w-full min-w-0" id="listbox-patterns-controlled-state">
                <p class="text-sm text-ui-ink-muted font-mono break-all text-center">
                  value: {inspect(@listbox_controlled_value)}
                </p>
              </div>
            </div>
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
