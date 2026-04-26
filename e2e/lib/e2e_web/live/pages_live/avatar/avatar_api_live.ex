defmodule E2eWeb.AvatarApiLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  @id_sv_client "api-set-src-client"
  @id_sv_js "api-set-src-client-js"
  @id_sv_server "api-set-src-server"
  @id_loaded_server "api-loaded-server"

  @primary_src "https://corex-ui.com/images/avatar.png"
  @alt_src "https://corex-ui.com/pwa-192x192.png"

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:id_sv_client, @id_sv_client)
      |> assign(:id_sv_js, @id_sv_js)
      |> assign(:id_sv_server, @id_sv_server)
      |> assign(:id_loaded_server, @id_loaded_server)
      |> assign(:primary_src, @primary_src)
      |> assign(:alt_src, @alt_src)
      |> assign(:codes, demo_codes())

    {:ok, socket}
  end

  defp demo_codes do
    m = E2eWeb.Demos.AvatarDemo

    %{
      set_src_binding: m.api_set_src_client_binding_code(),
      set_src_js_heex: m.api_set_src_client_js_heex(),
      set_src_js: m.api_set_src_client_js_js(),
      set_src_js_ts: m.api_set_src_client_js_ts(),
      set_src_server_heex: m.api_set_src_server_heex(),
      set_src_server_elixir: m.api_set_src_server_elixir(),
      loaded_server_heex: m.api_loaded_server_heex(),
      loaded_server_elixir: m.api_loaded_server_elixir()
    }
  end

  def handle_event("api_set_src_server", %{"url" => url}, socket) do
    {:noreply, Corex.Avatar.set_src(socket, @id_sv_server, url)}
  end

  def handle_event("api_loaded_server", _params, socket) do
    {:noreply, Corex.Avatar.loaded(socket, @id_loaded_server)}
  end

  def handle_event("api_loaded_server_client_only", _params, socket) do
    {:noreply, Corex.Avatar.loaded(socket, @id_loaded_server, respond_to: :client)}
  end

  def handle_event("avatar_loaded_response", %{"id" => id, "loaded" => loaded}, socket)
      when id == @id_loaded_server do
    desc = "#{id}\n#{inspect(loaded)}"

    {:noreply,
     Corex.Toast.push_toast(socket, "layout-toast", "avatar_loaded_response", desc, :info, 5000)}
  end

  def handle_event("avatar_loaded_dom", %{"id" => id, "loaded" => loaded}, socket) do
    desc = "avatar-loaded (client)\n#{id}\n#{inspect(loaded)}"

    {:noreply,
     Corex.Toast.push_toast(socket, "layout-toast", "avatar_loaded_dom", desc, :info, 5000)}
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
        id="avatar-api-page"
        title="Avatar · API"
        subtitle="Set the image URL or query load state from LiveView or the client."
      >
        <.demo_section
          id="avatar-api-set-src-binding"
          title="Set Src (Client Binding)"
          code={@codes.set_src_binding}
        >
          <:preview>
            <div class="flex flex-wrap gap-2 mb-4">
              <.action
                phx-click={Corex.Avatar.set_src(@id_sv_client, @primary_src)}
                class="button button--sm"
              >
                Set primary
              </.action>
              <.action
                phx-click={Corex.Avatar.set_src(@id_sv_client, @alt_src)}
                class="button button--sm"
              >
                Set alternate
              </.action>
            </div>
            <.avatar id={@id_sv_client} class="avatar" src={@primary_src} alt="API demo">
              <:fallback>?</:fallback>
            </.avatar>
          </:preview>
        </.demo_section>

        <.demo_section
          id="avatar-api-set-src-js"
          title="Set Src (Client JS)"
          code_tabs={[
            %{
              value: "heex",
              label: "Heex",
              language: :heex,
              code: @codes.set_src_js_heex
            },
            %{
              value: "js",
              label: "JS",
              language: :js,
              code: @codes.set_src_js
            },
            %{
              value: "ts",
              label: "TS",
              language: :javascript,
              code: @codes.set_src_js_ts
            }
          ]}
        >
          <:preview>
            <E2eWeb.Demos.AvatarDemo.api_set_src_client_js_example id={@id_sv_js} />
          </:preview>
        </.demo_section>

        <.demo_section
          id="avatar-api-set-src-server"
          title="Set Src (Server)"
          code_tabs={[
            %{
              value: "heex",
              label: "Heex",
              language: :heex,
              code: @codes.set_src_server_heex
            },
            %{
              value: "elixir",
              label: "Elixir",
              language: :elixir,
              code: @codes.set_src_server_elixir
            }
          ]}
        >
          <:preview>
            <E2eWeb.Demos.AvatarDemo.api_set_src_server_example
              id={@id_sv_server}
              event="api_set_src_server"
            />
          </:preview>
        </.demo_section>

        <.demo_section
          id="avatar-api-loaded-server"
          title="Loaded (Server)"
          code_tabs={[
            %{
              value: "heex",
              label: "Heex",
              language: :heex,
              code: @codes.loaded_server_heex
            },
            %{
              value: "elixir",
              label: "Elixir",
              language: :elixir,
              code: @codes.loaded_server_elixir
            }
          ]}
        >
          <:preview>
            <div
              id="avatar-api-loaded-dom-wrap"
              phx-hook=".AvatarApiLoadedDomToast"
              class="flex flex-col items-center"
            >
              <E2eWeb.Demos.AvatarDemo.api_loaded_server_example
                id={@id_loaded_server}
                event_loaded="api_loaded_server"
                event_loaded_client_only="api_loaded_server_client_only"
              />
            </div>
            <script :type={Phoenix.LiveView.ColocatedHook} name=".AvatarApiLoadedDomToast">
              export default {
                mounted() {
                  this.el.addEventListener("avatar-loaded", (event) => {
                    const d = event.detail || {};
                    this.pushEvent("avatar_loaded_dom", { id: d.id, loaded: d.loaded });
                  });
                }
              }
            </script>
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
