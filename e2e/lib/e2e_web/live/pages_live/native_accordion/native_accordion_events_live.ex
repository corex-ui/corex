defmodule E2eWeb.NativeAccordionEventsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias Corex.NativeAccordion
  alias E2eWeb.Demos.NativeAccordionDemo, as: Demo

  @id_server "events-on-value-change-server"

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:id_server, @id_server)
     |> assign(:open, ["lorem"])
     |> assign(:focused, "lorem")
     |> assign(:server_heex, Demo.events_server_heex())
     |> assign(:server_elixir, Demo.events_server_elixir())
     |> assign(:demo_items, Demo.events_items())
     |> stream(:server_logs, [])}
  end

  def handle_event("accordion_value_changed", params, socket) do
    log = new_log(params)

    {:noreply,
     socket
     |> NativeAccordion.handle_toggle(:open, params)
     |> stream_insert(:server_logs, log, at: 0)}
  end

  def handle_event("events_keydown", params, socket) do
    {:noreply, NativeAccordion.handle_keydown(socket, :focused, params)}
  end

  defp new_log(params) do
    %{
      id: "#{System.unique_integer([:positive])}",
      time:
        DateTime.utc_now()
        |> DateTime.truncate(:second)
        |> Calendar.strftime("%H:%M:%S"),
      source: "server",
      accordion_id: params["id"],
      value: inspect(params["item"] || params)
    }
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} mode={@mode} theme={@theme} path={@path}>
      <.demo_page
        path={@path}
        id="native-accordion-events-page"
        title={~t"Native Accordion · Event"}
        subtitle={~t"Subscribe to open value changes from LiveView (controlled)."}
      >
        <.demo_section
          id="native-accordion-events-server"
          title={~t"On Value Change (Server)"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @server_heex},
            %{value: "elixir", label: ~t"Elixir", language: :elixir, code: @server_elixir}
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-space-lg items-center w-full">
              <p class="text-sm opacity-80">Open: {inspect(@open)}</p>
              <.native_accordion
                id={@id_server}
                class="accordion"
                controlled
                value={@open}
                on_value_change="accordion_value_changed"
                on_keydown="events_keydown"
                focused_value={@focused}
                items={@demo_items}
              >
                <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
              </.native_accordion>

              <div class="w-full max-w-xl" data-part="log">
                <div :for={{dom_id, log} <- @streams.server_logs} id={dom_id} data-part="row">
                  <span class="font-mono text-xs">{log.time}</span>
                  <span class="text-sm"> item={log.value}</span>
                </div>
              </div>
            </div>
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
