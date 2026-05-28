defmodule E2eWeb.ShowcasesController do
  use E2eWeb, :controller

  alias E2eWeb.ShowcaseCatalog

  def index(conn, _params) do
    showcases =
      ShowcaseCatalog.index_entries()
      |> Enum.map(&localize_showcase/1)

    conn
    |> assign(:page_title, ~t"Showcase")
    |> assign(:seo, E2eWeb.SEO.showcases())
    |> assign(:showcases, showcases)
    |> render(:index)
  end

  defp localize_showcase(%{play_to: "/showcases/tetrex"} = entry),
    do: Map.put(entry, :play_to, ~p"/showcases/tetrex")

  defp localize_showcase(entry), do: entry
end
