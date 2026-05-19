defmodule E2eWeb.NumberInputApiLive do
  use E2eWeb, :live_view
  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  import E2eWeb.Demos.NumberInputDemo,
    only: [
      api_set_value_client_binding_example: 1,
      api_set_value_server_example: 1,
      api_set_value_client_js_example: 1,
      api_clear_client_binding_example: 1,
      api_clear_server_example: 1,
      api_commands_client_binding_example: 1,
      api_state_client_binding_example: 1,
      api_state_server_example: 1,
      api_state_client_js_example: 1
    ]

  @id_set_client "number-input-api-set-client"
  @id_set_js "number-input-api-set-js"
  @id_set_server "number-input-api-set-server"
  @id_clear_client "number-input-api-clear-client"
  @id_clear_server "number-input-api-clear-server"
  @id_cmd_client "number-input-api-cmd-client"
  @id_state_client "number-input-api-state-client"
  @id_state_js "number-input-api-state-js"
  @id_state_server "number-input-api-state-server"

  @impl true
  def mount(_params, _session, socket) do
    m = E2eWeb.Demos.NumberInputDemo

    socket =
      socket
      |> assign(:id_set_client, @id_set_client)
      |> assign(:id_set_js, @id_set_js)
      |> assign(:id_set_server, @id_set_server)
      |> assign(:id_clear_client, @id_clear_client)
      |> assign(:id_clear_server, @id_clear_server)
      |> assign(:id_cmd_client, @id_cmd_client)
      |> assign(:id_state_client, @id_state_client)
      |> assign(:id_state_js, @id_state_js)
      |> assign(:id_state_server, @id_state_server)
      |> assign(:codes, %{
        set_value_binding: m.api_set_value_client_binding_code(),
        set_value_server_heex: m.api_set_value_server_heex(),
        set_value_server_elixir: m.api_set_value_server_elixir(),
        set_value_js_heex: m.api_set_value_js_heex(),
        set_value_js: m.api_set_value_js_js(),
        set_value_js_ts: m.api_set_value_js_ts(),
        clear_client_heex: m.api_clear_client_binding_code(),
        clear_server_heex: m.api_clear_server_heex(),
        clear_server_elixir: m.api_clear_server_elixir(),
        commands_binding: m.api_commands_client_binding_code(),
        state_client_heex: m.api_state_client_binding_code(),
        state_server_heex: m.api_state_server_heex(),
        state_server_elixir: m.api_state_server_elixir(),
        state_js_heex: m.api_state_client_js_heex(),
        state_js: m.api_state_client_js_js(),
        state_js_ts: m.api_state_client_js_ts()
      })

    {:ok, socket}
  end

  @impl true
  def handle_event("api_number_set_value_server", _params, socket) do
    {:noreply, Corex.NumberInput.set_value(socket, @id_set_server, 99)}
  end

  @impl true
  def handle_event("api_number_clear_server", _params, socket) do
    {:noreply, Corex.NumberInput.clear_value(socket, @id_clear_server)}
  end

  @impl true
  def handle_event("api_number_state_server", _params, socket) do
    {:noreply, Corex.NumberInput.state(socket, @id_state_server)}
  end

  @impl true
  def handle_event(
        "number_input_state_response",
        %{
          "id" => id,
          "value" => value,
          "valueAsNumber" => n,
          "focused" => focused,
          "invalid" => invalid,
          "empty" => empty
        },
        socket
      )
      when id in [
             @id_state_client,
             @id_state_js,
             @id_state_server
           ] do
    desc =
      "#{id}\nvalue=#{inspect(value)} valueAsNumber=#{inspect(n)} focused=#{focused} invalid=#{invalid} empty=#{empty}"

    {:noreply,
     Corex.Toast.create(socket, "layout-toast", "number_input_state_response", desc, :info,
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
        id="number-input-api-page"
        title="Number Input · API"
        subtitle="Machine API: set, clear, step, bounds, focus, and read state from LiveView or the client."
      >
        <.demo_section
          id="number-input-api-set-value-binding"
          title="Set value (client binding)"
          code={@codes.set_value_binding}
        >
          <:preview>
            <.api_set_value_client_binding_example id={@id_set_client} />
          </:preview>
        </.demo_section>

        <.demo_section
          id="number-input-api-set-value-server"
          title="Set value (server)"
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
          id="number-input-api-set-value-js"
          title="Set value (client JS)"
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
          id="number-input-api-clear-binding"
          title="Clear value (client binding)"
          code={@codes.clear_client_heex}
        >
          <:preview>
            <.api_clear_client_binding_example id={@id_clear_client} />
          </:preview>
        </.demo_section>

        <.demo_section
          id="number-input-api-clear-server-section"
          title="Clear value (server)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @codes.clear_server_heex},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @codes.clear_server_elixir}
          ]}
        >
          <:preview>
            <.api_clear_server_example id={@id_clear_server} />
          </:preview>
        </.demo_section>

        <.demo_section
          id="number-input-api-commands-binding"
          title="Increment, decrement, min, max, focus"
          code={@codes.commands_binding}
        >
          <:preview>
            <.api_commands_client_binding_example id={@id_cmd_client} />
          </:preview>
        </.demo_section>

        <.demo_section
          id="number-input-api-state-binding"
          title="State (client binding)"
          code={@codes.state_client_heex}
        >
          <:preview>
            <.api_state_client_binding_example id={@id_state_client} />
          </:preview>
        </.demo_section>

        <.demo_section
          id="number-input-api-state-server-section"
          title="State (server)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @codes.state_server_heex},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @codes.state_server_elixir}
          ]}
        >
          <:preview>
            <.api_state_server_example id={@id_state_server} />
          </:preview>
        </.demo_section>

        <.demo_section
          id="number-input-api-state-js-section"
          title="State (client JS / TS)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @codes.state_js_heex},
            %{value: "js", label: "JS", language: :js, code: @codes.state_js},
            %{value: "ts", label: "TS", language: :javascript, code: @codes.state_js_ts}
          ]}
        >
          <:preview>
            <.api_state_client_js_example id={@id_state_js} />
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
