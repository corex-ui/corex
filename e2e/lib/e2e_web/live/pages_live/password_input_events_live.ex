defmodule E2eWeb.PasswordInputEventsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  @server_heex E2eWeb.Demos.PasswordInputDemo.events_server_heex()
  @server_elixir E2eWeb.Demos.PasswordInputDemo.events_server_elixir()
  @client_heex E2eWeb.Demos.PasswordInputDemo.events_client_heex()
  @client_js E2eWeb.Demos.PasswordInputDemo.events_client_js()
  @client_ts E2eWeb.Demos.PasswordInputDemo.events_client_ts()

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:server_heex, @server_heex)
      |> assign(:server_elixir, @server_elixir)
      |> assign(:client_heex, @client_heex)
      |> assign(:client_js, @client_js)
      |> assign(:client_ts, @client_ts)
      |> stream(:server_logs, [])
      |> stream(:client_logs, [])

    {:ok, socket}
  end

  def handle_event("password_visibility_changed", %{"id" => id, "visible" => visible}, socket) do
    log = new_log("server", id, inspect(visible))
    {:noreply, stream_insert(socket, :server_logs, log, at: 0)}
  end

  def handle_event(
        "password_visibility_client_changed",
        %{"id" => id, "visible" => visible},
        socket
      ) do
    log = new_log("client", id, inspect(visible))
    {:noreply, stream_insert(socket, :client_logs, log, at: 0)}
  end

  defp new_log(source, dom_id, value) do
    %{
      id: "#{System.unique_integer([:positive])}",
      time:
        DateTime.utc_now()
        |> DateTime.truncate(:second)
        |> Calendar.strftime("%H:%M:%S"),
      source: source,
      dom_id: dom_id,
      value: value
    }
  end

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
        id="password-input-events-page"
        title={~t"Password Input · Event"}
        subtitle={~t"Subscribe to visibility changes from LiveView or the client."}
      >
        <.demo_section
          id="password-input-events-server-section"
          title={~t"On Visibility Change (Server)"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @server_heex},
            %{value: "elixir", label: ~t"Elixir", language: :elixir, code: @server_elixir}
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-4 items-center w-full">
              <.password_input
                id="password-input-events-server"
                name="user[password]"
                on_visibility_change="password_visibility_changed"
              >
                <:label>Password</:label>
                <:visible_indicator><.heroicon name="hero-eye" /></:visible_indicator>
                <:hidden_indicator>
                  <.heroicon name="hero-eye-slash" />
                </:hidden_indicator>
              </.password_input>

              <.data_table
                id="password-input-events-log-server"
                class="data-table data-table--max-w-3xl"
                rows={@streams.server_logs}
              >
                <:col :let={{_dom_id, row}} label="Time">{row.time}</:col>
                <:col :let={{_dom_id, row}} label="Source">{row.source}</:col>
                <:col :let={{_dom_id, row}} label="Value">{row.value}</:col>
                <:empty>
                  <p>No event yet. Interact with the components to receive new events</p>
                </:empty>
              </.data_table>
            </div>
          </:preview>
        </.demo_section>

        <.demo_section
          id="password-input-events-client-section"
          title={~t"On Visibility Change (Client)"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @client_heex},
            %{value: "js", label: ~t"JS", language: :js, code: @client_js},
            %{value: "ts", label: ~t"TS", language: :javascript, code: @client_ts}
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-4 items-center w-full">
              <.password_input
                id="password-input-events-client"
                name="user[password]"
                on_visibility_change_client="password-visibility-changed"
              >
                <:label>Password</:label>
                <:visible_indicator><.heroicon name="hero-eye" /></:visible_indicator>
                <:hidden_indicator>
                  <.heroicon name="hero-eye-slash" />
                </:hidden_indicator>
              </.password_input>

              <div
                id="password-input-events-client-listener"
                class="w-full"
                phx-hook=".PasswordInputEventsClient"
                phx-update="ignore"
              >
                <script :type={Phoenix.LiveView.ColocatedHook} name=".PasswordInputEventsClient">
                  export default {
                    mounted() {
                      const el = document.getElementById("password-input-events-client");
                      if(!el) return;
                      el.addEventListener("password-visibility-changed", (event) => {
                        const d = event.detail ?? {};
                        const visible = d.visible === true;
                        this.pushEvent("password_visibility_client_changed", {
                          id: d.id,
                          visible,
                        });
                      });
                    }
                  }
                </script>
              </div>

              <.data_table
                id="password-input-events-log-client"
                class="data-table data-table--max-w-3xl"
                rows={@streams.client_logs}
              >
                <:col :let={{_dom_id, row}} label="Time">{row.time}</:col>
                <:col :let={{_dom_id, row}} label="Source">{row.source}</:col>
                <:col :let={{_dom_id, row}} label="Value">{row.value}</:col>
                <:empty>
                  <p>No event yet. Interact with the components to receive new events</p>
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
