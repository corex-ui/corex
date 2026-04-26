defmodule E2eWeb.PinInputFormLive do
  use E2eWeb, :live_view

  alias E2e.Form.PinInputForm
  alias Corex.Form
  alias Corex.Toast

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Pin Input form")
     |> assign_form()}
  end

  defp assign_form(socket) do
    form =
      %PinInputForm{}
      |> PinInputForm.changeset(%{})
      |> Phoenix.Component.to_form(as: :pin_input_form, id: "pin-input-form")

    assign(socket, :form, form)
  end

  @impl true
  def handle_event("validate", event_params, socket) do
    params = Map.get(event_params, "pin_input_form", %{})

    changeset =
      %PinInputForm{}
      |> PinInputForm.changeset(params)
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(
       :form,
       Phoenix.Component.to_form(changeset,
         action: :validate,
         as: :pin_input_form,
         id: "pin-input-form"
       )
     )}
  end

  @impl true
  def handle_event("save", event_params, socket) do
    params = Map.get(event_params, "pin_input_form", %{})

    case PinInputForm.changeset(%PinInputForm{}, params) do
      %Ecto.Changeset{valid?: true} = changeset ->
        data = Ecto.Changeset.apply_changes(changeset)
        message = "Submitted: pin=#{data.pin}"

        {:noreply,
         socket
         |> Toast.push_toast("layout-toast", "Submitted", message, :info, 5000)
         |> assign(
           :form,
           Phoenix.Component.to_form(PinInputForm.changeset(%PinInputForm{}, %{}),
             as: :pin_input_form,
             id: "pin-input-form"
           )
         )}

      %Ecto.Changeset{} = changeset ->
        {:noreply,
         socket
         |> assign(
           :form,
           Phoenix.Component.to_form(changeset,
             action: :insert,
             as: :pin_input_form,
             id: "pin-input-form"
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
      path={@path}
    >
      <article id="pin-input-form-live-page" class="w-full flex flex-col gap-4">
        <.layout_heading>
          <:title>Pin Input form</:title>
          <:subtitle>Live View Form</:subtitle>
        </.layout_heading>
        <p>
          Phoenix form with Ecto changeset. The pin input updates its hidden field for phx-change.
        </p>

        <.form
          for={@form}
          id={Form.get_form_id(@form)}
          phx-change="validate"
          phx-submit="save"
        >
          <.pin_input
            id="pin-input-form-pin"
            name="pin_input_form[pin]"
            count={4}
            class="pin-input"
          >
            <:label>Code</:label>
          </.pin_input>
          <.action type="submit" id="pin-input-form-live-submit" class="button button--accent">
            Submit
          </.action>
        </.form>
      </article>
    </Layouts.app>
    """
  end
end
