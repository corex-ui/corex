defmodule E2eWeb.RadioGroupFormLive do
  use E2eWeb, :live_view

  alias E2e.Form.RadioGroupForm
  alias Corex.Form
  alias Corex.Toast

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Radio Group form")
     |> assign_form()}
  end

  defp assign_form(socket) do
    form =
      %RadioGroupForm{}
      |> RadioGroupForm.changeset(%{})
      |> Phoenix.Component.to_form(as: :radio_group_form, id: "radio-group-form")

    assign(socket, :form, form)
  end

  @impl true
  def handle_event("validate", event_params, socket) do
    params = Map.get(event_params, "radio_group_form", %{})

    changeset =
      %RadioGroupForm{}
      |> RadioGroupForm.changeset(params)
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(
       :form,
       Phoenix.Component.to_form(changeset,
         action: :validate,
         as: :radio_group_form,
         id: "radio-group-form"
       )
     )}
  end

  @impl true
  def handle_event("choice_changed", %{"value" => value}, socket) do
    params = %{"choice" => value}

    changeset =
      %RadioGroupForm{}
      |> RadioGroupForm.changeset(params)
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(
       :form,
       Phoenix.Component.to_form(changeset,
         action: :validate,
         as: :radio_group_form,
         id: "radio-group-form"
       )
     )}
  end

  @impl true
  def handle_event("save", event_params, socket) do
    params = Map.get(event_params, "radio_group_form", %{})

    case RadioGroupForm.changeset(%RadioGroupForm{}, params) do
      %Ecto.Changeset{valid?: true} = changeset ->
        data = Ecto.Changeset.apply_changes(changeset)
        message = "Submitted: choice=#{data.choice}"

        {:noreply,
         socket
         |> Toast.push_toast("layout-toast", "Submitted", message, :info, 5000)
         |> assign(
           :form,
           Phoenix.Component.to_form(RadioGroupForm.changeset(%RadioGroupForm{}, params),
             as: :radio_group_form,
             id: "radio-group-form"
           )
         )}

      %Ecto.Changeset{} = changeset ->
        {:noreply,
         socket
         |> assign(
           :form,
           Phoenix.Component.to_form(changeset,
             action: :insert,
             as: :radio_group_form,
             id: "radio-group-form"
           )
         )}
    end
  end

  @impl true
  def render(assigns) do
    assigns = assign(assigns, :choice_value, get_choice_from_form(assigns.form))

    ~H"""
    <Layouts.app
      flash={@flash}
      mode={@mode}
      theme={@theme}
      locale={@locale}
      current_path={@current_path}
    >
      <.layout_heading>
        <:title>Radio Group form</:title>
        <:subtitle>Live View Form</:subtitle>
      </.layout_heading>
      <p>Phoenix form with Ecto changeset and controlled radio group</p>

      <.form
        for={@form}
        id={Form.get_form_id(@form)}
        phx-change="validate"
        phx-submit="save"
      >
        <.radio_group
          id="radio-group-form-choice"
          name="radio_group_form[choice]"
          value={@choice_value}
          controlled
          items={[
            %{value: "a", label: "Option A"},
            %{value: "b", label: "Option B"},
            %{value: "c", label: "Option C"}
          ]}
          on_value_change="choice_changed"
          class="radio-group"
        >
          <:label>Choose one</:label>
          <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
        </.radio_group>
        <.action type="submit" id="radio-group-form-live-submit" class="button button--accent">
          Submit
        </.action>
      </.form>
    </Layouts.app>
    """
  end

  defp get_choice_from_form(form) do
    form.params["choice"] ||
      Ecto.Changeset.get_change(form.source, :choice) ||
      Ecto.Changeset.get_field(form.source, :choice) ||
      nil
  end
end
