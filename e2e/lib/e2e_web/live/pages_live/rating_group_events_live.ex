defmodule E2eWeb.RatingGroupEventsLive do
  use E2eWeb, :live_view
  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  @code_heex ~S"""
  <.rating_group class="rating-group" on_value_change="rating_group_changed" on_value_change_client="rating-group-changed" />
  """
  @code_elixir ~S"""
  def handle_event("rating_group_changed", payload, socket) do
    {:noreply, socket}
  end
  """
  @code_js ~S"""
  const el = document.getElementById("rating-group-events");
  el?.addEventListener("rating-group-changed", (event) => {
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
  def handle_event("rating_group_changed", payload, socket) do
    {:noreply,
     stream_insert(socket, :logs, log("changed", payload["id"], inspect(payload)), at: 0)}
  end

  @impl true
  def handle_event("rating_group_client_changed", payload, socket) do
    {:noreply,
     stream_insert(socket, :logs, log("client_changed", payload["id"], inspect(payload)), at: 0)}
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
        id="rating-group-events-page"
        title="Rating group · Events"
        subtitle="Value change events (server + client)."
      >
        <.demo_section
          id="rating-group-events-section"
          title="On value change (Server and client)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @code_heex},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @code_elixir},
            %{value: "js", label: "JS", language: :js, code: @code_js}
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-space-lg items-center w-full">
              <.rating_group
                id="rating-group-events"
                class="rating-group"
                on_value_change="rating_group_changed"
                on_value_change_client="rating-group-changed"
              />
              <script :type={Phoenix.LiveView.ColocatedHook} name=".RatingGroupEventsClient">
                export default {
                  mounted() {
                    const el = document.getElementById("rating-group-events");
                    if(!el) return;
                    el.addEventListener("rating-group-changed", (event) => {
                      this.pushEvent("rating_group_client_changed", event.detail ?? {});
                    });
                  }
                }
              </script>
              <.data_table
                id="rating-group-events-log"
                class="data-table max-w-3xl"
                rows={@streams.logs}
              >
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
