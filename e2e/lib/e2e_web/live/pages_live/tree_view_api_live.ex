defmodule E2eWeb.TreeViewApiLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  @id_exp_client "tree-api-set-expanded-client"
  @id_exp_js "tree-api-set-expanded-js"
  @id_exp_server "tree-api-set-expanded-server"
  @id_sel_client "tree-api-set-selected-client"
  @id_sel_js "tree-api-set-selected-js"
  @id_sel_server "tree-api-set-selected-server"
  @id_get_exp_server "tree-api-get-expanded-server"
  @id_get_sel_server "tree-api-get-selected-server"

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:demo_items, E2eWeb.Demos.TreeViewDemo.api_items())
      |> assign(:id_exp_client, @id_exp_client)
      |> assign(:id_exp_js, @id_exp_js)
      |> assign(:id_exp_server, @id_exp_server)
      |> assign(:id_sel_client, @id_sel_client)
      |> assign(:id_sel_js, @id_sel_js)
      |> assign(:id_sel_server, @id_sel_server)
      |> assign(:id_get_exp_server, @id_get_exp_server)
      |> assign(:id_get_sel_server, @id_get_sel_server)
      |> assign(:codes, E2eWeb.Demos.TreeViewDemo.api_codes())

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
    {:noreply, push_event(socket, "tree_view_expanded_value", %{})}
  end

  def handle_event("tree_api_get_selected", _params, socket) do
    {:noreply, push_event(socket, "tree_view_selected_value", %{})}
  end

  def handle_event("tree_view_expanded_value_response", %{"value" => value}, socket) do
    desc = "#{@id_get_exp_server}\n#{inspect(value)}"

    {:noreply,
     Corex.Toast.create(
       socket,
       "layout-toast",
       "tree_view_expanded_value_response",
       desc,
       :info,
       duration: 5000
     )}
  end

  def handle_event("tree_view_selected_value_response", %{"value" => value}, socket) do
    desc = "#{@id_get_sel_server}\n#{inspect(value)}"

    {:noreply,
     Corex.Toast.create(
       socket,
       "layout-toast",
       "tree_view_selected_value_response",
       desc,
       :info,
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
        path={@path}
        id="tree-view-api-page"
        title="Tree view · API"
        subtitle="Control and interact with the tree view from LiveView or the client."
      >
        <.demo_section
          id="tree-view-api-set-expanded-client"
          title="Set expanded (Client binding)"
          code={@codes.set_expanded_client_heex}
        >
          <:preview>
            <E2eWeb.Demos.TreeViewDemo.api_set_expanded_client_example
              id={@id_exp_client}
              items={@demo_items}
            />
          </:preview>
        </.demo_section>

        <.demo_section
          id="tree-view-api-set-expanded-js"
          title="Set expanded (Client JS)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @codes.set_expanded_js_heex},
            %{value: "js", label: "JS", language: :js, code: @codes.set_expanded_js},
            %{value: "ts", label: "TS", language: :javascript, code: @codes.set_expanded_js_ts}
          ]}
        >
          <:preview>
            <E2eWeb.Demos.TreeViewDemo.api_set_expanded_client_js_example
              id={@id_exp_js}
              items={@demo_items}
            />
          </:preview>
        </.demo_section>

        <.demo_section
          id="tree-view-api-set-expanded-server"
          title="Set expanded (Server)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @codes.set_expanded_server_heex},
            %{
              value: "elixir",
              label: "Elixir",
              language: :elixir,
              code: @codes.set_expanded_server_elixir
            }
          ]}
        >
          <:preview>
            <E2eWeb.Demos.TreeViewDemo.api_set_expanded_server_example
              id={@id_exp_server}
              items={@demo_items}
              event="tree_api_set_expanded"
            />
          </:preview>
        </.demo_section>

        <.demo_section
          id="tree-view-api-set-selected-client"
          title="Set selected (Client binding)"
          code={@codes.set_selected_client_heex}
        >
          <:preview>
            <E2eWeb.Demos.TreeViewDemo.api_set_selected_client_example
              id={@id_sel_client}
              items={@demo_items}
            />
          </:preview>
        </.demo_section>

        <.demo_section
          id="tree-view-api-set-selected-js"
          title="Set selected (Client JS)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @codes.set_selected_js_heex},
            %{value: "js", label: "JS", language: :js, code: @codes.set_selected_js},
            %{value: "ts", label: "TS", language: :javascript, code: @codes.set_selected_js_ts}
          ]}
        >
          <:preview>
            <E2eWeb.Demos.TreeViewDemo.api_set_selected_client_js_example
              id={@id_sel_js}
              items={@demo_items}
            />
          </:preview>
        </.demo_section>

        <.demo_section
          id="tree-view-api-set-selected-server"
          title="Set selected (Server)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @codes.set_selected_server_heex},
            %{
              value: "elixir",
              label: "Elixir",
              language: :elixir,
              code: @codes.set_selected_server_elixir
            }
          ]}
        >
          <:preview>
            <E2eWeb.Demos.TreeViewDemo.api_set_selected_server_example
              id={@id_sel_server}
              items={@demo_items}
              event="tree_api_set_selected"
            />
          </:preview>
        </.demo_section>

        <.demo_section
          id="tree-view-api-get-expanded-server"
          title="Get expanded (Server)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @codes.get_expanded_heex},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @codes.get_expanded_elixir}
          ]}
        >
          <:preview>
            <E2eWeb.Demos.TreeViewDemo.api_get_expanded_server_example
              id={@id_get_exp_server}
              items={@demo_items}
              event="tree_api_get_expanded"
            />
          </:preview>
        </.demo_section>

        <.demo_section
          id="tree-view-api-get-selected-server"
          title="Get selected (Server)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @codes.get_selected_heex},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @codes.get_selected_elixir}
          ]}
        >
          <:preview>
            <E2eWeb.Demos.TreeViewDemo.api_get_selected_server_example
              id={@id_get_sel_server}
              items={@demo_items}
              event="tree_api_get_selected"
            />
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
