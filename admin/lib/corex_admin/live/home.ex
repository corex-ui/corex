defmodule CorexAdmin.Live.Home do
  @moduledoc false

  use Phoenix.LiveView
  use Corex

  alias CorexAdmin.Live.Components
  alias CorexAdmin.Live.Helpers

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :page_title, Helpers.hub_title(socket))}
  end

  @impl true
  def render(assigns) do
    assigns =
      assigns
      |> assign(:grouped, Helpers.grouped_resources(assigns))
      |> assign(:hub_title, Helpers.hub_title(assigns))
      |> assign(:hub_description, Helpers.hub_description(assigns))

    ~H"""
    <Components.shell>
      <.layout_heading class="layout-heading">
        <:title>{@hub_title}</:title>
        <:subtitle :if={@hub_description}>{@hub_description}</:subtitle>
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
