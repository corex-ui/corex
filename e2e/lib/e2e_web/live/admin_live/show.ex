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
            class="button"
            aria_label="Back to list"
            title="Back to list"
          >
            <.heroicon name="hero-arrow-left" />
          </.navigate>
          <.navigate
            to={~p"/admins/#{@admin}/edit?return_to=show"}
            type="navigate"
            class="button button--accent button--square"
            aria_label="Edit admin"
            title="Edit admin"
          >
            <.heroicon name="hero-pencil-square" />
            <span class="sr-only">Edit admin</span>
          </.navigate>
          <.dialog
            id={"admin-delete-#{@admin.id}"}
            class="dialog"
            role="alertdialog"
            modal
            close_on_interact_outside={false}
            initial_focus={"admin-delete-#{@admin.id}-cancel"}
            final_focus={"dialog:admin-delete-#{@admin.id}:trigger"}
          >
            <:trigger
              class="button button--alert button--square"
              aria_label="Delete admin"
              title="Delete admin"
            >
              <.heroicon name="hero-trash" />
            </:trigger>
            <:title>Delete admin?</:title>
            <:description>This action cannot be undone.</:description>
            <:content>
              <div class="flex flex-wrap justify-end gap-2 mt-4">
                <.action
                  id={"admin-delete-#{@admin.id}-cancel"}
                  phx-click={Corex.Dialog.set_open("admin-delete-#{@admin.id}", false)}
                  class="button button--sm button--variant-ghost"
                >
                  Cancel
                </.action>
                <.action
                  id={"admin-delete-#{@admin.id}-confirm"}
                  phx-click={
                    Corex.Dialog.set_open("admin-delete-#{@admin.id}", false)
                    |> JS.push("delete", value: %{id: @admin.id})
                  }
                  class="button button--sm button--alert"
                >
                  Delete
                </.action>
              </div>
            </:content>
          </.dialog>
        </:actions>
      </.layout_heading>

      <.data_list class="data-list max-w-md">
        <:label :for={field <- @fields} value={Atom.to_string(field)}>
          {label(field)}
        </:label>
        <:content :for={field <- @fields} value={Atom.to_string(field)}>
          <.record_field_value record={@admin} field={field} />
        </:content>
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

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    admin = Accounts.get_admin!(id)

    case Accounts.delete_admin(admin) do
      {:ok, _admin} ->
        {:noreply,
         socket
         |> put_flash(:info, "Admin deleted successfully")
         |> push_navigate(to: ~p"/admins")}

      {:error, _changeset} ->
        {:noreply, put_flash(socket, :error, "Could not delete admin.")}
    end
  end
end
