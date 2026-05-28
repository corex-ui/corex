defmodule E2eWeb.BlogController do
  use E2eWeb, :controller

  import E2eWeb.BlogPage

  @page_size 4

  def index(conn, params) do
    posts = E2e.Blog.list_posts()
    post_count = length(posts)
    total_pages = total_pages(post_count, @page_size)
    page = parse_page(params["page"], total_pages)
    page_posts = slice_posts(posts, page, @page_size)

    conn
    |> assign(:page_title, ~t"Blog")
    |> assign(:seo, E2eWeb.SEO.blog_index())
    |> assign(:post_count, post_count)
    |> assign(:page, page)
    |> assign(:page_size, @page_size)
    |> assign(:total_pages, total_pages)
    |> assign(:posts, page_posts)
    |> render(:index)
  end

  def show(conn, %{"slug" => slug}) do
    case E2e.Blog.get_by_slug(slug, E2eWeb.Locale.current()) do
      nil ->
        conn
        |> put_flash(:error, ~t"Post not found")
        |> redirect(to: ~p"/blog")

      post ->
        %{prev: prev, next: next} = E2e.Blog.prev_next_post(slug, E2eWeb.Locale.current())
        suggested = E2e.Blog.suggested_reads(slug, E2eWeb.Locale.current())

        conn
        |> assign(:page_title, post.title)
        |> assign(:seo, E2eWeb.SEO.for_post(post))
        |> assign(:post, post)
        |> assign(:date_label, post_date_label(post))
        |> assign(:reading_time, reading_time_minutes(post))
        |> assign(:tags, post.tags || [])
        |> assign(:suggested_reads, suggested)
        |> assign(:prev_post, prev)
        |> assign(:next_post, next)
        |> render(:show)
    end
  end

  defp total_pages(count, page_size) do
    count = max(count, 0)
    page_size = max(page_size, 1)

    if count == 0, do: 0, else: div(count + page_size - 1, page_size)
  end

  defp parse_page(raw, total_pages) do
    max_page = max(total_pages, 1)

    case Integer.parse(to_string(raw || "")) do
      {n, _} -> min(max(n, 1), max_page)
      _ -> 1
    end
  end

  defp slice_posts(posts, page, page_size) do
    offset = max(page - 1, 0) * page_size
    Enum.slice(posts, offset, page_size)
  end
end
