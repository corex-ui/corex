defmodule E2eWeb.HomeController do
  use E2eWeb, :controller

  @hero_code_snippet ~S"""
  <.accordion
    id="hero-accordion"
    value="machine"
    on_value_change_client="hero-accordion-changed"
  >
    <:trigger value="anatomy">
      Anatomy & slots
    </:trigger>
    <:content value="anatomy"><p>Structure, custom slots, compound mode.</p></:content>
    <:indicator value="anatomy">
      <.heroicon name="hero-chevron-right" />
    </:indicator>

    <:trigger value="machine">
      State machines
    </:trigger>
    <:content value="machine"><p>Zag.js powers accessibility, keyboard, and focus.</p></:content>
    <:indicator value="machine">
      <.heroicon name="hero-chevron-right" />
    </:indicator>
  </.accordion>
  """

  @install_command "mix corex.new my_app"

  def index(conn, _params) do
    conn
    |> assign(:page_title, "Corex")
    |> assign(:seo, E2eWeb.SEO.home())
    |> assign(:hero_code, @hero_code_snippet)
    |> assign(:install_command, @install_command)
    |> assign(:hero_marquee_items, hero_marquee_items())
    |> assign(:hero_bullets, hero_bullets())
    |> assign(:component_count, length(Corex.component_ids()))
    |> render(:index)
  end

  defp hero_marquee_items do
    [
      %{name: ~t"Elixir", img: "/images/tech/elixir.svg"},
      %{name: ~t"Phoenix", img: "/images/tech/phoenix.svg"},
      %{name: ~t"Zag.js", img: "/images/tech/zag.webp"},
      %{name: ~t"TypeScript", img: "/images/tech/typescript.svg"},
      %{name: ~t"Tailwind", img: "/images/tech/tailwind.svg"},
      %{name: ~t"Figma", img: "/images/tech/figma.svg"}
    ]
  end

  defp hero_bullets do
    [
      %{
        title: ~t"Server & client API.",
        body:
          ~t"Drive every component from LiveView or JavaScript and listen back from either side."
      },
      %{
        title: ~t"LiveView‑native.",
        body: ~t"Update props at runtime without resetting component state."
      },
      %{
        title: ~t"Truly unstyled.",
        body: ~t"Bring your own CSS or opt into Corex Design tokens, themes and modes."
      },
      %{
        title: ~t"Accessible by default.",
        body: ~t"Keyboard, focus and ARIA wired in by Zag.js state machines."
      }
    ]
  end
end
