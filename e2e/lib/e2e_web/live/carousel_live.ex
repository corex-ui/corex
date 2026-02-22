defmodule E2eWeb.CarouselLive do
  use E2eWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
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
      <.carousel
        id="my-carousel"
        items={[
          "/images/beach.jpg",
          "/images/fall.jpg",
          "/images/sand.jpg",
          "/images/star.jpg",
          "/images/winter.jpg"
        ]}
        class="carousel"
      >
        <:prev_trigger>
          <svg
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 24 24"
            stroke-width="1.5"
            stroke="currentColor"
            class="icon"
          >
            <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 19.5 8.25 12l7.5-7.5" />
          </svg>
        </:prev_trigger>
        <:next_trigger>
          <svg
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 24 24"
            stroke-width="1.5"
            stroke="currentColor"
            class="icon"
          >
            <path stroke-linecap="round" stroke-linejoin="round" d="m8.25 4.5 7.5 7.5-7.5 7.5" />
          </svg>
        </:next_trigger>
      </.carousel>
    </Layouts.app>
    """
  end
end
