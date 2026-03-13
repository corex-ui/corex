defmodule CorexWeb.Marquee do
  use Phoenix.Component
  use E2eWeb.LiveCapture

  alias Corex.{Heroicon, Marquee}

  @items_pause_on_hover [
    %{name: "Apple", logo: "🍎"},
    %{name: "Banana", logo: "🍌"},
    %{name: "Cherry", logo: "🍒"},
    %{name: "Grape", logo: "🍇"},
    %{name: "Lemon", logo: "🍋"}
  ]

  @items_with_components [
    %{name: "Home", icon: "hero-home"},
    %{name: "User", icon: "hero-user"},
    %{name: "Cog", icon: "hero-cog-6-tooth"},
    %{name: "Heart", icon: "hero-heart"},
    %{name: "Star", icon: "hero-star"}
  ]

  @items_with_files [
    %{name: "Phoenix", src: "/images/tech/phoenix.svg"},
    %{name: "Elixir", src: "/images/tech/elixir.svg"},
    %{name: "HTML5", src: "/images/tech/html5.svg"},
    %{name: "CSS", src: "/images/tech/css.svg"},
    %{name: "JavaScript", src: "/images/tech/javascript.svg"},
    %{name: "TypeScript", src: "/images/tech/typescript.svg"},
    %{name: "Tailwind", src: "/images/tech/tailwind.svg"},
    %{name: "Figma", src: "/images/tech/figma.svg"}
  ]

  capture variants: [
            pause_on_hover: %{
              id: "my-marquee",
              class: "marquee",
              items: @items_pause_on_hover,
              duration: 20,
              spacing: "2rem",
              pause_on_interaction: true,
              item: [
                %{
                  let: :item,
                  inner_block: ~s(<span>{item.item.logo}</span> <span>{item.item.name}</span>)
                }
              ]
            },
            with_components: %{
              id: "marquee-icons",
              class: "marquee",
              items: @items_with_components,
              duration: 25,
              spacing: "2rem",
              pause_on_interaction: true,
              item: [
                %{
                  let: :item,
                  inner_block:
                    ~s(<.heroicon name={item.item.icon} class="icon" /><span>{item.item.name}</span>)
                }
              ]
            },
            with_files: %{
              id: "marquee-tech",
              class: "marquee",
              items: @items_with_files,
              duration: 30,
              spacing: "2rem",
              pause_on_interaction: true,
              item: [
                %{
                  let: :item,
                  inner_block:
                    ~s(<img src={item.item.src} alt={item.item.name} class="w-10 mx-auto" /><p>{item.item.name}</p>)
                }
              ]
            }
          ]

  defdelegate marquee(assigns), to: Marquee
  defdelegate heroicon(assigns), to: Heroicon
end
