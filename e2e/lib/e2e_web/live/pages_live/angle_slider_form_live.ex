defmodule E2eWeb.AngleSliderFormLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias Corex.Toast
  alias E2e.Form.AngleSliderForm
  alias E2eWeb.Demos.AngleSliderDemo

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Angle Slider form")
     |> assign(:form_ecto, AngleSliderDemo.form_ecto())
     |> assign(:live_basic_heex, AngleSliderDemo.form_doc_live_changeset_heex())
     |> assign(:live_basic_elixir, AngleSliderDemo.form_doc_live_changeset_elixir())
     |> assign(:live_validate_heex, AngleSliderDemo.form_doc_live_validate_heex())
     |> assign(:live_validate_elixir, AngleSliderDemo.form_doc_live_validate_elixir())
     |> assign_forms()}
  end

  defp assign_forms(socket) do
    basic_form =
      %AngleSliderForm{}
      |> AngleSliderForm.changeset(%{})
      |> Phoenix.Component.to_form(as: :angle_slider_basic, id: "angle-slider-basic-form")

    validate_form =
      %AngleSliderForm{}
      |> AngleSliderForm.changeset_validate(%{})
      |> Phoenix.Component.to_form(
        as: :angle_slider_validate,
        id: "angle-slider-validate-form-live"
      )

    socket
    |> assign(:basic_form, basic_form)
    |> assign(:validate_form, validate_form)
  end

  @impl true
  def handle_event("validate_basic", params, socket) do
    rparams = Map.get(params, "angle_slider_basic", %{})

    changeset =
      %AngleSliderForm{}
      |> AngleSliderForm.changeset(rparams)
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(
       :basic_form,
       Phoenix.Component.to_form(changeset,
         action: :validate,
         as: :angle_slider_basic,
         id: "angle-slider-basic-form"
       )
     )}
  end

  @impl true
  def handle_event("angle_changed_basic", %{"value" => value}, socket) do
    angle = parse_float(value)
    params = %{"angle" => to_string(angle)}

    changeset =
      %AngleSliderForm{}
      |> AngleSliderForm.changeset(params)
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(
       :basic_form,
       Phoenix.Component.to_form(changeset,
         action: :validate,
         as: :angle_slider_basic,
         id: "angle-slider-basic-form"
       )
     )}
  end

  @impl true
  def handle_event("save_basic", params, socket) do
    rparams = Map.get(params, "angle_slider_basic", %{})

    case AngleSliderForm.changeset(%AngleSliderForm{}, rparams) do
      %Ecto.Changeset{valid?: true} = changeset ->
        data = Ecto.Changeset.apply_changes(changeset)
        message = "Submitted: angle=#{data.angle}"

        {:noreply,
         socket
         |> Toast.create("layout-toast", "Submitted", message, :info, duration: 5000)
         |> assign(
           :basic_form,
           Phoenix.Component.to_form(AngleSliderForm.changeset(%AngleSliderForm{}, rparams),
             as: :angle_slider_basic,
             id: "angle-slider-basic-form"
           )
         )}

      %Ecto.Changeset{} = changeset ->
        {:noreply,
         socket
         |> assign(
           :basic_form,
           Phoenix.Component.to_form(changeset,
             action: :insert,
             as: :angle_slider_basic,
             id: "angle-slider-basic-form"
           )
         )}
    end
  end

  @impl true
  def handle_event("validate_validate", params, socket) do
    rparams = Map.get(params, "angle_slider_validate", %{})

    changeset =
      %AngleSliderForm{}
      |> AngleSliderForm.changeset_validate(rparams)
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(
       :validate_form,
       Phoenix.Component.to_form(changeset,
         action: :validate,
         as: :angle_slider_validate,
         id: "angle-slider-validate-form-live"
       )
     )}
  end

  @impl true
  def handle_event("angle_changed_validate", %{"value" => value}, socket) do
    angle = parse_float(value)
    params = %{"angle" => to_string(angle)}

    changeset =
      %AngleSliderForm{}
      |> AngleSliderForm.changeset_validate(params)
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(
       :validate_form,
       Phoenix.Component.to_form(changeset,
         action: :validate,
         as: :angle_slider_validate,
         id: "angle-slider-validate-form-live"
       )
     )}
  end

  @impl true
  def handle_event("save_validate", params, socket) do
    rparams = Map.get(params, "angle_slider_validate", %{})

    case AngleSliderForm.changeset_validate(%AngleSliderForm{}, rparams) do
      %Ecto.Changeset{valid?: true} = changeset ->
        data = Ecto.Changeset.apply_changes(changeset)
        message = "Submitted: angle=#{data.angle}"

        {:noreply,
         socket
         |> Toast.create("layout-toast", "Submitted", message, :info, duration: 5000)
         |> assign(
           :validate_form,
           Phoenix.Component.to_form(
             AngleSliderForm.changeset_validate(%AngleSliderForm{}, rparams),
             as: :angle_slider_validate,
             id: "angle-slider-validate-form-live"
           )
         )}

      %Ecto.Changeset{} = changeset ->
        {:noreply,
         socket
         |> assign(
           :validate_form,
           Phoenix.Component.to_form(changeset,
             action: :insert,
             as: :angle_slider_validate,
             id: "angle-slider-validate-form-live"
           )
         )}
    end
  end

  defp parse_float(value) when is_number(value), do: value * 1.0

  @impl true
  def render(assigns) do
    assigns =
      assigns
      |> assign(:basic_angle_value, get_angle_from_form(assigns.basic_form))
      |> assign(:validate_angle_value, get_angle_from_form(assigns.validate_form))

    ~H"""
    <Layouts.app
      flash={@flash}
      mode={@mode}
      theme={@theme}
      path={@path}
    >
      <.demo_page
        id="angle-slider-form-live-page"
        title="Angle Slider form"
        subtitle="Live View Form"
      >
        <.demo_section
          id="angle-slider-live-form-changeset"
          title="Phoenix Form (changeset)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @live_basic_heex},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @live_basic_elixir},
            %{value: "ecto", label: "Ecto", language: :elixir, code: @form_ecto}
          ]}
        >
          <:preview>
            <AngleSliderDemo.form_preview_live_changeset
              form={@basic_form}
              angle_value={@basic_angle_value}
            />
          </:preview>
        </.demo_section>

        <.demo_section
          id="angle-slider-live-form-validate"
          title="Ecto Changeset (validation)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @live_validate_heex},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @live_validate_elixir},
            %{value: "ecto", label: "Ecto", language: :elixir, code: @form_ecto}
          ]}
        >
          <:preview>
            <AngleSliderDemo.form_preview_live_validate
              form={@validate_form}
              angle_value={@validate_angle_value}
            />
          </:preview>
        </.demo_section>
      </.demo_page>
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
