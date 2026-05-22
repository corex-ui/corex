defmodule E2eWeb.ShowcaseCatalog do
  @moduledoc false

  use GettextSigils, backend: E2eWeb.Gettext

  def carousel_items do
    [
      Corex.Image.new("/images/templates/soonex/preview-hero.png", alt: ~t"Hero section"),
      Corex.Image.new("/images/templates/soonex/preview-highlights.png",
        alt: ~t"Highlights section"
      ),
      Corex.Image.new("/images/templates/soonex/preview-waitlist.png",
        alt: ~t"Waitlist section"
      )
    ]
  end

  def index_entries do
    [
      %{
        id: "soonex",
        title: "Soonex",
        description:
          "Single-locale coming-soon layout with Neo through Leo themes, Markdown journal, waitlist, and static assets sized for GitHub Pages or any CDN.",
        detail_to: "/showcases/soonex",
        demo_to: "https://corex-ui.github.io/soonex/",
        github_to: "https://github.com/corex-ui/soonex",
        tags: ["Starter kit", "Tableau"]
      },
      %{
        id: "soonex-i18n",
        title: "Soonex i18n",
        description:
          "Locales and RTL on the same stack: localized routes, Arabic typography, and the same Corex component set as Soonex.",
        detail_to: "/showcases/soonex-i18n",
        demo_to: "https://corex-ui.github.io/soonex_i18n/",
        github_to: "https://github.com/corex-ui/soonex_i18n",
        tags: ["Locales", "RTL"]
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

  def template(:soonex) do
    %{
      id: :soonex,
      page_title: "Soonex",
      heading: "Soonex",
      subtitle: "Static Tableau starter with Corex",
      lede:
        "Single-locale coming-soon layout with Neo through Leo themes, Markdown journal, waitlist, and static assets sized for GitHub Pages or any CDN.",
      badge_icon: "hero-bolt",
      badge_label: "Starter kit",
      carousel_id: "soonex-showcase-carousel",
      carousel_aria: "Soonex preview slides",
      demo_to: "https://corex-ui.github.io/soonex/",
      github_to: "https://github.com/corex-ui/soonex"
    }
  end

  def template(:soonex_i18n) do
    %{
      id: :soonex_i18n,
      page_title: "Soonex i18n",
      heading: "Soonex i18n",
      subtitle: "Locales and RTL on the same stack",
      lede:
        "Same Soonex surface with Gettext and Localize: Arabic, English, and French out of the box, RTL-aware controls, and the same static build pipeline.",
      badge_icon: "hero-language",
      badge_label: "Locales & RTL",
      carousel_id: "soonex-i18n-showcase-carousel",
      carousel_aria: "Soonex i18n preview slides",
      demo_to: "https://corex-ui.github.io/soonex_i18n/",
      github_to: "https://github.com/corex-ui/soonex_i18n"
    }
  end

  def template_for_live_action(:soonex), do: template(:soonex)
  def template_for_live_action(:soonex_i18n), do: template(:soonex_i18n)
end
