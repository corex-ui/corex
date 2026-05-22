defmodule E2eWeb.ShowcaseTemplateLive do
  use E2eWeb, :live_view

  alias E2eWeb.ShowcaseCatalog

  @impl true
  def mount(_params, _session, socket) do
    template = ShowcaseCatalog.template_for_live_action(socket.assigns.live_action)
    carousel_items = ShowcaseCatalog.carousel_items()

    {:ok,
     socket
     |> assign(:page_title, template.page_title)
     |> assign(:seo, E2eWeb.SEO.showcase_template(template.id))
     |> assign(:template, template)
     |> assign(:carousel_items, carousel_items)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.marketing flash={@flash} mode={@mode} theme={@theme} path={@path}>
      <div class="layout__article w-full items-stretch">
        <section class="layout__section w-full min-w-0 max-w-none" aria-labelledby="showcase-heading">
          <.layout_heading class="layout-heading max-w-3xl w-full">
            <:title>
              <span id="showcase-heading">{@template.heading}</span>
            </:title>
            <:subtitle>{@template.subtitle}</:subtitle>
          </.layout_heading>

          <article class="flex min-h-0 min-w-0 max-w-3xl flex-col gap-space rounded-xl border border-border bg-layer p-size-lg shadow-md">
            <div class="inline-flex items-center gap-space-sm self-start rounded-full border border-border bg-root px-space-sm py-space-sm text-xs font-medium text-ink-muted">
              <.heroicon name={@template.badge_icon} class="icon" />
              <span>{@template.badge_label}</span>
            </div>

            <div class="overflow-hidden rounded-lg border border-border bg-root">
              <.carousel
                id={@template.carousel_id}
                aria_label={@template.carousel_aria}
                orientation="vertical"
                loop
                items={@carousel_items}
                class="carousel carousel--accent w-full max-w-none"
              >
                <:prev_trigger>
                  <.heroicon name="hero-arrow-up" />
                </:prev_trigger>
                <:next_trigger>
                  <.heroicon name="hero-arrow-down" />
                </:next_trigger>
              </.carousel>
            </div>

            <p class="m-0 max-w-prose text-base leading-snug text-ink-muted">{@template.lede}</p>

            <div class="mt-auto flex flex-wrap gap-space-sm pt-space-sm">
              <.navigate
                to={@template.demo_to}
                class="button button--brand rounded-full"
                external
              >
                {~t"Live demo"}
                <.heroicon name="hero-arrow-top-right-on-square" class="icon" />
              </.navigate>
              <.navigate
                to={@template.github_to}
                class="button button--ghost rounded-full"
                external
              >
                {~t"GitHub"}
                <.heroicon name="hero-arrow-top-right-on-square" class="icon" />
              </.navigate>
            </div>
          </article>
        </section>
      </div>
    </Layouts.marketing>
    """
  end
end
