defmodule E2eWeb.TreeViewApiLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias E2eWeb.Demos.TreeViewDemo, as: Demo

  @id_exp_client "tree-api-set-expanded-client"
  @id_exp_js "tree-api-set-expanded-js"
  @id_exp_server "tree-api-set-expanded-server"
  @id_sel_client "tree-api-set-selected-client"
  @id_sel_js "tree-api-set-selected-js"
  @id_sel_server "tree-api-set-selected-server"
  @id_exp_read_client "tree-api-expanded-client"
  @id_exp_read_js "tree-api-expanded-js"
  @id_get_exp_server "tree-api-get-expanded-server"
  @id_sel_read_client "tree-api-selected-client"
  @id_sel_read_js "tree-api-selected-js"
  @id_get_sel_server "tree-api-get-selected-server"

  @read_expanded_ids [@id_exp_read_client, @id_exp_read_js, @id_get_exp_server]
  @read_selected_ids [@id_sel_read_client, @id_sel_read_js, @id_get_sel_server]

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:demo_items, Demo.api_items())
      |> assign(:id_exp_client, @id_exp_client)
      |> assign(:id_exp_js, @id_exp_js)
      |> assign(:id_exp_server, @id_exp_server)
      |> assign(:id_sel_client, @id_sel_client)
      |> assign(:id_sel_js, @id_sel_js)
      |> assign(:id_sel_server, @id_sel_server)
      |> assign(:id_exp_read_client, @id_exp_read_client)
      |> assign(:id_exp_read_js, @id_exp_read_js)
      |> assign(:id_get_exp_server, @id_get_exp_server)
      |> assign(:id_sel_read_client, @id_sel_read_client)
      |> assign(:id_sel_read_js, @id_sel_read_js)
      |> assign(:id_get_sel_server, @id_get_sel_server)
      |> assign(:codes, Demo.api_codes())

    {:ok, socket}
  end

  @impl true
  def handle_event("tree_api_set_expanded", %{"value" => raw}, socket) do
    list = if raw == "", do: [], else: String.split(raw, ",", trim: true)
    {:noreply, Corex.TreeView.set_expanded_value(socket, @id_exp_server, list)}
  end

  def handle_event("tree_api_set_selected", %{"value" => raw}, socket) do
    list = if raw == "", do: [], else: String.split(raw, ",", trim: true)
    {:noreply, Corex.TreeView.set_selected_value(socket, @id_sel_server, list)}
  end

  def handle_event("tree_api_get_expanded", _params, socket) do
    {:noreply, Corex.TreeView.expanded_value(socket, @id_get_exp_server)}
  end

  def handle_event("tree_api_get_expanded_client_only", _params, socket) do
    {:noreply, Corex.TreeView.expanded_value(socket, @id_get_exp_server, respond_to: :client)}
  end

  def handle_event("tree_api_get_selected", _params, socket) do
    {:noreply, Corex.TreeView.value(socket, @id_get_sel_server)}
  end

  def handle_event("tree_api_get_selected_client_only", _params, socket) do
    {:noreply, Corex.TreeView.value(socket, @id_get_sel_server, respond_to: :client)}
  end

  def handle_event("tree_view_expanded_value_response", %{"id" => id, "value" => value}, socket)
      when id in @read_expanded_ids do
    {:noreply, toast_expanded_value(socket, id, value)}
  end

  def handle_event("tree_view_value_response", %{"id" => id, "value" => value}, socket)
      when id in @read_selected_ids do
    {:noreply, toast_selected_value(socket, id, value)}
  end

  defp toast_expanded_value(socket, id, value) do
    desc = "#{id}\n#{inspect(value)}"

    Corex.Toast.create(
      socket,
      "layout-toast",
      "tree_view_expanded_value_response",
      desc,
      :info,
      duration: 5000
    )
  end

  defp toast_selected_value(socket, id, value) do
    desc = "#{id}\n#{inspect(value)}"

    Corex.Toast.create(
      socket,
      "layout-toast",
      "tree_view_value_response",
      desc,
      :info,
      duration: 5000
    )
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
        id="tree-view-api-page"
        title={~t"Tree view · API"}
        subtitle={~t"Control and interact with the tree view from LiveView or the client."}
      >
        <.demo_section
          id="tree-view-api-set-expanded-client"
          title={~t"Set Expanded (Client Binding)"}
          code={@codes.set_expanded_client_heex}
        >
          <:preview>
            <Demo.api_set_expanded_client_example id={@id_exp_client} items={@demo_items} />
          </:preview>
        </.demo_section>

        <.demo_section
          id="tree-view-api-set-expanded-js"
          title={~t"Set Expanded (Client JS)"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @codes.set_expanded_js_heex},
            %{value: "js", label: ~t"JS", language: :js, code: @codes.set_expanded_js},
            %{value: "ts", label: ~t"TS", language: :javascript, code: @codes.set_expanded_js_ts}
          ]}
        >
          <:preview>
            <Demo.api_set_expanded_client_js_example id={@id_exp_js} items={@demo_items} />
          </:preview>
        </.demo_section>

        <.demo_section
          id="tree-view-api-set-expanded-server"
          title={~t"Set Expanded (Server)"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @codes.set_expanded_server_heex},
            %{
              value: "elixir",
              label: ~t"Elixir",
              language: :elixir,
              code: @codes.set_expanded_server_elixir
            }
          ]}
        >
          <:preview>
            <Demo.api_set_expanded_server_example
              id={@id_exp_server}
              items={@demo_items}
              event="tree_api_set_expanded"
            />
          </:preview>
        </.demo_section>

        <.demo_section
          id="tree-view-api-set-selected-client"
          title={~t"Set Selected (Client Binding)"}
          code={@codes.set_selected_client_heex}
        >
          <:preview>
            <Demo.api_set_selected_client_example id={@id_sel_client} items={@demo_items} />
          </:preview>
        </.demo_section>

        <.demo_section
          id="tree-view-api-set-selected-js"
          title={~t"Set Selected (Client JS)"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @codes.set_selected_js_heex},
            %{value: "js", label: ~t"JS", language: :js, code: @codes.set_selected_js},
            %{value: "ts", label: ~t"TS", language: :javascript, code: @codes.set_selected_js_ts}
          ]}
        >
          <:preview>
            <Demo.api_set_selected_client_js_example id={@id_sel_js} items={@demo_items} />
          </:preview>
        </.demo_section>

        <.demo_section
          id="tree-view-api-set-selected-server"
          title={~t"Set Selected (Server)"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @codes.set_selected_server_heex},
            %{
              value: "elixir",
              label: ~t"Elixir",
              language: :elixir,
              code: @codes.set_selected_server_elixir
            }
          ]}
        >
          <:preview>
            <Demo.api_set_selected_server_example
              id={@id_sel_server}
              items={@demo_items}
              event="tree_api_set_selected"
            />
          </:preview>
        </.demo_section>

        <.demo_section
          id="tree-view-api-expanded-binding"
          title={~t"Expanded (Client Binding)"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @codes.expanded_client_heex},
            %{value: "js", label: ~t"JS", language: :js, code: @codes.expanded_client_js},
            %{value: "ts", label: ~t"TS", language: :javascript, code: @codes.expanded_client_ts}
          ]}
        >
          <:preview>
            <Demo.api_expanded_client_binding_example
              id={@id_exp_read_client}
              items={@demo_items}
            />
          </:preview>
        </.demo_section>

        <.demo_section
          id="tree-view-api-expanded-js"
          title={~t"Expanded (Client JS)"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @codes.expanded_js_heex},
            %{value: "js", label: ~t"JS", language: :js, code: @codes.expanded_js},
            %{value: "ts", label: ~t"TS", language: :javascript, code: @codes.expanded_js_ts}
          ]}
        >
          <:preview>
            <Demo.api_expanded_client_js_example id={@id_exp_read_js} items={@demo_items} />
          </:preview>
        </.demo_section>

        <.demo_section
          id="tree-view-api-get-expanded-server"
          title={~t"Expanded (Server)"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @codes.expanded_server_heex},
            %{
              value: "elixir",
              label: ~t"Elixir",
              language: :elixir,
              code: @codes.expanded_server_elixir
            },
            %{value: "js", label: ~t"JS", language: :js, code: @codes.expanded_server_js},
            %{value: "ts", label: ~t"TS", language: :javascript, code: @codes.expanded_server_ts}
          ]}
        >
          <:preview>
            <Demo.api_expanded_server_example
              id={@id_get_exp_server}
              items={@demo_items}
              event_expanded="tree_api_get_expanded"
              event_expanded_client_only="tree_api_get_expanded_client_only"
            />
          </:preview>
        </.demo_section>

        <.demo_section
          id="tree-view-api-selected-binding"
          title={~t"Selected (Client Binding)"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @codes.selected_client_heex},
            %{value: "js", label: ~t"JS", language: :js, code: @codes.selected_client_js},
            %{value: "ts", label: ~t"TS", language: :javascript, code: @codes.selected_client_ts}
          ]}
        >
          <:preview>
            <Demo.api_selected_client_binding_example
              id={@id_sel_read_client}
              items={@demo_items}
            />
          </:preview>
        </.demo_section>

        <.demo_section
          id="tree-view-api-selected-js"
          title={~t"Selected (Client JS)"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @codes.selected_js_heex},
            %{value: "js", label: ~t"JS", language: :js, code: @codes.selected_js},
            %{value: "ts", label: ~t"TS", language: :javascript, code: @codes.selected_js_ts}
          ]}
        >
          <:preview>
            <Demo.api_selected_client_js_example id={@id_sel_read_js} items={@demo_items} />
          </:preview>
        </.demo_section>

        <.demo_section
          id="tree-view-api-get-selected-server"
          title={~t"Selected (Server)"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @codes.selected_server_heex},
            %{
              value: "elixir",
              label: ~t"Elixir",
              language: :elixir,
              code: @codes.selected_server_elixir
            },
            %{value: "js", label: ~t"JS", language: :js, code: @codes.selected_server_js},
            %{value: "ts", label: ~t"TS", language: :javascript, code: @codes.selected_server_ts}
          ]}
        >
          <:preview>
            <Demo.api_selected_server_example
              id={@id_get_sel_server}
              items={@demo_items}
              event_selected="tree_api_get_selected"
              event_selected_client_only="tree_api_get_selected_client_only"
            />
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
