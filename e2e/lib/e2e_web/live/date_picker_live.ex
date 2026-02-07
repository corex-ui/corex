defmodule E2eWeb.DatePickerLive do
  use E2eWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_event("set_value", %{"value" => value}, socket) do
    {:noreply, Corex.DatePicker.set_value(socket, "my-date-picker", value)}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="layout__row">
        <h1>Date Picker</h1>
        <h2>Live View</h2>
      </div>
      <h3>Client Api</h3>
      <div class="layout__row">
        <button
          phx-click={Corex.DatePicker.set_value("my-date-picker", "2024-01-15")}
          class="button button--sm"
        >
          Set to 2024-01-15
        </button>
        <button
          phx-click={Corex.DatePicker.set_value("my-date-picker", "2024-12-25")}
          class="button button--sm"
        >
          Set to 2024-12-25
        </button>
      </div>
      <h3>Server Api</h3>
      <div class="layout__row">
        <button phx-click="set_value" value="2024-01-15" class="button button--sm">
          Set to 2024-01-15
        </button>
        <button phx-click="set_value" value="2024-12-25" class="button button--sm">
          Set to 2024-12-25
        </button>
      </div>
      <.date_picker
        id="my-date-picker"
        trigger_aria_label="Select date"
        input_aria_label="Select date"
        class="date-picker"
      >
        <:label>Select a date</:label>
        <:trigger>
          <.icon name="hero-calendar" class="icon" />
        </:trigger>
        <:prev_trigger>
          <.icon name="hero-chevron-left" class="icon" />
        </:prev_trigger>
        <:next_trigger>
          <.icon name="hero-chevron-right" class="icon" />
        </:next_trigger>
      </.date_picker>
    </Layouts.app>
    """
  end
end
