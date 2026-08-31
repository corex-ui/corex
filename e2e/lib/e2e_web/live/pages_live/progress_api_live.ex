defmodule E2eWeb.ProgressApiLive do
  use E2eWeb, :live_view
  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  @impl true
  def mount(_params, _session, socket), do: {:ok, socket}

  @impl true
  def handle_event("progress_api_set", %{"value" => value}, socket) do
    {n, _} = Integer.parse(to_string(value))
    {:noreply, Corex.Progress.set_value(socket, "progress-api-srv", n)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} mode={@mode} theme={@theme} path={@path}>
      <.demo_page
        path={@path}
        id="progress-api-page"
        title="Progress · API"
        subtitle="Set value from client bindings, client JS, or a server event."
      >
        <.demo_section id="progress-api-set-value-binding" title="Set value (Client binding)">
          <:preview>
            <div class="flex flex-col gap-space w-full max-w-sm">
              <.action
                phx-click={Corex.Progress.set_value("progress-api-cb", 80)}
                class="button ui-size-sm"
              >
                Set 80
              </.action>
              <.progress id="progress-api-cb" class="progress" value={20} />
            </div>
          </:preview>
        </.demo_section>
        <.demo_section id="progress-api-set-value-js" title="Set value (Client JS)">
          <:preview>
            <div class="flex flex-col gap-space w-full max-w-sm">
              <button
                type="button"
                class="button ui-size-sm"
                onclick="document.getElementById('progress-api-cjs')?.dispatchEvent(new CustomEvent('corex:progress:set-value', {bubbles: false, detail: { value: 55 }}))"
              >Set 55</button>
              <.progress id="progress-api-cjs" class="progress" value={20} />
            </div>
          </:preview>
        </.demo_section>
        <.demo_section id="progress-api-set-value-server" title="Set value (Server)">
          <:preview>
            <div class="flex flex-col gap-space w-full max-w-sm">
              <.action phx-click="progress_api_set" phx-value-value="90" class="button ui-size-sm">
                Set 90
              </.action>
              <.progress id="progress-api-srv" class="progress" value={20} />
            </div>
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
