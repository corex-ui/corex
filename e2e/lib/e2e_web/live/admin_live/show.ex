defmodule E2eWeb.AdminLive.Show do
  use E2eWeb, :live_view

  alias E2e.Accounts
  alias E2e.Accounts.Admin

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app
      flash={@flash}
      mode={@mode}
      theme={@theme}
      path={@path}
    >
      <.layout_heading class="layout-heading">
        <:title>Admin {@admin.id}</:title>
        <:subtitle>This is a admin record from your database.</:subtitle>
        <:actions>
          <.navigate
            to={~p"/admins"}
            type="navigate"
            class="button button--sm button--square"
            aria_label={gettext("Previous page")}
          >
            <.heroicon name="hero-arrow-left" />
          </.navigate>
          <.navigate
            to={~p"/admins/#{@admin}/edit?return_to=show"}
            type="navigate"
            class="button button--accent button--sm"
          >
            <.heroicon name="hero-pencil-square" /> Edit admin
          </.navigate>
        </:actions>
      </.layout_heading>

      <.data_list class="data-list max-w-none">
        <:item :for={field <- @fields} title={label(field)}>
          <.record_field_value record={@admin} field={field} />
        </:item>
      </.data_list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Admin")
     |> assign(:fields, Admin.__schema__(:fields) |> Enum.sort())
     |> assign(:admin, Accounts.get_admin!(id))}
  end
end
