defmodule CorexAdmin.UI.Home do
  @moduledoc """
  Hub landing page.

  Lists only the resources the actor may index. Replace it entirely with a
  dashboard by passing `home:` to `use CorexAdmin`.
  """

  use CorexAdmin.UI

  slot :before_groups
  slot :after_groups

  @doc "The hub landing page."
  def page(assigns) do
    assigns =
      assigns
      |> assign(:grouped, Helpers.grouped_resources(assigns))
      |> assign(:hub_title, Helpers.hub_title(assigns))
      |> assign(:hub_description, Helpers.hub_description(assigns))

    ~H"""
    <.shell>
      <.layout_heading class="layout-heading">
        <:title>{@hub_title}</:title>
        <:subtitle :if={@hub_description}>{@hub_description}</:subtitle>
      </.layout_heading>
      {render_slot(@before_groups)}
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
      {render_slot(@after_groups)}
    </.shell>
    """
  end
end
