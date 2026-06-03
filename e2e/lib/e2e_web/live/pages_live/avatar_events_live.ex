defmodule E2eWeb.AvatarEventsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  @default_avatar_src "https://corex-ui.com/images/avatar.png"

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:avatar_src, @default_avatar_src)
     |> stream(:logs, [])}
  end

  @impl true
  def handle_event("avatar_events_changed", params, socket) do
    src = string_param(params, "avatar_src", socket.assigns.avatar_src)

    {:noreply, assign(socket, :avatar_src, src)}
  end

  @impl true
  def handle_event("avatar_status_changed", %{"status" => status, "id" => id}, socket) do
    {:noreply, stream_insert(socket, :logs, new_log("status_changed", id, status), at: 0)}
  end

  @impl true
  def handle_event("avatar_status_client_changed", %{"id" => id, "status" => status}, socket) do
    {:noreply, stream_insert(socket, :logs, new_log("status_client_changed", id, status), at: 0)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app
      flash={@flash}
      mode={@mode}
      theme={@theme}
      path={@path}
    >
      <.demo_page
        path={@path}
        id="avatar-events-page"
        title="Avatar · Event"
        subtitle="Status change events from the avatar hook."
      >
        <.demo_section
          id="avatar-events-section"
          title="Status change"
          code={E2eWeb.Demos.AvatarDemo.events_server_heex()}
        >
          <:preview>
            <div class="flex flex-col gap-4 items-center w-full max-w-3xl mx-auto">
              <form
                phx-change="avatar_events_changed"
                id="avatar-events-form"
                class="flex flex-col gap-4 w-full"
              >
                <.native_input
                  type="url"
                  id="avatar-events-src"
                  name="avatar_src"
                  value={@avatar_src}
                  class="native-input native-input--sm w-full"
                >
                  <:label>Image URL</:label>
                </.native_input>
              </form>

              <.avatar
                id="avatar-events"
                src={@avatar_src}
                alt="Avatar"
                on_status_change="avatar_status_changed"
                on_status_change_client="avatar-status-changed"
              >
                <:fallback>JD</:fallback>
              </.avatar>

              <script :type={Phoenix.LiveView.ColocatedHook} name=".AvatarEventsClient">
                export default {
                  mounted() {
                    const el = document.getElementById("avatar-events");
                    if(!el) return;
                    el.addEventListener("avatar-status-changed", (event) => {
                      const d = event.detail;
                      const status = d && typeof d.status === "string" ? d.status : null;
                      const id = d && typeof d.id === "string" ? d.id : "avatar-events";
                      this.pushEvent("avatar_status_client_changed", { id, status });
                    });
                  }
                }
              </script>

              <.data_table
                id="avatar-events-log"
                class="data-table data-table--max-w-3xl"
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

  defp string_param(params, key, default) do
    case Map.get(params, key) do
      v when is_binary(v) -> v
      _ -> default
    end
  end

  defp new_log(event, dom_id, value) do
    %{
      id: "#{System.unique_integer([:positive])}",
      time:
        DateTime.utc_now()
        |> DateTime.truncate(:second)
        |> Calendar.strftime("%H:%M:%S"),
      event: event,
      dom_id: dom_id,
      value: value
    }
  end
end
