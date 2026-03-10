defmodule E2eWeb.DatePickerControlledLive do
  use E2eWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :date, nil)}
  end

  def handle_event("date_changed", %{"value" => value}, socket) do
    {:noreply, assign(socket, :date, value)}
  end

  def handle_event("set_date", %{"value" => value}, socket) do
    {:noreply, assign(socket, :date, value)}
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
      <.layout_heading>
        <:title>Date Picker</:title>
        <:subtitle>Controlled Live View</:subtitle>
      </.layout_heading>

      <h3>Controlled State: {@date || "—"}</h3>

      <div class="layout__row">
        <.action phx-click="set_date" phx-value-value="2024-01-15" class="button button--sm">
          Set to 2024-01-15
        </.action>
        <.action phx-click="set_date" phx-value-value="2024-12-25" class="button button--sm">
          Set to 2024-12-25
        </.action>
      </div>

      <div class="mt-4">
        <.date_picker
          id="controlled-date-picker"
          class="date-picker"
          controlled
          value={@date}
          on_value_change="date_changed"
          trigger_aria_label="Select date"
          input_aria_label="Select date"
        >
          <:label>Date</:label>
          <:trigger>
            <.heroicon name="hero-calendar" class="icon" />
          </:trigger>
          <:prev_trigger>
            <.heroicon name="hero-chevron-left" class="icon" />
          </:prev_trigger>
          <:next_trigger>
            <.heroicon name="hero-chevron-right" class="icon" />
          </:next_trigger>
        </.date_picker>
      </div>
    </Layouts.app>
    """
  end
end
