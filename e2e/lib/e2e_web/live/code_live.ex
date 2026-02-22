defmodule E2eWeb.CodeLive do
  use E2eWeb, :live_view

  def mount(_params, _session, socket) do
    heredoc_example = """
    defmodule Hello do
      def world do
        "Hello, World!"
      end
    end
    """

    socket =
      socket
      |> assign(:code_examples, E2eWeb.CodeExamples.all())
      |> assign(:heredoc_example, heredoc_example)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app
      flash={@flash}
      mode={@mode}
      theme={@theme}
      locale={@locale}
      current_path={@current_path}
    >
      <h1>Code</h1>
      <h2>Live View</h2>
      <h3>Elixir</h3>
      <section class="layout__section">
        <div class="relative w-full">
          <.clipboard
            id="code-elixir"
            class="clipboard clipboard--sm absolute top-ui-padding right-ui-padding z-10"
            value={@code_examples.elixir}
            input={false}
            trigger_aria_label="Copy code"
          >
            <:trigger>
              <.icon name="hero-clipboard" class="icon data-copy" />
              <.icon name="hero-check" class="icon data-copied" />
            </:trigger>
          </.clipboard>
          <.code code={@code_examples.elixir} language={:elixir} class="code" />
        </div>
      </section>

      <h3>HTML</h3>
      <section class="layout__section">
        <div class="relative w-full">
          <.clipboard
            id="code-html"
            class="clipboard clipboard--sm absolute top-ui-padding right-ui-padding z-10"
            value={@code_examples.html}
            input={false}
            trigger_aria_label="Copy code"
          >
            <:trigger>
              <.icon name="hero-clipboard" class="icon data-copy" />
              <.icon name="hero-check" class="icon data-copied" />
            </:trigger>
          </.clipboard>
          <.code code={@code_examples.html} language={:html} class="code" />
        </div>
      </section>

      <h3>CSS</h3>
      <section class="layout__section">
        <div class="relative w-full">
          <.clipboard
            id="code-css"
            class="clipboard clipboard--sm absolute top-ui-padding right-ui-padding z-10"
            value={@code_examples.css}
            input={false}
            trigger_aria_label="Copy code"
          >
            <:trigger>
              <.icon name="hero-clipboard" class="icon data-copy" />
              <.icon name="hero-check" class="icon data-copied" />
            </:trigger>
          </.clipboard>
          <.code code={@code_examples.css} language={:css} class="code" />
        </div>
      </section>

      <h3>JavaScript</h3>
      <section class="layout__section">
        <div class="relative w-full">
          <.clipboard
            id="code-js"
            class="clipboard clipboard--sm absolute top-ui-padding right-ui-padding z-10"
            value={@code_examples.js}
            input={false}
            trigger_aria_label="Copy code"
          >
            <:trigger>
              <.icon name="hero-clipboard" class="icon data-copy" />
              <.icon name="hero-check" class="icon data-copied" />
            </:trigger>
          </.clipboard>
          <.code code={@code_examples.js} language={:js} class="code" />
        </div>
      </section>

      <h3>Inline with heredoc</h3>
      <section class="layout__section">
        <div class="relative w-full">
          <.clipboard
            id="code-heredoc"
            class="clipboard clipboard--sm absolute top-ui-padding right-ui-padding z-10"
            value={@heredoc_example}
            input={false}
            trigger_aria_label="Copy code"
          >
            <:trigger>
              <.icon name="hero-clipboard" class="icon data-copy" />
              <.icon name="hero-check" class="icon data-copied" />
            </:trigger>
          </.clipboard>
          <.code language={:elixir} class="code" code={@heredoc_example} />
        </div>
      </section>
    </Layouts.app>
    """
  end
end
