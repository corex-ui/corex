defmodule E2eWeb.NumberInputFormLive do
  use E2eWeb, :live_view

  alias E2e.Form.NumberInputForm
  alias Corex.Form
  alias Corex.Toast

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Number Input form")
     |> assign_form()}
  end

  defp assign_form(socket) do
    form =
      %NumberInputForm{}
      |> NumberInputForm.changeset(%{"value" => "1234"})
      |> Phoenix.Component.to_form(as: :number_input_form, id: "number-input-form")

    assign(socket, :form, form)
  end

  @impl true
  def handle_event("validate", event_params, socket) do
    params =
      Map.get(event_params, "number_input_form") ||
        socket.assigns.form.params

    changeset =
      %NumberInputForm{}
      |> NumberInputForm.changeset(params)
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(
       :form,
       Phoenix.Component.to_form(changeset,
         action: :validate,
         as: :number_input_form,
         id: "number-input-form"
       )
     )}
  end

  @impl true
  def handle_event("value_changed", %{"value" => value}, socket) do
    params = %{"value" => value}

    changeset =
      %NumberInputForm{}
      |> NumberInputForm.changeset(params)
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(
       :form,
       Phoenix.Component.to_form(changeset,
         action: :validate,
         as: :number_input_form,
         id: "number-input-form"
       )
     )}
  end

  @impl true
  def handle_event("save", event_params, socket) do
    params =
      Map.get(event_params, "number_input_form") ||
        socket.assigns.form.params

    case NumberInputForm.changeset(%NumberInputForm{}, params) do
      %Ecto.Changeset{valid?: true} = changeset ->
        data = Ecto.Changeset.apply_changes(changeset)
        message = "Submitted: value=#{data.value}"

        {:noreply,
         socket
         |> Toast.push_toast("layout-toast", "Submitted", message, :info, 5000)
         |> assign(
           :form,
           Phoenix.Component.to_form(NumberInputForm.changeset(%NumberInputForm{}, params),
             as: :number_input_form,
             id: "number-input-form"
           )
         )}

      %Ecto.Changeset{} = changeset ->
        {:noreply,
         socket
         |> assign(
           :form,
           Phoenix.Component.to_form(changeset,
             action: :insert,
             as: :number_input_form,
             id: "number-input-form"
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
        <:title>Number Input form</:title>
        <:subtitle>Live View Form</:subtitle>
      </.layout_heading>
      <p>Phoenix form with Ecto changeset and controlled number input (field=)</p>

      <.form
        for={@form}
        id={Form.get_form_id(@form)}
        phx-change="validate"
        phx-submit="save"
      >
        <.number_input
          field={@form[:value]}
          id="number-input-form-value"
          controlled
          on_value_change="value_changed"
          class="number-input"
        >
          <:label>Value</:label>
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
        <.action type="submit" id="number-input-form-live-submit" class="button button--accent">
          Submit
        </.action>
      </.form>
    </Layouts.app>
    """
  end
end
