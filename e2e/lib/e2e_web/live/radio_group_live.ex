defmodule E2eWeb.RadioGroupLive do
  use E2eWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} mode={@mode} locale={@locale} current_path={@current_path}>
      <div class="layout__row">
        <h1>Radio Group</h1>
        <h2>Live View</h2>
      </div>
      <.radio_group
        id="my-radio-group"
        items={[
          %{value: "a", label: "Option A"},
          %{value: "b", label: "Option B"},
          %{value: "c", label: "Option C"}
        ]}
        class="radio-group"
      >
        <:label>Choose one</:label>
        <:item_control>
          <.icon name="hero-check" class="data-checked" />
        </:item_control>
      </.radio_group>
    </Layouts.app>
    """
  end
end
