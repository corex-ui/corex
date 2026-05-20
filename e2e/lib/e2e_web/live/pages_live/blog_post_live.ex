defmodule E2eWeb.BlogPostLive do
  use E2eWeb, :live_view

  import E2eWeb.BlogPage

  @impl true
  def mount(%{"slug" => slug}, _session, socket) do
    case E2e.Blog.get_by_slug(slug, E2eWeb.Locale.current()) do
      nil ->
        {:ok,
         socket
         |> put_flash(:error, ~t"Post not found")
         |> push_navigate(to: ~p"/blog")}

      post ->
        %{prev: prev, next: next} = E2e.Blog.prev_next_post(slug, E2eWeb.Locale.current())

        suggested = E2e.Blog.suggested_reads(slug, E2eWeb.Locale.current())

        {:ok,
         socket
         |> assign(:page_title, post.title)
         |> assign(:seo, E2eWeb.SEO.for_post(post))
         |> assign(:post, post)
         |> assign(:date_label, post_date_label(post))
         |> assign(:reading_time, reading_time_minutes(post))
         |> assign(:tags, post.tags || [])
         |> assign(:suggested_reads, suggested)
         |> assign(:prev_post, prev)
         |> assign(:next_post, next)}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.blog flash={@flash} mode={@mode} theme={@theme} path={@path}>
      <article class="blog blog--post">
        <.blog_post_hero
          title={@post.title}
          description={@post.description}
          date_label={@date_label}
          reading_time={@reading_time}
          tags={@tags}
          prev={@prev_post}
          next={@next_post}
        />

        <section class="blog__post-body" aria-label={~t"Article"}>
          <div class="blog__inner">
            <div class="blog__article-shell typo markdown prose max-w-none">
              {@post.html |> Phoenix.HTML.raw()}
            </div>
          </div>
        </section>

        <.blog_read_next posts={@suggested_reads} />
      </article>
    </Layouts.blog>
    """
  end
end
