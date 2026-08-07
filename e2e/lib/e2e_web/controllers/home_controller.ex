defmodule E2eWeb.HomeController do
  use E2eWeb, :controller

  def index(conn, _params) do
    conn
    |> assign(:page_title, "Corex")
    |> assign(:seo, E2eWeb.SEO.home())
    |> assign(:hero_bullets, hero_bullets())
    |> assign(:hero_accordion_items, hero_accordion_items())
    |> assign(:installer_generators, installer_generators())
    |> assign(:installer_flags, installer_flags())
    |> assign(:home_stats, home_stats())
    |> assign(:home_tech, home_tech())
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

  defp home_stats do
    [
      %{
        value: ~t"43+",
        label: ~t"Components",
        body: ~t"Works in Controller and Live View"
      },
      %{
        value: ~t"100+",
        label: ~t"API & Events",
        body: ~t"From the Server and the Client"
      },
      %{
        value: ~t"100%",
        label: ~t"Open Source",
        body: ~t"Open Source and free to use. MIT License"
      },
      %{
        value: ~t"A11y",
        label: ~t"Built in",
        body: ~t"Keyboard, focus and ARIA from Zag.js machines."
      }
    ]
  end

  defp home_tech do
    [
      %{name: "Elixir", src: ~p"/images/tech/elixir.svg"},
      %{name: "Phoenix", src: ~p"/images/tech/phoenix.svg"},
      %{name: "Tableau", src: ~p"/images/tech/tableau.jpg"},
      %{name: "Ecto", src: ~p"/images/tech/ecto.png"},
      %{name: "Zag.js", src: ~p"/images/tech/zag.webp"},
      %{name: "TypeScript", src: ~p"/images/tech/typescript.svg"},
      %{name: "Tailwind CSS", src: ~p"/images/tech/tailwind.svg"},
      %{name: "Hex", src: ~p"/images/tech/hex.svg"}
    ]
  end

  defp installer_generators do
    [
      %{
        value: "phoenix",
        label: ~t"Phoenix",
        tip: ~t"Full LiveView server application with Corex."
      },
      %{
        value: "tableau",
        label: ~t"Tableau",
        tip: ~t"Static site generation with Corex."
      }
    ]
  end

  defp installer_flags do
    [
      %{
        value: "design",
        label: ~t"Design",
        tip: ~t"Design tokens, themes, and component CSS. Deselect for --no-design.",
        kind: :default_on
      },
      %{
        value: "mcp",
        label: ~t"MCP",
        tip: ~t"Dev MCP server for AI tooling. Deselect for --no-mcp.",
        kind: :default_on
      },
      %{
        value: "usage-rules",
        label: ~t"Usage rules",
        tip: ~t"Agent skills and usage rules for the editor. Deselect for --no-usage-rules.",
        kind: :default_on
      },
      %{
        value: "mode",
        label: ~t"Mode",
        tip: ~t"Light and dark mode wiring with a toggle. Adds --mode.",
        kind: :opt_in
      },
      %{
        value: "theme",
        label: ~t"Theme",
        tip: ~t"Neo, Uno, Duo, and Leo theme packs with a switcher. Adds --theme.",
        kind: :opt_in
      },
      %{
        value: "a11y",
        label: ~t"A11y",
        tip: ~t"User preference panel for text, contrast, motion, and more. Adds --a11y.",
        kind: :opt_in
      },
      %{
        value: "lang",
        label: ~t"Lang",
        tip: ~t"Locales, Gettext, and a language switcher. Adds --lang.",
        kind: :opt_in
      }
    ]
  end
end
