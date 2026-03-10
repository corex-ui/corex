defmodule E2eWeb.DatePickerFormLive do
  use E2eWeb, :live_view

  alias E2e.Form.DatePickerForm
  alias Corex.Form
  alias Corex.Toast

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Date Picker form")
     |> assign_form()}
  end

  defp assign_form(socket) do
    form =
      %DatePickerForm{}
      |> DatePickerForm.changeset(%{})
      |> Phoenix.Component.to_form(as: :date_picker_form, id: "date-picker-form")

    assign(socket, :form, form)
  end

  @impl true
  def handle_event("validate", event_params, socket) do
    params = Map.get(event_params, "date_picker_form", %{})

    changeset =
      %DatePickerForm{}
      |> DatePickerForm.changeset(params)
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(
       :form,
       Phoenix.Component.to_form(changeset,
         action: :validate,
         as: :date_picker_form,
         id: "date-picker-form"
       )
     )}
  end

  @impl true
  def handle_event("date_changed", %{"value" => value}, socket) do
    params = %{"date" => value}

    changeset =
      %DatePickerForm{}
      |> DatePickerForm.changeset(params)
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(
       :form,
       Phoenix.Component.to_form(changeset,
         action: :validate,
         as: :date_picker_form,
         id: "date-picker-form"
       )
     )}
  end

  @impl true
  def handle_event("save", event_params, socket) do
    params = Map.get(event_params, "date_picker_form", %{})

    case DatePickerForm.changeset(%DatePickerForm{}, params) do
      %Ecto.Changeset{valid?: true} = changeset ->
        data = Ecto.Changeset.apply_changes(changeset)
        message = "Submitted: date=#{data.date}"

        {:noreply,
         socket
         |> Toast.push_toast("layout-toast", "Submitted", message, :info, 5000)
         |> assign(
           :form,
           Phoenix.Component.to_form(DatePickerForm.changeset(%DatePickerForm{}, params),
             as: :date_picker_form,
             id: "date-picker-form"
           )
         )}

      %Ecto.Changeset{} = changeset ->
        {:noreply,
         socket
         |> assign(
           :form,
           Phoenix.Component.to_form(changeset,
             action: :insert,
             as: :date_picker_form,
             id: "date-picker-form"
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
        <:title>Date Picker form</:title>
        <:subtitle>Live View Form</:subtitle>
      </.layout_heading>
      <p>Phoenix form with Ecto changeset and controlled date picker</p>

      <.form
        for={@form}
        id={Form.get_form_id(@form)}
        phx-change="validate"
        phx-submit="save"
      >
        <.date_picker
          id="date-picker-form-date"
          field={@form[:date]}
          controlled
          trigger_aria_label="Select date"
          input_aria_label="Select date"
          on_value_change="date_changed"
          class="date-picker"
        >
          <:label>Date</:label>
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
        <.action type="submit" id="date-picker-form-live-submit" class="button button--accent">
          Submit
        </.action>
      </.form>
    </Layouts.app>
    """
  end
end
