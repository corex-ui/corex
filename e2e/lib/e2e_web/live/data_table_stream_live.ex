defmodule E2eWeb.DataTableStreamLive do
  use E2eWeb, :live_view

  @categories ~w(Fruit Vegetable Misc)
  @initial_items [
    %{id: "1", name: "Apple", category: "Fruit"},
    %{id: "2", name: "Banana", category: "Fruit"},
    %{id: "3", name: "Carrot", category: "Vegetable"}
  ]

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> stream(:items, @initial_items)
     |> assign(:next_id, 4)
     |> assign(:categories, @categories)}
  end

  def handle_event("add_item", _params, socket) do
    id = to_string(socket.assigns.next_id)

    item = %{
      id: id,
      name: "name-#{System.unique_integer([:positive])}",
      category: Enum.random(socket.assigns.categories)
    }

    {:noreply,
     socket
     |> stream_insert(:items, item)
     |> assign(:next_id, socket.assigns.next_id + 1)}
  end

  def handle_event("delete_item", %{"dom_id" => dom_id}, socket) do
    {:noreply, stream_delete_by_dom_id(socket, :items, dom_id)}
  end

  def handle_event("reset", _params, socket) do
    {:noreply,
     socket
     |> stream(:items, @initial_items, reset: true)
     |> assign(:next_id, 4)}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app
      flash={@flash}
      mode={@mode}
      theme={@theme}
      locale={@locale}
      current_path={@current_path}
    >
      <.layout_heading>
        <:title>Data Table</:title>
        <:subtitle>Stream</:subtitle>
      </.layout_heading>
      <p>Create a stream in mount; use <code>stream_insert/3</code> to add rows.</p>
      <div class="flex gap-2 mb-4">
        <.action phx-click="add_item" class="button button--sm button--accent">
          <.heroicon name="hero-plus" /> Add item
        </.action>
        <.action phx-click="reset" class="button button--sm">
          <.heroicon name="hero-arrow-path" /> Reset
        </.action>
      </div>
      <.data_table id="stream-table" class="data-table" rows={@streams.items}>
        <:col :let={{_id, row}} label="ID">{row.id}</:col>
        <:col :let={{_id, row}} label="Name">{row.name}</:col>
        <:col :let={{_id, row}} label="Category">{row.category}</:col>
        <:action :let={{dom_id, row}}>
          <.action
            phx-click="delete_item"
            phx-value-dom_id={dom_id}
            class="button button--sm button--alert"
            aria-label={"Delete #{row.name}"}
          >
            <.heroicon name="hero-trash" />
          </.action>
        </:action>
      </.data_table>
    </Layouts.app>
    """
  end
end
