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
  def handle_event("pin_changed", %{"value" => value}, socket) do
    pin = if is_list(value), do: Enum.join(value, ""), else: to_string(value)
    params = %{"pin" => pin}

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
    pin = get_pin_from_form(assigns.form)
    assigns = assign(assigns, :pin_value, pin_to_value_list(pin, 4))

    ~H"""
    <Layouts.app
      flash={@flash}
      mode={@mode}
      theme={@theme}
      locale={@locale}
      current_path={@current_path}
    >
      <.layout_heading>
        <:title>Pin Input form</:title>
        <:subtitle>Live View Form</:subtitle>
      </.layout_heading>
      <p>Phoenix form with Ecto changeset and controlled pin input</p>

      <.form
        for={@form}
        id={Form.get_form_id(@form)}
        phx-change="validate"
        phx-submit="save"
      >
        <.pin_input
          id="pin-input-form-pin"
          name="pin_input_form[pin]"
          value={@pin_value}
          controlled
          count={4}
          on_value_change="pin_changed"
          class="pin-input"
        >
          <:label>Code</:label>
        </.pin_input>
        <.action type="submit" id="pin-input-form-live-submit" class="button button--accent">
          Submit
        </.action>
      </.form>
    </Layouts.app>
    """
  end

  defp get_pin_from_form(form) do
    form.params["pin"] ||
      Ecto.Changeset.get_change(form.source, :pin) ||
      Ecto.Changeset.get_field(form.source, :pin) ||
      ""
  end

  defp pin_to_value_list("", count), do: List.duplicate("", count)

  defp pin_to_value_list(pin, count) do
    graphemes = String.graphemes(pin)
    padded = graphemes ++ List.duplicate("", max(0, count - length(graphemes)))
    Enum.take(padded, count)
  end
end
