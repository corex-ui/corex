defmodule E2eWeb.DemoPage do
  @moduledoc """
  Shared layout for the Corex e2e demo site.

  ## Title and subtitle

  - **Title**  -  `Component · Type` (middle dot, Unicode `·`), e.g. `Select · Playground`, `Tabs · API`.
  - **Subtitle**  -  prefer **omit**; if present, a single short line only. No instructional paragraphs.

  ## Title suffixes

  Use a consistent suffix on `demo_page` / layout headings so nav, breadcrumbs, and tests stay predictable:

  - **Anatomy**  -  `… Anatomy` (or `… · Anatomy` where the product name already contains a dot phrase).
  - **Style**  -  `… Style` for static styling guides.
  - **Form**  -  `… Form` for controller-rendered form demos.
  - **Playground**  -  `… Playground` for the interactive LiveView.
  - **API**  -  `… API` for imperative `Corex.*` and binding demos.
  - **Events**  -  `… Events` for server and client event logs.
  - **Pattern**  -  `… Pattern` or plural `Patterns` for composed scenarios.
  - **Live Form**  -  `… Live Form` for LiveView-backed forms.
  - **Controlled**  -  `… Controlled` for assign-driven demos.
  - **Animation**  -  `… Animation` when motion is the focus.

  ## Section copy

  - Do not use the `demo_section` **`:description`** slot for teaching copy.
  - Previews should show the component, not long prose or “test” explanations; keep state in code tabs when possible.

  ## Playground pages

  - Use **`<.demo_playground>`** (below) for every `… · Playground` LiveView: one DOM shape (`layout_heading` + `preview` frame + sidebar + canvas). `AccordionPlayLive` is the visual reference; all play pages should render through this component.
  - **Control strip order (when a control exists for the component):** (1) **Direction** LTR/RTL  -  `<.playground_dir_toggle>` when the component has `dir`; (2) orientation or other `toggle_group` axes; (3) `select` controls; (4) `switch` rows. Not every page has every control; only include what the primitive supports.

  ## Shell contract (page types)

  - **Anatomy**  -  `<.demo_page>` + one `<.demo_section>` per variant; stable `id` on each section.
  - **Style**  -  same structure as anatomy; focus on CSS modifier classes and layout.
  - **Form**  -  static submit flow; real field names and assigns.
  - **Playground**  -  `Layouts.app` + `<.demo_playground>`; optional controls in the **controls** slot when `controls_strip` is true (default), demo in the **canvas** slot. Set `controls_strip={false}` to omit the sidebar (e.g. Toast playground).
  - **API**  -  LiveView; stable element ids; snippets from `E2eWeb.Demos.*`. Prefer `<.demo_section>` with **Preview** and code tabs. The optional **`<.demo_api_row>`** is available for action rows if you need it; most API lives use `demo_section` with `<.action>` only.
  - **Events**  -  LiveView; `<.demo_event_log>`. For collections, prefer streams and `<.data_table>` like `AccordionEventsLive`.
  - **Patterns**  -  real async only (`<.async_result>`, `<.demo_pattern_async>`). No placeholder skeletons.
  - **Controlled / Live Form**  -  only where the router exposes them; match real assigns from `lib/components`.

  ## Which pages exist (component class)

  Routing follows `E2eWeb.DocPageMatrix`:

  - **Zag-backed**  -  anatomy (and style when applicable), playground, API, events, patterns where the primitive supports them; optional animation, live form, controlled when routed.
  - **Form + Zag**  -  static **Form** and live-form routes as listed.
  - **Non-Zag** (layout, data table shell, etc.)  -  usually anatomy and style only; **data table** adds a **Pattern** page.

  Static pages use this module; live API/events/patterns use `demo_page` / `demo_section` / `code_tabs` where shown.
  """

  use E2eWeb, :html

  attr :id, :string, required: true
  attr :title, :string, required: true
  attr :subtitle, :any, default: nil
  attr :heading_class, :string, default: "layout-heading max-w-none"
  attr :class, :string, default: "w-full flex flex-col gap-size"
  attr :rest, :global
  slot :inner_block, required: true

  def demo_page(assigns) do
    ~H"""
    <article id={@id} class={@class} {@rest}>
      <.layout_heading class={@heading_class}>
        <:title>{@title}</:title>
        <:subtitle :if={is_binary(@subtitle)}>{@subtitle}</:subtitle>
      </.layout_heading>
      {render_slot(@inner_block)}
    </article>
    """
  end

  attr :id, :string, default: nil
  attr :title, :string, required: true
  attr :subtitle, :any, default: nil
  attr :heading_class, :string, default: "layout-heading"
  attr :controls_strip, :boolean, default: true
  slot :controls
  slot :canvas, required: true

  def demo_playground(assigns) do
    ~H"""
    <div id={@id} class="w-full flex flex-col">
      <.layout_heading class={@heading_class} title_tag="h2" subtitle_tag="p">
        <:title>{@title}</:title>
        <:subtitle :if={is_binary(@subtitle)}>{@subtitle}</:subtitle>
      </.layout_heading>
      <div class="preview">
        <div class="preview__frame">
          <div :if={@controls_strip} class="preview__sidebar preview__sidebar--wrap">
            {render_slot(@controls)}
          </div>
          <section class="preview__main">
            <div class="preview__canvas">
              {render_slot(@canvas)}
            </div>
          </section>
        </div>
      </div>
    </div>
    """
  end

  attr :id, :string, required: true
  attr :value, :list, required: true
  attr :on_value_change, :string, required: true

  def playground_dir_toggle(assigns) do
    ~H"""
    <.toggle_group
      class="toggle-group toggle-group--sm max-w-7xs"
      id={@id}
      on_value_change={@on_value_change}
      multiple={false}
      deselectable={false}
      value={@value}
    >
      <:item value="ltr" aria_label="Left to right direction">LTR</:item>
      <:item value="rtl" aria_label="Right to left direction">RTL</:item>
    </.toggle_group>
    """
  end

  attr :id, :string, required: true
  attr :title, :string, required: true
  attr :code, :string, default: nil
  attr :code_tabs, :list, default: []
  attr :default_value, :string, default: "preview"
  attr :trigger_class, :string, default: nil
  attr :tabs_id, :string, default: nil
  attr :class, :string, default: "flex flex-col gap-4 items-start"

  attr :tabs_class, :string,
    default:
      "tabs max-w-6xl [&>[data-scope=tabs][data-part=root]>[data-scope=tabs][data-part=list]]:place-self-end"

  attr :preview_class, :string,
    default: "items-center shadow-sm py-space-xl p-space bg-root gap-space"

  attr :code_panel_class, :string, default: "items-center bg-root p-0 relative"
  attr :code_class, :string, default: "code max-w-none w-full"

  attr :clipboard_class, :string,
    default: "clipboard w-fit clipboard--sm absolute top-2 right-2 z-10"

  slot :description
  slot :preview, required: true

  def demo_section(assigns) do
    assigns =
      if is_binary(assigns[:tabs_id]) and assigns[:tabs_id] != "" do
        assigns
      else
        assign(assigns, :tabs_id, "#{assigns.id}-tabs")
      end

    assigns =
      if assigns[:code_tabs] == [] and is_binary(assigns[:code]) do
        assign(assigns, :code_tabs, [
          %{
            value: "heex",
            label: "Heex",
            language: :heex,
            code: assigns[:code]
          }
        ])
      else
        assigns
      end

    ~H"""
    <section id={@id} class={@class}>
      <h2>{@title}</h2>
      {render_slot(@description)}
      <.tabs id={@tabs_id} class={@tabs_class} value={@default_value}>
        <:trigger value="preview" class={@trigger_class}>Preview</:trigger>
        <:trigger
          :for={tab <- @code_tabs}
          value={tab.value}
          class={@trigger_class}
        >
          {tab.label}
        </:trigger>
        <:content value="preview" class={@preview_class}>
          {render_slot(@preview)}
        </:content>
        <:content :for={tab <- @code_tabs} value={tab.value} class={@code_panel_class}>
          <.clipboard
            class={@clipboard_class}
            value={tab.code}
            input={false}
            trigger_aria_label="Copy code"
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
          <.code
            class={@code_class}
            language={Map.get(tab, :language, :heex)}
            code={tab.code}
          />
        </:content>
      </.tabs>
    </section>
    """
  end

  @doc """
  Scrolling event log used on every Events page.

  Pass a list of events (most recent first). Each entry should be a
  map with `:name` and `:payload` (inspected as JSON-ish text).
  """
  attr :id, :string, required: true
  attr :events, :list, required: true
  attr :empty_label, :string, default: "Interact with the component to see events here."
  attr :class, :string, default: "flex flex-col w-full max-w-6xl gap-2"

  def demo_event_log(assigns) do
    ~H"""
    <div id={@id} class={@class}>
      <h4 class="text-sm font-medium text-ink-muted">Event log</h4>
      <ol
        :if={@events != []}
        class="flex flex-col gap-1 max-h-64 overflow-auto rounded-md border border-border bg-ui p-2 text-sm font-mono"
      >
        <li :for={event <- @events} class="flex gap-2 items-start">
          <span class="text-ink-muted">{event.name}</span>
          <span class="text-ink">{inspect(event.payload)}</span>
        </li>
      </ol>
      <p :if={@events == []} class="text-sm text-ink-muted">{@empty_label}</p>
    </div>
    """
  end

  @doc """
  One "dispatch + response" row used on every API page.
  """
  attr :id, :string, required: true
  attr :title, :string, required: true
  attr :description, :string, default: nil
  attr :class, :string, default: "flex flex-col gap-2"
  slot :actions, required: true
  slot :result

  def demo_api_row(assigns) do
    ~H"""
    <div id={@id} class={@class}>
      <h4 class="text-sm font-medium">{@title}</h4>
      <p :if={@description} class="text-sm text-ink-muted">{@description}</p>
      <div class="flex flex-wrap gap-2">
        {render_slot(@actions)}
      </div>
      <div :if={@result != []} class="text-sm font-mono text-ink-muted">
        {render_slot(@result)}
      </div>
    </div>
    """
  end

  @doc """
  Skeleton/async wrapper used by the `Async` pattern section.

  When `loading` is `true`, child content is wrapped in a
  `data-loading` container. Component CSS hooks on
  `[data-loading]` to render its skeleton.
  """
  attr :id, :string, required: true
  attr :loading, :boolean, default: false
  attr :class, :string, default: "flex flex-col gap-2 w-full"
  slot :inner_block, required: true

  def demo_pattern_async(assigns) do
    ~H"""
    <div id={@id} class={@class} data-loading={(@loading && "") || nil}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Optional shell for a **Controlled** pattern or `/controlled` page: status text,
  toolbar actions, then the live component.
  """
  attr :id, :string, required: true
  attr :class, :string, default: "flex flex-col gap-3 w-full max-w-6xl"

  slot :state
  slot :toolbar
  slot :inner_block, required: true

  def demo_pattern_controlled(assigns) do
    ~H"""
    <div id={@id} class={@class}>
      <div :if={@state != []} class="flex flex-wrap items-center gap-2 text-sm">
        {render_slot(@state)}
      </div>
      <div :if={@toolbar != []} class="flex flex-wrap gap-2">
        {render_slot(@toolbar)}
      </div>
      {render_slot(@inner_block)}
    </div>
    """
  end
end
