defmodule E2eWeb.CarouselApiLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  @id_client "api-carousel-play-client"
  @id_js "api-carousel-play-client-js"
  @id_server "api-carousel-play-server"

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:id_client, @id_client)
      |> assign(:id_js, @id_js)
      |> assign(:id_server, @id_server)
      |> assign(:codes, demo_codes())

    {:ok, socket}
  end

  defp demo_codes do
    m = E2eWeb.Demos.CarouselDemo

    %{
      binding: m.api_controls_client_binding_code(),
      js_heex: m.api_controls_client_js_heex(),
      js: m.api_controls_client_js_js(),
      js_ts: m.api_controls_client_js_ts(),
      server_heex: m.api_controls_server_heex(),
      server_elixir: m.api_controls_server_elixir()
    }
  end

  @impl true
  def handle_event("api_carousel_server_play", _params, socket) do
    {:noreply, Corex.Carousel.play(socket, @id_server)}
  end

  @impl true
  def handle_event("api_carousel_server_pause", _params, socket) do
    {:noreply, Corex.Carousel.pause(socket, @id_server)}
  end

  @impl true
  def handle_event("api_carousel_server_scroll_next", _params, socket) do
    {:noreply, Corex.Carousel.scroll_next(socket, @id_server)}
  end

  @impl true
  def handle_event("api_carousel_server_scroll_prev", _params, socket) do
    {:noreply, Corex.Carousel.scroll_prev(socket, @id_server)}
  end

  @impl true
  def handle_event("api_carousel_server_scroll_next_instant", _params, socket) do
    {:noreply, Corex.Carousel.scroll_next(socket, @id_server, true)}
  end

  @impl true
  def handle_event("api_carousel_server_scroll_prev_instant", _params, socket) do
    {:noreply, Corex.Carousel.scroll_prev(socket, @id_server, true)}
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
        id="carousel-api-page"
        title="Carousel · API"
        subtitle="Drive autoplay and paging from LiveView or the client."
      >
        <.demo_section
          id="carousel-api-client-binding"
          title="Play, pause, scroll (Client binding)"
          code={@codes.binding}
        >
          <:preview>
            <div class="flex flex-wrap gap-2 mb-4">
              <.action phx-click={Corex.Carousel.play(@id_client)} class="button ui-size-sm">
                Play
              </.action>
              <.action phx-click={Corex.Carousel.pause(@id_client)} class="button ui-size-sm">
                Pause
              </.action>
              <.action phx-click={Corex.Carousel.scroll_next(@id_client)} class="button ui-size-sm">
                Next
              </.action>
              <.action phx-click={Corex.Carousel.scroll_prev(@id_client)} class="button ui-size-sm">
                Prev
              </.action>
              <.action
                phx-click={Corex.Carousel.scroll_next(@id_client, true)}
                class="button ui-size-sm"
              >
                Next (instant)
              </.action>
              <.action
                phx-click={Corex.Carousel.scroll_prev(@id_client, true)}
                class="button ui-size-sm"
              >
                Prev (instant)
              </.action>
            </div>
            <.carousel
              id={@id_client}
              items={E2eWeb.Demos.CarouselDemo.gallery_images()}
              autoplay
              loop
              class="carousel"
            >
              <:prev_trigger><.heroicon name="hero-arrow-left" /></:prev_trigger>
              <:next_trigger><.heroicon name="hero-arrow-right" /></:next_trigger>
            </.carousel>
          </:preview>
        </.demo_section>

        <.demo_section
          id="carousel-api-client-js"
          title={~t"Play, pause, scroll (Client JS)"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @codes.js_heex},
            %{value: "js", label: ~t"JS", language: :js, code: @codes.js},
            %{value: "ts", label: ~t"TS", language: :javascript, code: @codes.js_ts}
          ]}
        >
          <:preview>
            <E2eWeb.Demos.CarouselDemo.api_controls_client_js_example id={@id_js} />
          </:preview>
        </.demo_section>

        <.demo_section
          id="carousel-api-server"
          title={~t"Play, pause, scroll (Server)"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @codes.server_heex},
            %{value: "elixir", label: ~t"Elixir", language: :elixir, code: @codes.server_elixir}
          ]}
        >
          <:preview>
            <E2eWeb.Demos.CarouselDemo.api_controls_server_example id={@id_server} />
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
