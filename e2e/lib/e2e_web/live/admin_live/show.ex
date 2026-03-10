defmodule E2eWeb.AdminLive.Show do
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
        <:title>Admin {@admin.id}</:title>
        <:subtitle>This is a admin record from your database.</:subtitle>
        <:actions>
          <.navigate
            to={~p"/#{@locale}/admins"}
            type="navigate"
            class="button"
            aria_label={gettext("Previous page")}
          >
            <.heroicon name="hero-arrow-left" />
          </.navigate>
          <.navigate
            to={~p"/#{@locale}/admins/#{@admin}/edit?return_to=show"}
            type="navigate"
            class="button button--accent"
          >
            <.heroicon name="hero-pencil-square" /> Edit admin
          </.navigate>
        </:actions>
      </.layout_heading>

      <.data_list class="data-list">
        <:item title="Name">{@admin.name}</:item>
        <:item title="Country">{@admin.country}</:item>
        <:item title="Terms">{@admin.terms}</:item>
      </.data_list>
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
