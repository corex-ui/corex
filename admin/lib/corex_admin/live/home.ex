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
      <div :if={@grouped == %{}} class="text-ink-muted">No resources available.</div>
      <section :for={{group, resources} <- @grouped} class="flex flex-col gap-space">
        <h2 class="m-0 text-lg font-semibold">{group}</h2>
        <ul class="m-0 grid list-none grid-cols-1 gap-space p-0 sm:grid-cols-2">
          <li :for={resource <- resources}>
            <.navigate
              to={Helpers.resource_path(assigns, Helpers.spec(resource))}
              class="flex flex-col gap-space-xs rounded-md border border-border bg-surface p-space text-ink no-underline hover:bg-ui-hover"
            >
              <span class="text-lg font-semibold">{Helpers.spec(resource).label}</span>
              <span class="text-sm text-ink-muted">Manage {Helpers.spec(resource).label}</span>
            </.navigate>
          </li>
        </ul>
      </section>
    </Components.shell>
    """
  end
end
