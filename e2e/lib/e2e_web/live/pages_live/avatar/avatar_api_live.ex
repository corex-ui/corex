defmodule E2eWeb.AvatarApiLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias E2eWeb.Demos.AvatarDemo, as: Demo

  @id_sv_client "api-set-src-client"
  @id_sv_js "api-set-src-client-js"
  @id_sv_server "api-set-src-server"
  @id_loaded_js "api-loaded-js"
  @id_loaded_server "api-loaded-server"

  @primary_src "https://corex-ui.com/images/avatar.png"
  @alt_src "https://corex-ui.com/pwa-192x192.png"

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:id_sv_client, @id_sv_client)
     |> assign(:id_sv_js, @id_sv_js)
     |> assign(:id_sv_server, @id_sv_server)
     |> assign(:id_loaded_js, @id_loaded_js)
     |> assign(:id_loaded_server, @id_loaded_server)
     |> assign(:primary_src, @primary_src)
     |> assign(:alt_src, @alt_src)
     |> assign(:codes, Demo.api_codes())}
  end

  def handle_event("api_set_src_server", %{"url" => url}, socket) do
    {:noreply, Corex.Avatar.set_src(socket, @id_sv_server, url)}
  end

  def handle_event("api_loaded_server", _params, socket) do
    {:noreply, Corex.Avatar.loaded(socket, @id_loaded_server, respond_to: :server)}
  end

  def handle_event("avatar_loaded_response", %{"id" => id, "loaded" => loaded}, socket) do
    desc = "#{id}\n#{inspect(loaded)}"

    {:noreply,
     Corex.Toast.create(socket, "layout-toast", "avatar_loaded_response", desc, :info,
       duration: 5000
     )}
  end

  def handle_event("avatar_loaded_dom", %{"id" => id, "loaded" => loaded}, socket) do
    desc = "avatar-loaded (client)\n#{id}\n#{inspect(loaded)}"

    {:noreply,
     Corex.Toast.create(socket, "layout-toast", "avatar_loaded_dom", desc, :info, duration: 5000)}
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
        id="avatar-api-page"
        title={~t"Avatar · API"}
        subtitle={~t"Set the image URL or query load state from LiveView or the client."}
      >
        <.demo_section
          id="avatar-api-set-src-binding"
          title={~t"Set Src (Client Binding)"}
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
          title={~t"Set Src (Client JS)"}
          code_tabs={[
            %{
              value: "heex",
              label: ~t"Heex",
              language: :heex,
              code: @codes.set_src_js_heex
            },
            %{
              value: "js",
              label: ~t"JS",
              language: :js,
              code: @codes.set_src_js
            },
            %{
              value: "ts",
              label: ~t"TS",
              language: :javascript,
              code: @codes.set_src_js_ts
            }
          ]}
        >
          <:preview>
            <Demo.api_set_src_client_js_example id={@id_sv_js} />
          </:preview>
        </.demo_section>

        <.demo_section
          id="avatar-api-set-src-server"
          title={~t"Set Src (Server)"}
          code_tabs={[
            %{
              value: "heex",
              label: ~t"Heex",
              language: :heex,
              code: @codes.set_src_server_heex
            },
            %{
              value: "elixir",
              label: ~t"Elixir",
              language: :elixir,
              code: @codes.set_src_server_elixir
            }
          ]}
        >
          <:preview>
            <Demo.api_set_src_server_example
              id={@id_sv_server}
              event="api_set_src_server"
            />
          </:preview>
        </.demo_section>

        <div
          id="avatar-api-loaded-wrap"
          phx-hook=".AvatarApiLoadedDomToast"
          class="flex flex-col gap-4 w-full"
        >
          <.demo_section
            id="avatar-api-loaded-binding"
            title={~t"Loaded (Client Binding)"}
            code={@codes.loaded_binding}
          >
            <:preview><Demo.api_loaded_client_binding_example /></:preview>
          </.demo_section>

          <.demo_section
            id="avatar-api-loaded-js"
            title={~t"Loaded (Client JS)"}
            code_tabs={[
              %{
                value: "heex",
                label: ~t"Heex",
                language: :heex,
                code: @codes.loaded_js_heex
              },
              %{
                value: "js",
                label: ~t"JS",
                language: :js,
                code: @codes.loaded_js
              },
              %{
                value: "ts",
                label: ~t"TS",
                language: :javascript,
                code: @codes.loaded_js_ts
              }
            ]}
          >
            <:preview>
              <Demo.api_loaded_client_js_example id={@id_loaded_js} />
            </:preview>
          </.demo_section>

          <.demo_section
            id="avatar-api-loaded-server"
            title={~t"Loaded (Server)"}
            code_tabs={[
              %{
                value: "heex",
                label: ~t"Heex",
                language: :heex,
                code: @codes.loaded_server_heex
              },
              %{
                value: "elixir",
                label: ~t"Elixir",
                language: :elixir,
                code: @codes.loaded_server_elixir
              }
            ]}
          >
            <:preview>
              <Demo.api_loaded_server_example
                id={@id_loaded_server}
                event_loaded="api_loaded_server"
              />
            </:preview>
          </.demo_section>
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
      </.demo_page>
    </Layouts.app>
    """
  end
end
