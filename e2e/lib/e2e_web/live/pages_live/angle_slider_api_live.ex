defmodule E2eWeb.AngleSliderApiLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  @id_sv_client "api-angle-slider"
  @id_sv_js "api-angle-slider-client-js"
  @id_sv_server "api-angle-slider-server"

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:id_sv_client, @id_sv_client)
     |> assign(:id_sv_js, @id_sv_js)
     |> assign(:id_sv_server, @id_sv_server)
     |> assign(:codes, demo_codes())}
  end

  defp demo_codes do
    m = E2eWeb.Demos.AngleSliderDemo

    %{
      binding: m.api_set_value_client_binding_code(),
      js_heex: m.api_set_value_client_js_heex(),
      js: m.api_set_value_client_js_js(),
      js_ts: m.api_set_value_client_js_ts(),
      server_heex: m.api_set_value_server_heex(),
      server_elixir: m.api_set_value_server_elixir()
    }
  end

  @impl true
  def handle_event("api_set_value", %{"value" => value}, socket) do
    angle =
      case Float.parse(to_string(value)) do
        {num, _} -> num
        :error -> 0.0
      end

    {:noreply, Corex.AngleSlider.set_value(socket, @id_sv_server, angle)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app
      flash={@flash}
      mode={@mode}
      theme={@theme}
      path={@path}
    >
      <.demo_page
        id="angle-slider-api-page"
        title="Angle Slider · API"
        subtitle="Programmatically control the Angle Slider via client or server events."
      >
        <.demo_section
          id="angle-slider-api-set-value-binding"
          title="Set Value (Client Binding)"
          code={@codes.binding}
        >
          <:preview>
            <E2eWeb.Demos.AngleSliderDemo.api_set_value_client_binding_example id={@id_sv_client} />
          </:preview>
        </.demo_section>

        <.demo_section
          id="angle-slider-api-set-value-js"
          title="Set Value (Client JS)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @codes.js_heex},
            %{value: "js", label: "JS", language: :js, code: @codes.js},
            %{value: "ts", label: "TS", language: :javascript, code: @codes.js_ts}
          ]}
        >
          <:preview>
            <E2eWeb.Demos.AngleSliderDemo.api_set_value_client_js_example id={@id_sv_js} />
          </:preview>
        </.demo_section>

        <.demo_section
          id="angle-slider-api-set-value-server"
          title="Set Value (Server)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @codes.server_heex},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @codes.server_elixir}
          ]}
        >
          <:preview>
            <E2eWeb.Demos.AngleSliderDemo.api_set_value_server_example
              id={@id_sv_server}
              event="api_set_value"
            />
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
