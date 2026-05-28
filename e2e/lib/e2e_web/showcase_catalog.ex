defmodule E2eWeb.ShowcaseCatalog do
  @moduledoc false

  use GettextSigils, backend: E2eWeb.Gettext

  def index_entries do
    [
      %{
        id: "soonex",
        title: ~t"Soonex",
        description:
          ~t"Single-locale coming-soon layout with Neo through Leo themes, Markdown journal, waitlist, and static assets sized for GitHub Pages or any CDN.",
        demo_to: "https://corex-ui.github.io/soonex/",
        github_to: "https://github.com/corex-ui/soonex",
        tags: [~t"Starter kit", ~t"Tableau"]
      },
      %{
        id: "soonex-i18n",
        title: ~t"Soonex i18n",
        description:
          ~t"Locales and RTL on the same stack: localized routes, Arabic typography, and the same Corex component set as Soonex.",
        demo_to: "https://corex-ui.github.io/soonex_i18n/",
        github_to: "https://github.com/corex-ui/soonex_i18n",
        tags: [~t"Locales", ~t"RTL"]
      },
      %{
        id: "landex",
        title: ~t"Landex",
        description:
          ~t"A landing page built with Corex, Tableau, and Motion. Contact form using a Cloudflare Worker and the Resend API.",
        site_to: "https://oranje-patrimoine.fr/",
        tags: [~t"Landing", ~t"Tableau", ~t"Motion"]
      },
      %{
        id: "tetrex",
        title: ~t"Tetrex",
        description:
          ~t"Checkbox Tetris with semantic piece colors, live sessions, top-10 leaderboard, and frame replay.",
        play_to: "/showcases/tetrex",
        tags: [~t"LiveView", ~t"Checkbox"]
      }
    ]
  end
end
