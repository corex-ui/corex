defmodule E2eWeb.DrawerEventsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  @code_heex ~S"""
  <.drawer class="drawer" on_open_change="drawer_open_changed" on_open_change_client="drawer-open-changed">
    <:trigger>Open</:trigger>
    <:content>Sheet content</:content>
  </.drawer>
  """
  @code_elixir ~S"""
  def handle_event("drawer_open_changed", %{"open" => open, "id" => id}, socket) do
    {:noreply, socket}
  end
  """
  @code_js ~S"""
  const el = document.getElementById("drawer-events");
  el?.addEventListener("drawer-open-changed", (event) => {
    console.log(event.detail);
  });
  """


  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:code_heex, @code_heex)
     |> assign(:code_elixir, @code_elixir)
     |> assign(:code_js, @code_js)
     |> stream(:logs, [])}
  end

  @impl true
  def handle_event("drawer_open_changed", %{"open" => open, "id" => id}, socket) do
    {:noreply, stream_insert(socket, :logs, log("open_changed", id, inspect(open)), at: 0)}
  end

  @impl true
  def handle_event("drawer_open_client_changed", %{"id" => id, "open" => open}, socket) do
    {:noreply, stream_insert(socket, :logs, log("open_client_changed", id, inspect(open)), at: 0)}
  end

  defp log(event, dom_id, value) do
    %{
      id: "#{System.unique_integer([:positive])}",
      time: DateTime.utc_now() |> DateTime.truncate(:second) |> Calendar.strftime("%H:%M:%S"),
      event: event,
      dom_id: dom_id,
      value: value
    }
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} mode={@mode} theme={@theme} path={@path}>
      <.demo_page
        path={@path}
        id="drawer-events-page"
        title="Drawer · Events"
        subtitle="Open change events (server + client)."
      >
        <.demo_section
          id="drawer-events-section"
          title="On open change (Server and client)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @code_heex},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @code_elixir},
            %{value: "js", label: "JS", language: :js, code: @code_js}
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-space-lg items-center w-full">
              <.drawer
                id="drawer-events"
                class="drawer"
                on_open_change="drawer_open_changed"
                on_open_change_client="drawer-open-changed"
              >
                <:trigger>Open</:trigger>
                <:content>Sheet content</:content>
              </.drawer>
              <script :type={Phoenix.LiveView.ColocatedHook} name=".DrawerEventsClient">
                export default {
                  mounted() {
                    const el = document.getElementById("drawer-events");
                    if(!el) return;
                    el.addEventListener("drawer-open-changed", (event) => {
                      const d = event.detail;
                      this.pushEvent("drawer_open_client_changed", { id: d?.id ?? "drawer-events", open: d?.open ?? null });
                    });
                  }
                }
              </script>
              <.data_table id="drawer-events-log" class="data-table max-w-3xl" rows={@streams.logs}>
                <:col :let={{_dom_id, row}} label="Time">{row.time}</:col>
                <:col :let={{_dom_id, row}} label="Event">{row.event}</:col>
                <:col :let={{_dom_id, row}} label="Value">{row.value}</:col>
                <:empty>
                  <p>No event yet.</p>
                </:empty>
              </.data_table>
            </div>
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
