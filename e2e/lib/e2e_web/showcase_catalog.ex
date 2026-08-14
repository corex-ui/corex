defmodule E2eWeb.ShowcaseCatalog do
  @moduledoc false

  use GettextSigils, backend: E2eWeb.Gettext

  def home_entries do
    Enum.filter(index_entries(), &(&1.id in ["netoum", "oranje-patrimoine"]))
  end

  def index_entries do
    [
      %{
        id: "netoum",
        title: ~t"Netoum",
        description:
          ~t"The company behind Corex: product design, accessible web apps, and open-source tooling.",
        site_to: "https://netoum.com",
        site_label: ~t"Visit site",
        image: "/images/showcases/netoum.png",
        image_alt: ~t"Netoum homepage",
        tags: [~t"Company", ~t"Open source"]
      },
      %{
        id: "oranje-patrimoine",
        title: ~t"Oranje Patrimoine",
        description:
          ~t"Paris property-management site built with Corex, a CMS admin, and a contact form.",
        site_to: "https://oranje-patrimoine.fr/",
        site_label: ~t"Visit site",
        image: "/images/showcases/oranje-patrimoine.png",
        image_alt: ~t"Oranje Patrimoine homepage",
        tags: [~t"Landing", ~t"Tableau", ~t"CMS"]
      },
      %{
        id: "tetrex",
        title: ~t"Tetrex",
        description:
          ~t"Checkbox Tetris with semantic piece colors, live sessions, top-10 leaderboard, and frame replay.",
        play_to: "/showcases/tetrex",
        play_label: ~t"Play now",
        image: "/images/showcases/tetrex.png",
        image_alt: ~t"Tetrex gameplay",
        tags: [~t"LiveView", ~t"Checkbox"]
      },
      %{
        id: "soonex",
        title: ~t"Soonex",
        description:
          ~t"Single-locale coming-soon layout with Neo through Leo themes, Markdown journal, waitlist, and static assets sized for GitHub Pages or any CDN.",
        demo_to: "https://corex-ui.github.io/soonex/",
        github_to: "https://github.com/corex-ui/soonex",
        image: "/images/showcases/soonex.png",
        image_alt: ~t"Soonex live demo",
        tags: [~t"Starter kit", ~t"Tableau"]
      },
      %{
        id: "soonex-i18n",
        title: ~t"Soonex i18n",
        description:
          ~t"Locales and RTL on the same stack: localized routes, Arabic typography, and the same Corex component set as Soonex.",
        demo_to: "https://corex-ui.github.io/soonex_i18n/",
        github_to: "https://github.com/corex-ui/soonex_i18n",
        image: "/images/showcases/soonex-i18n.png",
        image_alt: ~t"Soonex i18n live demo",
        tags: [~t"Locales", ~t"RTL"]
      }
    ]
  end
end
