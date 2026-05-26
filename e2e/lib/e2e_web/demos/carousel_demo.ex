defmodule E2eWeb.Demos.CarouselDemo do
  use E2eWeb, :html

  alias Corex.Image

  alias E2eWeb.Demos.DocExamples

  @gallery_items_attr "items={#{DocExamples.code_carousel_gallery_items()}}"
  @posts_items_attr "items={#{DocExamples.code_carousel_posts()}}"
  @posts_list_attr DocExamples.code_carousel_posts()

  @styling_carousel_triggers """
      <:prev_trigger><.heroicon name="hero-arrow-left" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-arrow-right" /></:next_trigger>
  """

  def gallery_images do
    [
      {~p"/images/beach.jpg", "Beach"},
      {~p"/images/fall.jpg", "Fall"},
      {~p"/images/sand.jpg", "Sand"},
      {~p"/images/star.jpg", "Star"},
      {~p"/images/winter.jpg", "Winter"}
    ]
    |> Enum.map(fn {src, alt} -> Image.new(src, alt: alt) end)
  end

  def blog_posts do
    [
      %{
        title: "Lorem ipsum dolor sit amet",
        description: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."
      },
      %{
        title: "Duis dictum gravida odio ac pharetra?",
        description: "Nullam eget vestibulum ligula, at interdum tellus."
      },
      %{
        title: "Donec condimentum ex mi",
        description: "Congue molestie ipsum gravida a. Sed ac eros luctus."
      }
    ]
  end

  def api_controls_client_binding_code do
    """
    <.action phx-click={Corex.Carousel.play("api-carousel-play-client")}>Play</.action>
    <.action phx-click={Corex.Carousel.pause("api-carousel-play-client")}>Pause</.action>
    <.action phx-click={Corex.Carousel.scroll_next("api-carousel-play-client")}>Next</.action>
    <.action phx-click={Corex.Carousel.scroll_prev("api-carousel-play-client")}>Prev</.action>
    <.action phx-click={Corex.Carousel.scroll_next("api-carousel-play-client", true)}>Next (instant)</.action>
    <.action phx-click={Corex.Carousel.scroll_prev("api-carousel-play-client", true)}>Prev (instant)</.action>
    <.carousel
      id="api-carousel-play-client"
      #{@gallery_items_attr}
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
    """
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
      #{@gallery_items_attr}
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
    ~S"""
    const el: HTMLElement | null = document.getElementById("api-carousel-play-client-js")
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
      items={gallery_images()}
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
    """
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
      #{@gallery_items_attr}
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
      items={gallery_images()}
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
    """
    <.carousel id="carousel-style-default" #{@gallery_items_attr} class="carousel w-full max-w-xs">
    #{@styling_carousel_triggers}
    </.carousel>
    <.carousel id="carousel-style-accent" #{@gallery_items_attr} class="carousel carousel--accent w-full max-w-xs">
    #{@styling_carousel_triggers}
    </.carousel>
    <.carousel id="carousel-style-brand" #{@gallery_items_attr} class="carousel carousel--brand w-full max-w-xs">
    #{@styling_carousel_triggers}
    </.carousel>
    <.carousel id="carousel-style-alert" #{@gallery_items_attr} class="carousel carousel--alert w-full max-w-xs">
    #{@styling_carousel_triggers}
    </.carousel>
    <.carousel id="carousel-style-info" #{@gallery_items_attr} class="carousel carousel--info w-full max-w-xs">
    #{@styling_carousel_triggers}
    </.carousel>
    <.carousel id="carousel-style-success" #{@gallery_items_attr} class="carousel carousel--success w-full max-w-xs">
    #{@styling_carousel_triggers}
    </.carousel>
    """
  end

  def styling_color_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-4 items-end justify-center">
      <.carousel id="carousel-style-default" items={gallery_images()} class="carousel w-full max-w-xs">
        <:prev_trigger><.heroicon name="hero-arrow-left" /></:prev_trigger>
        <:next_trigger><.heroicon name="hero-arrow-right" /></:next_trigger>
      </.carousel>
      <.carousel
        id="carousel-style-accent"
        items={gallery_images()}
        class="carousel carousel--accent w-full max-w-xs"
      >
        <:prev_trigger><.heroicon name="hero-arrow-left" /></:prev_trigger>
        <:next_trigger><.heroicon name="hero-arrow-right" /></:next_trigger>
      </.carousel>
      <.carousel
        id="carousel-style-brand"
        items={gallery_images()}
        class="carousel carousel--brand w-full max-w-xs"
      >
        <:prev_trigger><.heroicon name="hero-arrow-left" /></:prev_trigger>
        <:next_trigger><.heroicon name="hero-arrow-right" /></:next_trigger>
      </.carousel>
      <.carousel
        id="carousel-style-alert"
        items={gallery_images()}
        class="carousel carousel--alert w-full max-w-xs"
      >
        <:prev_trigger><.heroicon name="hero-arrow-left" /></:prev_trigger>
        <:next_trigger><.heroicon name="hero-arrow-right" /></:next_trigger>
      </.carousel>
      <.carousel
        id="carousel-style-info"
        items={gallery_images()}
        class="carousel carousel--info w-full max-w-xs"
      >
        <:prev_trigger><.heroicon name="hero-arrow-left" /></:prev_trigger>
        <:next_trigger><.heroicon name="hero-arrow-right" /></:next_trigger>
      </.carousel>
      <.carousel
        id="carousel-style-success"
        items={gallery_images()}
        class="carousel carousel--success w-full max-w-xs"
      >
        <:prev_trigger><.heroicon name="hero-arrow-left" /></:prev_trigger>
        <:next_trigger><.heroicon name="hero-arrow-right" /></:next_trigger>
      </.carousel>
    </div>
    """
  end

  def styling_size_code do
    """
    <.carousel id="carousel-style-sm" #{@gallery_items_attr} class="carousel carousel--sm w-full max-w-3xs">
    #{@styling_carousel_triggers}
    </.carousel>
    <.carousel id="carousel-style-md" #{@gallery_items_attr} class="carousel carousel--md w-full max-w-xs">
    #{@styling_carousel_triggers}
    </.carousel>
    <.carousel id="carousel-style-lg" #{@gallery_items_attr} class="carousel carousel--lg w-full max-w-md">
    #{@styling_carousel_triggers}
    </.carousel>
    <.carousel id="carousel-style-xl" #{@gallery_items_attr} class="carousel carousel--xl w-full max-w-lg">
    #{@styling_carousel_triggers}
    </.carousel>
    """
  end

  def styling_size_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-6 items-end justify-center">
      <.carousel
        id="carousel-style-sm"
        items={gallery_images()}
        class="carousel carousel--sm w-full max-w-3xs"
      >
        <:prev_trigger><.heroicon name="hero-arrow-left" /></:prev_trigger>
        <:next_trigger><.heroicon name="hero-arrow-right" /></:next_trigger>
      </.carousel>
      <.carousel
        id="carousel-style-md"
        items={gallery_images()}
        class="carousel carousel--md w-full max-w-xs"
      >
        <:prev_trigger><.heroicon name="hero-arrow-left" /></:prev_trigger>
        <:next_trigger><.heroicon name="hero-arrow-right" /></:next_trigger>
      </.carousel>
      <.carousel
        id="carousel-style-lg"
        items={gallery_images()}
        class="carousel carousel--lg w-full max-w-md"
      >
        <:prev_trigger><.heroicon name="hero-arrow-left" /></:prev_trigger>
        <:next_trigger><.heroicon name="hero-arrow-right" /></:next_trigger>
      </.carousel>
      <.carousel
        id="carousel-style-xl"
        items={gallery_images()}
        class="carousel carousel--xl w-full max-w-lg"
      >
        <:prev_trigger><.heroicon name="hero-arrow-left" /></:prev_trigger>
        <:next_trigger><.heroicon name="hero-arrow-right" /></:next_trigger>
      </.carousel>
    </div>
    """
  end

  def styling_radius_code do
    """
    <.carousel id="carousel-style-rounded-default" #{@gallery_items_attr} class="carousel w-full max-w-xs">
    #{@styling_carousel_triggers}
    </.carousel>
    <.carousel id="carousel-style-rounded-none" #{@gallery_items_attr} class="carousel carousel--rounded-none w-full max-w-xs">
    #{@styling_carousel_triggers}
    </.carousel>
    <.carousel id="carousel-style-rounded-sm" #{@gallery_items_attr} class="carousel carousel--rounded-sm w-full max-w-xs">
    #{@styling_carousel_triggers}
    </.carousel>
    <.carousel id="carousel-style-rounded-md" #{@gallery_items_attr} class="carousel carousel--rounded-md w-full max-w-xs">
    #{@styling_carousel_triggers}
    </.carousel>
    <.carousel id="carousel-style-rounded-lg" #{@gallery_items_attr} class="carousel carousel--rounded-lg w-full max-w-xs">
    #{@styling_carousel_triggers}
    </.carousel>
    <.carousel id="carousel-style-rounded-xl" #{@gallery_items_attr} class="carousel carousel--rounded-xl w-full max-w-xs">
    #{@styling_carousel_triggers}
    </.carousel>
    <.carousel id="carousel-style-rounded-full" #{@gallery_items_attr} class="carousel carousel--rounded-full w-full max-w-xs">
    #{@styling_carousel_triggers}
    </.carousel>
    """
  end

  def styling_radius_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-6 items-end justify-center">
      <.carousel
        id="carousel-style-rounded-default"
        items={gallery_images()}
        class="carousel w-full max-w-xs"
      >
        <:prev_trigger><.heroicon name="hero-arrow-left" /></:prev_trigger>
        <:next_trigger><.heroicon name="hero-arrow-right" /></:next_trigger>
      </.carousel>
      <.carousel
        id="carousel-style-rounded-none"
        items={gallery_images()}
        class="carousel carousel--rounded-none w-full max-w-xs"
      >
        <:prev_trigger><.heroicon name="hero-arrow-left" /></:prev_trigger>
        <:next_trigger><.heroicon name="hero-arrow-right" /></:next_trigger>
      </.carousel>
      <.carousel
        id="carousel-style-rounded-sm"
        items={gallery_images()}
        class="carousel carousel--rounded-sm w-full max-w-xs"
      >
        <:prev_trigger><.heroicon name="hero-arrow-left" /></:prev_trigger>
        <:next_trigger><.heroicon name="hero-arrow-right" /></:next_trigger>
      </.carousel>
      <.carousel
        id="carousel-style-rounded-md"
        items={gallery_images()}
        class="carousel carousel--rounded-md w-full max-w-xs"
      >
        <:prev_trigger><.heroicon name="hero-arrow-left" /></:prev_trigger>
        <:next_trigger><.heroicon name="hero-arrow-right" /></:next_trigger>
      </.carousel>
      <.carousel
        id="carousel-style-rounded-lg"
        items={gallery_images()}
        class="carousel carousel--rounded-lg w-full max-w-xs"
      >
        <:prev_trigger><.heroicon name="hero-arrow-left" /></:prev_trigger>
        <:next_trigger><.heroicon name="hero-arrow-right" /></:next_trigger>
      </.carousel>
      <.carousel
        id="carousel-style-rounded-xl"
        items={gallery_images()}
        class="carousel carousel--rounded-xl w-full max-w-xs"
      >
        <:prev_trigger><.heroicon name="hero-arrow-left" /></:prev_trigger>
        <:next_trigger><.heroicon name="hero-arrow-right" /></:next_trigger>
      </.carousel>
      <.carousel
        id="carousel-style-rounded-full"
        items={gallery_images()}
        class="carousel carousel--rounded-full w-full max-w-xs"
      >
        <:prev_trigger><.heroicon name="hero-arrow-left" /></:prev_trigger>
        <:next_trigger><.heroicon name="hero-arrow-right" /></:next_trigger>
      </.carousel>
    </div>
    """
  end

  def events_server_heex do
    """
    <.carousel
      #{@gallery_items_attr}
      class="carousel"
      on_page_change="carousel_page_changed"
    >
      <:prev_trigger><.heroicon name="hero-arrow-left" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-arrow-right" /></:next_trigger>
    </.carousel>
    """
  end

  def events_server_elixir do
    """
    def handle_event("carousel_page_changed", %{"id" => id, "page" => page} = params, socket) do
      IO.inspect(params, label: "carousel_page_changed")
      {:noreply, socket}
    end
    """
  end

  def events_client_heex do
    """
    <.carousel
      id="carousel-events-client"
      #{@gallery_items_attr}
      class="carousel"
      on_page_change_client="carousel-page-changed"
    >
      <:prev_trigger><.heroicon name="hero-arrow-left" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-arrow-right" /></:next_trigger>
    </.carousel>
    """
  end

  def events_client_js do
    """
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
    """
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
    """
    <.carousel
      #{@gallery_items_attr}
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
      items={gallery_images()}
      class="carousel"
    >
      <:prev_trigger><.heroicon name="hero-arrow-left" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-arrow-right" /></:next_trigger>
    </.carousel>
    """
  end

  def loop_code do
    """
    <.carousel
      #{@gallery_items_attr}
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
      items={gallery_images()}
      loop
      class="carousel"
    >
      <:prev_trigger><.heroicon name="hero-arrow-left" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-arrow-right" /></:next_trigger>
    </.carousel>
    """
  end

  def vertical_code do
    """
    <.carousel
      #{@gallery_items_attr}
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
      items={gallery_images()}
      orientation="vertical"
      class="carousel"
    >
      <:prev_trigger><.heroicon name="hero-arrow-up" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-arrow-down" /></:next_trigger>
    </.carousel>
    """
  end

  def images_code do
    """
    <.carousel #{@gallery_items_attr} class="carousel">
      <:prev_trigger><.heroicon name="hero-arrow-left" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-arrow-right" /></:next_trigger>
    </.carousel>
    """
  end

  def images_example(assigns) do
    _ = assigns

    ~H"""
    <.carousel id="carousel-images" items={gallery_images()} class="carousel">
      <:prev_trigger><.heroicon name="hero-arrow-left" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-arrow-right" /></:next_trigger>
    </.carousel>
    """
  end

  def custom_content_code do
    """
    <.carousel #{@posts_items_attr} class="carousel">
      <:item :let={post}>
        <article>
          <h3>{post.title}</h3>
          <p>{post.description}</p>
          <.navigate to="#" class="link">Read more</.navigate>
        </article>
      </:item>
      <:prev_trigger><.heroicon name="hero-arrow-left" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-arrow-right" /></:next_trigger>
    </.carousel>
    """
  end

  def custom_content_example(assigns) do
    assigns = assign(assigns, :posts, blog_posts())

    ~H"""
    <.carousel id="carousel-blog" items={@posts} class="carousel">
      <:item :let={post}>
        <article class="flex flex-col gap-2 p-4">
          <h3>{post.title}</h3>
          <p>{post.description}</p>
          <.navigate to="#" class="link">Read more</.navigate>
        </article>
      </:item>
      <:prev_trigger><.heroicon name="hero-arrow-left" /></:prev_trigger>
      <:next_trigger><.heroicon name="hero-arrow-right" /></:next_trigger>
    </.carousel>
    """
  end

  def compound_code do
    """
    <.carousel compound :let={ctx} item_count={3} class="carousel">
      <.carousel_root ctx={ctx}>
        <.carousel_item_group ctx={ctx}>
          <%= for {post, index} <- Enum.with_index(#{@posts_list_attr}) do %>
            <.carousel_item ctx={ctx} index={index}>
              <article>
                <h3>{post.title}</h3>
                <p>{post.description}</p>
                <.navigate to="#" class="link">Read more</.navigate>
              </article>
            </.carousel_item>
          <% end %>
        </.carousel_item_group>
        <.carousel_control ctx={ctx}>
          <.carousel_prev_trigger ctx={ctx}><.heroicon name="hero-arrow-left" /></.carousel_prev_trigger>
          <.carousel_indicator_group ctx={ctx}>
            <%= for index <- 0..2 do %>
              <.carousel_indicator ctx={ctx} index={index} />
            <% end %>
          </.carousel_indicator_group>
          <.carousel_next_trigger ctx={ctx}><.heroicon name="hero-arrow-right" /></.carousel_next_trigger>
        </.carousel_control>
      </.carousel_root>
    </.carousel>
    """
  end

  def compound_example(assigns) do
    assigns = assign(assigns, :posts, blog_posts())

    ~H"""
    <.carousel :let={ctx} id="carousel-compound" compound item_count={3} class="carousel">
      <.carousel_root ctx={ctx}>
        <.carousel_item_group ctx={ctx}>
          <%= for {post, index} <- Enum.with_index(@posts) do %>
            <.carousel_item ctx={ctx} index={index}>
              <article class="flex flex-col gap-2 p-4">
                <h3>{post.title}</h3>
                <p>{post.description}</p>
                <.navigate to="#" class="link">Read more</.navigate>
              </article>
            </.carousel_item>
          <% end %>
        </.carousel_item_group>
        <.carousel_control ctx={ctx}>
          <.carousel_prev_trigger ctx={ctx}>
            <.heroicon name="hero-arrow-left" />
          </.carousel_prev_trigger>
          <.carousel_indicator_group ctx={ctx}>
            <%= for index <- 0..(length(@posts) - 1) do %>
              <.carousel_indicator ctx={ctx} index={index} />
            <% end %>
          </.carousel_indicator_group>
          <.carousel_next_trigger ctx={ctx}>
            <.heroicon name="hero-arrow-right" />
          </.carousel_next_trigger>
        </.carousel_control>
      </.carousel_root>
    </.carousel>
    """
  end
end
