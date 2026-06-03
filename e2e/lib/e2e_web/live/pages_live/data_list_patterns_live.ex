defmodule E2eWeb.DataListPatternsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias E2eWeb.Demos.DataListDemo, as: Demo

  @id_stream "data-list-patterns-stream-list"

  @initial_stream_items [
    %{
      value: "lorem",
      label: "Lorem ipsum dolor sit amet",
      content: "Consectetur adipiscing elit."
    },
    %{
      value: "duis",
      label: "Duis dictum gravida odio ac pharetra?",
      content: "Nullam eget vestibulum ligula."
    },
    %{
      value: "donec",
      label: "Donec condimentum ex mi",
      content: "Congue molestie ipsum gravida a."
    }
  ]

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:id_stream, @id_stream)
     |> assign(:stream_heex, Demo.patterns_stream_demo_heex())
     |> assign(:stream_elixir, Demo.patterns_stream_elixir())
     |> stream_configure(:items, dom_id: &"data-list:stream-data-list:item:#{&1.value}")
     |> stream(:items, @initial_stream_items)
     |> assign(:items_list, @initial_stream_items)
     |> assign(:next_id, 4)}
  end

  @impl true
  def handle_event("stream_add", _params, socket) do
    id = "item-#{socket.assigns.next_id}"

    row = %{
      value: id,
      label: "Row #{socket.assigns.next_id}",
      content: "Added at #{Time.utc_now() |> Time.to_string()}"
    }

    {:noreply,
     socket
     |> stream_insert(:items, row)
     |> assign(:items_list, socket.assigns.items_list ++ [row])
     |> assign(:next_id, socket.assigns.next_id + 1)}
  end

  def handle_event("stream_reset", _params, socket) do
    {:noreply,
     socket
     |> stream(:items, [], reset: true)
     |> assign(:items_list, [])
     |> assign(:next_id, 1)}
  end

  @impl true
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
        id="data-list-patterns-page"
        title="Data List · Pattern"
        subtitle="Update items from a LiveView stream while the component reads a plain list assign."
        heading_class="layout-heading"
      >
        <.demo_section
          id="data-list-patterns-stream"
          title="Stream"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @stream_heex},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @stream_elixir}
          ]}
        >
          <:preview>
            <div class="flex flex-wrap gap-4">
              <.action phx-click="stream_add" semantic="accent">Add row</.action>
              <.action phx-click="stream_reset" semantic="alert">Reset</.action>
            </div>
            <.data_list
              id={@id_stream}
              items={Corex.Content.new(@items_list)}
            >
              <:empty>
                <p>No items</p>
              </:empty>
            </.data_list>
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
