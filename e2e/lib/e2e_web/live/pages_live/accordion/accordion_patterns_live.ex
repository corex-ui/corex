defmodule E2eWeb.AccordionPatternsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1, authoring_preview: 1]

  alias E2eWeb.Demos.AccordionDemo, as: Demo

  @id_async "patterns-async"
  @id_controlled "patterns-controlled"
  @id_stream "stream-accordion"

  @initial_stream_items [
    %{value: "1", label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit."},
    %{
      value: "2",
      label: "Duis dictum gravida odio ac pharetra?",
      content: "Nullam eget vestibulum ligula."
    },
    %{value: "3", label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a."}
  ]

  def mount(_params, _session, socket) do
    if connected?(socket) do
      Process.send_after(self(), :add_timestamp_item, 3000)
    end

    socket =
      socket
      |> assign(:id_async, @id_async)
      |> assign(:id_controlled, @id_controlled)
      |> assign(:id_stream, @id_stream)
      |> assign(:value, ["lorem"])
      |> assign(:items, items())
      |> assign(:async_heex_full, E2eWeb.AuthoringSnippet.heex_snippets(Demo.patterns_async_heex_full()))
      |> assign(:async_heex_panel, Demo.patterns_async_heex_panel())
      |> assign(:async_elixir, Demo.patterns_async_elixir())
      |> assign(:controlled_heex, E2eWeb.AuthoringSnippet.heex_snippets(Demo.patterns_controlled_heex()))
      |> assign(:controlled_elixir, Demo.patterns_controlled_elixir())
      |> assign(:stream_heex, E2eWeb.AuthoringSnippet.heex_snippets(Demo.patterns_stream_demo_heex()))
      |> assign(:stream_elixir, Demo.patterns_stream_elixir())
      |> stream_configure(:items, dom_id: &"accordion:stream-accordion:item:#{&1.value}")
      |> stream(:items, @initial_stream_items)
      |> assign(:items_list, @initial_stream_items)
      |> assign(:next_id, 4)
      |> assign_async(:accordion, fn ->
        Process.sleep(1000)

        items =
          Corex.Content.new([
            %{
              value: "lorem",
              label: ~t"Lorem ipsum dolor sit amet",
              content: ~t"Consectetur adipiscing elit. Sed sodales ullamcorper tristique."
            },
            %{
              value: "duis",
              label: ~t"Duis dictum gravida odio ac pharetra?",
              content: ~t"Nullam eget vestibulum ligula, at interdum tellus."
            },
            %{
              value: "donec",
              label: ~t"Donec condimentum ex mi",
              content: ~t"Congue molestie ipsum gravida a. Sed ac eros luctus."
            }
          ])

        {:ok, %{accordion: %{items: items, value: ["duis"]}}}
      end)

    {:ok, socket}
  end

  def handle_info(:add_timestamp_item, socket) do
    Process.send_after(self(), :add_timestamp_item, 10_000)

    id = to_string(socket.assigns.next_id)

    time =
      DateTime.utc_now()
      |> DateTime.truncate(:second)
      |> DateTime.to_time()
      |> Time.to_string()

    item = %{
      value: id,
      label: ~t"Item #{id} @ #{time}",
      content: ~t"Content for item #{id}."
    }

    {:noreply,
     socket
     |> stream_insert(:items, item)
     |> assign(:items_list, socket.assigns.items_list ++ [item])
     |> assign(:next_id, socket.assigns.next_id + 1)}
  end

  def handle_event("add_item", _params, socket) do
    id = to_string(socket.assigns.next_id)
    item = %{value: id, label: ~t"Item #{id}", content: ~t"Content for item #{id}."}

    {:noreply,
     socket
     |> stream_insert(:items, item)
     |> assign(:items_list, socket.assigns.items_list ++ [item])
     |> assign(:next_id, socket.assigns.next_id + 1)}
  end

  def handle_event("reset", _params, socket) do
    {:noreply,
     socket
     |> stream(:items, @initial_stream_items, reset: true)
     |> assign(:items_list, @initial_stream_items)
     |> assign(:next_id, 4)}
  end

  def handle_event("patterns_controlled_changed", %{"value" => value}, socket) do
    {:noreply, assign(socket, :value, value)}
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
        id="accordion-patterns-page"
        title={~t"Accordion · Pattern"}
        subtitle={~t"Async loading, controlled state, and streaming items."}
      >
        <.demo_section
          id="accordion-patterns-async"
          title={~t"Async"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @async_heex_full},
            %{value: "elixir", label: ~t"Elixir", language: :elixir, code: @async_elixir}
          ]}
        >
          <:preview>
            <.authoring_preview>
              <:styled>
                <.async_result :let={accordion} assign={@accordion}>
                  <:loading>
                    <.accordion_skeleton count={3} class="accordion" />
                  </:loading>

                  <.accordion
                    id={@id_async}
                    class="accordion"
                    items={accordion.items}
                    value={accordion.value}
                  >
                    <:indicator>
                      <.heroicon name="hero-chevron-right" />
                    </:indicator>
                  </.accordion>
                </.async_result>
              </:styled>
              <:markup>
                <.async_result :let={accordion} assign={@accordion}>
                  <:loading>
                    <.accordion_skeleton count={3} />
                  </:loading>

                  <.accordion
                    id={@id_async}
                    unstyled
                    items={accordion.items}
                    value={accordion.value}
                  >
                    <:indicator>
                      <.heroicon name="hero-chevron-right" />
                    </:indicator>
                  </.accordion>
                </.async_result>
              </:markup>
            </.authoring_preview>
          </:preview>
        </.demo_section>

        <.demo_section
          id="accordion-patterns-controlled"
          title={~t"Controlled (LiveView)"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @controlled_heex},
            %{value: "elixir", label: ~t"Elixir", language: :elixir, code: @controlled_elixir}
          ]}
        >
          <:preview>
            <.authoring_preview>
              <:styled>
                <.accordion
                  id={@id_controlled}
                  class="accordion"
                  items={@items}
                  multiple={false}
                  controlled
                  value={@value}
                  on_value_change="patterns_controlled_changed"
                >
                  <:indicator>
                    <.heroicon name="hero-chevron-right" />
                  </:indicator>
                </.accordion>
              </:styled>
              <:markup>
                <.accordion
                  id={@id_controlled}
                  unstyled
                  items={@items}
                  multiple={false}
                  controlled
                  value={@value}
                  on_value_change="patterns_controlled_changed"
                >
                  <:indicator>
                    <.heroicon name="hero-chevron-right" />
                  </:indicator>
                </.accordion>
              </:markup>
            </.authoring_preview>
          </:preview>
        </.demo_section>

        <.demo_section
          id="accordion-patterns-stream"
          title={~t"Stream"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @stream_heex},
            %{value: "elixir", label: ~t"Elixir", language: :elixir, code: @stream_elixir}
          ]}
        >
          <:preview>
            <.stack gap="md" align="center" width="full">
              <.row wrap="wrap" gap="sm" align="center" justify="center" width="full">
                <.action phx-click="add_item" size="sm" semantic="accent">
                  <.heroicon name="hero-plus" /> Add item
                </.action>
                <.action phx-click="reset" size="sm" semantic="alert">
                  Reset
                </.action>
              </.row>
              <.authoring_preview>
                <:styled>
                  <.accordion
                    id={@id_stream}
                    class="accordion"
                    width="full"
                    max_width="xl"
                    items={Corex.Content.new(@items_list)}
                  >
                    <:indicator>
                      <.heroicon name="hero-chevron-right" />
                    </:indicator>
                  </.accordion>
                </:styled>
                <:markup>
                  <.accordion
                    id={@id_stream}
                    unstyled
                    width="full"
                    max_width="xl"
                    items={Corex.Content.new(@items_list)}
                  >
                    <:indicator>
                      <.heroicon name="hero-chevron-right" />
                    </:indicator>
                  </.accordion>
                </:markup>
              </.authoring_preview>
            </.stack>
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end

  defp items do
    Demo.patterns_items()
  end
end
