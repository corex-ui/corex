defmodule E2eWeb.AngleSliderFormLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias Corex.Toast
  alias E2e.Form.AngleSliderForm
  alias E2eWeb.Demos.AngleSliderDemo

  @phoenix_form_id "angle-slider-live-form-phoenix"

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Angle Slider · Form")
     |> assign(:form_ecto, AngleSliderDemo.form_ecto())
     |> assign(:live_phoenix_heex, AngleSliderDemo.form_doc_live_phoenix_heex())
     |> assign(:live_phoenix_elixir, AngleSliderDemo.form_doc_live_phoenix_elixir())
     |> assign(:live_ecto_heex, AngleSliderDemo.form_doc_live_ecto_heex())
     |> assign(:live_ecto_elixir, AngleSliderDemo.form_doc_live_ecto_elixir())
     |> assign_forms()}
  end

  defp assign_forms(socket) do
    phoenix_form =
      Phoenix.Component.to_form(%{"angle" => "0"},
        as: :angle_slider_phoenix,
        id: @phoenix_form_id
      )

    validate_form =
      %AngleSliderForm{}
      |> AngleSliderForm.changeset_validate(%{})
      |> Phoenix.Component.to_form(
        as: :angle_slider_validate,
        id: "angle-slider-validate-form-live"
      )

    socket
    |> assign(:phoenix_form, phoenix_form)
    |> assign(:validate_form, validate_form)
  end

  @impl true
  def handle_event("save_phoenix", %{"angle_slider_phoenix" => params}, socket) do
    angle = params["angle"] || ""

    {:noreply,
     socket
     |> Toast.create("layout-toast", "Submitted", "Submitted: angle=#{angle}", :info,
       duration: 5000
     )
     |> assign(
       :phoenix_form,
       Phoenix.Component.to_form(%{"angle" => angle},
         as: :angle_slider_phoenix,
         id: @phoenix_form_id
       )
     )}
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

  defp parse_float(value) when is_binary(value) do
    case Float.parse(value) do
      {num, _} -> num
      :error -> 0.0
    end
  end

  defp parse_float(_), do: 0.0

  @impl true
  def render(assigns) do
    assigns = assign(assigns, :validate_angle_value, get_angle_from_form(assigns.validate_form))

    ~H"""
    <Layouts.app
      flash={@flash}
      mode={@mode}
      theme={@theme}
      path={@path}
    >
      <.demo_page
        path={@path}
        id="angle-slider-form-live-page"
        title={~t"Angle Slider form"}
      >
        <.demo_section
          id="angle-slider-live-form-phoenix-section"
          title={~t"Phoenix Form"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @live_phoenix_heex},
            %{value: "elixir", label: ~t"Elixir", language: :elixir, code: @live_phoenix_elixir}
          ]}
        >
          <:preview>
            <AngleSliderDemo.form_preview_live_phoenix form={@phoenix_form} />
          </:preview>
        </.demo_section>

        <.demo_section
          id="angle-slider-live-form-ecto-section"
          title={~t"Phoenix Form + Ecto"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @live_ecto_heex},
            %{value: "elixir", label: ~t"Elixir", language: :elixir, code: @live_ecto_elixir},
            %{value: "ecto", label: ~t"Ecto", language: :elixir, code: @form_ecto}
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
