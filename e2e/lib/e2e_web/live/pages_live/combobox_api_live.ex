defmodule E2eWeb.ComboboxApiLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias E2eWeb.Demos.ComboboxDemo, as: Demo
  alias Phoenix.LiveView.JS

  @id_overview "combobox-api-overview-field"

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:id_overview, @id_overview)
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

  def render(assigns) do
    ~H"""
    <Layouts.app
      flash={@flash}
      mode={@mode}
      theme={@theme}
      path={@path}
    >
      <.demo_page
        id="combobox-api-page"
        title="Combobox · API"
        subtitle="Programmatic selection via JS or LiveView."
      >
        <.demo_section
          id="combobox-api-overview-doc"
          title="Overview"
          code={Demo.api_overview_code()}
        >
          <:preview>
            <Demo.api_overview_example id={@id_overview} />
          </:preview>
        </.demo_section>

        <.demo_section
          id="combobox-api-set-value-binding"
          title="set_value (Phoenix binding)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @codes.set_value_binding}
          ]}
        >
          <:preview>
            <div class="flex flex-wrap gap-2 items-center w-full">
              <.action
                phx-click={Corex.Combobox.set_value("combobox-api-sv-client", ["bel"])}
                class="button button--sm"
              >
                Belgium
              </.action>
              <.action
                phx-click={Corex.Combobox.set_value("combobox-api-sv-client", [])}
                class="button button--sm"
              >
                Clear
              </.action>
            </div>
            <.combobox
              id="combobox-api-sv-client"
              class="combobox max-w-md"
              placeholder="Select"
              items={Corex.List.new(Demo.items_minimal())}
            >
              <:empty>No results</:empty>
              <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
            </.combobox>
          </:preview>
        </.demo_section>

        <.demo_section
          id="combobox-api-set-value-server"
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
            <div class="flex flex-wrap gap-2 items-center w-full">
              <.action phx-click="combobox_api_set_value" class="button button--sm">Belgium</.action>
            </div>
            <.combobox
              id="combobox-api-sv-server"
              class="combobox max-w-md"
              placeholder="Select"
              items={Corex.List.new(Demo.items_minimal())}
            >
              <:empty>No results</:empty>
              <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
            </.combobox>
          </:preview>
        </.demo_section>

        <.demo_section
          id="combobox-api-set-value-js"
          title="set_value (CustomEvent from JavaScript)"
          code_tabs={[
            %{value: "js", label: "JS", language: :js, code: @codes.set_value_js}
          ]}
        >
          <:preview>
            <.action
              type="button"
              class="button button--sm"
              phx-click={
                JS.dispatch("corex:combobox:set-value",
                  to: "#combobox-api-sv-js",
                  detail: %{value: ["deu"]},
                  bubbles: false
                )
              }
            >
              Germany (JS)
            </.action>
            <.combobox
              id="combobox-api-sv-js"
              class="combobox max-w-md"
              placeholder="Select"
              items={Corex.List.new(Demo.items_minimal())}
            >
              <:empty>No results</:empty>
              <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
            </.combobox>
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
