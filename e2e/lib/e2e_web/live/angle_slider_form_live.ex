defmodule E2eWeb.AngleSliderFormLive do
  use E2eWeb, :live_view

  alias E2e.Form.AngleSliderForm
  alias Corex.Form
  alias Corex.Toast

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Angle Slider form")
     |> assign_form()}
  end

  defp assign_form(socket) do
    form =
      %AngleSliderForm{}
      |> AngleSliderForm.changeset(%{})
      |> Phoenix.Component.to_form(as: :angle_slider_form, id: "angle-slider-form")

    assign(socket, :form, form)
  end

  @impl true
  def handle_event("validate", %{"angle_slider_form" => params}, socket) do
    changeset =
      %AngleSliderForm{}
      |> AngleSliderForm.changeset(params)
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(
       :form,
       Phoenix.Component.to_form(changeset,
         action: :validate,
         as: :angle_slider_form,
         id: "angle-slider-form"
       )
     )}
  end

  @impl true
  def handle_event("angle_changed", %{"value" => value}, socket) do
    angle = parse_float(value)
    params = %{"angle" => to_string(angle)}

    changeset =
      %AngleSliderForm{}
      |> AngleSliderForm.changeset(params)
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(
       :form,
       Phoenix.Component.to_form(changeset,
         action: :validate,
         as: :angle_slider_form,
         id: "angle-slider-form"
       )
     )}
  end

  @impl true
  def handle_event("save", %{"angle_slider_form" => params}, socket) do
    case AngleSliderForm.changeset(%AngleSliderForm{}, params) do
      %Ecto.Changeset{valid?: true} = changeset ->
        data = Ecto.Changeset.apply_changes(changeset)
        message = "Submitted: angle=#{data.angle}"

        {:noreply,
         socket
         |> Toast.push_toast("layout-toast", "Submitted", message, :info, 5000)
         |> assign(
           :form,
           Phoenix.Component.to_form(AngleSliderForm.changeset(%AngleSliderForm{}, params),
             as: :angle_slider_form,
             id: "angle-slider-form"
           )
         )}

      %Ecto.Changeset{} = changeset ->
        {:noreply,
         socket
         |> assign(
           :form,
           Phoenix.Component.to_form(changeset,
             action: :insert,
             as: :angle_slider_form,
             id: "angle-slider-form"
           )
         )}
    end
  end

  defp parse_float(value) when is_binary(value) do
    case Float.parse(value) do
      {num, _} -> num
      :error -> 0.0
    end
  end

  defp parse_float(value) when is_number(value), do: value * 1.0

  @impl true
  def render(assigns) do
    assigns = assign(assigns, :angle_value, get_angle_from_form(assigns.form))

    ~H"""
    <Layouts.app
      flash={@flash}
      mode={@mode}
      theme={@theme}
      locale={@locale}
      current_path={@current_path}
    >
      <.layout_heading>
        <:title>Angle Slider form</:title>
        <:subtitle>Live View Form</:subtitle>
      </.layout_heading>
      <p>Phoenix form with Ecto changeset and controlled angle slider</p>

      <.form
        for={@form}
        id={Form.get_form_id(@form)}
        phx-change="validate"
        phx-submit="save"
      >
        <.angle_slider
          id="angle-slider-form-angle"
          name="angle_slider_form[angle]"
          value={@angle_value}
          controlled
          marker_values={[0, 90, 180, 270]}
          on_value_change="angle_changed"
          class="angle-slider"
        >
          <:label>Angle</:label>
        </.angle_slider>
        <.action type="submit" id="angle-slider-form-live-submit" class="button button--accent">
          Submit
        </.action>
      </.form>
    </Layouts.app>
    """
  end

  defp get_angle_from_form(form) do
    raw =
      form.params["angle"] ||
        Ecto.Changeset.get_change(form.source, :angle) ||
        Ecto.Changeset.get_field(form.source, :angle)

    case raw do
      nil ->
        0.0

      "" ->
        0.0

      val when is_binary(val) ->
        case Float.parse(val) do
          {num, _} -> num
          :error -> 0.0
        end

      val when is_number(val) ->
        val * 1.0
    end
  end
end
