defmodule E2eWeb.ShowcaseCatalog do
  @moduledoc false

  def index_entries do
    [
      %{
        id: "soonex",
        title: "Soonex",
        description:
          "Single-locale coming-soon layout with Neo through Leo themes, Markdown journal, waitlist, and static assets sized for GitHub Pages or any CDN.",
        demo_to: "https://corex-ui.github.io/soonex/",
        github_to: "https://github.com/corex-ui/soonex",
        tags: ["Starter kit", "Tableau"]
      },
      %{
        id: "soonex-i18n",
        title: "Soonex i18n",
        description:
          "Locales and RTL on the same stack: localized routes, Arabic typography, and the same Corex component set as Soonex.",
        demo_to: "https://corex-ui.github.io/soonex_i18n/",
        github_to: "https://github.com/corex-ui/soonex_i18n",
        tags: ["Locales", "RTL"]
      },
      %{
        id: "landex",
        title: "Landex",
        description:
          "A landing page built with Corex, Tableau, and Motion. Contact form using a Cloudflare Worker and the Resend API.",
        site_to: "https://oranje-patrimoine.fr/",
        tags: ["Landing", "Tableau", "Motion"]
      },
      %{
        id: "tetrex",
        title: "Tetrex",
        description:
          "Checkbox Tetris with semantic piece colors, live sessions, top-10 leaderboard, and frame replay.",
        play_to: "/showcases/tetrex",
        tags: ["LiveView", "Checkbox"]
      }
    ]
  end
end
