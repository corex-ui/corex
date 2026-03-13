defmodule E2eWeb.AdminLive.Index do
  use E2eWeb, :live_view

  alias E2e.Accounts

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app
      flash={@flash}
      mode={@mode}
      theme={@theme}
      locale={@locale}
      current_path={@current_path}
    >
      <.layout_heading>
        <:title>Listing Admins</:title>
        <:subtitle>Add and manage admin records</:subtitle>
        <:actions>
          <.navigate to={~p"/#{@locale}/admins/new"} type="navigate" class="button button--accent">
            <.heroicon name="hero-plus" /> New Admin
          </.navigate>
        </:actions>
      </.layout_heading>
      <.data_table
        id="admins"
        class="data-table"
        rows={@streams.admins}
        row_click={fn {_id, admin} -> JS.navigate(~p"/#{@locale}/admins/#{admin}") end}
      >
        <:col :let={{_id, admin}} label="Name">{admin.name}</:col>
        <:col :let={{_id, admin}} label="Country">{admin.country}</:col>
        <:col :let={{_id, admin}} label="Terms">{admin.terms}</:col>
        <:action :let={{_id, admin}}>
          <div class="sr-only">
            <.link navigate={~p"/#{@locale}/admins/#{admin}"} class="link">Show</.link>
          </div>
          <.link
            navigate={~p"/#{@locale}/admins/#{admin}/edit"}
            class="button button--sm"
            aria-label={"Edit #{admin.name}"}
          >
            <.heroicon name="hero-pencil-square" />
          </.link>
        </:action>
        <:action :let={{_id, admin}}>
          <.action
            phx-click={JS.push("delete", value: %{id: admin.id})}
            data-confirm="Are you sure?"
            class="button button--sm button--alert"
            aria-label={"Delete #{admin.name}"}
          >
            <.heroicon name="hero-trash" />
          </.action>
        </:action>
      </.data_table>
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
