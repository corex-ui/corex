defmodule E2eWeb.AdminLive.Form do
  use E2eWeb, :live_view

  alias E2e.Accounts
  alias E2e.Accounts.Admin

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} mode={@mode}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage admin records in your database.</:subtitle>
      </.header>

      <.form
        for={@form}
        id={get_form_id(@form)}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />

        <.select
          class="select"
          field={@form[:country]}
          controlled
          placeholder="Select a country"
          collection={[
            %{label: "France", id: "fra"},
            %{label: "Belgium", id: "bel"},
            %{label: "Germany", id: "deu"}
          ]}
        >
          <:label>
            Your country of residence
          </:label>
          <:trigger>
            <.icon name="hero-chevron-down" />
          </:trigger>
          <:error :let={msg}>
            <.icon name="hero-exclamation-circle" class="icon" />
            {msg}
          </:error>
        </.select>

        <.date_picker field={@form[:birth_date]} class="date-picker" controlled>
          <:label>Select a date</:label>
          <:trigger>
            <.icon name="hero-calendar" class="icon" />
          </:trigger>
          <:prev_trigger>
            <.icon name="hero-chevron-left" class="icon" />
          </:prev_trigger>
          <:next_trigger>
            <.icon name="hero-chevron-right" class="icon" />
          </:next_trigger>
          <:error :let={msg}>
            <.icon name="hero-exclamation-circle" class="icon" />
            {msg}
          </:error>
        </.date_picker>
        <.signature_pad field={@form[:signature]} class="signature-pad" controlled>
        <:label>Sign here</:label>
        <:clear_trigger>
          <.icon name="hero-x-mark" />
        </:clear_trigger>
            <:error :let={msg}>
          <.icon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.signature_pad>
        <.checkbox field={@form[:terms]} class="checkbox" controlled>
          <:label>
            Accept the terms
          </:label>
          <:control>
            <.icon name="hero-check" class="data-checked" />
          </:control>
          <:error :let={msg}>
            <.icon name="hero-exclamation-circle" class="icon" />
            {msg}
          </:error>
        </.checkbox>

        <footer class="flex w-full justify-between gap-ui-gap">
          <.button navigate={return_path(@return_to, @admin)} class="button">Cancel</.button>
          <.button phx-disable-with="Saving..." class="button button--accent ">Save Admin</.button>
        </footer>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, %{"id" => id}) do
    admin = Accounts.get_admin!(id)

    socket
    |> assign(:page_title, "Edit Admin")
    |> assign(:admin, admin)
    |> assign(:form, to_form(Accounts.change_admin(admin)))
  end

  defp apply_action(socket, :new, _params) do
    admin = %Admin{}

    socket
    |> assign(:page_title, "New Admin")
    |> assign(:admin, admin)
    |> assign(:form, to_form(Accounts.change_admin(admin)))
  end

  @impl true
  def handle_event("validate", %{"admin" => admin_params}, socket) do
    changeset = Accounts.change_admin(socket.assigns.admin, admin_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"admin" => admin_params}, socket) do
    save_admin(socket, socket.assigns.live_action, admin_params)
  end

  defp save_admin(socket, :edit, admin_params) do
    case Accounts.update_admin(socket.assigns.admin, admin_params) do
      {:ok, admin} ->
        {:noreply,
         socket
         |> put_flash(:info, "Admin updated successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, admin))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_admin(socket, :new, admin_params) do
    case Accounts.create_admin(admin_params) do
      {:ok, admin} ->
        {:noreply,
         socket
         |> put_flash(:info, "Admin created successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, admin))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path("index", _admin), do: ~p"/admins"
  defp return_path("show", admin), do: ~p"/admins/#{admin}"
end
