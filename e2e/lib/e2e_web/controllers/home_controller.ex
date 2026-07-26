defmodule E2eWeb.HomeController do
  use E2eWeb, :controller

  def index(conn, _params) do
    conn
    |> assign(:page_title, "Corex")
    |> assign(:seo, E2eWeb.SEO.home())
    |> assign(:hero_bullets, hero_bullets())
    |> assign(:hero_accordion_items, hero_accordion_items())
    |> render(:index)
  end

  defp hero_accordion_items do
    [
      %{
        value: "anatomy",
        label: ~t"Anatomy & slots",
        content: ~t"Structure, custom slots, compound mode."
      },
      %{
        value: "machine",
        label: ~t"State machines",
        content: ~t"Zag.js powers accessibility, keyboard, and focus."
      }
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
        title: ~t"LiveView-native.",
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
