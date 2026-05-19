defmodule E2eWeb.ColorPickerApiLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias E2eWeb.Demos.ColorPickerDemo, as: D

  @id_value_c "color-picker-api-value-c"

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:id_value_c, @id_value_c)
     |> assign(:codes, demo_codes())}
  end

  defp demo_codes do
    %{
      binding: D.api_set_value_client_code(),
      server_heex: D.api_set_value_server_heex(),
      server_elixir: D.api_set_value_server_elixir()
    }
  end

  @impl true
  def handle_event("cp_api_s_value", %{"color" => hex}, socket) do
    {:noreply, Corex.ColorPicker.set_value(socket, "color-picker-api-value-s", hex)}
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
        id="color-picker-api-page"
        title="Color Picker · API"
        subtitle="Programmatic color: client `phx-click` binding, then the matching server push."
      >
        <.demo_section
          id="color-picker-api-set-value-c"
          title="set_value (Client binding)"
          code={@codes.binding}
        >
          <:preview>
            <D.api_set_value_client_example id={@id_value_c} />
          </:preview>
        </.demo_section>

        <.demo_section
          id="color-picker-api-set-value-s"
          title="set_value (Server)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @codes.server_heex},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @codes.server_elixir}
          ]}
        >
          <:preview>
            <div class="layout__row mb-4">
              <.action phx-click="cp_api_s_value" phx-value-color="#ff0000" class="button button--sm">
                Set red
              </.action>
              <.action phx-click="cp_api_s_value" phx-value-color="#3b82f6" class="button button--sm">
                Set blue
              </.action>
            </div>
            <.color_picker
              id="color-picker-api-value-s"
              value="#3b82f6"
              label="Set the color (Server)"
              presets={["#ff0000", "#00ff00", "#0000ff", "#3b82f6"]}
              class="color-picker"
            />
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
