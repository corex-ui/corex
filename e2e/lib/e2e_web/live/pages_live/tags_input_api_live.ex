defmodule E2eWeb.TagsInputApiLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  import E2eWeb.Demos.TagsInputDemo,
    only: [
      api_set_value_client_binding_example: 1,
      api_set_value_client_js_example: 1,
      api_set_value_server_example: 1,
      api_add_value_client_binding_example: 1,
      api_add_value_client_js_example: 1,
      api_add_value_server_example: 1,
      api_clear_client_binding_example: 1,
      api_clear_client_js_example: 1,
      api_clear_server_example: 1
    ]

  @id_set_client "tags-api-set-client"
  @id_set_js "tags-api-set-js"
  @id_add_client "tags-api-add-client"
  @id_add_js "tags-api-add-js"
  @id_clear_client "tags-api-clear-client"
  @id_clear_js "tags-api-clear-js"

  @impl true
  def mount(_params, _session, socket) do
    m = E2eWeb.Demos.TagsInputDemo

    socket =
      socket
      |> assign(:id_set_client, @id_set_client)
      |> assign(:id_set_js, @id_set_js)
      |> assign(:id_add_client, @id_add_client)
      |> assign(:id_add_js, @id_add_js)
      |> assign(:id_clear_client, @id_clear_client)
      |> assign(:id_clear_js, @id_clear_js)
      |> assign(:codes, %{
        set_value_binding: m.api_set_value_client_binding_code(),
        set_value_server_heex: m.api_set_value_server_heex(),
        set_value_server_elixir: m.api_set_value_server_elixir(),
        set_value_js_heex: m.api_set_value_js_heex(),
        set_value_js: m.api_set_value_js_js(),
        set_value_js_ts: m.api_set_value_js_ts(),
        add_value_binding: m.api_add_value_client_binding_code(),
        add_value_server_heex: m.api_add_value_server_heex(),
        add_value_server_elixir: m.api_add_value_server_elixir(),
        add_value_js_heex: m.api_add_value_js_heex(),
        add_value_js: m.api_add_value_js_js(),
        add_value_js_ts: m.api_add_value_js_ts(),
        clear_client_heex: m.api_clear_client_binding_code(),
        clear_server_heex: m.api_clear_server_heex(),
        clear_server_elixir: m.api_clear_server_elixir(),
        clear_js_heex: m.api_clear_js_heex(),
        clear_js: m.api_clear_js_js(),
        clear_js_ts: m.api_clear_js_ts()
      })

    {:ok, socket}
  end

  @impl true
  def handle_event("api_tags_set_value_server", _params, socket) do
    {:noreply, Corex.TagsInput.set_value(socket, "tags-api-set-server", ["lorem", "duis"])}
  end

  @impl true
  def handle_event("api_tags_add_value_server", _params, socket) do
    {:noreply, Corex.TagsInput.add_value(socket, "tags-api-add-server", "duis")}
  end

  @impl true
  def handle_event("api_tags_clear_all_server", _params, socket) do
    {:noreply, Corex.TagsInput.clear_value(socket, "tags-api-clear-server")}
  end

  @impl true
  def handle_event("api_tags_clear_lorem_server", _params, socket) do
    {:noreply, Corex.TagsInput.remove_value(socket, "tags-api-clear-server", "lorem")}
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
        path={@path}
        id="tags-input-api-page"
        title="Tags Input · API"
        subtitle="Set, add, and clear tags from LiveView, client bindings, or a DOM dispatch."
      >
        <.demo_section
          id="tags-input-api-set-value-binding"
          title="Set Value (Client Binding)"
          code={@codes.set_value_binding}
        >
          <:preview>
            <.api_set_value_client_binding_example id={@id_set_client} />
          </:preview>
        </.demo_section>
        <.demo_section
          id="tags-input-api-set-value-js"
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
          id="tags-input-api-set-value-server"
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
            <.api_set_value_server_example />
          </:preview>
        </.demo_section>
        <.demo_section
          id="tags-input-api-add-value-binding"
          title="Add Value (Client Binding)"
          code={@codes.add_value_binding}
        >
          <:preview>
            <.api_add_value_client_binding_example id={@id_add_client} />
          </:preview>
        </.demo_section>
        <.demo_section
          id="tags-input-api-add-value-js"
          title="Add Value (Client JS / dispatch)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @codes.add_value_js_heex},
            %{value: "js", label: "JS", language: :js, code: @codes.add_value_js},
            %{value: "ts", label: "TS", language: :javascript, code: @codes.add_value_js_ts}
          ]}
        >
          <:preview>
            <.api_add_value_client_js_example id={@id_add_js} />
          </:preview>
        </.demo_section>
        <.demo_section
          id="tags-input-api-add-value-server"
          title="Add Value (Server)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @codes.add_value_server_heex},
            %{
              value: "elixir",
              label: "Elixir",
              language: :elixir,
              code: @codes.add_value_server_elixir
            }
          ]}
        >
          <:preview>
            <.api_add_value_server_example />
          </:preview>
        </.demo_section>
        <.demo_section
          id="tags-input-api-clear-binding"
          title="Clear (Client Binding)"
          code={@codes.clear_client_heex}
        >
          <:preview>
            <.api_clear_client_binding_example id={@id_clear_client} />
          </:preview>
        </.demo_section>
        <.demo_section
          id="tags-input-api-clear-js"
          title="Clear (Client JS / dispatch)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @codes.clear_js_heex},
            %{value: "js", label: "JS", language: :js, code: @codes.clear_js},
            %{value: "ts", label: "TS", language: :javascript, code: @codes.clear_js_ts}
          ]}
        >
          <:preview>
            <.api_clear_client_js_example id={@id_clear_js} />
          </:preview>
        </.demo_section>
        <.demo_section
          id="tags-input-api-clear-server"
          title="Clear"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @codes.clear_server_heex},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @codes.clear_server_elixir}
          ]}
        >
          <:preview>
            <.api_clear_server_example />
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
