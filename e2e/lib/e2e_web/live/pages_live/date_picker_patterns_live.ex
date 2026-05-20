defmodule E2eWeb.DatePickerPatternsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :selected, nil)}
  end

  @impl true
  def handle_event("pattern_date_changed", %{"value" => value}, socket) do
    {:noreply, assign(socket, :selected, value)}
  end

  @impl true
  def render(assigns) do
    assigns =
      assign(
        assigns,
        :code_tabs,
        [
          %{
            value: "heex",
            label: "Heex",
            language: :heex,
            code: E2eWeb.Demos.DatePickerDemo.patterns_controlled_code()
          },
          %{
            value: "elixir",
            label: ~t"Elixir",
            language: :elixir,
            code: E2eWeb.Demos.DatePickerDemo.patterns_controlled_elixir()
          }
        ]
      )

    ~H"""
    <Layouts.app
      flash={@flash}
      mode={@mode}
      theme={@theme}
      path={@path}
    >
      <.demo_page
        id="date-picker-patterns-page"
        title={~t"Date Picker · Pattern"}
        subtitle={~t"Controlled value with LiveView as source of truth."}
      >
        <.demo_section
          id="date-picker-patterns-controlled-section"
          title={~t"Controlled (value)"}
          code_tabs={@code_tabs}
        >
          <:preview>
            <div class="flex flex-col gap-3 items-start w-full max-w-md">
              <p class="text-sm text-fg-subtle" id="date-picker-patterns-status">
                Selected: <span class="font-medium text-fg">{@selected || " - "}</span>
              </p>
              <.date_picker
                id="date-picker-patterns-controlled"
                class="date-picker"
                controlled
                value={@selected && [@selected]}
                on_value_change="pattern_date_changed"
                translation={
                  %Corex.DatePicker.Translation{
                    open_calendar: "Select date",
                    close_calendar: "Select date",
                    input: "Select date"
                  }
                }
              >
                <:label>Date</:label>
                <:trigger><.heroicon name="hero-calendar" class="icon" /></:trigger>
                <:prev_trigger><.heroicon name="hero-chevron-left" class="icon" /></:prev_trigger>
                <:next_trigger><.heroicon name="hero-chevron-right" class="icon" /></:next_trigger>
              </.date_picker>
            </div>
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
