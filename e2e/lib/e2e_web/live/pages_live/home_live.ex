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

  @hero_code_snippet ~S"""
  <.accordion class="accordion">
    <:trigger value="anatomy">Anatomy</:trigger>
    <:trigger value="machine">State machines</:trigger>
    <:content value="anatomy">Structure & slots</:content>
    <:content value="machine">Zag.js on the client</:content>
  </.accordion>
  """

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Corex")
     |> assign(:hero_code, @hero_code_snippet)
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
      <section class="home__hero" data-home-hero aria-labelledby="home-hero-heading">
        <div class="home__hero__backdrop" aria-hidden="true">
          <div class="home__hero__glow home__hero__glow--brand"></div>
          <div class="home__hero__glow home__hero__glow--accent"></div>
          <div class="home__hero__grid-pattern"></div>
        </div>

        <div class="home__hero__stack">
          <div class="home__hero__inner">
            <div class="home__hero__copy" data-home-anim-group>
              <h1 id="home-hero-heading" data-home-anim class="home__display text-7xl">
                The <span class="text-brand">Phoenix UI</span>
                with a <span class="text-alert">real API</span>.
              </h1>

              <p data-home-anim class="home__lede">
                Corex brings Zag.js state machines to Phoenix to build accessible and unstyled components with a full server and client API.
                <br />
                Control and listen from both sides of the wire and Fully Compatible with Phoenix Form, Stream and Ecto Changeset
              </p>

              <ul data-home-anim class="home__bullets" aria-label="Highlights">
                <li class="home__bullet">
                  <.heroicon name="hero-check-circle" class="home__bullet__icon icon" />
                  <span>
                    <strong>Flexible anatomy:</strong>
                    declarative, custom slots and full compound mode.
                  </span>
                </li>
                <li class="home__bullet">
                  <.heroicon name="hero-check-circle" class="home__bullet__icon icon" />
                  <span>
                    <strong>Server and client API & Events:</strong>
                    push state in, pull it out and react to changes in Elixir and JavaScript.
                  </span>
                </li>
                <li class="home__bullet">
                  <.heroicon name="hero-check-circle" class="home__bullet__icon icon" />
                  <span>
                    <strong>LiveView-native:</strong>
                    update props at runtime without resetting component state.
                  </span>
                </li>
                <li class="home__bullet">
                  <.heroicon name="hero-check-circle" class="home__bullet__icon icon" />
                  <span>
                    <strong>Server App & Static Website</strong>
                    Build a full app with Phoenix or build a static site using Tableau.
                  </span>
                </li>
                <li class="home__bullet">
                  <.heroicon name="hero-check-circle" class="home__bullet__icon icon" />
                  <span>
                    <strong>Accessible and keyboard-first:</strong> powered by Zag.js state machines.
                  </span>
                </li>
                <li class="home__bullet">
                  <.heroicon name="hero-check-circle" class="home__bullet__icon icon" />
                  <span>
                    <strong>Truly unstyled:</strong> bring your own CSS or use Corex Design System.
                  </span>
                </li>
              </ul>

              <div data-home-anim class="home__cta-row">
                <.navigate
                  to={~p"/accordion/anatomy"}
                  class="button button--brand rounded-full"
                >
                  Browse components <.heroicon name="hero-arrow-right" class="icon" />
                </.navigate>
                <.navigate
                  to="https://hexdocs.pm/corex/installation.html"
                  class="button button--ghost rounded-full"
                  external
                >
                  Visit Hexdocs <.heroicon name="hero-arrow-top-right-on-square" class="icon" />
                </.navigate>
              </div>
            </div>

            <div class="home__hero__composition" data-home-composition>
              <h2 class="sr-only">{gettext("Interactive preview")}</h2>
              <div
                class="home__card home__card--accordion"
                data-home-float
                data-rotate="-4"
              >
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

              <div
                class="home__card home__card--api"
                data-home-float
                data-rotate="3"
              >
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

              <div
                class="home__card home__card--code"
                data-home-float
                data-rotate="-2"
              >
                <div class="home__card__header">
                  <div class="home__card__label">
                    <.heroicon name="hero-code-bracket" class="icon" />
                    <span>HEEx</span>
                  </div>
                  <.clipboard
                    id="hero-code-clipboard"
                    class="clipboard w-auto"
                    value={@hero_code}
                    input={false}
                    trigger_aria_label="Copy snippet"
                    root_class="home__card__clipboard-root"
                    control_class="home__card__clipboard-control"
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

              <div
                class="home__card home__card--events"
                data-home-float
                data-rotate="4"
              >
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

          <div class="home__hero__marquee" aria-label="Built with">
            <div class="home__hero__marquee__inner">
              <p class="home__hero__marquee__label">Built with</p>
              <.marquee
                id="home-stack-marquee"
                class="marquee marquee--on-layer maw-w-md"
                items={[
                  %{name: "Elixir", img: "/images/tech/elixir.svg"},
                  %{name: "Phoenix", img: "/images/tech/phoenix.svg"},
                  %{name: "Zag.js", img: "/images/tech/zag.webp"},
                  %{name: "TypeScript", img: "/images/tech/typescript.svg"},
                  %{name: "Tailwind", img: "/images/tech/tailwind.svg"},
                  %{name: "Figma", img: "/images/tech/figma.svg"}
                ]}
                speed={50}
                spacing="5rem"
              >
                <:item :let={item}>
                  <img src={item.img} alt={item.name} class="home__hero__marquee__logo" />
                </:item>
              </.marquee>
            </div>
          </div>
        </div>
      </section>
    </Layouts.marketing>
    """
  end
end
