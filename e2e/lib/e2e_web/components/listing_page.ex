defmodule E2eWeb.ListingPage do
  @moduledoc false

  use E2eWeb, :html

  attr(:eyebrow, :string, required: true)
  attr(:title, :string, required: true)
  attr(:accent, :string, default: nil)
  attr(:lede, :string, required: true)
  attr(:meta, :string, default: nil)
  attr(:heading_id, :string, default: "listing-index-heading")

  def listing_index_hero(assigns) do
    ~H"""
    <header class="blog__hero" aria-labelledby={@heading_id}>
      <div class="blog__head">
        <p class="blog__eyebrow">{@eyebrow}</p>
        <h1 id={@heading_id} class="blog__display">
          {@title}
          <span :if={@accent} class="blog__display__accent">{@accent}</span>
        </h1>
        <p class="blog__lede">{@lede}</p>
        <p :if={@meta} class="blog__meta">{@meta}</p>
      </div>
    </header>
    """
  end

  attr(:title, :string, required: true)
  attr(:description, :string, default: nil)
  attr(:demo_to, :string, default: nil)
  attr(:github_to, :string, default: nil)
  attr(:play_to, :string, default: nil)
  attr(:play_label, :string, default: nil)
  attr(:site_to, :string, default: nil)
  attr(:site_label, :string, default: nil)
  attr(:tags, :list, default: [])

  def listing_card(assigns) do
    template_card? = is_binary(assigns.demo_to) and is_binary(assigns.github_to)
    play_card? = is_binary(assigns.play_to)
    site_card? = is_binary(assigns.site_to)

    assigns =
      assigns
      |> assign(:template_card?, template_card?)
      |> assign(:play_card?, play_card?)
      |> assign(:site_card?, site_card?)

    ~H"""
    <article class="blog__card">
      <h2 class="blog__card__title">{@title}</h2>
      <p :if={@description} class="blog__card__excerpt">{@description}</p>
      <ul :if={@tags != []} class="m-0 flex list-none flex-wrap gap-space-sm p-0 blog__card__tags">
        <li :for={tag <- @tags}>
          <.badge size="sm">{tag}</.badge>
        </li>
      </ul>
      <div :if={@template_card?} class="mt-auto flex flex-wrap gap-space-sm pt-space-sm">
        <.navigate to={@demo_to} as="button" size="sm" semantic="brand" external>
          {~t"Live demo"}
          <.heroicon name="hero-arrow-top-right-on-square" />
        </.navigate>
        <.navigate to={@github_to} as="button" size="sm" variant="ghost" external>
          {~t"GitHub"}
          <.heroicon name="hero-arrow-top-right-on-square" />
        </.navigate>
      </div>
      <div :if={@play_card?} class="mt-auto flex flex-wrap gap-space-sm pt-space-sm">
        <.navigate to={@play_to} as="button" size="sm" semantic="brand">
          {@play_label || ~t"Play"}
          <.heroicon name="hero-arrow-right" />
        </.navigate>
      </div>
      <div :if={@site_card?} class="mt-auto flex flex-wrap gap-space-sm pt-space-sm">
        <.navigate to={@site_to} as="button" size="sm" semantic="brand" external>
          {@site_label || ~t"View Site"}
          <.heroicon name="hero-arrow-top-right-on-square" />
        </.navigate>
      </div>
    </article>
    """
  end

  attr(:title, :string, required: true)
  attr(:subtitle, :string, default: nil)

  def listing_section_heading(assigns) do
    ~H"""
    <div class="flex flex-col gap-space-sm">
      <h2 class="blog__eyebrow m-0">{@title}</h2>
      <p :if={@subtitle} class="blog__lede m-0">{@subtitle}</p>
    </div>
    """
  end
end
