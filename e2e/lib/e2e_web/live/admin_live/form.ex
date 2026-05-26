defmodule E2eWeb.AdminLive.Form do
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
        <:title>{@page_title}</:title>
        <:subtitle>Use this form to manage admin records in your database.</:subtitle>
        <:actions>
          <.navigate
            to={return_path(@return_to, @admin)}
            type="navigate"
            class="button"
            aria_label="Cancel"
            title="Cancel"
          >
            <.heroicon name="hero-arrow-left" />
            <span class="sr-only">Cancel</span>
          </.navigate>
          <.dialog
            :if={@live_action == :edit}
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
                  class="button button--sm button--ghost"
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

      <.form
        for={@form}
        id={@form.id}
        phx-change="validate"
        phx-submit="save"
      >
        <.native_input field={@form[:name]} type="text" class="native-input">
          <:label>Name</:label>
          <:error :let={msg}>
            <.heroicon name="hero-exclamation-circle" class="icon" />
            {msg}
          </:error>
        </.native_input>

        <.select
          class="select max-w-none"
          field={@form[:country]}
          deselectable
          translation={%Corex.Select.Translation{placeholder: "Select a country"}}
          items={[
            %{label: "France", value: "fra"},
            %{label: "Belgium", value: "bel"},
            %{label: "Germany", value: "deu"}
          ]}
        >
          <:label>
            Your country of residence
          </:label>
          <:trigger>
            <.heroicon name="hero-chevron-down" />
          </:trigger>
          <:error :let={msg}>
            <.heroicon name="hero-exclamation-circle" class="icon" />
            {msg}
          </:error>
        </.select>

        <.combobox
          field={@form[:currency]}
          class="combobox max-w-none"
          placeholder="Search currency"
          items={currency_items()}
        >
          <:label>Preferred currency</:label>
          <:empty>No results</:empty>
          <:item :let={item}>
            <span class="font-mono text-xs uppercase place-self-end">{item.value}</span>
            <span>{item.label}</span>
          </:item>
          <:trigger>
            <.heroicon name="hero-chevron-down" />
          </:trigger>
          <:error :let={msg}>
            <.heroicon name="hero-exclamation-circle" class="icon" />
            {msg}
          </:error>
        </.combobox>

        <.tags_input field={@form[:tags]} class="tags-input max-w-none">
          <:label>Tags</:label>
          <:close>
            <.heroicon name="hero-x-mark" />
          </:close>
          <:error :let={msg}>
            <.heroicon name="hero-exclamation-circle" class="icon" />
            {msg}
          </:error>
        </.tags_input>

        <.date_picker field={@form[:birth_date]} class="date-picker max-w-none">
          <:label>Select a date</:label>
          <:trigger>
            <.heroicon name="hero-calendar" class="icon" />
          </:trigger>
          <:prev_trigger>
            <.heroicon name="hero-chevron-left" class="icon" />
          </:prev_trigger>
          <:next_trigger>
            <.heroicon name="hero-chevron-right" class="icon" />
          </:next_trigger>
          <:error :let={msg}>
            <.heroicon name="hero-exclamation-circle" class="icon" />
            {msg}
          </:error>
        </.date_picker>
        <.signature_pad field={@form[:signature]} class="signature-pad max-w-none">
          <:label>Sign here</:label>
          <:clear_trigger>
            <.heroicon name="hero-x-mark" />
          </:clear_trigger>
          <:error :let={msg}>
            <.heroicon name="hero-exclamation-circle" class="icon" />
            {msg}
          </:error>
        </.signature_pad>
        <.number_input
          field={@form[:level]}
          min={1.0}
          max={5.0}
          step={1.0}
          class="number-input max-w-none"
        >
          <:label>Level</:label>
          <:decrement_trigger>
            <.heroicon name="hero-chevron-down" class="icon" />
          </:decrement_trigger>
          <:increment_trigger>
            <.heroicon name="hero-chevron-up" class="icon" />
          </:increment_trigger>
          <:error :let={msg}>
            <.heroicon name="hero-exclamation-circle" class="icon" />
            {msg}
          </:error>
        </.number_input>
        <.checkbox field={@form[:terms]} class="checkbox">
          <:label>
            Accept the terms
          </:label>
          <:indicator>
            <.heroicon name="hero-check" />
          </:indicator>
          <:error :let={msg}>
            <.heroicon name="hero-exclamation-circle" class="icon" />
            {msg}
          </:error>
        </.checkbox>

        <footer class="flex w-full justify-between gap-2">
          <.navigate to={return_path(@return_to, @admin)} type="navigate" class="button">
            Cancel
          </.navigate>
          <.action phx-disable-with="Saving..." type="submit" class="button button--accent">
            Save Admin
          </.action>
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
    changeset =
      socket.assigns.admin
      |> Accounts.change_admin(admin_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("validate", _params, socket), do: {:noreply, socket}

  def handle_event("save", %{"admin" => admin_params}, socket) do
    save_admin(socket, socket.assigns.live_action, admin_params)
  end

  def handle_event("save", params, socket) do
    admin_params = Map.get(params, "admin", %{})
    save_admin(socket, socket.assigns.live_action, admin_params)
  end

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

  defp save_admin(socket, :edit, admin_params) do
    case Accounts.update_admin(socket.assigns.admin, admin_params) do
      {:ok, admin} ->
        {:noreply,
         socket
         |> put_flash(:info, "Admin updated successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, admin))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
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
        {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
    end
  end

  defp return_path("index", _admin), do: ~p"/admins"
  defp return_path("show", admin), do: ~p"/admins/#{admin}"

  defp currency_items do
    [
      %{value: "eur", label: ~t"Euro"},
      %{value: "usd", label: ~t"US Dollar"},
      %{value: "gbp", label: ~t"British Pound"},
      %{value: "jpy", label: ~t"Japanese Yen"},
      %{value: "chf", label: ~t"Swiss Franc"},
      %{value: "cad", label: ~t"Canadian Dollar"},
      %{value: "aud", label: ~t"Australian Dollar"},
      %{value: "sek", label: ~t"Swedish Krona"},
      %{value: "nok", label: ~t"Norwegian Krone"},
      %{value: "sgd", label: ~t"Singapore Dollar"}
    ]
  end
end
