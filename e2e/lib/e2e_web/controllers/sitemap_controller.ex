defmodule E2eWeb.SitemapController do
  use E2eWeb, :controller

  @static_pages [
    %{loc: "/", priority: 1.0, changefreq: "weekly"},
    %{loc: "/en/blog", priority: 0.8, changefreq: "weekly"},
    %{loc: "/ar/blog", priority: 0.8, changefreq: "weekly"},
    %{loc: "/en/showcases", priority: 0.7, changefreq: "monthly"},
    %{loc: "/ar/showcases", priority: 0.7, changefreq: "monthly"},
    %{loc: "/en/showcases/soonex", priority: 0.7, changefreq: "monthly"},
    %{loc: "/ar/showcases/soonex", priority: 0.7, changefreq: "monthly"},
    %{loc: "/en/showcases/soonex-i18n", priority: 0.7, changefreq: "monthly"},
    %{loc: "/ar/showcases/soonex-i18n", priority: 0.7, changefreq: "monthly"},
    %{loc: "/en/showcases/tetrex", priority: 0.6, changefreq: "weekly"},
    %{loc: "/ar/showcases/tetrex", priority: 0.6, changefreq: "weekly"}
  ]

  def index(conn, _params) do
    urls = @static_pages ++ E2e.Blog.sitemap_entries()
    base = E2eWeb.SEO.base_url()

    body =
      [
        ~S(<?xml version="1.0" encoding="UTF-8"?>),
        ~S(<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">),
        Enum.map(urls, &url_entry(base, &1)),
        ~S(</urlset>)
      ]
      |> IO.iodata_to_binary()

    conn
    |> put_resp_content_type("application/xml")
    |> send_resp(200, body)
  end

  defp url_entry(base, %{loc: loc} = entry) do
    path = if String.starts_with?(loc, "/"), do: loc, else: "/" <> loc
    loc_url = base <> path

    lastmod =
      case Map.get(entry, :lastmod) do
        s when is_binary(s) -> "<lastmod>#{s}</lastmod>"
        _ -> ""
      end

    priority = Map.get(entry, :priority, 0.5)
    changefreq = Map.get(entry, :changefreq, "monthly")

    """
    <url>
      <loc>#{loc_url}</loc>
      #{lastmod}
      <changefreq>#{changefreq}</changefreq>
      <priority>#{priority}</priority>
    </url>
    """
  end
end
