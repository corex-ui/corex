defmodule E2eWeb.BlogPage do
  @moduledoc false

  use E2eWeb, :html

  attr(:posts, :list, required: true)

  def blog_read_next(assigns) do
    ~H"""
    <section :if={@posts != []} class="blog__read-next" aria-labelledby="blog-read-next-heading">
      <div class="blog__inner blog__read-next__inner">
        <h2 id="blog-read-next-heading" class="blog__eyebrow">{~t"Continue reading"}</h2>
        <ul class="blog__read-next__list">
          <li :for={post <- @posts}>
            <.navigate to={~p"/blog/#{post.slug}"} class="blog__read-next__item">
              <span class="blog__read-next__copy">
                <span class="blog__read-next__title">{post.title}</span>
                <span :if={post.description} class="blog__read-next__excerpt">
                  {post.description}
                </span>
              </span>
              <.heroicon name="hero-arrow-right" class="blog__read-next__icon" />
            </.navigate>
          </li>
        </ul>
      </div>
    </section>
    """
  end

  attr(:title, :string, required: true)
  attr(:description, :string, default: nil)
  attr(:date_label, :string, default: nil)
  attr(:reading_time, :integer, default: nil)
  attr(:tags, :list, default: [])
  attr(:prev, :map, default: nil)
  attr(:next, :map, default: nil)

  def blog_post_hero(assigns) do
    ~H"""
    <header class="blog__post-hero" aria-labelledby="blog-post-heading">
      <div class="blog__inner blog__post-hero__inner">
        <div class="blog__post-toolbar">
          <.navigate to={~p"/blog"} class="blog__back link link--accent">
            <.heroicon name="hero-arrow-left" class="blog__back__icon" />
            {~t"All articles"}
          </.navigate>

          <nav
            :if={@prev || @next}
            class="blog__post-nav"
            aria-label={~t"Article navigation"}
          >
            <.navigate
              :if={@prev}
              to={~p"/blog/#{@prev.slug}"}
              class="button button--sm flex items-center gap-2 rounded-e-none"
            >
              <.heroicon name="hero-chevron-left" class="shrink-0" title={@prev.label} />
            </.navigate>
            <.navigate
              :if={@next}
              to={~p"/blog/#{@next.slug}"}
              class="button button--sm flex items-center gap-2 not-only:border-s-0 rounded-s-none"
            >
              <.heroicon name="hero-chevron-right" class="shrink-0" title={@next.label} />
            </.navigate>
          </nav>
        </div>

        <div class="blog__post-head">
          <div class="blog__post-meta">
            <p :if={@date_label} class="blog__eyebrow">{@date_label}</p>
            <%= if @reading_time do %>
              <p class="blog__post-meta__read">
                {ngettext("1 min read", "%{count} min read", @reading_time, count: @reading_time)}
              </p>
            <% end %>
          </div>
          <h1 id="blog-post-heading" class="blog__display">{@title}</h1>
          <%= if @description do %>
            <p class="blog__lede blog__lede--post">{@description}</p>
          <% end %>
          <.post_tags tags={@tags} class="blog__post-tags" />
        </div>
      </div>
    </header>
    """
  end

  attr(:post_count, :integer, default: 0)

  def blog_index_hero(assigns) do
    ~H"""
    <header class="blog__hero" aria-labelledby="blog-index-heading">
      <div class="blog__head">
        <p class="blog__eyebrow">{~t"Journal"}</p>
        <h1 id="blog-index-heading" class="blog__display">
          {~t"Corex"} <span class="blog__display__accent">{~t"blog"}</span>
        </h1>
        <p class="blog__lede">
          {~t"Articles about Corex, Phoenix LiveView, accessibility, and UI development."}
        </p>
        <p :if={@post_count > 0} class="blog__meta">
          <span>
            {@post_count} {ngettext("article", "articles", @post_count)}
          </span>
          <.navigate
            class="button button--sm button--circle"
            to="/feed.xml"
            external
            aria_label={~t"RSS feed"}
          >
            <.heroicon name="hero-rss" />
          </.navigate>
        </p>
      </div>
    </header>
    """
  end

  attr(:post, :map, required: true)

  def post_card(assigns) do
    post = assigns.post
    date_label = post_date_label(post)
    tags = Map.get(post, :tags) || []

    assigns =
      assigns
      |> assign(:date_label, date_label)
      |> assign(:tags, tags)

    ~H"""
    <article class="blog__card">
      <div class="blog__card__top">
        <%= if @date_label do %>
          <p class="blog__card__date">{@date_label}</p>
        <% else %>
          <span></span>
        <% end %>
        <.heroicon name="hero-arrow-right" class="blog__card__arrow" />
      </div>
      <h2 class="blog__card__title">
        <.navigate to={~p"/blog/#{@post.slug}"} class="blog__card__link">
          {@post.title}
        </.navigate>
      </h2>
      <%= if @post.description do %>
        <p class="blog__card__excerpt">{@post.description}</p>
      <% end %>
      <.post_tags tags={@tags} class="blog__card__tags" />
    </article>
    """
  end

  attr(:tags, :list, default: [])
  attr(:class, :string, default: nil)

  def post_tags(assigns) do
    ~H"""
    <%= if @tags != [] do %>
      <ul class={["m-0 flex list-none flex-wrap gap-space-sm p-0", @class]}>
        <li :for={tag <- @tags}>
          <span class="badge badge--muted badge--sm">{tag}</span>
        </li>
      </ul>
    <% end %>
    """
  end

  def post_date_label(%{date: %DateTime{} = dt}), do: Calendar.strftime(dt, "%Y-%m-%d")
  def post_date_label(%{date: %Date{} = d}), do: Calendar.strftime(d, "%Y-%m-%d")
  def post_date_label(_), do: nil

  def reading_time_minutes(%{html: html}) when is_binary(html) do
    case Floki.parse_fragment(html) do
      {:ok, doc} ->
        doc
        |> Floki.text()
        |> estimate_reading_minutes()

      {:error, _} ->
        estimate_reading_minutes(html)
    end
  end

  def reading_time_minutes(_), do: 1

  defp estimate_reading_minutes(text) when is_binary(text) do
    words =
      text
      |> String.replace(~r/\s+/, " ")
      |> String.trim()
      |> String.split(" ", trim: true)
      |> length()

    max(1, div(words + 199, 200))
  end
end
