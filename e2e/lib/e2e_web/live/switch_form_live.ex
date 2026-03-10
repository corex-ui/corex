defmodule E2eWeb.SwitchFormLive do
  use E2eWeb, :live_view

  alias E2e.Form.Preferences
  alias Corex.Form
  alias Corex.Toast

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Switch form")
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
  def handle_event("save", %{"preferences" => params}, socket) do
    case Preferences.changeset(%Preferences{}, params) do
      %Ecto.Changeset{valid?: true} = changeset ->
        data = Ecto.Changeset.apply_changes(changeset)
        message = "Submitted: notifications=#{data.notifications}"

        {:noreply,
         socket
         |> Toast.push_toast("layout-toast", "Submitted", message, :info, 5000)
         |> assign(
           :form,
           Phoenix.Component.to_form(Preferences.changeset(%Preferences{}, params),
             as: :preferences
           )
         )}

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
      <.layout_heading>
        <:title>Switch form</:title>
        <:subtitle>Live View Form</:subtitle>
      </.layout_heading>
      <p>Phoenix form with Ecto changeset and controlled switch</p>

      <.form
        for={@form}
        id={Form.get_form_id(@form)}
        phx-change="validate"
        phx-submit="save"
      >
        <.switch field={@form[:notifications]} class="switch" controlled>
          <:label>Enable notifications</:label>
          <:error :let={msg}>
            <.heroicon name="hero-exclamation-circle" class="icon" />
            {msg}
          </:error>
        </.switch>
        <.action type="submit" id="switch-form-live-submit" class="button button--accent">
          Submit
        </.action>
      </.form>
    </Layouts.app>
    """
  end
end
