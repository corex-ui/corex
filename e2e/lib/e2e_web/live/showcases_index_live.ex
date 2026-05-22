defmodule E2eWeb.ShowcasesIndexLive do
  use E2eWeb, :live_view

  import E2eWeb.ListingPage

  alias E2eWeb.ShowcaseCatalog

  @impl true
  def mount(_params, _session, socket) do
    showcases = ShowcaseCatalog.index_entries()

    {:ok,
     socket
     |> assign(:page_title, ~t"Showcases")
     |> assign(:seo, E2eWeb.SEO.showcases())
     |> assign(:showcases, showcases)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.blog flash={@flash} mode={@mode} theme={@theme} path={@path}>
      <div id="showcases-page" class="blog">
        <div class="blog__inner">
          <.listing_index_hero
            eyebrow={~t"Examples"}
            title={~t"Corex "}
            accent={~t"showcases"}
            lede={~t"Production-ready starters and interactive demos built with Corex components."}
            meta={
              ngettext("1 showcase", "%{count} showcases", length(@showcases),
                count: length(@showcases)
              )
            }
            heading_id="showcases-index-heading"
          />
        </div>

        <section class="blog__listing" aria-label={~t"Showcases"}>
          <div class="blog__inner">
            <div class="blog__grid">
              <.listing_card
                :for={showcase <- @showcases}
                title={showcase.title}
                description={showcase.description}
                detail_to={showcase_detail_to(showcase)}
                demo_to={Map.get(showcase, :demo_to)}
                github_to={Map.get(showcase, :github_to)}
                play_to={showcase_play_to(showcase)}
                tags={showcase.tags}
              />
            </div>
          </div>
        </section>
      </div>
    </Layouts.blog>
    """
  end

  defp showcase_detail_to(%{id: "soonex"}), do: ~p"/showcases/soonex"
  defp showcase_detail_to(%{id: "soonex-i18n"}), do: ~p"/showcases/soonex-i18n"
  defp showcase_detail_to(_), do: nil

  defp showcase_play_to(%{id: "tetrex"}), do: ~p"/showcases/tetrex"
  defp showcase_play_to(_), do: nil
end
