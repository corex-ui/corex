defmodule E2eWeb.RadioGroupLive do
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
      <div class="layout__row">
        <h1>Radio Group</h1>
        <h2>Live View</h2>
      </div>
      <div>
        <h3>Without indicator</h3>
        <.radio_group
          id="radio-group-plain"
          name="choice-plain"
          items={[
            %{value: "a", label: "Option A"},
            %{value: "b", label: "Option B"},
            %{value: "c", label: "Option C"}
          ]}
          class="radio-group"
        >
          <:label>Choose one</:label>
        </.radio_group>
      </div>
      <div>
        <h3>With indicator</h3>
        <.radio_group
          id="radio-group-indicator"
          name="choice-indicator"
          items={[
            %{value: "a", label: "Option A"},
            %{value: "b", label: "Option B"},
            %{value: "c", label: "Option C"}
          ]}
          class="radio-group"
        >
          <:label>Choose one</:label>
          <:item_control><.icon name="hero-check" class="data-checked" /></:item_control>
        </.radio_group>
      </div>
    </Layouts.app>
    """
  end
end
