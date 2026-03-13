defmodule E2eWeb.PasswordInputFormLive do
  use E2eWeb, :live_view

  alias E2e.Form.PasswordInputForm
  alias Corex.Form
  alias Corex.Toast

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Password Input form")
     |> assign_form()}
  end

  defp assign_form(socket) do
    form =
      %PasswordInputForm{}
      |> PasswordInputForm.changeset(%{})
      |> Phoenix.Component.to_form(as: :password_input_form, id: "password-input-form")

    assign(socket, :form, form)
  end

  @impl true
  def handle_event("validate", event_params, socket) do
    params = Map.get(event_params, "password_input_form", %{})

    changeset =
      %PasswordInputForm{}
      |> PasswordInputForm.changeset(params)
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(
       :form,
       Phoenix.Component.to_form(changeset,
         action: :validate,
         as: :password_input_form,
         id: "password-input-form"
       )
     )}
  end

  @impl true
  def handle_event("save", event_params, socket) do
    params = Map.get(event_params, "password_input_form", %{})

    case PasswordInputForm.changeset(%PasswordInputForm{}, params) do
      %Ecto.Changeset{valid?: true} ->
        message = "Submitted: password=***"

        {:noreply,
         socket
         |> Toast.push_toast("layout-toast", "Submitted", message, :info, 5000)
         |> assign(
           :form,
           Phoenix.Component.to_form(PasswordInputForm.changeset(%PasswordInputForm{}, %{}),
             as: :password_input_form,
             id: "password-input-form"
           )
         )}

      %Ecto.Changeset{} = changeset ->
        {:noreply,
         socket
         |> assign(
           :form,
           Phoenix.Component.to_form(changeset,
             action: :insert,
             as: :password_input_form,
             id: "password-input-form"
           )
         )}
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
        <:title>Password Input form</:title>
        <:subtitle>Live View Form</:subtitle>
      </.layout_heading>
      <p>Phoenix form with Ecto changeset</p>

      <.form
        for={@form}
        id={Form.get_form_id(@form)}
        phx-change="validate"
        phx-submit="save"
      >
        <.password_input
          field={@form[:password]}
          id="password-input-form-password"
          class="password-input"
        >
          <:label>Password</:label>
          <:visible_indicator><.heroicon name="hero-eye" class="icon" /></:visible_indicator>
          <:hidden_indicator><.heroicon name="hero-eye-slash" class="icon" /></:hidden_indicator>
        </.password_input>
        <.action type="submit" id="password-input-form-live-submit" class="button button--accent">
          Submit
        </.action>
      </.form>
    </Layouts.app>
    """
  end
end
