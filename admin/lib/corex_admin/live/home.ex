defmodule CorexAdmin.Live.Home do
  @moduledoc false

  use Phoenix.LiveView
  use Corex

  alias CorexAdmin.Live.Components
  alias CorexAdmin.Live.Helpers

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :page_title, "Admin")}
  end

  @impl true
  def render(assigns) do
    prefix = Helpers.home_path(assigns)

    assigns =
      assigns
      |> assign(:grouped, Helpers.grouped_resources(assigns))
      |> assign(:admins_path, String.replace_suffix(prefix, "/admin", "/admins"))

    ~H"""
    <Components.shell socket={assigns}>
      <.layout_heading class="layout-heading">
        <:title>Admin</:title>
        <:subtitle>
          Isolated Corex Admin demo — your data is scoped to this browser session and resets periodically.
          The unauthenticated
          <.navigate to={@admins_path} class="link">/admins</.navigate>
          CRUD is a counterexample — do not copy it.
        </:subtitle>
      </.layout_heading>
      <div :if={@grouped == %{}} class="admin-muted">No resources available.</div>
      <section :for={{group, resources} <- @grouped} class="admin-home-group">
        <h2 class="admin-home-title">{group}</h2>
        <ul class="admin-home-list">
          <li :for={resource <- resources}>
            <.navigate
              to={Helpers.resource_path(assigns, Helpers.spec(resource))}
              class="admin-home-card"
            >
              <span class="admin-home-card-title">{Helpers.spec(resource).label}</span>
              <span class="admin-home-card-copy">Manage {Helpers.spec(resource).label}</span>
            </.navigate>
          </li>
        </ul>
      </section>
    </Components.shell>
    """
  end
end
