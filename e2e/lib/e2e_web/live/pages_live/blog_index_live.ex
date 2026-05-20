defmodule E2eWeb.BlogIndexLive do
  use E2eWeb, :live_view

  import E2eWeb.BlogPage

  @page_size 4

  @impl true
  def mount(_params, _session, socket) do
    posts = E2e.Blog.list_posts()
    post_count = length(posts)

    {:ok,
     socket
     |> assign(:page_title, ~t"Blog")
     |> assign(:seo, E2eWeb.SEO.blog_index())
     |> assign(:all_posts, posts)
     |> assign(:post_count, post_count)}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    total_pages = total_pages(socket.assigns.post_count, @page_size)
    page = parse_page(params["page"], total_pages)
    posts = slice_posts(socket.assigns.all_posts, page, @page_size)

    {:noreply,
     socket
     |> assign(:page, page)
     |> assign(:page_size, @page_size)
     |> assign(:total_pages, total_pages)
     |> assign(:posts, posts)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.blog flash={@flash} mode={@mode} theme={@theme} path={@path}>
      <div class="blog">
        <div class="blog__inner">
          <.blog_index_hero post_count={@post_count} />
        </div>

        <section class="blog__listing" aria-label={~t"Blog posts"}>
          <div class="blog__inner">
            <div :if={@posts != []} class="blog__grid">
              <.post_card :for={post <- @posts} post={post} />
            </div>

            <p :if={@posts == []} class="blog__empty">{~t"No posts yet."}</p>

            <div :if={@post_count > 0} class="blog__pagination">
              <.pagination
                id="blog-index-pagination"
                class="pagination pagination--accent"
                count={@post_count}
                page={@page}
                page_size={@page_size}
                sibling_count={1}
                boundary_count={1}
                dir={E2eWeb.Locale.dir(E2eWeb.Locale.current())}
                controlled={:all}
                type={:link}
                to={~p"/blog"}
                redirect={:patch}
              >
                <:prev><.heroicon name="hero-chevron-left" /></:prev>
                <:next><.heroicon name="hero-chevron-right" /></:next>
                <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
              </.pagination>
            </div>
          </div>
        </section>
      </div>
    </Layouts.blog>
    """
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
