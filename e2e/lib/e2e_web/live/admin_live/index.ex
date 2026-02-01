defmodule E2eWeb.AdminLive.Index do
  use E2eWeb, :live_view

  alias E2e.Accounts

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Listing Admins
        <:actions>
          <.button class="button button--accent" navigate={~p"/admins/new"}>
            <.icon name="hero-plus" /> New Admin
          </.button>
        </:actions>
      </.header>

      <.table
        id="admins"
        rows={@streams.admins}
        row_click={fn {_id, admin} -> JS.navigate(~p"/admins/#{admin}") end}
      >
        <:col :let={{_id, admin}} label="Name">{admin.name}</:col>
        <:col :let={{_id, admin}} label="Country">{admin.country}</:col>
        <:col :let={{_id, admin}} label="Terms">{admin.terms}</:col>
        <:action :let={{_id, admin}}>
          <div class="sr-only">
            <.link navigate={~p"/admins/#{admin}"} class="link">Show</.link>
          </div>
          <.link navigate={~p"/admins/#{admin}/edit"} class="link">Edit</.link>
        </:action>
        <:action :let={{id, admin}}>
          <.link
            phx-click={JS.push("delete", value: %{id: admin.id}) |> hide("##{id}")}
            data-confirm="Are you sure?"
            class="link link--alert"
          >
            Delete
          </.link>
        </:action>
      </.table>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Listing Admins")
     |> stream(:admins, list_admins())}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    admin = Accounts.get_admin!(id)
    {:ok, _} = Accounts.delete_admin(admin)

    {:noreply, stream_delete(socket, :admins, admin)}
  end

  defp list_admins() do
    Accounts.list_admins()
  end
end
