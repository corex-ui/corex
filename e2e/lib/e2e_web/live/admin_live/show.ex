defmodule E2eWeb.AdminLive.Show do
  use E2eWeb, :live_view

  alias E2e.Accounts

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} mode={@mode} locale={@locale} current_path={@current_path}>
      <.header>
        Admin {@admin.id}
        <:subtitle>This is a admin record from your database.</:subtitle>
        <:actions>
          <.button class="button" navigate={~p"/#{@locale}/admins"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button
            class="button button--accent"
            navigate={~p"/#{@locale}/admins/#{@admin}/edit?return_to=show"}
          >
            <.icon name="hero-pencil-square" /> Edit admin
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Name">{@admin.name}</:item>
        <:item title="Country">{@admin.country}</:item>
        <:item title="Terms">{@admin.terms}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Admin")
     |> assign(:admin, Accounts.get_admin!(id))}
  end
end
