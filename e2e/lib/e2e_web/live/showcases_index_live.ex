defmodule E2eWeb.ShowcasesIndexLive do
  use E2eWeb, :live_view

  import E2eWeb.ListingPage

  alias E2eWeb.ShowcaseCatalog

  @impl true
  def mount(_params, _session, socket) do
    showcases =
      ShowcaseCatalog.index_entries()
      |> Enum.map(&localize_showcase/1)

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
                demo_to={Map.get(showcase, :demo_to)}
                github_to={Map.get(showcase, :github_to)}
                play_to={Map.get(showcase, :play_to)}
                play_label={Map.get(showcase, :play_label)}
                tags={showcase.tags}
              />
            </div>
          </div>
        </section>
      </div>
    </Layouts.blog>
    """
  end

  defp localize_showcase(%{play_to: "/showcases/tetrex"} = entry),
    do: Map.put(entry, :play_to, ~p"/showcases/tetrex")

  defp localize_showcase(entry), do: entry
end
