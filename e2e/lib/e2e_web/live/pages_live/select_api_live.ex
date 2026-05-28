defmodule E2eWeb.SelectApiLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias E2eWeb.Demos.SelectDemo, as: Demo
  alias Phoenix.LiveView.JS

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :codes, demo_codes())}
  end

  defp demo_codes do
    %{
      set_value_binding: Demo.api_set_value_client_binding_code(),
      set_value_server_heex: Demo.api_set_value_server_heex(),
      set_value_server_elixir: Demo.api_set_value_server_elixir(),
      set_value_js: Demo.api_set_value_client_js()
    }
  end

  def handle_event("select_api_set_value", _params, socket) do
    {:noreply, Corex.Select.set_value(socket, "select-api-srv", ["fra"])}
  end

  def handle_event("select_api_clear", _params, socket) do
    {:noreply, Corex.Select.set_value(socket, "select-api-srv", [])}
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
        id="select-api-page"
        title={~t"Select · API"}
        subtitle={~t"Programmatic selection from LiveView or the client."}
      >
        <.demo_section
          id="select-api-set-value-client-binding"
          title={~t"Set Value (Client Binding)"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @codes.set_value_binding}
          ]}
        >
          <:preview>
            <div class="flex flex-wrap gap-2 items-center w-full justify-center">
              <.action
                phx-click={Corex.Select.set_value("select-api-cb", ["fra"])}
                class="button button--sm"
              >
                France
              </.action>
              <.action
                phx-click={Corex.Select.set_value("select-api-cb", [])}
                class="button button--sm"
              >
                Clear
              </.action>
            </div>
            <.select
              id="select-api-cb"
              class="select select--accent"
              items={Corex.List.new(Demo.items_minimal())}
              translation={%Corex.Select.Translation{placeholder: ~t"Select"}}
            >
              <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
            </.select>
          </:preview>
        </.demo_section>

        <.demo_section
          id="select-api-set-value-server"
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
              <.action phx-click="select_api_set_value" class="button button--sm">
                France
              </.action>
              <.action phx-click="select_api_clear" class="button button--sm">
                Clear
              </.action>
            </div>
            <.select
              id="select-api-srv"
              class="select select--accent"
              items={Corex.List.new(Demo.items_minimal())}
              translation={%Corex.Select.Translation{placeholder: ~t"Select"}}
            >
              <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
            </.select>
          </:preview>
        </.demo_section>

        <.demo_section
          id="select-api-set-value-client-js"
          title={~t"Set Value (Client JS)"}
          code_tabs={[
            %{value: "js", label: ~t"JS", language: :js, code: @codes.set_value_js}
          ]}
        >
          <:preview>
            <div class="flex flex-wrap gap-2 items-center w-full justify-center">
              <.action
                type="button"
                class="button button--sm"
                phx-click={
                  JS.dispatch("corex:select:set-value",
                    to: "#select-api-cjs",
                    detail: %{value: ["fra"]},
                    bubbles: false
                  )
                }
              >
                France
              </.action>
              <.action
                type="button"
                class="button button--sm"
                phx-click={
                  JS.dispatch("corex:select:set-value",
                    to: "#select-api-cjs",
                    detail: %{value: []},
                    bubbles: false
                  )
                }
              >
                Clear
              </.action>
            </div>
            <.select
              id="select-api-cjs"
              class="select select--accent"
              items={Corex.List.new(Demo.items_minimal())}
              translation={%Corex.Select.Translation{placeholder: ~t"Select"}}
            >
              <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
            </.select>
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
