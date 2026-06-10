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

  - Use **`<.demo_playground>>`** (below) for every `… · Playground` LiveView: one DOM shape (`layout_heading` + `preview` frame + sidebar + canvas). `AccordionPlayLive` is the visual reference; all play pages should render through this component. Source links live on **`demo_page`** only, not in the playground block.
  - **Control strip order (when a control exists for the component):** (1) **Direction** LTR/RTL  -  `<.playground_dir_toggle>` when the component has `dir`; (2) orientation or other `toggle_group` axes; (3) `select` controls; (4) `switch` rows. Not every page has every control; only include what the primitive supports.
  - **Control strip sizing:** use `--sm` on sidebar controls only (not the canvas demo), e.g. `toggle-group toggle-group--size-sm`, `select select--size-sm`, `switch switch--size-sm`, `checkbox checkbox--size-sm`, `number-input number-input--size-sm`, `native-input native-input--size-sm`.

  ## Shell contract (page types)
  ## Shell contract (page types)

  - **Anatomy**  -  `<.demo_page path={@path}>>` + one `<.demo_section>` per variant; stable `id` on each section.
  - **Style**  -  same structure as anatomy; focus on CSS modifier classes and layout.
  - **Form**  -  static submit flow; real field names and assigns.
  - **Playground**  -  `Layouts.app` + `<.demo_playground>>`; optional controls in the **controls** slot when `controls_strip` is true (default), demo in the **canvas** slot. Set `controls_strip={false}` to omit the sidebar (e.g. Toast playground).
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

  import E2eWeb.AuthoringToggle

  attr :id, :string, required: true
  attr :title, :string, required: true
  attr :subtitle, :any, default: nil
  attr :path, :string, default: nil
  attr :disable_markup, :boolean, default: false
  attr :heading_class, :string, default: "layout-heading"
  attr :class, :string, default: "doc-page"
  attr :rest, :global
  slot :inner_block, required: true

  def demo_page(assigns) do
    assigns =
      assign(
        assigns,
        :disable_markup,
        E2eWeb.DocAuthoring.disable_markup_on_page?(
          id: Map.get(assigns, :id),
          path: Map.get(assigns, :path)
        )
      )

    ~H"""
    <article id={@id} class={@class} {@rest}>
      <.layout_heading class={@heading_class} width="full" max_width="none">
        <:title>{@title}</:title>
        <:subtitle :if={is_binary(@subtitle)}>{@subtitle}</:subtitle>
      </.layout_heading>
      <div :if={@path} id="doc-page-toolbar" class="doc-page-toolbar">
        <.component_source_bar path={@path} />
        <.demo_authoring_settings disable_markup={@disable_markup} />
      </div>
      {render_slot(@inner_block)}
    </article>
    """
  end

  attr :path, :string, required: true

  def component_source_bar(assigns) do
    links = E2eWeb.ComponentSourceLinks.links_for_path(assigns.path)
    assigns = assign(assigns, :links, links || [])

    ~H"""
    <div :if={@links != []} class="doc-source-bar">
      <.navigate :for={link <- @links} to={link.to} as="button" size="sm" variant="ghost" external>
        <img :if={link.icon} src={link.icon} alt="" width="16" height="16" />
        {link.label}
        <.heroicon name="hero-arrow-top-right-on-square" />
      </.navigate>
    </div>
    """
  end

  attr :id, :string, default: nil
  attr :title, :string, default: nil
  attr :subtitle, :any, default: nil
  attr :path, :string, default: nil
  attr :heading_class, :string, default: "layout-heading"
  attr :title_tag, :string, default: "h1"
  attr :subtitle_tag, :string, default: "p"
  attr :controls_strip, :boolean, default: true
  slot :controls
  slot :canvas, required: true

  def demo_playground(assigns) do
    ~H"""
    <div id={@id} class="w-full flex flex-col">
      <.layout_heading
        :if={is_binary(@title)}
        class={@heading_class}
        width="full"
        max_width="none"
        title_tag={@title_tag}
        subtitle_tag={@subtitle_tag}
      >
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
      size="sm"
      class="max-w-7xs"
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
  attr :value, :list, required: true
  attr :on_value_change, :string, required: true

  def playground_orientation_toggle(assigns) do
    ~H"""
    <.toggle_group
      size="sm"
      class="max-w-7xs"
      id={@id}
      on_value_change={@on_value_change}
      multiple={false}
      deselectable={false}
      value={@value}
    >
      <:item value="vertical" aria_label="Vertical orientation">
        <.heroicon name="hero-arrows-up-down" />
      </:item>
      <:item value="horizontal" aria_label="Horizontal orientation">
        <.heroicon name="hero-arrows-right-left" />
      </:item>
    </.toggle_group>
    """
  end

  attr :id, :string, required: true
  attr :code, :any, default: nil
  attr :code_tabs, :list, default: []
  attr :default_value, :string, default: "preview"
  attr :trigger_class, :string, default: nil
  attr :tabs_id, :string, default: nil

  attr :tabs_class, :string, default: "tabs doc-section-tabs"

  attr :preview_class, :string, default: "doc-section-preview"

  attr :code_panel_class, :string, default: "doc-section-code"
  attr :code_class, :string, default: nil
  attr :code_max_height, :string, default: "lg"

  attr :clipboard_class, :string,
    default: "clipboard w-fit clipboard--size-sm absolute top-2 right-2 z-10"

  attr :wrapper_class, :string, default: "doc-preview-tabs"

  attr :authoring_scope, :string,
    default: nil,
    values: [nil, "styled"],
    doc: "when styled, preview and code ignore global unstyled authoring in this block"

  slot :preview, required: true

  def demo_preview_tabs(assigns) do
    assigns =
      if is_binary(assigns[:tabs_id]) and assigns[:tabs_id] != "" do
        assigns
      else
        assign(assigns, :tabs_id, "#{assigns.id}-tabs")
      end

    assigns =
      if assigns[:code_tabs] == [] and not is_nil(assigns[:code]) do
        assign(assigns, :code_tabs, code_tabs_from_code(assigns[:code]))
      else
        assigns
      end

    ~H"""
    <div
      id={@id}
      class={@wrapper_class}
      data-authoring-scope={@authoring_scope}
    >
      <.tabs id={@tabs_id} class={@tabs_class} value={@default_value} width="full" max_width="none">
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
          <.authoring_code_block
            code={tab.code}
            authoring_scope={@authoring_scope}
            language={Map.get(tab, :language, :heex)}
            clipboard_class={@clipboard_class}
            code_class={@code_class}
            code_max_height={@code_max_height}
          />
        </:content>
      </.tabs>
    </div>
    """
  end

  attr :disable_markup, :boolean, default: false

  def demo_authoring_settings(assigns) do
    %{authoring: authoring} = E2eWeb.DocAuthoring.get()
    assigns = assign(assigns, :authoring, authoring)

    ~H"""
    <div
      id="doc-authoring-settings"
      class="doc-authoring-settings"
      data-disable-markup={@disable_markup}
    >
      <span class="doc-authoring-settings__label">Authoring</span>
      <.authoring_toggle
        id="doc-authoring-mode"
        authoring={@authoring}
        disable_markup={@disable_markup}
      />
    </div>
    """
  end

  slot :styled, required: true
  slot :markup, required: true

  def authoring_preview(assigns) do
    ~H"""
    <div data-authoring-preview="styled">
      {render_slot(@styled)}
    </div>
    <div data-authoring-preview="markup">
      {render_slot(@markup)}
    </div>
    """
  end

  attr :id, :string, required: true
  attr :title, :string, required: true
  attr :code, :any, default: nil
  attr :code_tabs, :list, default: []
  attr :default_value, :string, default: "preview"
  attr :trigger_class, :string, default: nil
  attr :tabs_id, :string, default: nil
  attr :class, :string, default: "doc-section"

  attr :tabs_class, :string, default: "tabs doc-section-tabs"

  attr :preview_class, :string, default: "doc-section-preview"

  attr :code_panel_class, :string, default: "doc-section-code"
  attr :code_class, :string, default: nil
  attr :code_max_height, :string, default: "lg"

  attr :clipboard_class, :string,
    default: "clipboard w-fit clipboard--size-sm absolute top-2 right-2 z-10"

  attr :values, :string, default: nil

  attr :authoring_scope, :string,
    default: nil,
    values: [nil, "styled"],
    doc: "when styled, preview and code ignore global unstyled authoring in this block"

  slot :description
  slot :preview, required: true

  def demo_section(assigns) do
    assigns =
      if is_binary(assigns[:tabs_id]) and assigns[:tabs_id] != "" do
        assigns
      else
        assign(assigns, :tabs_id, "#{assigns.id}-tabs")
      end

    ~H"""
    <section id={@id} class={@class}>
      <.h2>{@title}</.h2>
      <p :if={is_binary(@values)}>{~t"Values: #{@values}"}</p>
      {render_slot(@description)}
      <.demo_preview_tabs
        id={"#{@id}-preview"}
        tabs_id={@tabs_id}
        code={@code}
        code_tabs={@code_tabs}
        default_value={@default_value}
        trigger_class={@trigger_class}
        tabs_class={@tabs_class}
        preview_class={@preview_class}
        code_panel_class={@code_panel_class}
        code_class={@code_class}
        code_max_height={@code_max_height}
        clipboard_class={@clipboard_class}
        authoring_scope={@authoring_scope}
      >
        <:preview>{render_slot(@preview)}</:preview>
      </.demo_preview_tabs>
    </section>
    """
  end

  attr :id, :string, required: true
  attr :title, :string, default: "Style matrix"
  attr :class, :string, default: "style-matrix"
  slot :inner_block, required: true

  def demo_style_matrix(assigns) do
    ~H"""
    <section :if={E2eWeb.StyleMatrix.visible?()} id={@id} class={@class}>
      <.h2>{@title}</.h2>
      {render_slot(@inner_block)}
    </section>
    """
  end

  attr :code, :any, required: true
  attr :authoring_scope, :string, default: nil, values: [nil, "styled"]
  attr :language, :atom, default: :heex
  attr :clipboard_class, :string, required: true
  attr :code_class, :string, default: nil
  attr :code_max_height, :string, required: true

  defp authoring_code_block(%{authoring_scope: "styled", code: %{attr: attr, class: class}} = assigns) do
    authoring_code_block(%{assigns | authoring_scope: nil, code: %{attr: attr, class: class}})
  end

  defp authoring_code_block(%{code: %{attr: attr, class: class, markup: markup}} = assigns) do
    %{app_name: app_name} = E2eWeb.DocAuthoring.get()

    assigns =
      assigns
      |> assign(:attr_template, attr)
      |> assign(:class_template, class)
      |> assign(:markup_template, markup)
      |> assign(:attr_code, E2eWeb.AuthoringSnippet.personalize_snippet(attr, app_name))
      |> assign(:class_code, E2eWeb.AuthoringSnippet.personalize_snippet(class, app_name))
      |> assign(:markup_code, E2eWeb.AuthoringSnippet.personalize_snippet(markup, app_name))

    ~H"""
    <div
      class="relative"
      data-authoring-code
      data-snippet-attr-template={@attr_template}
      data-snippet-class-template={@class_template}
      data-snippet-markup-template={@markup_template}
    >
      <div data-authoring-panel="attr" class="relative">
        <.code_block
          code={@attr_code}
          language={@language}
          clipboard_class={@clipboard_class}
          code_class={@code_class}
          code_max_height={@code_max_height}
        />
      </div>
      <div data-authoring-panel="class" class="relative">
        <.code_block
          code={@class_code}
          language={@language}
          clipboard_class={@clipboard_class}
          code_class={@code_class}
          code_max_height={@code_max_height}
        />
      </div>
      <div data-authoring-panel="markup" class="relative">
        <.code_block
          code={@markup_code}
          language={@language}
          clipboard_class={@clipboard_class}
          code_class={@code_class}
          code_max_height={@code_max_height}
        />
      </div>
    </div>
    """
  end

  defp authoring_code_block(%{code: %{attr: attr, class: class}} = assigns) do
    %{app_name: app_name} = E2eWeb.DocAuthoring.get()

    assigns =
      assigns
      |> assign(:attr_template, attr)
      |> assign(:class_template, class)
      |> assign(:attr_code, E2eWeb.AuthoringSnippet.personalize_snippet(attr, app_name))
      |> assign(:class_code, E2eWeb.AuthoringSnippet.personalize_snippet(class, app_name))

    ~H"""
    <div
      class="relative"
      data-authoring-code
      data-snippet-attr-template={@attr_template}
      data-snippet-class-template={@class_template}
    >
      <div data-authoring-panel="attr" class="relative">
        <.code_block
          code={@attr_code}
          language={@language}
          clipboard_class={@clipboard_class}
          code_class={@code_class}
          code_max_height={@code_max_height}
        />
      </div>
      <div data-authoring-panel="class" class="relative">
        <.code_block
          code={@class_code}
          language={@language}
          clipboard_class={@clipboard_class}
          code_class={@code_class}
          code_max_height={@code_max_height}
        />
      </div>
    </div>
    """
  end

  defp authoring_code_block(assigns) do
    template = assigns.code
    %{app_name: app_name} = E2eWeb.DocAuthoring.get()
    code = E2eWeb.AuthoringSnippet.personalize_snippet(template, app_name)
    assigns = assign(assigns, :code, code) |> assign(:template, template)

    ~H"""
    <div class="relative" data-authoring-code data-snippet-attr-template={@template}>
      <.code_block
        code={@code}
        language={@language}
        clipboard_class={@clipboard_class}
        code_class={@code_class}
        code_max_height={@code_max_height}
      />
    </div>
    """
  end

  defp code_tabs_from_code(%{attr: attr, class: class, markup: markup}) do
    [
      %{
        value: "heex",
        label: ~t"Heex",
        language: :heex,
        code: %{attr: attr, class: class, markup: markup}
      }
    ]
  end

  defp code_tabs_from_code(%{attr: attr, class: class}) do
    [
      %{
        value: "heex",
        label: ~t"Heex",
        language: :heex,
        code: %{attr: attr, class: class}
      }
    ]
  end

  defp code_tabs_from_code(code) when is_binary(code) do
    [
      %{
        value: "heex",
        label: ~t"Heex",
        language: :heex,
        code: code
      }
    ]
  end

  attr :code, :string, required: true
  attr :language, :atom, default: :heex
  attr :clipboard_class, :string, required: true
  attr :code_class, :string, default: nil
  attr :code_max_height, :string, required: true

  defp code_block(assigns) do
    ~H"""
    <.clipboard
      class={@clipboard_class}
      value={@code}
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
      max_width="none"
      max_height={@code_max_height}
      width="full"
      class={@code_class}
      language={@language}
      code={@code}
    />
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
      <h4 class="text-sm font-medium text-ui-ink-muted">Event log</h4>
      <ol
        :if={@events != []}
        class="flex flex-col gap-1 max-h-64 overflow-auto rounded-md border border-border bg-ui p-2 text-sm font-mono"
      >
        <li :for={event <- @events} class="flex gap-2 items-start">
          <span class="text-ui-ink-muted">{event.name}</span>
          <span class="text-ui-ink">{inspect(event.payload)}</span>
        </li>
      </ol>
      <p :if={@events == []} class="text-sm text-ui-ink-muted">{@empty_label}</p>
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
      <p :if={@description} class="text-sm text-ui-ink-muted">{@description}</p>
      <div class="flex flex-wrap gap-2">
        {render_slot(@actions)}
      </div>
      <div :if={@result != []} class="text-sm font-mono text-ui-ink-muted">
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
