defmodule E2eWeb.AngleSliderPatternsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  @id "patterns-angle-slider"
  @id_async "patterns-angle-slider-async"
  @id_controlled "patterns-angle-slider-controlled"

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:id, @id)
      |> assign(:id_async, @id_async)
      |> assign(:id_controlled, @id_controlled)
      |> assign(:value, 90.0)
      |> assign(:angle_value, nil)
      |> assign(:angle_value_as_degree, nil)
      |> assign(:angle_dragging, nil)
      |> assign(:async_heex_full, E2eWeb.Demos.AngleSliderDemo.patterns_async_heex_full())
      |> assign(:async_heex_panel, E2eWeb.Demos.AngleSliderDemo.patterns_async_heex_panel())
      |> assign(:async_elixir, E2eWeb.Demos.AngleSliderDemo.patterns_async_elixir())
      |> assign(:controlled_heex, E2eWeb.Demos.AngleSliderDemo.patterns_controlled_heex())
      |> assign(:controlled_elixir, E2eWeb.Demos.AngleSliderDemo.patterns_controlled_elixir())
      |> assign_async(:angle_slider, fn ->
        Process.sleep(1000)
        {:ok, %{angle_slider: %{value: 90.0}}}
      end)

    {:ok, socket}
  end

  def handle_event("patterns_controlled_changed", %{"value" => value}, socket) do
    {:noreply, assign(socket, :value, value)}
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
        id="angle-slider-patterns-page"
        title="Angle Slider · Pattern"
        subtitle="Common ways to structure Angle Slider state and data flows."
      >
        <.demo_section
          id="angle-slider-patterns-async"
          title="Async"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @async_heex_full},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @async_elixir}
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

        <.demo_section
          id="angle-slider-patterns-controlled"
          title="Controlled (LiveView)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @controlled_heex},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @controlled_elixir}
          ]}
        >
          <:preview>
            <.angle_slider
              id={@id_controlled}
              class="angle-slider"
              marker_values={[0, 90, 180, 270]}
              controlled
              value={@value}
              on_value_change="patterns_controlled_changed"
            >
              <:label>Angle</:label>
            </.angle_slider>
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
