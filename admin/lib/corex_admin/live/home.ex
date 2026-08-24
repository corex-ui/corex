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
    assigns = assign(assigns, :grouped, Helpers.grouped_resources(assigns))

    ~H"""
    <Components.shell socket={assigns}>
      <.layout_heading class="layout-heading">
        <:title>Admin</:title>
        <:subtitle>Choose a resource to manage.</:subtitle>
      </.layout_heading>
      <div :if={@grouped == %{}} class="text-ink-muted">No resources available.</div>
      <section :for={{group, resources} <- @grouped} class="flex flex-col gap-space">
        <h2 class="m-0 text-lg font-semibold">{group}</h2>
        <ul class="m-0 grid list-none grid-cols-1 gap-space p-0 sm:grid-cols-2">
          <li :for={resource <- resources}>
            <.navigate
              to={Helpers.resource_path(assigns, Helpers.spec(resource))}
              class="link flex flex-col gap-space-xs rounded-md border border-border bg-surface p-space"
            >
              <span class="font-semibold text-ink">{Helpers.spec(resource).label}</span>
              <span class="text-sm text-ink-muted">{Helpers.spec(resource).slug}</span>
            </.navigate>
          </li>
        </ul>
      </section>
    </Components.shell>
    """
  end
end
