defmodule E2eWeb.PinInputApiLive do
  use E2eWeb, :live_view
  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  import E2eWeb.Demos.PinInputDemo,
    only: [
      api_set_value_client_binding_example: 1,
      api_set_value_client_js_example: 1,
      api_set_value_server_example: 1,
      api_value_client_binding_example: 1,
      api_value_client_js_example: 1,
      api_value_server_example: 1,
      api_clear_client_binding_example: 1,
      api_clear_server_example: 1
    ]

  @id_set_client "pin-api-set-client"
  @id_set_js "pin-api-set-js"
  @id_set_server "pin-api-set-server"
  @id_val_client "pin-api-val-client"
  @id_val_js "pin-api-val-js"
  @id_val_server "pin-api-val-server"
  @id_clear_client "pin-api-clear-client"
  @id_clear_server "pin-api-clear-server"

  @impl true
  def mount(_params, _session, socket) do
    m = E2eWeb.Demos.PinInputDemo

    socket =
      socket
      |> assign(:id_set_client, @id_set_client)
      |> assign(:id_set_js, @id_set_js)
      |> assign(:id_set_server, @id_set_server)
      |> assign(:id_val_client, @id_val_client)
      |> assign(:id_val_js, @id_val_js)
      |> assign(:id_val_server, @id_val_server)
      |> assign(:id_clear_client, @id_clear_client)
      |> assign(:id_clear_server, @id_clear_server)
      |> assign(:codes, %{
        set_value_binding: m.api_set_value_client_binding_code(),
        set_value_server_heex: m.api_set_value_server_heex(),
        set_value_server_elixir: m.api_set_value_server_elixir(),
        set_value_js_heex: m.api_set_value_js_heex(),
        set_value_js: m.api_set_value_js_js(),
        set_value_js_ts: m.api_set_value_js_ts(),
        value_client_heex: m.api_value_client_binding_code(),
        value_server_heex: m.api_value_server_heex(),
        value_server_elixir: m.api_value_server_elixir(),
        value_js_heex: m.api_value_client_js_heex(),
        value_js: m.api_value_client_js_js(),
        value_js_ts: m.api_value_client_js_ts(),
        clear_client_heex: m.api_clear_client_binding_code(),
        clear_server_heex: m.api_clear_server_heex(),
        clear_server_elixir: m.api_clear_server_elixir()
      })

    {:ok, socket}
  end

  @impl true
  def handle_event("api_pin_set_value_server", _params, socket) do
    {:noreply, Corex.PinInput.set_value(socket, @id_set_server, ["1", "2", "3", "4"])}
  end

  @impl true
  def handle_event("api_pin_value_server", _params, socket) do
    {:noreply, Corex.PinInput.value(socket, @id_val_server)}
  end

  @impl true
  def handle_event("api_pin_clear_server", _params, socket) do
    {:noreply, Corex.PinInput.clear(socket, @id_clear_server)}
  end

  @impl true
  def handle_event(
        "pin_input_value_response",
        %{"id" => id, "value" => value, "valueAsString" => s},
        socket
      )
      when id in [
             @id_val_client,
             @id_val_js,
             @id_val_server
           ] do
    desc = "#{id}\nvalue=#{inspect(value)} valueAsString=#{s}"

    {:noreply,
     Corex.Toast.create(socket, "layout-toast", "pin_input_value_response", desc, :info,
       duration: 5000
     )}
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
        id="pin-input-api-page"
        title="Pin Input · API"
        subtitle="Set, read, and clear the pin from LiveView, client bindings, or a (Client JS)."
      >
        <.demo_section
          id="pin-input-api-set-value-binding"
          title="Set Value (Client Binding)"
          code={@codes.set_value_binding}
        >
          <:preview>
            <.api_set_value_client_binding_example id={@id_set_client} />
          </:preview>
        </.demo_section>
        <.demo_section
          id="pin-input-api-set-value-js"
          title="Set Value (Client JS / dispatch)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @codes.set_value_js_heex},
            %{value: "js", label: "JS", language: :js, code: @codes.set_value_js},
            %{value: "ts", label: "TS", language: :javascript, code: @codes.set_value_js_ts}
          ]}
        >
          <:preview>
            <.api_set_value_client_js_example id={@id_set_js} />
          </:preview>
        </.demo_section>
        <.demo_section
          id="pin-input-api-set-value-server"
          title="Set Value (Server)"
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
            <.api_set_value_server_example id={@id_set_server} />
          </:preview>
        </.demo_section>
        <.demo_section
          id="pin-input-api-value-binding"
          title="Value (Client Binding)"
          code={@codes.value_client_heex}
        >
          <:preview>
            <.api_value_client_binding_example id={@id_val_client} />
          </:preview>
        </.demo_section>
        <.demo_section
          id="pin-input-api-value-js"
          title="Value (Client JS / dispatch)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @codes.value_js_heex},
            %{value: "js", label: "JS", language: :js, code: @codes.value_js},
            %{value: "ts", label: "TS", language: :javascript, code: @codes.value_js_ts}
          ]}
        >
          <:preview>
            <.api_value_client_js_example id={@id_val_js} />
          </:preview>
        </.demo_section>
        <.demo_section
          id="pin-input-api-value-server"
          title="Value (Server)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @codes.value_server_heex},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @codes.value_server_elixir}
          ]}
        >
          <:preview>
            <.api_value_server_example id={@id_val_server} />
          </:preview>
        </.demo_section>
        <.demo_section
          id="pin-input-api-clear-binding"
          title="Clear (Client Binding)"
          code={@codes.clear_client_heex}
        >
          <:preview>
            <.api_clear_client_binding_example id={@id_clear_client} />
          </:preview>
        </.demo_section>
        <.demo_section
          id="pin-input-api-clear-server"
          title="Clear (Server)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @codes.clear_server_heex},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @codes.clear_server_elixir}
          ]}
        >
          <:preview>
            <.api_clear_server_example id={@id_clear_server} />
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
