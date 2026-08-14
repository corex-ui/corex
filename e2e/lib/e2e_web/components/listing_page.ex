defmodule E2eWeb.ListingPage do
  @moduledoc false

  use E2eWeb, :html

  attr(:eyebrow, :string, default: nil)
  attr(:title, :string, required: true)
  attr(:accent, :string, default: nil)
  attr(:lede, :string, default: nil)
  attr(:meta, :string, default: nil)
  attr(:heading_id, :string, default: "listing-index-heading")
  attr(:class, :string, default: "blog__hero")
  slot(:actions)

  def listing_index_hero(assigns) do
    ~H"""
    <header class={@class} aria-labelledby={@heading_id}>
      <div class="blog__head">
        <p :if={is_binary(@eyebrow)} class="blog__eyebrow">{@eyebrow}</p>
        <h1 id={@heading_id} class="blog__display">
          {@title}
          <span :if={@accent} class="blog__display__accent">{@accent}</span>
        </h1>
        <p :if={is_binary(@lede)} class="blog__lede">{@lede}</p>
        <p :if={@meta} class="blog__meta">{@meta}</p>
        <div :if={@actions != []} class="flex flex-wrap gap-space-sm">
          {render_slot(@actions)}
        </div>
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
  attr(:image, :string, default: nil)
  attr(:image_alt, :string, default: nil)
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
      |> assign(:primary_class, "blog__card__link link ui-nav ui-brand ui-size-xl")

    ~H"""
    <article class="blog__card">
      <div :if={@image} class="blog__card__media">
        <img src={@image} alt={@image_alt || ""} loading="lazy" width="1440" height="900" />
      </div>
      <div class="blog__card__body">
        <h2 class="blog__card__title">{@title}</h2>
        <p :if={@description} class="blog__card__excerpt">{@description}</p>
        <ul :if={@tags != []} class="m-0 flex list-none flex-wrap gap-space-sm p-0 blog__card__tags">
          <li :for={tag <- @tags}>
            <span class="badge ui-size-sm">{tag}</span>
          </li>
        </ul>
      </div>
      <div
        :if={@template_card? or @play_card? or @site_card?}
        class="blog__card__actions justify-center"
      >
        <.navigate :if={@template_card?} to={@demo_to} class={@primary_class} external>
          {~t"Live demo"}
          <.heroicon name="hero-arrow-top-right-on-square" class="icon" />
        </.navigate>
        <.navigate
          :if={@template_card?}
          to={@github_to}
          class="blog__card__secondary link ui-nav ui-size-xl"
          external
        >
          {~t"GitHub"}
          <.heroicon name="hero-arrow-top-right-on-square" class="icon" />
        </.navigate>
        <.navigate :if={@play_card?} to={@play_to} class={@primary_class}>
          {@play_label || ~t"Play now"}
          <.heroicon name="hero-arrow-right" class="icon" />
        </.navigate>
        <.navigate :if={@site_card?} to={@site_to} class={@primary_class} external>
          {@site_label || ~t"Visit site"}
          <.heroicon name="hero-arrow-top-right-on-square" class="icon" />
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
