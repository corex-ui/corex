defmodule E2eWeb.Home.Page do
  use E2eWeb, :html

  attr(:hero_bullets, :list, required: true)
  attr(:hero_accordion_items, :list, required: true)

  def page(assigns) do
    ~H"""
    <div id="home" class="w-full text-ink">
      <section
        class="relative isolate flex min-h-dvh w-full flex-col justify-center overflow-x-hidden py-size-xl"
        aria-labelledby="home-hero-heading"
      >
        <div class="relative z-1 mx-auto grid w-full max-w-7xl flex-1 grid-cols-1 items-center justify-items-center gap-space-xl lg:grid-cols-2 lg:items-center lg:justify-items-stretch lg:gap-space-xl xl:grid-cols-[minmax(0,1fr)_minmax(22rem,1.15fr)]">
          <div class="flex w-full max-w-xl flex-col items-center gap-space-lg text-center lg:max-w-none lg:items-start lg:text-start">
            <h1
              id="home-hero-heading"
              class="display m-0 text-balance text-4xl tracking-tighter text-ink sm:text-5xl lg:text-6xl xl:text-7xl"
            >
              {~t"The Phoenix UI with a"} <span class="text-brand-text">{~t"real API"}</span>.
            </h1>

            <p class="m-0 max-w-xl text-pretty text-lg text-ink-muted">
              {~t"Accessible, unstyled Phoenix components with a full server-and-client API, powered by"}
              <.navigate to="https://zagjs.com" class="link" external>
                Zag.js <.heroicon name="hero-arrow-top-right-on-square" />
              </.navigate>
              {~t"state machines."}
            </p>

            <ul
              class="m-0 mt-2 grid w-full max-w-xl list-none grid-cols-1 gap-x-8 gap-y-4 p-0 sm:grid-cols-2"
              aria-label={~t"Highlights"}
            >
              <li
                :for={bullet <- @hero_bullets}
                class="relative flex items-start gap-x-3 text-pretty text-start text-sm text-ink-muted"
              >
                <span class="mt-0.5 shrink-0 text-success-text">
                  <.heroicon name="hero-check" />
                </span>
                <span>
                  <strong class="font-semibold text-ink">{bullet.title}</strong> {bullet.body}
                </span>
              </li>
            </ul>

            <div class="mt-space-sm flex flex-wrap items-center justify-center gap-space lg:justify-start">
              <.navigate
                to={~p"/accordion/playground"}
                class="button ui-accent ui-solid ui-size-lg ui-rounded-full"
              >
                {~t"Browse components"}
                <.heroicon name="hero-arrow-right" />
              </.navigate>
              <.navigate
                to="https://hexdocs.pm/corex/installation.html"
                class="button ui-ghost ui-size-lg ui-rounded-full"
                external
              >
                {~t"Visit Hexdocs"}
                <.heroicon name="hero-arrow-top-right-on-square" />
              </.navigate>
            </div>
          </div>

          <div
            id="home-hero-interactive"
            class="relative flex h-[min(22rem,55dvh)] w-full min-w-0 flex-col overflow-hidden rounded-xl border border-border bg-layer shadow-md lg:h-[min(28rem,72dvh)]"
            phx-hook="HomeHero"
          >
            <h2 class="sr-only">{~t"Interactive preview"}</h2>

            <div class="flex shrink-0 flex-wrap items-center justify-center gap-space-sm border-b border-border px-space py-space-sm">
              <span class="badge ui-ghost ui-size-sm">
                <.heroicon name="hero-command-line" /> API
              </span>
              <button
                type="button"
                data-hero-accordion-value={Jason.encode!(["anatomy"])}
                class="button ui-size-sm ui-rounded-full"
              >
                <.heroicon name="hero-chevron-right" /> {~t"Open first"}
              </button>
              <button
                type="button"
                data-hero-accordion-value={Jason.encode!(["anatomy", "machine"])}
                class="button ui-size-sm ui-rounded-full"
              >
                <.heroicon name="hero-square-3-stack-3d" /> {~t"Open all"}
              </button>
              <button
                type="button"
                data-hero-accordion-value={Jason.encode!([])}
                class="button ui-size-sm ui-rounded-full"
              >
                <.heroicon name="hero-x-mark" /> {~t"Close all"}
              </button>
            </div>

            <div class="grid min-h-0 flex-1 grid-cols-1 lg:grid-cols-2">
              <div class="flex min-h-0 min-w-0 flex-col gap-space-sm overflow-y-auto border-b border-border p-space lg:border-b-0 lg:border-r">
                <span class="badge ui-ghost ui-size-sm self-start">
                  <.heroicon name="hero-bars-3-bottom-left" /> {~t"Accordion"}
                </span>
                <.accordion
                  id="hero-accordion"
                  class="accordion"
                  value="machine"
                  on_value_change_client="hero-accordion-changed"
                  items={Corex.Content.new(@hero_accordion_items)}
                >
                  <:indicator>
                    <.heroicon name="hero-chevron-right" />
                  </:indicator>
                </.accordion>
              </div>

              <div class="flex min-h-0 min-w-0 flex-col gap-space-sm p-space">
                <span
                  id="hero-events-badge"
                  class="badge ui-ghost ui-size-sm shrink-0 self-start"
                >
                  <.heroicon name="hero-signal" /> {~t"Events"}
                </span>
                <.data_table
                  id="hero-events-table"
                  class="data-table min-h-0 flex-1 overflow-y-auto text-xs rounded-md"
                  rows={[]}
                >
                  <:col :let={_row} label={~t"Time"}></:col>
                  <:col :let={_row} label={~t"Open items"}></:col>
                  <:empty>
                    <p class="m-0 px-space-sm py-space text-center text-xs text-ink-muted">
                      {~t"Toggle the accordion to watch events land."}
                    </p>
                  </:empty>
                </.data_table>
              </div>
            </div>
          </div>
        </div>
      </section>
    </div>
    """
  end
end
