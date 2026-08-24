defmodule E2eWeb.SliderPatternsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  @id "patterns-slider"
  @id_async "patterns-slider-async"

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:id, @id)
      |> assign(:id_async, @id_async)
      |> assign(:async_heex_full, E2eWeb.Demos.SliderDemo.patterns_async_heex_full())
      |> assign(:async_heex_panel, E2eWeb.Demos.SliderDemo.patterns_async_heex_panel())
      |> assign(:async_elixir, E2eWeb.Demos.SliderDemo.patterns_async_elixir())
      |> assign_async(:slider, fn ->
        Process.sleep(1000)
        {:ok, %{slider: %{value: [25]}}}
      end)

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
      <.demo_page
        path={@path}
        id="slider-patterns-page"
        title={~t"Slider · Pattern"}
        subtitle={~t"Common ways to structure Slider state and data flows."}
      >
        <.demo_section
          id="slider-patterns-async"
          title={~t"Async"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @async_heex_full},
            %{value: "elixir", label: ~t"Elixir", language: :elixir, code: @async_elixir}
          ]}
        >
          <:preview>
            <.async_result :let={slider} assign={@slider}>
              <:loading>
                <.slider_skeleton class="slider" />
              </:loading>

              <.slider
                id={@id_async}
                class="slider"
                value={slider.value}
                marker_values={[0, 25, 50, 75, 100]}
              >
                <:label>Volume</:label>
              </.slider>
            </.async_result>
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
