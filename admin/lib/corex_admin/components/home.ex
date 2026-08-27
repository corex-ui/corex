defmodule CorexAdmin.Components.Home do
  @moduledoc false

  use Phoenix.Component
  use Corex

  alias CorexAdmin.Gettext
  alias CorexAdmin.Live.Components
  alias CorexAdmin.Live.Helpers

  def page(assigns) do
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
      <div :if={@grouped == %{}} class="admin-muted">{Gettext.t("No resources available.")}</div>
      <section :for={{group, resources} <- @grouped} class="admin-home-group">
        <h2 class="admin-home-title">{group}</h2>
        <ul class="admin-home-list">
          <li :for={resource <- resources}>
            <.navigate
              to={Helpers.resource_path(assigns, Helpers.spec(resource))}
              class="admin-home-card"
            >
              <span class="admin-home-card-title">{Helpers.spec(resource).label}</span>
              <span class="admin-home-card-copy">
                {Gettext.t("Manage %{label}", label: Helpers.spec(resource).label)}
              </span>
            </.navigate>
          </li>
        </ul>
      </section>
    </Components.shell>
    """
  end
end
