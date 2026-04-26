defmodule E2eWeb.CarouselEventsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  @id_server "carousel-events-server"
  @id_client "carousel-events-client"
  @client_event "carousel-page-changed"

  @server_heex E2eWeb.Demos.CarouselDemo.events_server_heex()
  @server_elixir E2eWeb.Demos.CarouselDemo.events_server_elixir()
  @client_heex E2eWeb.Demos.CarouselDemo.events_client_heex()
  @client_js E2eWeb.Demos.CarouselDemo.events_client_js()
  @client_ts E2eWeb.Demos.CarouselDemo.events_client_ts()

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:id_server, @id_server)
      |> assign(:id_client, @id_client)
      |> assign(:client_event, @client_event)
      |> assign(:server_heex, @server_heex)
      |> assign(:server_elixir, @server_elixir)
      |> assign(:client_heex, @client_heex)
      |> assign(:client_js, @client_js)
      |> assign(:client_ts, @client_ts)
      |> stream(:server_logs, [])
      |> stream(:client_logs, [])

    {:ok, socket}
  end

  def handle_event("carousel_page_changed", %{"id" => id, "page" => page} = params, socket) do
    log = new_log("server", id, inspect(%{page: page, params: params}))

    socket =
      socket
      |> stream_insert(:server_logs, log, at: 0)

    {:noreply, socket}
  end

  def handle_event("carousel_page_client_changed", %{"id" => id, "page" => page}, socket) do
    log = new_log("client", id, inspect(page))

    socket =
      socket
      |> stream_insert(:client_logs, log, at: 0)

    {:noreply, socket}
  end

  defp new_log(source, carousel_id, value) do
    %{
      id: "#{System.unique_integer([:positive])}",
      time:
        DateTime.utc_now()
        |> DateTime.truncate(:second)
        |> Calendar.strftime("%H:%M:%S"),
      source: source,
      carousel_id: carousel_id,
      value: value
    }
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
        id="carousel-events-page"
        title="Carousel · Event"
        subtitle="Subscribe to page changes from LiveView or the client."
      >
        <.demo_section
          id="carousel-events-server"
          title="On Page Change (Server)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @server_heex},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @server_elixir}
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-4 items-center w-full">
              <div class="w-full flex justify-center">
                <.carousel
                  id={@id_server}
                  items={[
                    ~p"/images/beach.jpg",
                    ~p"/images/fall.jpg",
                    ~p"/images/sand.jpg",
                    ~p"/images/star.jpg",
                    ~p"/images/winter.jpg"
                  ]}
                  class="carousel w-full"
                  on_page_change="carousel_page_changed"
                >
                  <:prev_trigger><.heroicon name="hero-arrow-left" /></:prev_trigger>
                  <:next_trigger><.heroicon name="hero-arrow-right" /></:next_trigger>
                </.carousel>
              </div>

              <.data_table
                id="carousel-events-log-server"
                class="data-table max-w-3xl"
                rows={@streams.server_logs}
              >
                <:col :let={{_dom_id, row}} label="Time">{row.time}</:col>
                <:col :let={{_dom_id, row}} label="Source">{row.source}</:col>
                <:col :let={{_dom_id, row}} label="Value">{row.value}</:col>
                <:empty>
                  <p>No event yet. Interact with the components to receive new events</p>
                </:empty>
              </.data_table>
            </div>
          </:preview>
        </.demo_section>

        <.demo_section
          id="carousel-events-client"
          title="On Page Change (Client)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @client_heex},
            %{value: "js", label: "JS", language: :js, code: @client_js},
            %{value: "ts", label: "TS", language: :javascript, code: @client_ts}
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-4 items-center w-full">
              <div class="w-full flex justify-center">
                <.carousel
                  id={@id_client}
                  items={[
                    ~p"/images/beach.jpg",
                    ~p"/images/fall.jpg",
                    ~p"/images/sand.jpg",
                    ~p"/images/star.jpg",
                    ~p"/images/winter.jpg"
                  ]}
                  class="carousel w-full"
                  on_page_change_client={@client_event}
                >
                  <:prev_trigger><.heroicon name="hero-arrow-left" /></:prev_trigger>
                  <:next_trigger><.heroicon name="hero-arrow-right" /></:next_trigger>
                </.carousel>
              </div>

              <div
                id="carousel-events-client-listener"
                class="w-full"
                phx-hook=".CarouselEventsClient"
                phx-update="ignore"
              >
                <script :type={Phoenix.LiveView.ColocatedHook} name=".CarouselEventsClient">
                  export default {
                    mounted() {
                      const el = document.getElementById("carousel-events-client");
                      if (!el) return;
                      el.addEventListener("carousel-page-changed", (event) => {
                        const d = event.detail;
                        const page =
                          d && d.value && typeof d.value === "object" && "page" in d.value
                            ? d.value.page
                            : null;
                        this.pushEvent("carousel_page_client_changed", {
                          id: d?.id ?? "carousel-events-client",
                          page
                        });
                      });
                    }
                  }
                </script>
              </div>

              <.data_table
                id="carousel-events-log-client"
                class="data-table max-w-3xl"
                rows={@streams.client_logs}
              >
                <:col :let={{_dom_id, row}} label="Time">{row.time}</:col>
                <:col :let={{_dom_id, row}} label="Source">{row.source}</:col>
                <:col :let={{_dom_id, row}} label="Value">{row.value}</:col>
                <:empty>
                  <p>No event yet. Interact with the components to receive new events</p>
                </:empty>
              </.data_table>
            </div>
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
