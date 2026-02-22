defmodule E2eWeb.ActionLive do
  use E2eWeb, :live_view

  def mount(_params, _session, socket) do
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
      <h1>Action</h1>
      <h2>Live View</h2>
      <h3>Anatomy</h3>
      <section class="layout__section">
        <div class="layout__row gap-ui-gap">
          <.action class="button">Text</.action>
          <.action class="button">
            Text and SVG
            <span aria-hidden="true"><.icon name="hero-arrow-right" class="icon" /></span>
          </.action>
          <.action class="button button--square" aria_label="Button text">
            <span aria-hidden="true"><.icon name="hero-arrow-right" class="icon" /></span>
          </.action>
          <.action class="button button--square" aria_label="Button text">B</.action>
        </div>
      </section>

      <h3>Color</h3>
      <section class="layout__section">
        <div class="layout__row gap-ui-gap">
          <.action class="button">Text</.action>
          <.action class="button button--accent">Text</.action>
          <.action class="button button--brand">Text</.action>
          <.action class="button button--alert">Text</.action>
          <.action class="button button--info">Text</.action>
          <.action class="button button--success">Text</.action>
        </div>
      </section>

      <h3>Size</h3>
      <section class="layout__section">
        <div class="layout__row gap-ui-gap items-center">
          <.action class="button button--sm">Button SM</.action>
          <.action class="button">Button MD</.action>
          <.action class="button button--lg">Button LG</.action>
          <.action class="button button--xl">Button XL</.action>
        </div>
      </section>

      <h3>Shape</h3>
      <section class="layout__section">
        <div class="layout__row gap-ui-gap items-center">
          <.action class="button button--square" aria_label="Square button">
            <span aria-hidden="true"><.icon name="hero-arrow-right" class="icon" /></span>
          </.action>
          <.action class="button button--square" aria_label="Square button">B</.action>
          <.action class="button button--circle" aria_label="Circle button">
            <span aria-hidden="true"><.icon name="hero-arrow-right" class="icon" /></span>
          </.action>
          <.action class="button button--circle" aria_label="Circle button">B</.action>
        </div>
      </section>

      <h3>Disabled</h3>
      <section class="layout__section">
        <div class="layout__row gap-ui-gap items-center">
          <.action class="button" disabled>Text</.action>
          <.action class="button button--accent" disabled>Text</.action>
          <.action class="button button--square" aria_label="Disabled" disabled>
            <span aria-hidden="true"><.icon name="hero-arrow-right" class="icon" /></span>
          </.action>
        </div>
      </section>
    </Layouts.app>
    """
  end
end
