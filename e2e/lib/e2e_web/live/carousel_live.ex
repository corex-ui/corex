defmodule E2eWeb.CarouselLive do
  use E2eWeb, :live_view


  def mount(_params, _session, socket) do
    {:ok, assign(socket, :carousel_items, [
      ~p"/images/beach.jpg",
      ~p"/images/fall.jpg",
      ~p"/images/sand.jpg",
      ~p"/images/star.jpg",
      ~p"/images/winter.jpg"
    ])}
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
        <h1>Carousel</h1>
        <h2>Live View</h2>
      </div>
      <div class="layout__row flex flex-col gap-ui">
        <section>
          <h3 class="font-ui-lg mb-micro">Basic</h3>
          <.carousel id="carousel-basic" items={@carousel_items} class="carousel">
            <:prev_trigger>
              <.icon name="hero-arrow-left" />
            </:prev_trigger>
            <:next_trigger>
              <.icon name="hero-arrow-right" />
            </:next_trigger>
          </.carousel>
        </section>
        <section>
          <h3 class="font-ui-lg mb-micro">Loop</h3>
          <.carousel id="carousel-loop" items={@carousel_items} loop class="carousel">
            <:prev_trigger>
              <.icon name="hero-arrow-left" />
            </:prev_trigger>
            <:next_trigger>
              <.icon name="hero-arrow-right" />
            </:next_trigger>
          </.carousel>
        </section>
        <section>
          <h3 class="font-ui-lg mb-micro">Vertical</h3>
          <.carousel
            id="carousel-vertical"
            items={@carousel_items}
            orientation="vertical"
            class="carousel"
          >
            <:prev_trigger>
              <.icon name="hero-arrow-up" />
            </:prev_trigger>
            <:next_trigger>
              <.icon name="hero-arrow-down" />
            </:next_trigger>
          </.carousel>
        </section>
        <section>
          <h3 class="font-ui-lg mb-micro">Slides per page (2)</h3>
          <.carousel
            id="carousel-multiple"
            items={@carousel_items}
            slides_per_page={2}
            class="carousel"
          >
            <:prev_trigger>
              <.icon name="hero-arrow-left" />
            </:prev_trigger>
            <:next_trigger>
              <.icon name="hero-arrow-right" />
            </:next_trigger>
          </.carousel>
        </section>
        <section>
          <h3 class="font-ui-lg mb-micro">Autoplay</h3>
          <.carousel id="carousel-autoplay" items={@carousel_items} autoplay class="carousel">
            <:prev_trigger>
              <.icon name="hero-arrow-left" />
            </:prev_trigger>
            <:next_trigger>
              <.icon name="hero-arrow-right" />
            </:next_trigger>
          </.carousel>
        </section>
      </div>
    </Layouts.app>
    """
  end
end
