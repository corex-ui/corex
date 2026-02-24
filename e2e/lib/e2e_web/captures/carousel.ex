defmodule CorexWeb.Carousel do
  use Phoenix.Component
  use E2eWeb.LiveCapture

  alias Corex.Carousel
  alias E2eWeb.CoreComponents

  @items [
    "/images/beach.jpg",
    "/images/fall.jpg",
    "/images/sand.jpg",
    "/images/star.jpg",
    "/images/winter.jpg"
  ]

  capture variants: [
            basic: %{
              id: "carousel-basic",
              class: "carousel",
              items: @items,
              prev_trigger: [%{inner_block: ~s(<.icon name="hero-arrow-left" />)}],
              next_trigger: [%{inner_block: ~s(<.icon name="hero-arrow-right" />)}]
            },
            loop: %{
              id: "carousel-loop",
              class: "carousel",
              items: @items,
              loop: true,
              prev_trigger: [%{inner_block: ~s(<.icon name="hero-arrow-left" />)}],
              next_trigger: [%{inner_block: ~s(<.icon name="hero-arrow-right" />)}]
            },
            vertical: %{
              id: "carousel-vertical",
              class: "carousel",
              items: @items,
              orientation: "vertical",
              prev_trigger: [%{inner_block: ~s(<.icon name="hero-arrow-up" />)}],
              next_trigger: [%{inner_block: ~s(<.icon name="hero-arrow-down" />)}]
            },
            slides_per_page: %{
              id: "carousel-multiple",
              class: "carousel",
              items: @items,
              slides_per_page: 2,
              prev_trigger: [%{inner_block: ~s(<.icon name="hero-arrow-left" />)}],
              next_trigger: [%{inner_block: ~s(<.icon name="hero-arrow-right" />)}]
            },
            auto_play: %{
              id: "carousel-autoplay",
              class: "carousel",
              items: @items,
              autoplay: true,
              prev_trigger: [%{inner_block: ~s(<.icon name="hero-arrow-left" />)}],
              next_trigger: [%{inner_block: ~s(<.icon name="hero-arrow-right" />)}]
            },
          ]

  defdelegate carousel(assigns), to: Carousel
  defdelegate icon(assigns), to: CoreComponents
end
