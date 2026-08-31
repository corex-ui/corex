defmodule E2eWeb.PresenceApiLive do
  use E2eWeb, :live_view
  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  @impl true
  def mount(_params, _session, socket), do: {:ok, socket}

  @impl true
  def handle_event("presence_api_show", _params, socket) do
    {:noreply, Corex.Presence.set_present(socket, "presence-api-srv", true)}
  end

  @impl true
  def handle_event("presence_api_hide", _params, socket) do
    {:noreply, Corex.Presence.set_present(socket, "presence-api-srv", false)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} mode={@mode} theme={@theme} path={@path}>
      <.demo_page path={@path} id="presence-api-page" title="Presence · API" subtitle="Toggle present from client bindings, client JS, or a server event. The trigger is outside the wrapper.">
        <.demo_section id="presence-api-client-binding" title="Set present (Client binding)">
          <:preview>
            <div class="flex flex-col gap-space items-center">
              <div class="flex gap-space-sm">
                <.action phx-click={Corex.Presence.set_present("presence-api-cb", true)} class="button ui-size-sm">Show</.action>
                <.action phx-click={Corex.Presence.set_present("presence-api-cb", false)} class="button ui-size-sm">Hide</.action>
              </div>
              <.presence id="presence-api-cb" class="presence">Bound panel</.presence>
            </div>
          </:preview>
        </.demo_section>
        <.demo_section id="presence-api-client-js" title="Set present (Client JS)">
          <:preview>
            <div class="flex flex-col gap-space items-center">
              <button type="button" class="button ui-size-sm" onclick="document.getElementById('presence-api-cjs')?.dispatchEvent(new CustomEvent('corex:presence:set-present', {bubbles: false, detail: { present: true }}))">Show</button>
              <.presence id="presence-api-cjs" class="presence">JS panel</.presence>
            </div>
          </:preview>
        </.demo_section>
        <.demo_section id="presence-api-server" title="Set present (Server)">
          <:preview>
            <div class="flex flex-col gap-space items-center">
              <div class="flex gap-space-sm">
                <.action phx-click="presence_api_show" class="button ui-size-sm">Show</.action>
                <.action phx-click="presence_api_hide" class="button ui-size-sm">Hide</.action>
              </div>
              <.presence id="presence-api-srv" class="presence">Server panel</.presence>
            </div>
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
