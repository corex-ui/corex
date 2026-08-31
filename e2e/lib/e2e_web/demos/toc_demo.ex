defmodule E2eWeb.Demos.TocDemo do
  use E2eWeb, :html

  alias E2eWeb.DemoScales

  def anatomy_minimal_code do
    ~S"""
    <.toc class="toc" />
    """
  end

  def anatomy_minimal_example(assigns) do
    _ = assigns

    ~H"""
    <.toc id="toc-anatomy-minimal" class="toc" />
    """
  end

  def anatomy_article_code do
    ~S"""
    <div class="grid grid-cols-[minmax(0,1fr)_12rem] gap-space items-start">
      <article class="flex flex-col gap-space-lg">
        <h2 id="intro">Introduction</h2>
        <p>Long-form content so the sticky TOC can track headings.</p>
        <p>Corex is a Phoenix LiveView component library with Zag.js behavior.</p>
        <h2 id="install">Install</h2>
        <p>Add the Hex package, run the installer, and include Design CSS.</p>
        <p>Keep the host id stable so hooks hydrate the same node after patch.</p>
        <h3 id="usage">Usage</h3>
        <p>Render hosts with a stable id. Hooks hydrate Zag machines after JS loads.</p>
        <p>Open Anatomy, API, Events, and Style from the docs sidebar.</p>
        <h2 id="api">API</h2>
        <p>Client bindings dispatch CustomEvents. Server handlers push LiveView events.</p>
        <p>Use set helpers from buttons instead of remounting the host.</p>
        <h2 id="a11y">Accessibility</h2>
        <p>Parts keep Zag data attributes so keyboard and screen reader behavior stay intact.</p>
        <p>Overflow regions that scroll should remain keyboard reachable.</p>
      </article>
      <div class="sticky top-space">
        <.toc class="toc" />
      </div>
    </div>
    """
  end

  def anatomy_article_example(assigns) do
    _ = assigns

    ~H"""
    <div class="grid w-full grid-cols-1 md:grid-cols-[minmax(0,1fr)_12rem] gap-space items-start">
      <article class="flex flex-col gap-space-lg max-h-96 overflow-auto pr-space" tabindex="0">
        <section>
          <h2 id="intro">Introduction</h2>
          <p>
            Corex is a Phoenix LiveView component library. This article is long enough to scroll so the table of contents can highlight the active section.
          </p>
          <p :for={_ <- 1..6}>
            Keep scrolling. Each heading below maps to a TOC link.
          </p>
        </section>
        <section>
          <h2 id="install">Install</h2>
          <p>Add the Hex package, run the installer, and include Design CSS.</p>
          <p :for={_ <- 1..6}>Installation notes continue here.</p>
        </section>
        <section>
          <h3 id="usage">Usage</h3>
          <p>Render hosts with a stable id. Hooks hydrate Zag machines after JS loads.</p>
          <p :for={_ <- 1..6}>Usage details continue here.</p>
        </section>
        <section>
          <h2 id="api">API</h2>
          <p>Client bindings dispatch CustomEvents. Server handlers push LiveView events.</p>
          <p :for={_ <- 1..6}>API notes continue here.</p>
        </section>
        <section>
          <h2 id="a11y">Accessibility</h2>
          <p>Parts keep Zag data attributes so keyboard and screen reader behavior stay intact.</p>
          <p :for={_ <- 1..6}>Accessibility notes continue here.</p>
        </section>
        <section>
          <h2 id="tokens">Tokens</h2>
          <p>Design CSS maps semantic axes onto control tokens without extra wrappers.</p>
          <p :for={_ <- 1..6}>Token notes continue here.</p>
        </section>
        <section>
          <h2 id="patterns">Patterns</h2>
          <p>Clone Select overlay SSR, avatar loading, and dialog surfaces instead of inventing new models.</p>
          <p :for={_ <- 1..6}>Pattern notes continue here.</p>
        </section>
      </article>
      <div class="sticky top-space">
        <.toc id="toc-anatomy-article" class="toc" />
      </div>
    </div>
    """
  end

  def styling_color_code do
    ~S"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.toc class="toc" />
    <.toc class="toc ui-accent" />
    <.toc class="toc ui-brand" />
    <.toc class="toc ui-alert" />
    <.toc class="toc ui-success" />
    <.toc class="toc ui-info" />
    </div>
    """
  end

  def styling_color_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-sm items-start">
      <.toc id="toc-style-default" class="toc" />
      <.toc id="toc-style-accent" class="toc ui-accent" />
      <.toc id="toc-style-brand" class="toc ui-brand" />
      <.toc id="toc-style-alert" class="toc ui-alert" />
      <.toc id="toc-style-success" class="toc ui-success" />
      <.toc id="toc-style-info" class="toc ui-info" />
    </div>
    """
  end

  def styling_size_code do
    ~S"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.toc class="toc ui-size-sm" />
    <.toc class="toc ui-size-md" />
    <.toc class="toc ui-size-lg" />
    <.toc class="toc ui-size-xl" />
    </div>
    """
  end

  def styling_size_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-sm items-start">
      <.toc id="toc-style-size-sm" class="toc ui-size-sm" />
      <.toc id="toc-style-size-md" class="toc ui-size-md" />
      <.toc id="toc-style-size-lg" class="toc ui-size-lg" />
      <.toc id="toc-style-size-xl" class="toc ui-size-xl" />
    </div>
    """
  end

  def styling_rounded_code do
    ~S"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.toc class="toc ui-rounded-none" />
    <.toc class="toc ui-rounded-sm" />
    <.toc class="toc ui-rounded-md" />
    <.toc class="toc ui-rounded-lg" />
    <.toc class="toc ui-rounded-xl" />
    <.toc class="toc ui-rounded-full" />
    </div>
    """
  end

  def styling_rounded_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-sm items-start">
      <.toc id="toc-style-r-none" class="toc ui-rounded-none" />
      <.toc id="toc-style-r-sm" class="toc ui-rounded-sm" />
      <.toc id="toc-style-r-md" class="toc ui-rounded-md" />
      <.toc id="toc-style-r-lg" class="toc ui-rounded-lg" />
      <.toc id="toc-style-r-xl" class="toc ui-rounded-xl" />
      <.toc id="toc-style-r-full" class="toc ui-rounded-full" />
    </div>
    """
  end

  def styling_width_code do
    DemoScales.width_layout_variants("toc")
    |> Enum.map(fn %{id: _id, modifier: modifier} ->
      class = DemoScales.join_modifiers("toc", modifier)
      ~s(<.toc class="#{class}" />)
    end)
    |> DemoScales.join_code()
  end

  def styling_width_example(assigns) do
    assigns = assign(assigns, :width_variants, DemoScales.width_layout_variants("toc"))

    ~H"""
    <div class="flex flex-col gap-space">
      <.toc
        :for={step <- @width_variants}
        id={"toc-style-w-#{step.id}"}
        class={DemoScales.join_modifiers("toc", step.modifier)}
      />
    </div>
    """
  end

  def styling_max_width_code do
    DemoScales.max_width_variants("toc")
    |> Enum.take(4)
    |> Enum.map(fn %{id: _id, modifier: modifier} ->
      class = DemoScales.join_modifiers("toc", modifier)
      ~s(<.toc class="#{class}" />)
    end)
    |> DemoScales.join_code()
  end

  def styling_max_width_example(assigns) do
    assigns =
      assign(assigns, :max_width_variants, DemoScales.max_width_variants("toc") |> Enum.take(4))

    ~H"""
    <div class="flex flex-col gap-space">
      <.toc
        :for={step <- @max_width_variants}
        class={DemoScales.join_modifiers("toc", step.modifier)}
      />
    </div>
    """
  end
end
