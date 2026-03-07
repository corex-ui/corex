defmodule E2eWeb.CheckboxFormLive do
  use E2eWeb, :live_view

  alias E2e.Form.Preferences
  alias Corex.Form

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Checkbox form")
     |> assign(:submitted, nil)
     |> assign_form()}
  end

  defp assign_form(socket) do
    form =
      %Preferences{}
      |> Preferences.changeset(%{})
      |> Phoenix.Component.to_form(as: :preferences)

    assign(socket, :form, form)
  end

  @impl true
  def handle_event("validate", %{"preferences" => params}, socket) do
    changeset =
      %Preferences{}
      |> Preferences.changeset(params)
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(:form, Phoenix.Component.to_form(changeset, action: :validate, as: :preferences))}
  end

  @impl true
  def handle_event("set_terms_checked", _params, socket) do
    form =
      %Preferences{}
      |> Preferences.changeset(%{"terms" => "true", "notifications" => "false"})
      |> Phoenix.Component.to_form(as: :preferences)

    {:noreply,
     socket
     |> assign(:form, form)
     |> push_event("checkbox_set_checked", %{id: "checkbox-form-terms", checked: true})}
  end

  @impl true
  def handle_event("save", %{"preferences" => params}, socket) do
    case Preferences.changeset(%Preferences{}, params) do
      %Ecto.Changeset{valid?: true} = changeset ->
        data = Ecto.Changeset.apply_changes(changeset)

        {:noreply,
         socket
         |> assign(:submitted, %{terms: data.terms})
         |> assign(:form, Phoenix.Component.to_form(Preferences.changeset(%Preferences{}, params), as: :preferences))}

      %Ecto.Changeset{} = changeset ->
        {:noreply,
         socket
         |> assign(:form, Phoenix.Component.to_form(changeset, action: :insert, as: :preferences))}
    end
  end

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
      <h1>Checkbox form (LiveView)</h1>
      <p>Phoenix form with Ecto changeset and controlled checkbox</p>

      <.form
        for={@form}
        id={Form.get_form_id(@form)}
        phx-change="validate"
        phx-submit="save"
      >
        <.checkbox field={@form[:terms]} class="checkbox" controlled id="checkbox-form-terms">
          <:label>Accept terms</:label>
          <:error :let={msg}>
            <.icon name="hero-exclamation-circle" class="icon" />
            {msg}
          </:error>
        </.checkbox>
        <.switch field={@form[:notifications]} class="switch" controlled>
          <:label>Enable notifications</:label>
          <:error :let={msg}>
            <.icon name="hero-exclamation-circle" class="icon" />
            {msg}
          </:error>
        </.switch>
        <.action type="button" phx-click="set_terms_checked" id="checkbox-form-set-checked" class="button button--sm">
          Set checked from server
        </.action>
        <.action type="submit" id="checkbox-form-live-submit" class="button button--accent">Submit</.action>
      </.form>

      <div :if={@submitted} id="checkbox-form-result">
        <p>Submitted: terms=<%= @submitted.terms %></p>
      </div>
    </Layouts.app>
    """
  end
end
