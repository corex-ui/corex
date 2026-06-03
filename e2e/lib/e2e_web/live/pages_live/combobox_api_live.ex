defmodule E2eWeb.ComboboxApiLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias E2eWeb.Demos.ComboboxDemo, as: Demo
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
      set_value_js: Demo.api_set_value_client_js()
    }
  end

  def handle_event("combobox_api_set_value", _params, socket) do
    {:noreply, Corex.Combobox.set_value(socket, "combobox-api-sv-server", ["bel"])}
  end

  def handle_event("combobox_api_clear", _params, socket) do
    {:noreply, Corex.Combobox.set_value(socket, "combobox-api-sv-server", [])}
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
        id="combobox-api-page"
        title={~t"Combobox · API"}
        subtitle={~t"Programmatic selection from LiveView or the client."}
      >
        <.demo_section
          id="combobox-api-set-value-binding"
          title={~t"Set Value (Client Binding)"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @codes.set_value_binding}
          ]}
        >
          <:preview>
            <div class="flex flex-wrap gap-2 items-center w-full justify-center">
              <.action
                phx-click={Corex.Combobox.set_value("combobox-api-sv-client", ["bel"])}
                size="sm"
              >
                Belgium
              </.action>
              <.action
                phx-click={Corex.Combobox.set_value("combobox-api-sv-client", [])}
                size="sm"
              >
                Clear
              </.action>
            </div>
            <.combobox
              id="combobox-api-sv-client"
              placeholder={~t"Select"}
              items={Corex.List.new(Demo.items_minimal())}
            >
              <:empty>No results</:empty>
              <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
            </.combobox>
          </:preview>
        </.demo_section>

        <.demo_section
          id="combobox-api-set-value-server"
          title={~t"Set Value (Server)"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @codes.set_value_server_heex},
            %{
              value: "elixir",
              label: ~t"Elixir",
              language: :elixir,
              code: @codes.set_value_server_elixir
            }
          ]}
        >
          <:preview>
            <div class="flex flex-wrap gap-2 items-center w-full justify-center">
              <.action phx-click="combobox_api_set_value" size="sm">Belgium</.action>
              <.action phx-click="combobox_api_clear" size="sm">Clear</.action>
            </div>
            <.combobox
              id="combobox-api-sv-server"
              placeholder={~t"Select"}
              items={Corex.List.new(Demo.items_minimal())}
            >
              <:empty>No results</:empty>
              <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
            </.combobox>
          </:preview>
        </.demo_section>

        <.demo_section
          id="combobox-api-set-value-js"
          title={~t"Set Value (Client JS)"}
          code_tabs={[
            %{value: "js", label: ~t"JS", language: :js, code: @codes.set_value_js}
          ]}
        >
          <:preview>
            <div class="flex flex-wrap gap-2 items-center w-full justify-center">
              <.action
                type="button"
                size="sm"
                phx-click={
                  JS.dispatch("corex:combobox:set-value",
                    to: "#combobox-api-sv-js",
                    detail: %{value: ["deu"]},
                    bubbles: false
                  )
                }
              >
                Germany
              </.action>
              <.action
                type="button"
                size="sm"
                phx-click={
                  JS.dispatch("corex:combobox:set-value",
                    to: "#combobox-api-sv-js",
                    detail: %{value: []},
                    bubbles: false
                  )
                }
              >
                Clear
              </.action>
            </div>
            <.combobox
              id="combobox-api-sv-js"
              placeholder={~t"Select"}
              items={Corex.List.new(Demo.items_minimal())}
            >
              <:empty>No results</:empty>
              <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
            </.combobox>
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
