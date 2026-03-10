defmodule E2eWeb.ColorPickerFormLive do
  use E2eWeb, :live_view

  alias E2e.Form.ColorPickerForm
  alias Corex.Form
  alias Corex.Toast

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Color Picker form")
     |> assign_form()}
  end

  defp assign_form(socket) do
    form =
      %ColorPickerForm{}
      |> ColorPickerForm.changeset(%{})
      |> Phoenix.Component.to_form(as: :color_picker_form, id: "color-picker-form")

    assign(socket, :form, form)
  end

  @impl true
  def handle_event("validate", %{"color_picker_form" => params}, socket) do
    changeset =
      %ColorPickerForm{}
      |> ColorPickerForm.changeset(params)
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(
       :form,
       Phoenix.Component.to_form(changeset,
         action: :validate,
         as: :color_picker_form,
         id: "color-picker-form"
       )
     )}
  end

  @impl true
  def handle_event("color_changed", %{"valueAsString" => value}, socket) do
    params = %{"color" => value}

    changeset =
      %ColorPickerForm{}
      |> ColorPickerForm.changeset(params)
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(
       :form,
       Phoenix.Component.to_form(changeset,
         action: :validate,
         as: :color_picker_form,
         id: "color-picker-form"
       )
     )}
  end

  @impl true
  def handle_event("save", %{"color_picker_form" => params}, socket) do
    case ColorPickerForm.changeset(%ColorPickerForm{}, params) do
      %Ecto.Changeset{valid?: true} = changeset ->
        data = Ecto.Changeset.apply_changes(changeset)
        message = "Submitted: color=#{data.color}"

        {:noreply,
         socket
         |> Toast.push_toast("layout-toast", "Submitted", message, :info, 5000)
         |> assign(
           :form,
           Phoenix.Component.to_form(ColorPickerForm.changeset(%ColorPickerForm{}, params),
             as: :color_picker_form,
             id: "color-picker-form"
           )
         )}

      %Ecto.Changeset{} = changeset ->
        {:noreply,
         socket
         |> assign(
           :form,
           Phoenix.Component.to_form(changeset,
             action: :insert,
             as: :color_picker_form,
             id: "color-picker-form"
           )
         )}
    end
  end

  defp get_color_from_form(form) do
    form.params["color"] ||
      Ecto.Changeset.get_change(form.source, :color) ||
      Ecto.Changeset.get_field(form.source, :color) ||
      "#3b82f6"
  end

  @impl true
  def render(assigns) do
    assigns = assign(assigns, :color_value, get_color_from_form(assigns.form))

    ~H"""
    <Layouts.app
      flash={@flash}
      mode={@mode}
      theme={@theme}
      locale={@locale}
      current_path={@current_path}
    >
      <.layout_heading>
        <:title>Color Picker form</:title>
        <:subtitle>Live View Form</:subtitle>
      </.layout_heading>
      <p>Phoenix form with Ecto changeset and controlled color picker</p>

      <.form
        for={@form}
        id={Form.get_form_id(@form)}
        phx-change="validate"
        phx-submit="save"
      >
        <.color_picker
          id="color-picker-form-color"
          name="color_picker_form[color]"
          value={@color_value}
          controlled
          label="Pick a color"
          presets={["#ff0000", "#00ff00", "#0000ff", "#3b82f6"]}
          on_value_change="color_changed"
          class="color-picker"
        />
        <.action type="submit" id="color-picker-form-live-submit" class="button button--accent">
          Submit
        </.action>
      </.form>
    </Layouts.app>
    """
  end
end
