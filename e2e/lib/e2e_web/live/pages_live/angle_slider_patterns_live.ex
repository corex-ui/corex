defmodule E2eWeb.AngleSliderPatternsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  @id "patterns-angle-slider"
  @id_async "patterns-angle-slider-async"

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:id, @id)
      |> assign(:id_async, @id_async)
      |> assign(:async_heex_full, E2eWeb.Demos.AngleSliderDemo.patterns_async_heex_full())
      |> assign(:async_heex_panel, E2eWeb.Demos.AngleSliderDemo.patterns_async_heex_panel())
      |> assign(:async_elixir, E2eWeb.Demos.AngleSliderDemo.patterns_async_elixir())
      |> assign_async(:angle_slider, fn ->
        Process.sleep(1000)
        {:ok, %{angle_slider: %{value: 90.0}}}
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
        id="angle-slider-patterns-page"
        title={~t"Angle Slider · Pattern"}
        subtitle={~t"Common ways to structure Angle Slider state and data flows."}
      >
        <.demo_section
          id="angle-slider-patterns-async"
          title={~t"Async"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @async_heex_full},
            %{value: "elixir", label: ~t"Elixir", language: :elixir, code: @async_elixir}
          ]}
        >
          <:preview>
            <.async_result :let={angle_slider} assign={@angle_slider}>
              <:loading>
                <.angle_slider_skeleton class="angle-slider" />
              </:loading>

              <.angle_slider
                id={@id_async}
                class="angle-slider"
                value={angle_slider.value}
                marker_values={[0, 90, 180, 270]}
              >
                <:label>Angle</:label>
              </.angle_slider>
            </.async_result>
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
