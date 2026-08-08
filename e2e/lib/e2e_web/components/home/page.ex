defmodule E2eWeb.Home.Page do
  use E2eWeb, :html

  attr(:hero_bullets, :list, required: true)
  attr(:hero_accordion_items, :list, required: true)
  attr(:home_stats, :list, required: true)
  attr(:home_tech, :list, required: true)
  attr(:installer_generators, :list, required: true)
  attr(:installer_flags, :list, required: true)

  def page(assigns) do
    ~H"""
    <div id="home" class="w-full text-ink">
      <section
        class="relative isolate flex min-h-dvh w-full flex-col justify-center overflow-x-hidden py-size-xl"
        aria-labelledby="home-hero-heading"
      >
        <div class="relative z-1 mx-auto grid w-full max-w-7xl flex-1 grid-cols-1 items-center justify-items-center gap-size-lg lg:grid-cols-2 lg:items-center lg:justify-items-stretch lg:gap-size-xl xl:grid-cols-[minmax(0,1fr)_minmax(22rem,1.15fr)]">
          <div class="flex w-full max-w-xl flex-col items-center gap-size-md text-center lg:max-w-none lg:items-start lg:text-start">
            <h1
              id="home-hero-heading"
              class="display m-0 text-pretty text-4xl tracking-tighter text-ink sm:text-5xl lg:text-5xl xl:text-6xl"
            >
              <span class="sr-only">
                {~t"The Phoenix UI with API, Events, Anatomy, Design, and Accessibility."}
              </span>
              <span
                aria-hidden="true"
                class="flex flex-col items-center gap-0 lg:items-start"
              >
                <span>{~t"The Phoenix UI"}</span>
                <span class="home-hero-rotator-phrase">
                  {~t"with"}{" "}
                  <span
                    id="home-hero-rotator"
                    class="home-hero-rotator text-brand-text"
                    data-interval-ms="2800"
                  >
                    <span class="home-hero-rotator__sizer" aria-hidden="true">
                      {~t"Accessibility"}.
                    </span>
                    <span class="home-hero-rotator__word" data-active>{~t"API"}.</span>
                    <span class="home-hero-rotator__word">{~t"Events"}.</span>
                    <span class="home-hero-rotator__word">{~t"Anatomy"}.</span>
                    <span class="home-hero-rotator__word">{~t"Design"}.</span>
                    <span class="home-hero-rotator__word">{~t"Accessibility"}.</span>
                  </span>
                </span>
              </span>
            </h1>

            <p class="m-0 max-w-xl text-pretty text-lg text-ink-muted">
              {~t"Accessible, unstyled Phoenix components with a full server-and-client API, powered by"}
              <.navigate to="https://zagjs.com" class="link" external>
                Zag.js <.heroicon name="hero-arrow-top-right-on-square" />
              </.navigate>
              {~t"state machines."}
            </p>

            <ul
              class="m-0 grid w-full max-w-xl list-none grid-cols-1 gap-x-space-xl gap-y-space-lg p-0 sm:grid-cols-2"
              aria-label={~t"Highlights"}
            >
              <li
                :for={bullet <- @hero_bullets}
                class="relative flex items-start gap-x-space text-pretty text-start text-sm text-ink-muted"
              >
                <span class="mt-space-xs shrink-0 text-success-text">
                  <.heroicon name="hero-check" />
                </span>
                <span>
                  <strong class="font-semibold text-ink">{bullet.title}</strong> {bullet.body}
                </span>
              </li>
            </ul>

            <.home_ctas align={:start} />
          </div>

          <div
            id="home-hero-interactive"
            class="relative flex h-auto min-h-[50dvh] w-fit max-w-full min-w-0 flex-col overflow-hidden rounded-md border border-border bg-surface shadow-md sm:h-[min(28rem,72dvh)] sm:min-h-0 lg:w-full"
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
                class="button ui-size-sm"
              >
                <.heroicon name="hero-chevron-right" /> {~t"Open first"}
              </button>
              <button
                type="button"
                data-hero-accordion-value={Jason.encode!(["anatomy", "machine"])}
                class="button ui-size-sm"
              >
                <.heroicon name="hero-square-3-stack-3d" /> {~t"Open all"}
              </button>
              <button
                type="button"
                data-hero-accordion-value={Jason.encode!([])}
                class="button ui-size-sm"
              >
                <.heroicon name="hero-x-mark" /> {~t"Close all"}
              </button>
            </div>

            <div class="grid min-h-0 flex-1 grid-cols-2 max-sm:grid-cols-1">
              <div class="flex min-h-0 min-w-0 flex-col gap-space-sm border-r border-border p-space max-sm:border-r-0 max-sm:border-b">
                <span class="badge ui-ghost ui-size-sm shrink-0 self-start">
                  <.heroicon name="hero-bars-3-bottom-left" /> {~t"Accordion"}
                </span>
                <div class="min-h-0 flex-1 overflow-y-auto scrollbar scrollbar--sm">
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
              </div>

              <div class="flex min-h-0 min-w-0 flex-col gap-space-sm p-space max-sm:min-h-[12rem]">
                <span
                  id="hero-events-badge"
                  class="badge ui-ghost ui-size-sm shrink-0 self-start"
                >
                  <.heroicon name="hero-signal" /> {~t"Events"}
                </span>
                <.data_table
                  id="hero-events-table"
                  class="data-table w-full max-w-none text-xs rounded-md"
                  rows={[]}
                >
                  <:col :let={_row} label={~t"Time"}></:col>
                  <:col :let={_row} label={~t"Open items"}></:col>
                  <:empty>
                    <p class="m-0 text-center text-xs text-ink-muted">
                      {~t"Toggle the accordion to watch events land."}
                    </p>
                  </:empty>
                </.data_table>
              </div>
            </div>
          </div>
        </div>
      </section>

      <section
        id="home-highlights"
        class="home-highlights relative isolate flex min-h-dvh w-full flex-col justify-center overflow-x-hidden border-t border-border py-size-xl"
        aria-labelledby="home-highlights-heading"
      >
        <div class="relative z-1 mx-auto flex w-full max-w-6xl flex-col gap-size-xl px-space">
          <div class="flex flex-col items-center gap-space-lg text-center">
            <h2
              id="home-highlights-heading"
              class="display m-0 text-balance text-3xl tracking-tighter text-ink sm:text-4xl lg:text-5xl"
            >
              {~t"Built for the Elixir ecosystem"}
            </h2>
          </div>

          <ul class="m-0 grid list-none grid-cols-1 gap-space-xl p-0 sm:grid-cols-2 xl:grid-cols-4">
            <li
              :for={stat <- @home_stats}
              class="group relative flex flex-col gap-space overflow-hidden rounded-xl border border-border bg-root p-space-lg shadow-sm transition-shadow hover:shadow-md"
            >
              <span class="absolute inset-y-0 start-0 w-1 bg-brand" aria-hidden="true"></span>
              <p class="display m-0 text-4xl tracking-tighter text-brand-text sm:text-5xl">
                {stat.value}
              </p>
              <div class="flex flex-col gap-space-sm">
                <p class="m-0 text-lg font-semibold text-ink">{stat.label}</p>
                <p class="m-0 text-pretty text-sm text-ink-muted">{stat.body}</p>
              </div>
            </li>
          </ul>

          <div class="home-highlights-marquee flex flex-col gap-size-sm py-size-sm">
            <p class="m-0 text-center text-lg font-medium text-ink-muted sm:text-xl">
              {~t"Powered by the stack you already use"}
            </p>
            <.marquee
              id="home-tech-marquee"
              class="marquee ui-width-full"
              items={@home_tech}
              speed={35}
              spacing="3.5rem"
              auto_fill={false}
              pause_on_interaction
            >
              <:item :let={item}>
                <span
                  class="inline-flex h-11 items-center justify-center px-space-sm"
                  title={item.name}
                >
                  <img
                    src={item.src}
                    alt={item.name}
                    title={item.name}
                    height="44"
                    class="pointer-events-none h-11 w-auto"
                  />
                </span>
              </:item>
            </.marquee>
          </div>

          <.home_ctas />
        </div>
      </section>

      <E2eWeb.Home.Anatomy.section />

      <section
        id="home-installer"
        class="relative isolate flex min-h-dvh w-full flex-col justify-center overflow-x-hidden border-t border-border py-size-xl"
        aria-labelledby="home-installer-heading"
        phx-hook="HomeInstaller"
        data-archives-phoenix={"mix archive.install hex phx_new\nmix archive.install hex corex_new"}
        data-archives-tableau={"mix archive.install hex tableau_new\nmix archive.install hex corex_new"}
      >
        <div class="relative z-1 mx-auto flex w-full max-w-6xl flex-col gap-size-xl px-space">
          <div class="flex flex-col gap-space-lg text-center lg:text-start">
            <p class="m-0 text-sm font-medium tracking-wide text-brand-text uppercase">
              {~t"Get started"}
            </p>
            <h2
              id="home-installer-heading"
              class="display m-0 text-balance text-3xl tracking-tighter text-ink sm:text-4xl lg:text-5xl"
            >
              {~t"Install Corex"}
            </h2>
            <p class="m-0 max-w-2xl text-pretty text-lg text-ink-muted lg:mx-0 mx-auto">
              {~t"Compose your generator command, then copy from the terminal."}
            </p>
          </div>

          <div class="grid grid-cols-1 gap-size-lg lg:grid-cols-[minmax(0,1fr)_minmax(0,1.15fr)] lg:items-start">
            <div class="relative z-20 flex flex-col gap-space-xl rounded-xl border border-border bg-surface p-space-xl shadow-md">
              <div class="flex flex-col gap-space-lg">
                <div class="flex items-center gap-space-sm">
                  <span class="text-sm font-semibold text-ink">{~t"Generator"}</span>
                  <.installer_tip
                    id="home-installer-tip-generator"
                    content={
                      ~t"Phoenix scaffolds a LiveView server app. Tableau scaffolds a static site."
                    }
                  />
                </div>
                <.toggle_group
                  id="home-installer-generator"
                  class="toggle-group ui-width-full"
                  multiple={false}
                  deselectable={false}
                  value={["phoenix"]}
                  on_value_change_client="home-installer-changed"
                >
                  <:item :for={gen <- @installer_generators} value={gen.value} aria_label={gen.tip}>
                    {gen.label}
                  </:item>
                </.toggle_group>
              </div>

              <div class="flex flex-col gap-space-lg">
                <div class="flex items-center gap-space-sm">
                  <span class="text-sm font-semibold text-ink">{~t"App name"}</span>
                  <.installer_tip
                    id="home-installer-tip-name"
                    content={
                      ~t"Project folder name. Use lowercase letters, numbers, and underscores."
                    }
                  />
                </div>
                <.native_input
                  id="home-installer-name"
                  type="text"
                  name="app_name"
                  value="my_app"
                  autocomplete="off"
                  class="native-input ui-width-full"
                >
                  <:label class="sr-only">{~t"App name"}</:label>
                </.native_input>
              </div>

              <div class="flex flex-col gap-space-lg">
                <div class="flex items-center gap-space-sm">
                  <span class="text-sm font-semibold text-ink">{~t"Defaults"}</span>
                  <.installer_tip
                    id="home-installer-tip-defaults"
                    content={
                      ~t"Included unless you turn them off. Deselecting adds the matching --no-* flag."
                    }
                  />
                </div>
                <.toggle_group
                  id="home-installer-defaults"
                  class="toggle-group ui-width-full"
                  multiple
                  value={["design", "mcp", "usage-rules"]}
                  on_value_change_client="home-installer-changed"
                >
                  <:item
                    :for={flag <- Enum.filter(@installer_flags, &(&1.kind == :default_on))}
                    value={flag.value}
                    aria_label={flag.tip}
                  >
                    {flag.label}
                  </:item>
                </.toggle_group>
              </div>

              <div class="flex flex-col gap-space-lg">
                <div class="flex items-center gap-space-sm">
                  <span class="text-sm font-semibold text-ink">{~t"Add-ons"}</span>
                  <.installer_tip
                    id="home-installer-tip-addons"
                    content={
                      ~t"Extra capabilities you opt into. Each selection appends its --flag to the command."
                    }
                  />
                </div>
                <.toggle_group
                  id="home-installer-addons"
                  class="toggle-group ui-width-full"
                  multiple
                  value={[]}
                  on_value_change_client="home-installer-changed"
                >
                  <:item
                    :for={flag <- Enum.filter(@installer_flags, &(&1.kind == :opt_in))}
                    value={flag.value}
                    aria_label={flag.tip}
                  >
                    {flag.label}
                  </:item>
                </.toggle_group>
              </div>
            </div>

            <div class="relative z-10 flex flex-col gap-size-md lg:sticky lg:top-24">
              <.installer_terminal
                id_prefix="home-installer-archives"
                label={~t"Archives"}
                tip={
                  ~t"One-time Mix archive install so the generators are available on your machine."
                }
                code={"mix archive.install hex phx_new\nmix archive.install hex corex_new"}
                clipboard_id="home-installer-archives-clipboard"
              />

              <.installer_terminal
                id_prefix="home-installer-command"
                label={~t"Command"}
                tip={
                  ~t"Live preview of mix corex.new / mix corex.tableau.new from your selections. Copy and paste into a terminal."
                }
                code="mix corex.new my_app"
                clipboard_id="home-installer-clipboard"
              />
            </div>
          </div>

          <.home_ctas />
        </div>
      </section>
    </div>
    """
  end

  attr(:align, :atom, default: :center, values: [:center, :start])

  defp home_ctas(assigns) do
    ~H"""
    <div class={[
      "flex flex-wrap items-center gap-space-lg",
      @align == :start && "justify-center lg:justify-start",
      @align == :center && "justify-center"
    ]}>
      <.navigate
        to={~p"/accordion/playground"}
        class="button ui-brand ui-solid ui-size-lg"
      >
        {~t"Browse components"}
        <.heroicon name="hero-arrow-right" />
      </.navigate>
      <.navigate
        to="https://hexdocs.pm/corex/installation.html"
        class="button ui-ghost ui-size-lg"
        external
      >
        {~t"Visit Hexdocs"}
        <.heroicon name="hero-arrow-top-right-on-square" />
      </.navigate>
    </div>
    """
  end

  attr(:id, :string, required: true)
  attr(:content, :string, required: true)

  defp installer_tip(assigns) do
    ~H"""
    <.tooltip
      id={@id}
      class="tooltip ui-size-sm"
      trigger_tag={:span}
      positioning={%Corex.Positioning{placement: "top"}}
    >
      <:trigger class="inline-flex size-4 shrink-0 items-center justify-center text-ink-muted transition-colors hover:text-brand-text">
        <.heroicon name="hero-question-mark-circle" class="size-4" />
        <span class="sr-only">{~t"More info"}</span>
      </:trigger>
      <:content>
        <p class="m-0 max-w-xs text-pretty text-sm">{@content}</p>
      </:content>
    </.tooltip>
    """
  end

  attr(:id_prefix, :string, required: true)
  attr(:label, :string, required: true)
  attr(:tip, :string, required: true)
  attr(:code, :string, required: true)
  attr(:clipboard_id, :string, required: true)

  defp installer_terminal(assigns) do
    ~H"""
    <div class="flex flex-col gap-space-lg">
      <div class="relative z-20 flex items-center gap-space-sm">
        <span class="text-sm font-semibold text-ink">{@label}</span>
        <.installer_tip id={"#{@id_prefix}-tip"} content={@tip} />
      </div>

      <div class="relative z-0">
        <.clipboard
          id={@clipboard_id}
          class="clipboard ui-size-sm absolute top-2 right-2 z-10"
          value={@code}
          input={false}
          trigger_aria_label={~t"Copy code"}
        >
          <:copy>
            <.heroicon name="hero-clipboard" />
          </:copy>
          <:copied>
            <.heroicon name="hero-check" />
          </:copied>
        </.clipboard>

        <.code id={@id_prefix} class="code ui-width-full" language={:shell} code={@code} />
      </div>
    </div>
    """
  end
end
