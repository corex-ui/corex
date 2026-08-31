defmodule E2eWeb.DateInputApiLive do
  use E2eWeb, :live_view
  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias E2eWeb.Demos.DateInputDemo, as: Demo

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :codes, Demo.api_codes())}
  end

  @impl true
  def handle_event("date_input_api_set", _params, socket) do
    {:noreply, Corex.DateInput.set_value(socket, "date-input-api-srv", "2026-12-25")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} mode={@mode} theme={@theme} path={@path}>
      <.demo_page path={@path} id="date-input-api-page" title="Date input · API" subtitle="Set value from client bindings, client JS, or a server event.">
        <.demo_section id="date-input-api-set-value-binding" title="Set value (Client binding)" code={@codes.set_value_client_binding}>
          <:preview>
            <div class="flex flex-col gap-space items-center">
              <.action phx-click={Corex.DateInput.set_value("date-input-api-cb", "2026-08-31")} class="button ui-size-sm">Set date</.action>
              <.date_input id="date-input-api-cb" class="date-input" />
            </div>
          </:preview>
        </.demo_section>
        <.demo_section
          id="date-input-api-set-value-js"
          title="Set value (Client JS)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @codes.set_value_client_js_heex},
            %{value: "js", label: "JS", language: :js, code: @codes.set_value_client_js},
            %{value: "ts", label: "TS", language: :javascript, code: @codes.set_value_client_ts}
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-space items-center">
              <button type="button" class="button ui-size-sm" onclick="document.getElementById('date-input-api-cjs')?.dispatchEvent(new CustomEvent('corex:date-input:set-value', {bubbles: false, detail: { value: '2026-01-15' }}))">Set date</button>
              <.date_input id="date-input-api-cjs" class="date-input" />
            </div>
          </:preview>
        </.demo_section>
        <.demo_section
          id="date-input-api-set-value-server"
          title="Set value (Server)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @codes.set_value_server_heex},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @codes.set_value_server_elixir}
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-space items-center">
              <.action phx-click="date_input_api_set" class="button ui-size-sm">Set date</.action>
              <.date_input id="date-input-api-srv" class="date-input" />
            </div>
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
