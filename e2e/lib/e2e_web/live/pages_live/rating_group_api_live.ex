defmodule E2eWeb.RatingGroupApiLive do
  use E2eWeb, :live_view
  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias E2eWeb.Demos.RatingGroupDemo, as: Demo

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :codes, Demo.api_codes())}
  end

  @impl true
  def handle_event("rating_group_api_set", _params, socket) do
    {:noreply, Corex.RatingGroup.set_value(socket, "rating-group-api-srv", 5)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} mode={@mode} theme={@theme} path={@path}>
      <.demo_page
        path={@path}
        id="rating-group-api-page"
        title="Rating group · API"
        subtitle="Set value from client bindings, client JS, or a server event."
      >
        <.demo_section
          id="rating-group-api-set-value-binding"
          title="Set value (Client binding)"
          code={@codes.set_value_client_binding}
        >
          <:preview>
            <div class="flex flex-col gap-space items-center">
              <.action
                phx-click={Corex.RatingGroup.set_value("rating-group-api-cb", 4)}
                class="button ui-size-sm"
              >
                Set 4
              </.action>
              <.rating_group id="rating-group-api-cb" class="rating-group" />
            </div>
          </:preview>
        </.demo_section>
        <.demo_section
          id="rating-group-api-set-value-js"
          title="Set value (Client JS)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @codes.set_value_client_js_heex},
            %{value: "js", label: "JS", language: :js, code: @codes.set_value_client_js},
            %{value: "ts", label: "TS", language: :javascript, code: @codes.set_value_client_ts}
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-space items-center">
              <button
                type="button"
                class="button ui-size-sm"
                onclick="document.getElementById('rating-group-api-cjs')?.dispatchEvent(new CustomEvent('corex:rating-group:set-value', {bubbles: false, detail: { value: 3 }}))"
              >Set 3</button>
              <.rating_group id="rating-group-api-cjs" class="rating-group" />
            </div>
          </:preview>
        </.demo_section>
        <.demo_section
          id="rating-group-api-set-value-server"
          title="Set value (Server)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @codes.set_value_server_heex},
            %{
              value: "elixir",
              label: "Elixir",
              language: :elixir,
              code: @codes.set_value_server_elixir
            }
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-space items-center">
              <.action phx-click="rating_group_api_set" class="button ui-size-sm">Set 5</.action>
              <.rating_group id="rating-group-api-srv" class="rating-group" />
            </div>
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
