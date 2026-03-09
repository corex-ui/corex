defmodule E2eWeb.DataTableStreamLive do
  use E2eWeb, :live_view

  @initial_items [
    %{id: "1", name: "Apple", price: 1.20, category: "Fruit"},
    %{id: "2", name: "Banana", price: 0.50, category: "Fruit"},
    %{id: "3", name: "Carrot", price: 0.80, category: "Vegetable"}
  ]

  def mount(_params, _session, socket) do
    if connected?(socket) do
      Process.send_after(self(), :add_random_item, 3000)
    end

    {:ok,
     socket
     |> stream_configure(:items, dom_id: &"data-table:stream-table:item:#{&1.id}")
     |> stream(:items, @initial_items)
     |> assign(:items_list, @initial_items)
     |> assign(:next_id, 4)}
  end

  def handle_info(:add_random_item, socket) do
    Process.send_after(self(), :add_random_item, 10000)

    id = to_string(socket.assigns.next_id)

    time =
      DateTime.utc_now()
      |> DateTime.truncate(:second)
      |> DateTime.to_time()
      |> Time.to_string()

    item = %{
      id: id,
      name: "Item #{id}",
      price: Enum.random(1..10) + Enum.random(0..99) / 100.0,
      category: "Misc @ #{time}"
    }

    {:noreply,
     socket
     |> stream_insert(:items, item)
     |> assign(:items_list, [item | socket.assigns.items_list])
     |> assign(:next_id, socket.assigns.next_id + 1)}
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
      <div class="layout__row">
        <h1>Data Table</h1>
        <h2>Stream</h2>
      </div>
      <p>
        Phoenix Stream: table rows are kept in sync with the stream. Add or remove items to test.
      </p>
      <p>
        Every 10 seconds a new item is added automatically.
      </p>
      <div class="flex gap-2 mb-4">
        <.action phx-click="add_item" class="button button--sm button--accent">
          <.icon name="hero-plus" /> Add item
        </.action>
        <.action phx-click="reset" class="button button--sm button--alert">
          Reset
        </.action>
      </div>

      <.data_table
        id="stream-table"
        class="data-table"
        rows={@streams.items}
      >
        <:col :let={{_id, row}} label="ID">{row.id}</:col>
        <:col :let={{_id, row}} label="Name">{row.name}</:col>
        <:col :let={{_id, row}} label="Category">{row.category}</:col>
        <:col :let={{_id, row}} label="Price">
          ${:erlang.float_to_binary(row.price * 1.0, decimals: 2)}
        </:col>
        <:action :let={{_id, row}}>
          <.action
            phx-click={JS.push("remove_item", value: %{id: row.id})}
            data-phx-push="remove_item"
            data-phx-push-id={row.id}
            class="button button--sm button--alert button--sm"
            aria-label={"Delete #{row.name}"}
          >
            <.icon name="hero-trash" class="icon" />
          </.action>
        </:action>
      </.data_table>
    </Layouts.app>
    """
  end

  def handle_event("add_item", _params, socket) do
    id = to_string(socket.assigns.next_id)

    item = %{
      id: id,
      name: "Manual Item #{id}",
      price: Enum.random(1..10) * 1.5,
      category: "Manual"
    }

    {:noreply,
     socket
     |> stream_insert(:items, item)
     |> assign(:items_list, [item | socket.assigns.items_list])
     |> assign(:next_id, socket.assigns.next_id + 1)}
  end

  def handle_event("remove_item", %{"id" => id}, socket) do
    case Enum.find(socket.assigns.items_list, &(&1.id == id)) do
      nil ->
        {:noreply, socket}

      item ->
        {:noreply,
         socket
         |> stream_delete(:items, item)
         |> assign(:items_list, List.delete(socket.assigns.items_list, item))}
    end
  end

  def handle_event("reset", _params, socket) do
    {:noreply,
     socket
     |> stream(:items, @initial_items, reset: true)
     |> assign(:items_list, @initial_items)
     |> assign(:next_id, 4)}
  end
end
