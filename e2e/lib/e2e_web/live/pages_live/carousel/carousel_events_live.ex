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
      |> assign(:gallery_images, E2eWeb.Demos.CarouselDemo.gallery_images())
      |> stream(:server_logs, [])
      |> stream(:client_logs, [])

    {:ok, socket}
  end

  def handle_event("carousel_page_changed", %{"id" => id, "page" => page} = params, socket) do
    log = new_log("server", id, page, Map.get(params, "pageSnapPoint"))

    socket =
      socket
      |> stream_insert(:server_logs, log, at: 0)

    {:noreply, socket}
  end

  def handle_event("carousel_page_client_changed", %{"id" => id, "page" => page} = params, socket) do
    log = new_log("client", id, page, Map.get(params, "pageSnapPoint"))

    socket =
      socket
      |> stream_insert(:client_logs, log, at: 0)

    {:noreply, socket}
  end

  defp new_log(source, carousel_id, page, page_snap_point) do
    %{
      id: "#{System.unique_integer([:positive])}",
      time:
        DateTime.utc_now()
        |> DateTime.truncate(:second)
        |> Calendar.strftime("%H:%M:%S"),
      source: source,
      carousel_id: carousel_id,
      page: to_string(page),
      page_snap_point: format_snap_point(page_snap_point)
    }
  end

  defp format_snap_point(nil), do: "—"
  defp format_snap_point(value), do: to_string(value)

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
        id="carousel-events-page"
        title={~t"Carousel · Event"}
        subtitle={~t"Subscribe to page changes from LiveView or the client."}
      >
        <.demo_section
          id="carousel-events-server-section"
          title={~t"On Page Change (Server)"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @server_heex},
            %{value: "elixir", label: ~t"Elixir", language: :elixir, code: @server_elixir}
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-4 items-center w-full">
              <div class="w-full flex justify-center">
                <.carousel
                  id={@id_server}
                  items={@gallery_images}
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
                <:col :let={{_dom_id, row}} label="ID">{row.carousel_id}</:col>
                <:col :let={{_dom_id, row}} label="Page">{row.page}</:col>
                <:col :let={{_dom_id, row}} label="Snap">{row.page_snap_point}</:col>
                <:empty>
                  <p>No event yet. Interact with the components to receive new events</p>
                </:empty>
              </.data_table>
            </div>
          </:preview>
        </.demo_section>

        <.demo_section
          id="carousel-events-client-section"
          title={~t"On Page Change (Client)"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @client_heex},
            %{value: "js", label: ~t"JS", language: :js, code: @client_js},
            %{value: "ts", label: ~t"TS", language: :javascript, code: @client_ts}
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-4 items-center w-full">
              <div class="w-full flex justify-center">
                <.carousel
                  id={@id_client}
                  items={@gallery_images}
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
                        this.pushEvent("carousel_page_client_changed", {
                          id: d?.id ?? "carousel-events-client",
                          page: d?.page ?? null,
                          pageSnapPoint: d?.pageSnapPoint ?? null
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
                <:col :let={{_dom_id, row}} label="ID">{row.carousel_id}</:col>
                <:col :let={{_dom_id, row}} label="Page">{row.page}</:col>
                <:col :let={{_dom_id, row}} label="Snap">{row.page_snap_point}</:col>
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
