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
      |> NumberInputForm.changeset(%{"value" => "0"})
      |> Phoenix.Component.to_form(as: :number_input_form, id: "number-input-form")

    assign(socket, :form, form)
  end

  @impl true
  def handle_event("validate", %{"number_input_form" => params}, socket) do
    changeset =
      %NumberInputForm{}
      |> NumberInputForm.changeset(params)
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(:form, Phoenix.Component.to_form(changeset, action: :validate, as: :number_input_form, id: "number-input-form"))}
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
     |> assign(:form, Phoenix.Component.to_form(changeset, action: :validate, as: :number_input_form, id: "number-input-form"))}
  end

  @impl true
  def handle_event("save", %{"number_input_form" => params}, socket) do
    case NumberInputForm.changeset(%NumberInputForm{}, params) do
      %Ecto.Changeset{valid?: true} = changeset ->
        data = Ecto.Changeset.apply_changes(changeset)
        message = "Submitted: value=#{data.value}"

        {:noreply,
         socket
         |> Toast.push_toast("layout-toast", "Submitted", message, :info, 5000)
         |> assign(:form, Phoenix.Component.to_form(NumberInputForm.changeset(%NumberInputForm{}, params), as: :number_input_form, id: "number-input-form"))}

      %Ecto.Changeset{} = changeset ->
        {:noreply,
         socket
         |> assign(:form, Phoenix.Component.to_form(changeset, action: :insert, as: :number_input_form, id: "number-input-form"))}
    end
  end

  @impl true
  def render(assigns) do
    assigns = assign(assigns, :number_value, get_value_from_form(assigns.form))

    ~H"""
    <Layouts.app
      flash={@flash}
      mode={@mode}
      theme={@theme}
      locale={@locale}
      current_path={@current_path}
    >
      <h1>Number Input form (LiveView)</h1>
      <p>Phoenix form with Ecto changeset and controlled number input</p>

      <.form
        for={@form}
        id={Form.get_form_id(@form)}
        phx-change="validate"
        phx-submit="save"
      >
        <.number_input
          id="number-input-form-value"
          name="number_input_form[value]"
          value={@number_value}
          controlled
          on_value_change="value_changed"
          class="number-input"
        >
          <:label>Value</:label>
          <:decrement_trigger>
            <.icon name="hero-chevron-down" class="icon" />
          </:decrement_trigger>
          <:increment_trigger>
            <.icon name="hero-chevron-up" class="icon" />
          </:increment_trigger>
        </.number_input>
        <.action type="submit" id="number-input-form-live-submit" class="button button--accent">
          Submit
        </.action>
      </.form>
    </Layouts.app>
    """
  end

  defp get_value_from_form(form) do
    raw =
      form.params["value"] ||
        Ecto.Changeset.get_change(form.source, :value) ||
        Ecto.Changeset.get_field(form.source, :value)

    case raw do
      nil -> "0"
      "" -> "0"
      val when is_number(val) -> to_string(val)
      val when is_binary(val) -> val
    end
  end
end
