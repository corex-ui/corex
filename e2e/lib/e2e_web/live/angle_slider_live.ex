defmodule E2eWeb.AngleSliderLive do
  use E2eWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} mode={@mode} locale={@locale} current_path={@current_path}>
      <div class="layout__row">
        <h1>Angle Slider</h1>
        <h2>Live View</h2>
      </div>
      <.angle_slider id="my-angle-slider" class="angle-slider" marker_values={[0, 90, 180, 270]}>
        <:label>Angle</:label>
      </.angle_slider>
    </Layouts.app>
    """
  end
end
