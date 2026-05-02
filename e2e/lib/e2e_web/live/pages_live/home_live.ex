defmodule E2eWeb.HomeLive do
  use E2eWeb, :live_view

  defp hero_accordion_items do
    [
      %{
        value: "anatomy",
        trigger: "Anatomy & slots",
        content: "Structure, custom slots, compound mode."
      },
      %{
        value: "machine",
        trigger: "State machines",
        content: "Zag.js powers accessibility, keyboard, and focus."
      }
    ]
  end

  defp hero_marquee_items do
    [
      %{name: "Elixir", img: "/images/tech/elixir.svg"},
      %{name: "Phoenix", img: "/images/tech/phoenix.svg"},
      %{name: "Zag.js", img: "/images/tech/zag.webp"},
      %{name: "TypeScript", img: "/images/tech/typescript.svg"},
      %{name: "Tailwind", img: "/images/tech/tailwind.svg"},
      %{name: "Figma", img: "/images/tech/figma.svg"}
    ]
  end

  defp hero_bullets do
    [
      %{
        title: "Server & client API.",
        body:
          "Drive every component from LiveView or JavaScript — and listen back from either side."
      },
      %{
        title: "LiveView‑native.",
        body: "Update props at runtime without resetting component state."
      },
      %{
        title: "Truly unstyled.",
        body: "Bring your own CSS or opt into Corex Design tokens, themes and modes."
      },
      %{
        title: "Accessible by default.",
        body: "Keyboard, focus and ARIA wired in by Zag.js state machines."
      }
    ]
  end

  @hero_code_snippet ~S"""
  <.accordion class="accordion">
    <:trigger value="anatomy">Anatomy</:trigger>
    <:trigger value="machine">State machines</:trigger>
    <:content value="anatomy">Structure & slots</:content>
    <:content value="machine">Zag.js on the client</:content>
  </.accordion>
  """

  @install_command "mix corex.new my_app"

  defp component_count, do: length(Corex.component_ids())

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Corex")
     |> assign(:hero_code, @hero_code_snippet)
     |> assign(:install_command, @install_command)
     |> assign(:hero_marquee_items, hero_marquee_items())
     |> assign(:hero_bullets, hero_bullets())
     |> assign(:component_count, component_count())
     |> stream(:accordion_events, [], limit: 20)}
  end

  @impl true
  def handle_event("hero_accordion_changed", %{"id" => _id, "value" => value}, socket) do
    entry = %{
      id: System.unique_integer([:positive, :monotonic]),
      at: Time.utc_now() |> Time.truncate(:second),
      open: format_open(value)
    }

    {:noreply, stream_insert(socket, :accordion_events, entry, at: 0, limit: 20)}
  end

  defp format_open(nil), do: "—"
  defp format_open([]), do: "—"
  defp format_open(list) when is_list(list), do: Enum.join(list, ", ")

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.marketing
      flash={@flash}
      mode={@mode}
      theme={@theme}
      path={@path}
    >
      <section class="home__hero" aria-labelledby="home-hero-heading">
        <div class="home__hero__stack">
          <div class="home__hero__inner">
            <div class="home__hero__copy">
              <h1 id="home-hero-heading" class="home__display home__display--lg">
                The Phoenix UI with a <span class="home__display__accent">real API</span>.
              </h1>

              <p class="home__lede">
                Accessible, unstyled Phoenix components with a full server‑and‑client API,
                powered by
                <.navigate to="https://zagjs.com" class="link" external>Zag.js</.navigate>
                state machines.
              </p>

              <ul class="home__bullets" aria-label="Highlights">
                <li :for={bullet <- @hero_bullets} class="home__bullet">
                  <.heroicon name="hero-check" class="home__bullet__icon" />
                  <span>
                    <strong>{bullet.title}</strong> {bullet.body}
                  </span>
                </li>
              </ul>

              <div class="home__hero__cta-row">
                <.navigate
                  to={~p"/accordion/playground"}
                  class="button button--brand rounded-full"
                >
                  {gettext("Browse components")}
                  <.heroicon name="hero-arrow-right" class="icon" />
                </.navigate>
                <.navigate
                  to="https://hexdocs.pm/corex/installation.html"
                  class="button button--ghost rounded-full"
                  external
                >
                  {gettext("Visit Hexdocs")}
                  <.heroicon name="hero-arrow-top-right-on-square" class="icon" />
                </.navigate>
              </div>
            </div>

            <div class="home__hero__composition">
              <h2 class="sr-only">{gettext("Interactive preview")}</h2>
              <div class="home__card home__card--accordion">
                <div class="home__card__label">
                  <.heroicon name="hero-bars-3-bottom-left" class="icon" />
                  <span>Accordion</span>
                </div>
                <.accordion
                  id="hero-accordion"
                  class="accordion"
                  value="machine"
                  on_value_change="hero_accordion_changed"
                  items={Corex.Content.new(hero_accordion_items())}
                >
                  <:indicator>
                    <.heroicon name="hero-chevron-right" />
                  </:indicator>
                </.accordion>
              </div>

              <div class="home__card home__card--api">
                <div class="home__card__label">
                  <.heroicon name="hero-command-line" class="icon" />
                  <span>API</span>
                </div>
                <p class="home__card__hint">Drive the accordion from anywhere.</p>
                <div class="home__card__actions">
                  <.action
                    phx-click={Corex.Accordion.set_value("hero-accordion", ["anatomy"])}
                    class="button button--sm button--accent"
                  >
                    <.heroicon name="hero-chevron-right" class="icon" /> Open first
                  </.action>
                  <.action
                    phx-click={
                      Corex.Accordion.set_value("hero-accordion", [
                        "anatomy",
                        "machine"
                      ])
                    }
                    class="button button--sm"
                  >
                    <.heroicon name="hero-square-3-stack-3d" class="icon" /> Open all
                  </.action>
                  <.action
                    phx-click={Corex.Accordion.set_value("hero-accordion", [])}
                    class="button button--sm button--ghost"
                  >
                    <.heroicon name="hero-x-mark" class="icon" /> Close all
                  </.action>
                </div>
              </div>

              <div class="home__card home__card--code">
                <div class="home__card__header">
                  <div class="home__card__label">
                    <.heroicon name="hero-code-bracket" class="icon" />
                    <span>HEEx</span>
                  </div>
                  <.clipboard
                    id="hero-code-clipboard"
                    class="clipboard clipboard--sm"
                    value={@hero_code}
                    input={false}
                    trigger_aria_label="Copy snippet"
                  >
                    <:copy>
                      <span>Copy</span>
                      <.heroicon name="hero-clipboard" />
                    </:copy>
                    <:copied>
                      <span>Copied</span>
                      <.heroicon name="hero-check" />
                    </:copied>
                  </.clipboard>
                </div>
                <.code
                  id="hero-code"
                  language={:heex}
                  class="code code--text-xs"
                  code={@hero_code}
                />
              </div>

              <div class="home__card home__card--events">
                <div class="home__card__label">
                  <.heroicon name="hero-signal" class="icon" />
                  <span>Events</span>
                </div>
                <.data_table
                  id="hero-events-table"
                  class="data-table home__card__events-table"
                  rows={@streams.accordion_events}
                >
                  <:col :let={{_id, row}} label="Time">
                    {Calendar.strftime(row.at, "%H:%M:%S")}
                  </:col>
                  <:col :let={{_id, row}} label="Open items">{row.open}</:col>
                  <:empty>
                    <p class="home__card__events-empty">
                      Toggle the accordion to watch events land.
                    </p>
                  </:empty>
                </.data_table>
              </div>
            </div>
          </div>
        </div>
      </section>

      <section
        class="home__section home__section--alt home__numbers-section"
        aria-labelledby="home-numbers-heading"
      >
        <div class="home__section__inner">
          <h2 id="home-numbers-heading" class="sr-only">
            {gettext("Corex by the numbers")}
          </h2>
          <div class="home__numbers">
            <div class="home__numbers__cell">
              <span class="home__numbers__value">
                {@component_count}<span class="home__numbers__value__suffix">+</span>
              </span>
              <span class="home__numbers__label">Components</span>
              <p class="home__numbers__hint">
                Works in Controller and Live View
              </p>
            </div>
            <div class="home__numbers__cell">
              <span class="home__numbers__value">
                100<span class="home__numbers__value__suffix">+</span>
              </span>
              <span class="home__numbers__label">API & Events</span>
              <p class="home__numbers__hint">
                Control the components from the Server and the Client
              </p>
            </div>
            <div class="home__numbers__cell">
              <span class="home__numbers__value">
                100<span class="home__numbers__value__suffix">%</span>
              </span>
              <span class="home__numbers__label">Open Source</span>
              <p class="home__numbers__hint">
                Open Source and free to use. MIT License
              </p>
            </div>
            <div class="home__numbers__cell">
              <span class="home__numbers__value">
                A<span class="home__numbers__value__suffix">11y</span>
              </span>
              <span class="home__numbers__label">Built in</span>
              <p class="home__numbers__hint">
                Keyboard, focus and ARIA from Zag.js machines.
              </p>
            </div>
          </div>
        </div>
      </section>

      <section class="home__section home__stack-section" aria-labelledby="home-stack-heading">
        <div class="home__section__inner home__stack">
          <div class="home__stack__head">
            <span class="home__stack__rule" aria-hidden="true"></span>
            <h2 id="home-stack-heading" class="home__eyebrow">Built with</h2>
            <span class="home__stack__rule" aria-hidden="true"></span>
          </div>

          <.marquee
            id="home-stack-marquee"
            class="marquee marquee--on-layer home__stack__marquee"
            duration={28}
            spacing="0px"
            pause_on_interaction
            items={@hero_marquee_items}
          >
            <:item :let={item}>
              <span class="home__stack__item">
                <img src={item.img} alt={item.name} class="home__stack__logo" />
              </span>
            </:item>
          </.marquee>
        </div>
      </section>

      <section
        class="home__section home__section--alt home__cta"
        aria-labelledby="home-cta-heading"
      >
        <div class="home__section__inner">
          <div class="home__cta__inner">
            <p class="home__eyebrow">Ready?</p>
            <h2 id="home-cta-heading" class="home__cta__display">
              Install Corex <span class="home__display__accent">in one command.</span>
            </h2>
            <p class="home__lede">
              Igniter wires up the dependency, the design tokens and the assets pipeline for you.
            </p>

            <.clipboard
              id="home-install-clipboard"
              class="clipboard"
              value={@install_command}
              trigger_aria_label="Copy install command"
            >
              <:copy>
                <span>Copy</span>
                <.heroicon name="hero-clipboard" />
              </:copy>
              <:copied>
                <span>Copied</span>
                <.heroicon name="hero-check" />
              </:copied>
            </.clipboard>

            <div class="home__cta__actions">
              <.navigate
                to={~p"/accordion/playground"}
                class="button button--brand rounded-full"
              >
                {gettext("Browse components")}
                <.heroicon name="hero-arrow-right" class="icon" />
              </.navigate>
              <.navigate
                to="https://github.com/corex-ui/corex"
                class="button button--ghost rounded-full"
                external
              >
                {gettext("Star on GitHub")}
                <.heroicon name="hero-arrow-top-right-on-square" class="icon" />
              </.navigate>
            </div>
          </div>
        </div>
      </section>
    </Layouts.marketing>
    """
  end
end
