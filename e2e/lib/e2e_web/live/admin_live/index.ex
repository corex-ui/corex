defmodule E2eWeb.AdminLive.Index do
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
        <:title>Listing Admins</:title>
        <:subtitle>Add and manage admin records</:subtitle>
        <:actions>
          <.navigate
            to={~p"/admins/new"}
            type="navigate"
            class="button button--accent button--square"
            aria_label="New admin"
            title="New admin"
          >
            <.heroicon name="hero-plus" />
            <span class="sr-only">New admin</span>
          </.navigate>
        </:actions>
      </.layout_heading>
      <.data_table
        id="admins"
        class="data-table max-w-none"
        rows={@streams.admins}
        row_click={fn {_id, admin} -> JS.navigate(~p"/admins/#{admin}") end}
      >
        <:empty>No admins yet.</:empty>
        <:col
          :let={{_id, admin}}
          :for={field <- @fields}
          label={label(field)}
        >
          <.record_field_value record={admin} field={field} />
        </:col>
        <:action :let={{_id, admin}}>
          <div class="sr-only">
            <.navigate to={~p"/admins/#{admin}"} type="navigate" class="link">Show</.navigate>
          </div>
          <.navigate
            to={~p"/admins/#{admin}/edit"}
            type="navigate"
            class="button button--sm button--square"
            aria_label={"Edit #{admin.name}"}
          >
            <.heroicon name="hero-pencil-square" />
          </.navigate>
        </:action>
        <:action :let={{_id, admin}}>
          <.dialog
            id={"admin-delete-#{admin.id}"}
            class="dialog"
            role="alertdialog"
            modal
            close_on_interact_outside={false}
            initial_focus={"admin-delete-#{admin.id}-cancel"}
            final_focus={"dialog:admin-delete-#{admin.id}:trigger"}
          >
            <:trigger
              class="button button--sm button--alert button--square"
              aria_label={"Delete #{admin.name}"}
            >
              <.heroicon name="hero-trash" />
            </:trigger>
            <:title>Delete admin?</:title>
            <:description>This action cannot be undone.</:description>
            <:content>
              <div class="flex flex-wrap justify-end gap-2 mt-4">
                <.action
                  id={"admin-delete-#{admin.id}-cancel"}
                  phx-click={Corex.Dialog.set_open("admin-delete-#{admin.id}", false)}
                  class="button button--sm button--variant-ghost"
                >
                  Cancel
                </.action>
                <.action
                  id={"admin-delete-#{admin.id}-confirm"}
                  phx-click={
                    Corex.Dialog.set_open("admin-delete-#{admin.id}", false)
                    |> JS.push("delete", value: %{id: admin.id})
                  }
                  class="button button--sm button--alert"
                >
                  Delete
                </.action>
              </div>
            </:content>
          </.dialog>
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
     |> assign(:fields, Admin.__schema__(:fields) |> Enum.sort())
     |> stream(:admins, list_admins())}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    admin = Accounts.get_admin!(id)

    case Accounts.delete_admin(admin) do
      {:ok, _admin} ->
        {:noreply, stream_delete(socket, :admins, admin)}

      {:error, _changeset} ->
        {:noreply, put_flash(socket, :error, "Could not delete admin.")}
    end
  end

  defp list_admins do
    Accounts.list_admins()
  end
end
