defmodule E2eWeb.DataListPatternsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias E2eWeb.Demos.DataListDemo, as: Demo

  @id_dynamic "data-list-patterns-dynamic-list"

  @initial_items [
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
     |> assign(:id_dynamic, @id_dynamic)
     |> assign(:dynamic_heex, Demo.patterns_dynamic_demo_heex())
     |> assign(:dynamic_elixir, Demo.patterns_dynamic_elixir())
     |> assign(:items, @initial_items)
     |> assign(:next_id, 4)}
  end

  @impl true
  def handle_event("add", _params, socket) do
    id = "item-#{socket.assigns.next_id}"

    row = %{
      value: id,
      label: "Row #{socket.assigns.next_id}",
      content: "Added at #{Time.utc_now() |> Time.to_string()}"
    }

    {:noreply,
     socket
     |> assign(:items, socket.assigns.items ++ [row])
     |> assign(:next_id, socket.assigns.next_id + 1)}
  end

  def handle_event("reset", _params, socket) do
    {:noreply,
     socket
     |> assign(:items, [])
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
        subtitle="Update items from a LiveView list assign."
        heading_class="layout-heading"
      >
        <.demo_section
          id="data-list-patterns-dynamic"
          title="Dynamic items"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @dynamic_heex},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @dynamic_elixir}
          ]}
        >
          <:preview>
            <div class="flex flex-wrap gap-space-lg">
              <.action phx-click="add" class="button ui-accent">Add row</.action>
              <.action phx-click="reset" class="button ui-alert">Reset</.action>
            </div>
            <.data_list
              id={@id_dynamic}
              class="data-list"
              items={Corex.Content.new(@items)}
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
