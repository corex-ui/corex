defmodule E2eWeb.FeedController do
  use E2eWeb, :controller

  @channel_title "Corex Blog"
  @channel_description "Articles about Corex, Phoenix LiveView, accessibility, and UI development."

  def index(conn, _params) do
    base = E2eWeb.SEO.base_url()
    posts = E2e.Blog.list_posts("en")
    updated = latest_pub_date(posts)

    body =
      [
        ~S(<?xml version="1.0" encoding="UTF-8"?>),
        ~S(<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">),
        "<channel>",
        element("title", @channel_title),
        element("link", base <> "/en/blog"),
        element("description", @channel_description),
        element("language", "en"),
        element("lastBuildDate", updated),
        ~s(<atom:link href="#{xml_escape(base <> "/feed.xml")}" rel="self" type="application/rss+xml" />),
        Enum.map(posts, &item_entry(base, &1)),
        "</channel>",
        "</rss>"
      ]
      |> IO.iodata_to_binary()

    conn
    |> put_resp_content_type("application/rss+xml")
    |> send_resp(200, body)
  end

  defp item_entry(base, post) do
    link = base <> normalize_permalink(post.permalink)
    pub_date = post_pub_date(post)

    [
      "<item>",
      element("title", post.title),
      element("link", link),
      element("guid", link, isPermaLink: "true"),
      element("pubDate", pub_date),
      optional_element("description", post.description),
      Enum.map(post.tags || [], &element("category", &1)),
      "</item>"
    ]
  end

  defp latest_pub_date([%{date: %DateTime{} = dt} | _]), do: rss_date(dt)

  defp latest_pub_date([%{date: %Date{} = d} | _]) do
    d
    |> DateTime.new!(~T[12:00:00], "Etc/UTC")
    |> rss_date()
  end

  defp latest_pub_date(_), do: rss_date(DateTime.utc_now())

  defp post_pub_date(%{date: %DateTime{} = dt}), do: rss_date(dt)

  defp post_pub_date(%{date: %Date{} = d}) do
    d
    |> DateTime.new!(~T[12:00:00], "Etc/UTC")
    |> rss_date()
  end

  defp post_pub_date(_), do: rss_date(DateTime.utc_now())

  defp rss_date(%DateTime{} = dt) do
    dt
    |> DateTime.shift_zone!("Etc/UTC")
    |> Calendar.strftime("%a, %d %b %Y %H:%M:%S +0000")
  end

  defp normalize_permalink(path) when is_binary(path) do
    path
    |> String.trim()
    |> then(fn p -> if String.starts_with?(p, "/"), do: p, else: "/" <> p end)
    |> String.trim_trailing("/")
    |> then(fn p -> p <> "/" end)
  end

  defp element(name, value, attrs \\ []) do
    attr_str =
      Enum.map_join(attrs, "", fn {k, v} -> " #{k}=\"#{xml_escape(to_string(v))}\"" end)

    "<#{name}#{attr_str}>#{xml_escape(to_string(value))}</#{name}>"
  end

  defp optional_element(_name, nil), do: ""
  defp optional_element(_name, ""), do: ""
  defp optional_element(name, value), do: element(name, value)

  defp xml_escape(text) when is_binary(text) do
    text
    |> String.replace("&", "&amp;")
    |> String.replace("<", "&lt;")
    |> String.replace(">", "&gt;")
    |> String.replace("\"", "&quot;")
    |> String.replace("'", "&apos;")
  end
end
