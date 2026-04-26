defmodule E2eWeb.ListboxApiLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias E2eWeb.Demos.ListboxDemo, as: Demo
  alias Phoenix.LiveView.JS

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:codes, demo_codes())

    {:ok, socket}
  end

  defp demo_codes do
    %{
      set_value_binding: Demo.api_set_value_client_binding_code(),
      set_value_server_heex: Demo.api_set_value_server_heex(),
      set_value_server_elixir: Demo.api_set_value_server_elixir(),
      set_value_js: Demo.api_set_value_client_js(),
      value_binding: Demo.api_value_client_binding_code(),
      value_server_heex: Demo.api_value_server_heex(),
      value_server_elixir: Demo.api_value_server_elixir()
    }
  end

  def handle_event("listbox_api_set_value", _params, socket) do
    {:noreply, Corex.Listbox.set_value(socket, "listbox-api-sv-server", ["bel"])}
  end

  def handle_event("listbox_api_value_server", _params, socket) do
    {:noreply, Corex.Listbox.value(socket, "listbox-api-val-server")}
  end

  def handle_event("listbox_value_response", %{"id" => id, "value" => value}, socket) do
    desc = "#{id}\n#{inspect(value)}"

    {:noreply,
     Corex.Toast.push_toast(socket, "layout-toast", "listbox_value_response", desc, :info, 5000)}
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
        id="listbox-api-page"
        title="Listbox · API"
        subtitle="Programmatic selection and reading the current value from LiveView or the client."
      >
        <.demo_section
          id="listbox-api-set-value-binding"
          title="set_value (Phoenix binding)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @codes.set_value_binding}
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-3 w-full max-w-md">
              <div class="flex flex-wrap gap-2 items-center">
                <.action
                  phx-click={Corex.Listbox.set_value("listbox-api-sv-client", ["bel"])}
                  class="button button--sm"
                >
                  Belgium
                </.action>
                <.action
                  phx-click={Corex.Listbox.set_value("listbox-api-sv-client", [])}
                  class="button button--sm"
                >
                  Clear
                </.action>
              </div>
              <.listbox id="listbox-api-sv-client" class="listbox" items={Demo.items_minimal()}>
                <:label>Choose a country</:label>
                <:item_indicator><.heroicon name="hero-check" /></:item_indicator>
              </.listbox>
            </div>
          </:preview>
        </.demo_section>

        <.demo_section
          id="listbox-api-set-value-server"
          title="set_value (push_event from LiveView)"
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
            <div class="flex flex-col gap-3 w-full max-w-md">
              <div class="flex flex-wrap gap-2 items-center">
                <.action phx-click="listbox_api_set_value" class="button button--sm">Belgium</.action>
              </div>
              <.listbox id="listbox-api-sv-server" class="listbox" items={Demo.items_minimal()}>
                <:label>Choose a country</:label>
                <:item_indicator><.heroicon name="hero-check" /></:item_indicator>
              </.listbox>
            </div>
          </:preview>
        </.demo_section>

        <.demo_section
          id="listbox-api-set-value-js"
          title="set_value (CustomEvent from JavaScript)"
          code_tabs={[
            %{value: "js", label: "JS", language: :js, code: @codes.set_value_js}
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-3 w-full max-w-md">
              <.action
                type="button"
                class="button button--sm"
                phx-click={
                  JS.dispatch("corex:listbox:set-value",
                    to: "#listbox-api-sv-js",
                    detail: %{value: ["deu"]},
                    bubbles: false
                  )
                }
              >
                Germany (JS.dispatch)
              </.action>
              <.listbox id="listbox-api-sv-js" class="listbox" items={Demo.items_minimal()}>
                <:label>Choose a country</:label>
                <:item_indicator><.heroicon name="hero-check" /></:item_indicator>
              </.listbox>
            </div>
          </:preview>
        </.demo_section>

        <.demo_section
          id="listbox-api-value-binding"
          title="value (Phoenix binding)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @codes.value_binding}
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-3 w-full max-w-md">
              <.action
                phx-click={Corex.Listbox.value("listbox-api-val-client")}
                class="button button--sm"
              >
                Read selection
              </.action>
              <.listbox id="listbox-api-val-client" class="listbox" items={Demo.items_minimal()}>
                <:label>Choose a country</:label>
                <:item_indicator><.heroicon name="hero-check" /></:item_indicator>
              </.listbox>
            </div>
          </:preview>
        </.demo_section>

        <.demo_section
          id="listbox-api-value-server"
          title="value (push_event from LiveView)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @codes.value_server_heex},
            %{
              value: "elixir",
              label: "Elixir",
              language: :elixir,
              code: @codes.value_server_elixir
            }
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-3 w-full max-w-md">
              <.action phx-click="listbox_api_value_server" class="button button--sm">
                Read selection
              </.action>
              <.listbox id="listbox-api-val-server" class="listbox" items={Demo.items_minimal()}>
                <:label>Choose a country</:label>
                <:item_indicator><.heroicon name="hero-check" /></:item_indicator>
              </.listbox>
            </div>
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
