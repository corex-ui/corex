defmodule E2eWeb.LayoutHeadingPatternsLive do
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
      path={@path}
    >
      <.layout_heading>
        <:title>Layout Heading</:title>
        <:subtitle>Live View</:subtitle>
      </.layout_heading>

      <h3>Title only</h3>
      <.layout_heading>
        <:title>Page Title</:title>
      </.layout_heading>

      <h3>Title and subtitle</h3>
      <.layout_heading>
        <:title>Page Title</:title>
        <:subtitle>Live View</:subtitle>
      </.layout_heading>

      <h3>Title, subtitle and actions</h3>
      <.layout_heading>
        <:title>Page Title</:title>
        <:subtitle>Live View</:subtitle>
        <:actions>
          <.navigate to={~p"/"} type="navigate" class="button">
            <.heroicon name="hero-arrow-left" class="icon" /> Back
          </.navigate>
        </:actions>
      </.layout_heading>
    </Layouts.app>
    """
  end
end
