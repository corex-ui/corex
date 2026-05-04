defmodule E2eWeb.Demos.CarouselDemo do
  use E2eWeb, :html

  def api_controls_client_binding_code do
    ~S"""
    <.action phx-click={Corex.Carousel.play("api-carousel-play-client")}>Play</.action>
    <.action phx-click={Corex.Carousel.pause("api-carousel-play-client")}>Pause</.action>
    <.action phx-click={Corex.Carousel.scroll_next("api-carousel-play-client")}>Next</.action>
    <.action phx-click={Corex.Carousel.scroll_prev("api-carousel-play-client")}>Prev</.action>
    <.action phx-click={Corex.Carousel.scroll_next("api-carousel-play-client", true)}>Next (instant)</.action>
    <.action phx-click={Corex.Carousel.scroll_prev("api-carousel-play-client", true)}>Prev (instant)</.action>
    <.carousel
      id="api-carousel-play-client"
      items={[
        ~p"/images/beach.jpg",
        ~p"/images/fall.jpg",
        ~p"/images/sand.jpg",
        ~p"/images/star.jpg",
        ~p"/images/winter.jpg"
      ]}
      autoplay
      loop
      class="carousel"
    >
      <:prev_trigger><.heroicon name="hero-arrow-left" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-arrow-right" /></:next_trigger>
    </.carousel>
    """
  end

  def api_controls_client_js_heex do
    ~S"""
    <.action
      phx-click={
        Phoenix.LiveView.JS.dispatch("corex:carousel:play",
          to: "#api-carousel-play-client-js",
          detail: %{},
          bubbles: false
        )
      }
    >
      Play
    </.action>
    <.action
      phx-click={
        Phoenix.LiveView.JS.dispatch("corex:carousel:pause",
          to: "#api-carousel-play-client-js",
          detail: %{},
          bubbles: false
        )
      }
    >
      Pause
    </.action>
    <.action
      phx-click={
        Phoenix.LiveView.JS.dispatch("corex:carousel:scroll-next",
          to: "#api-carousel-play-client-js",
          detail: %{},
          bubbles: false
        )
      }
    >
      Next
    </.action>
    <.action
      phx-click={
        Phoenix.LiveView.JS.dispatch("corex:carousel:scroll-prev",
          to: "#api-carousel-play-client-js",
          detail: %{},
          bubbles: false
        )
      }
    >
      Prev
    </.action>
    <.action
      phx-click={
        Phoenix.LiveView.JS.dispatch("corex:carousel:scroll-next",
          to: "#api-carousel-play-client-js",
          detail: %{instant: true},
          bubbles: false
        )
      }
    >
      Next (instant)
    </.action>
    <.action
      phx-click={
        Phoenix.LiveView.JS.dispatch("corex:carousel:scroll-prev",
          to: "#api-carousel-play-client-js",
          detail: %{instant: true},
          bubbles: false
        )
      }
    >
      Prev (instant)
    </.action>
    <.carousel
      id="api-carousel-play-client-js"
      items={[
        ~p"/images/beach.jpg",
        ~p"/images/fall.jpg",
        ~p"/images/sand.jpg",
        ~p"/images/star.jpg",
        ~p"/images/winter.jpg"
      ]}
      autoplay
      loop
      class="carousel"
    >
      <:prev_trigger><.heroicon name="hero-arrow-left" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-arrow-right" /></:next_trigger>
    </.carousel>
    """
  end

  def api_controls_client_js_js do
    ~S"""
    const el = document.getElementById("api-carousel-play-client-js")
    el?.dispatchEvent(new CustomEvent("corex:carousel:play", { bubbles: false, detail: {} }))
    el?.dispatchEvent(new CustomEvent("corex:carousel:pause", { bubbles: false, detail: {} }))
    el?.dispatchEvent(new CustomEvent("corex:carousel:scroll-next", { bubbles: false, detail: {} }))
    el?.dispatchEvent(new CustomEvent("corex:carousel:scroll-prev", { bubbles: false, detail: {} }))
    el?.dispatchEvent(
      new CustomEvent("corex:carousel:scroll-next", { bubbles: false, detail: { instant: true } })
    )
    el?.dispatchEvent(
      new CustomEvent("corex:carousel:scroll-prev", { bubbles: false, detail: { instant: true } })
    )
    """
  end

  def api_controls_client_js_ts do
    api_controls_client_js_js()
  end

  def api_controls_client_js_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action
        phx-click={
          Phoenix.LiveView.JS.dispatch("corex:carousel:play",
            to: "##{@id}",
            detail: %{},
            bubbles: false
          )
        }
        class="button button--sm"
      >
        Play
      </.action>
      <.action
        phx-click={
          Phoenix.LiveView.JS.dispatch("corex:carousel:pause",
            to: "##{@id}",
            detail: %{},
            bubbles: false
          )
        }
        class="button button--sm"
      >
        Pause
      </.action>
      <.action
        phx-click={
          Phoenix.LiveView.JS.dispatch("corex:carousel:scroll-next",
            to: "##{@id}",
            detail: %{},
            bubbles: false
          )
        }
        class="button button--sm"
      >
        Next
      </.action>
      <.action
        phx-click={
          Phoenix.LiveView.JS.dispatch("corex:carousel:scroll-prev",
            to: "##{@id}",
            detail: %{},
            bubbles: false
          )
        }
        class="button button--sm"
      >
        Prev
      </.action>
      <.action
        phx-click={
          Phoenix.LiveView.JS.dispatch("corex:carousel:scroll-next",
            to: "##{@id}",
            detail: %{instant: true},
            bubbles: false
          )
        }
        class="button button--sm"
      >
        Next (instant)
      </.action>
      <.action
        phx-click={
          Phoenix.LiveView.JS.dispatch("corex:carousel:scroll-prev",
            to: "##{@id}",
            detail: %{instant: true},
            bubbles: false
          )
        }
        class="button button--sm"
      >
        Prev (instant)
      </.action>
    </div>
    <.carousel
      id={@id}
      items={[
        ~p"/images/beach.jpg",
        ~p"/images/fall.jpg",
        ~p"/images/sand.jpg",
        ~p"/images/star.jpg",
        ~p"/images/winter.jpg"
      ]}
      autoplay
      loop
      class="carousel"
    >
      <:prev_trigger><.heroicon name="hero-arrow-left" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-arrow-right" /></:next_trigger>
    </.carousel>
    """
  end

  def api_controls_server_heex do
    ~S"""
    <.action phx-click="api_carousel_server_play" class="button button--sm">Play</.action>
    <.action phx-click="api_carousel_server_pause" class="button button--sm">Pause</.action>
    <.action phx-click="api_carousel_server_scroll_next" class="button button--sm">Next</.action>
    <.action phx-click="api_carousel_server_scroll_prev" class="button button--sm">Prev</.action>
    <.action phx-click="api_carousel_server_scroll_next_instant" class="button button--sm">
      Next (instant)
    </.action>
    <.action phx-click="api_carousel_server_scroll_prev_instant" class="button button--sm">
      Prev (instant)
    </.action>
    <.carousel
      id="api-carousel-play-server"
      items={[
        ~p"/images/beach.jpg",
        ~p"/images/fall.jpg",
        ~p"/images/sand.jpg",
        ~p"/images/star.jpg",
        ~p"/images/winter.jpg"
      ]}
      autoplay
      loop
      class="carousel"
    >
      <:prev_trigger><.heroicon name="hero-arrow-left" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-arrow-right" /></:next_trigger>
    </.carousel>
    """
  end

  def api_controls_server_elixir do
    ~S"""
    def handle_event("api_carousel_server_play", _params, socket) do
      {:noreply, Corex.Carousel.play(socket, "api-carousel-play-server")}
    end

    def handle_event("api_carousel_server_pause", _params, socket) do
      {:noreply, Corex.Carousel.pause(socket, "api-carousel-play-server")}
    end

    def handle_event("api_carousel_server_scroll_next", _params, socket) do
      {:noreply, Corex.Carousel.scroll_next(socket, "api-carousel-play-server")}
    end

    def handle_event("api_carousel_server_scroll_prev", _params, socket) do
      {:noreply, Corex.Carousel.scroll_prev(socket, "api-carousel-play-server")}
    end

    def handle_event("api_carousel_server_scroll_next_instant", _params, socket) do
      {:noreply, Corex.Carousel.scroll_next(socket, "api-carousel-play-server", true)}
    end

    def handle_event("api_carousel_server_scroll_prev_instant", _params, socket) do
      {:noreply, Corex.Carousel.scroll_prev(socket, "api-carousel-play-server", true)}
    end
    """
  end

  def api_controls_server_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click="api_carousel_server_play" class="button button--sm">Play</.action>
      <.action phx-click="api_carousel_server_pause" class="button button--sm">Pause</.action>
      <.action phx-click="api_carousel_server_scroll_next" class="button button--sm">Next</.action>
      <.action phx-click="api_carousel_server_scroll_prev" class="button button--sm">Prev</.action>
      <.action phx-click="api_carousel_server_scroll_next_instant" class="button button--sm">
        Next (instant)
      </.action>
      <.action phx-click="api_carousel_server_scroll_prev_instant" class="button button--sm">
        Prev (instant)
      </.action>
    </div>
    <.carousel
      id={@id}
      items={[
        ~p"/images/beach.jpg",
        ~p"/images/fall.jpg",
        ~p"/images/sand.jpg",
        ~p"/images/star.jpg",
        ~p"/images/winter.jpg"
      ]}
      autoplay
      loop
      class="carousel"
    >
      <:prev_trigger><.heroicon name="hero-arrow-left" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-arrow-right" /></:next_trigger>
    </.carousel>
    """
  end

  def styling_color_code do
    ~S"""
    <.carousel
      id="carousel-style-accent"
      items={[
        ~p"/images/beach.jpg",
        ~p"/images/fall.jpg",
        ~p"/images/sand.jpg",
        ~p"/images/star.jpg",
        ~p"/images/winter.jpg"
      ]}
      class="carousel carousel--accent"
    >
      <:prev_trigger><.heroicon name="hero-arrow-left" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-arrow-right" /></:next_trigger>
    </.carousel>
    """
  end

  def styling_color_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-4 items-end justify-center">
      <.carousel
        id="carousel-style-accent"
        items={[
          ~p"/images/beach.jpg",
          ~p"/images/fall.jpg",
          ~p"/images/sand.jpg",
          ~p"/images/star.jpg",
          ~p"/images/winter.jpg"
        ]}
        class="carousel carousel--accent w-full max-w-xs"
      >
        <:prev_trigger><.heroicon name="hero-arrow-left" /></:prev_trigger>
        <:next_trigger><.heroicon name="hero-arrow-right" /></:next_trigger>
      </.carousel>
      <.carousel
        id="carousel-style-brand"
        items={[
          ~p"/images/beach.jpg",
          ~p"/images/fall.jpg",
          ~p"/images/sand.jpg",
          ~p"/images/star.jpg",
          ~p"/images/winter.jpg"
        ]}
        class="carousel carousel--brand w-full max-w-xs"
      >
        <:prev_trigger><.heroicon name="hero-arrow-left" /></:prev_trigger>
        <:next_trigger><.heroicon name="hero-arrow-right" /></:next_trigger>
      </.carousel>
      <.carousel
        id="carousel-style-alert"
        items={[
          ~p"/images/beach.jpg",
          ~p"/images/fall.jpg",
          ~p"/images/sand.jpg",
          ~p"/images/star.jpg",
          ~p"/images/winter.jpg"
        ]}
        class="carousel carousel--alert w-full max-w-xs"
      >
        <:prev_trigger><.heroicon name="hero-arrow-left" /></:prev_trigger>
        <:next_trigger><.heroicon name="hero-arrow-right" /></:next_trigger>
      </.carousel>
    </div>
    """
  end

  def styling_size_code do
    ~S"""
    <.carousel
      id="carousel-style-sm"
      items={[
        ~p"/images/beach.jpg",
        ~p"/images/fall.jpg",
        ~p"/images/sand.jpg",
        ~p"/images/star.jpg",
        ~p"/images/winter.jpg"
      ]}
      class="carousel carousel--sm"
    >
      <:prev_trigger><.heroicon name="hero-arrow-left" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-arrow-right" /></:next_trigger>
    </.carousel>
    <.carousel
      id="carousel-style-lg"
      items={[
        ~p"/images/beach.jpg",
        ~p"/images/fall.jpg",
        ~p"/images/sand.jpg",
        ~p"/images/star.jpg",
        ~p"/images/winter.jpg"
      ]}
      class="carousel carousel--lg"
    >
      <:prev_trigger><.heroicon name="hero-arrow-left" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-arrow-right" /></:next_trigger>
    </.carousel>
    """
  end

  def styling_size_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-6 items-end justify-center">
      <.carousel
        id="carousel-style-sm"
        items={[
          ~p"/images/beach.jpg",
          ~p"/images/fall.jpg",
          ~p"/images/sand.jpg",
          ~p"/images/star.jpg",
          ~p"/images/winter.jpg"
        ]}
        class="carousel carousel--sm w-full max-w-3xs"
      >
        <:prev_trigger><.heroicon name="hero-arrow-left" /></:prev_trigger>
        <:next_trigger><.heroicon name="hero-arrow-right" /></:next_trigger>
      </.carousel>
      <.carousel
        id="carousel-style-lg"
        items={[
          ~p"/images/beach.jpg",
          ~p"/images/fall.jpg",
          ~p"/images/sand.jpg",
          ~p"/images/star.jpg",
          ~p"/images/winter.jpg"
        ]}
        class="carousel carousel--lg w-full max-w-md"
      >
        <:prev_trigger><.heroicon name="hero-arrow-left" /></:prev_trigger>
        <:next_trigger><.heroicon name="hero-arrow-right" /></:next_trigger>
      </.carousel>
    </div>
    """
  end

  def events_server_heex do
    ~S"""
    <.carousel
      id="carousel-events-server"
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
    """
  end

  def events_server_elixir do
    ~S"""
    def handle_event("carousel_page_changed", %{"id" => id, "page" => page} = params, socket) do
      log = new_log("server", id, inspect(params))
      {:noreply, stream_insert(socket, :server_logs, log, at: 0)}
    end
    """
  end

  def events_client_heex do
    ~S"""
    <.carousel
      id="carousel-events-client"
      items={[
        ~p"/images/beach.jpg",
        ~p"/images/fall.jpg",
        ~p"/images/sand.jpg",
        ~p"/images/star.jpg",
        ~p"/images/winter.jpg"
      ]}
      class="carousel w-full"
      on_page_change_client="carousel-page-changed"
    >
      <:prev_trigger><.heroicon name="hero-arrow-left" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-arrow-right" /></:next_trigger>
    </.carousel>
    """
  end

  def events_client_js do
    ~S"""
    const el = document.getElementById("carousel-events-client");
    el?.addEventListener("carousel-page-changed", (event) => {
      const d = event.detail;
      const page =
        d && d.value && typeof d.value === "object" && "page" in d.value ? d.value.page : null;
      console.log(d?.id, page);
    });
    """
  end

  def events_client_ts do
    ~S"""
    const el = document.getElementById("carousel-events-client");
    type PageDetail = { id: string; value: { page: number } };
    el?.addEventListener("carousel-page-changed", (event: Event) => {
      const d = (event as CustomEvent<PageDetail>).detail;
      const page =
        d && d.value && typeof d.value === "object" && "page" in d.value ? d.value.page : null;
      console.log(d?.id, page);
    });
    """
  end

  def basic_code do
    ~S"""
    <.carousel
      id="carousel-basic"
      items={[
        ~p"/images/beach.jpg",
        ~p"/images/fall.jpg",
        ~p"/images/sand.jpg",
        ~p"/images/star.jpg",
        ~p"/images/winter.jpg"
      ]}
      class="carousel"
    >
      <:prev_trigger><.heroicon name="hero-arrow-left" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-arrow-right" /></:next_trigger>
    </.carousel>
    """
  end

  def basic_example(assigns) do
    ~H"""
    <.carousel
      id="carousel-basic"
      items={[
        ~p"/images/beach.jpg",
        ~p"/images/fall.jpg",
        ~p"/images/sand.jpg",
        ~p"/images/star.jpg",
        ~p"/images/winter.jpg"
      ]}
      class="carousel"
    >
      <:prev_trigger><.heroicon name="hero-arrow-left" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-arrow-right" /></:next_trigger>
    </.carousel>
    """
  end

  def loop_code do
    ~S"""
    <.carousel
      id="carousel-loop"
      items={[
        ~p"/images/beach.jpg",
        ~p"/images/fall.jpg",
        ~p"/images/sand.jpg",
        ~p"/images/star.jpg",
        ~p"/images/winter.jpg"
      ]}
      loop
      class="carousel"
    >
      <:prev_trigger><.heroicon name="hero-arrow-left" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-arrow-right" /></:next_trigger>
    </.carousel>
    """
  end

  def loop_example(assigns) do
    ~H"""
    <.carousel
      id="carousel-loop"
      items={[
        ~p"/images/beach.jpg",
        ~p"/images/fall.jpg",
        ~p"/images/sand.jpg",
        ~p"/images/star.jpg",
        ~p"/images/winter.jpg"
      ]}
      loop
      class="carousel"
    >
      <:prev_trigger><.heroicon name="hero-arrow-left" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-arrow-right" /></:next_trigger>
    </.carousel>
    """
  end

  def vertical_code do
    ~S"""
    <.carousel
      id="carousel-vertical"
      items={[
        ~p"/images/beach.jpg",
        ~p"/images/fall.jpg",
        ~p"/images/sand.jpg",
        ~p"/images/star.jpg",
        ~p"/images/winter.jpg"
      ]}
      orientation="vertical"
      class="carousel"
    >
      <:prev_trigger><.heroicon name="hero-arrow-up" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-arrow-down" /></:next_trigger>
    </.carousel>
    """
  end

  def vertical_example(assigns) do
    ~H"""
    <.carousel
      id="carousel-vertical"
      items={[
        ~p"/images/beach.jpg",
        ~p"/images/fall.jpg",
        ~p"/images/sand.jpg",
        ~p"/images/star.jpg",
        ~p"/images/winter.jpg"
      ]}
      orientation="vertical"
      class="carousel"
    >
      <:prev_trigger><.heroicon name="hero-arrow-up" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-arrow-down" /></:next_trigger>
    </.carousel>
    """
  end
end
