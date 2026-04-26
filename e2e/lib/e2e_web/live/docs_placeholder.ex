defmodule E2eWeb.DocsPlaceholder do
  use Phoenix.Component

  alias E2eWeb.Layouts

  import E2eWeb.DemoPage

  def stub(assigns) do
    page_id = Map.get(assigns, :demo_page_id) || "docs-placeholder-page"

    assigns = assign(assigns, :demo_page_id, page_id)

    ~H"""
    <Layouts.app
      flash={@flash}
      mode={@mode}
      theme={@theme}
      path={@path}
    >
      <.demo_page
        id={@demo_page_id}
        title={"#{@docs_title} #{@docs_section}"}
        subtitle={@docs_section}
      >
        <.demo_section id="docs-placeholder-section" title="Coming soon" code="">
          <:preview>
            <p class="text-muted">Content will mirror the Accordion reference pages.</p>
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
