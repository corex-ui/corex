defmodule E2eWeb.ColorPickerFormLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias E2e.Form.ColorPickerForm
  alias E2eWeb.Demos.ColorPickerDemo
  alias Corex.Toast

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Color Picker form")
     |> assign(:form_ecto, ColorPickerDemo.form_ecto())
     |> assign(:live_basic_heex, ColorPickerDemo.form_doc_live_changeset_heex())
     |> assign(:live_basic_elixir, ColorPickerDemo.form_doc_live_changeset_elixir())
     |> assign(:live_validate_heex, ColorPickerDemo.form_doc_live_validate_heex())
     |> assign(:live_validate_elixir, ColorPickerDemo.form_doc_live_validate_elixir())
     |> assign_forms()}
  end

  defp assign_forms(socket) do
    basic_form =
      %ColorPickerForm{}
      |> ColorPickerForm.changeset(%{})
      |> Phoenix.Component.to_form(as: :color_picker_basic, id: "color-picker-basic-form")

    validate_form =
      %ColorPickerForm{}
      |> ColorPickerForm.changeset_validate(%{})
      |> Phoenix.Component.to_form(
        as: :color_picker_validate,
        id: "color-picker-validate-form-live"
      )

    socket
    |> assign(:basic_form, basic_form)
    |> assign(:validate_form, validate_form)
  end

  @impl true
  def handle_event("validate_basic", event_params, socket) do
    incoming = Map.get(event_params, "color_picker_basic", %{})
    prior = socket.assigns.basic_form.params || %{}
    params = Map.merge(prior, incoming)

    changeset =
      %ColorPickerForm{}
      |> ColorPickerForm.changeset(params)
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(
       :basic_form,
       Phoenix.Component.to_form(changeset,
         action: :validate,
         as: :color_picker_basic,
         id: "color-picker-basic-form"
       )
     )}
  end

  @impl true
  def handle_event("color_changed_basic", %{"valueAsString" => value}, socket) do
    params = %{"color" => value}

    changeset =
      %ColorPickerForm{}
      |> ColorPickerForm.changeset(params)
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(
       :basic_form,
       Phoenix.Component.to_form(changeset,
         action: :validate,
         as: :color_picker_basic,
         id: "color-picker-basic-form"
       )
     )}
  end

  @impl true
  def handle_event("save_basic", event_params, socket) do
    incoming = Map.get(event_params, "color_picker_basic", %{})
    prior = socket.assigns.basic_form.params || %{}
    params = Map.merge(prior, incoming)

    case ColorPickerForm.changeset(%ColorPickerForm{}, params) do
      %Ecto.Changeset{valid?: true} = changeset ->
        data = Ecto.Changeset.apply_changes(changeset)
        message = "Submitted: color=#{data.color}"

        {:noreply,
         socket
         |> Toast.push_toast("layout-toast", "Submitted", message, :info, 5000)
         |> assign(
           :basic_form,
           Phoenix.Component.to_form(ColorPickerForm.changeset(%ColorPickerForm{}, params),
             as: :color_picker_basic,
             id: "color-picker-basic-form"
           )
         )}

      %Ecto.Changeset{} = changeset ->
        {:noreply,
         socket
         |> assign(
           :basic_form,
           Phoenix.Component.to_form(changeset,
             action: :insert,
             as: :color_picker_basic,
             id: "color-picker-basic-form"
           )
         )}
    end
  end

  @impl true
  def handle_event("validate_validate", event_params, socket) do
    incoming = Map.get(event_params, "color_picker_validate", %{})
    prior = socket.assigns.validate_form.params || %{}
    params = Map.merge(prior, incoming)

    changeset =
      %ColorPickerForm{}
      |> ColorPickerForm.changeset_validate(params)
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(
       :validate_form,
       Phoenix.Component.to_form(changeset,
         action: :validate,
         as: :color_picker_validate,
         id: "color-picker-validate-form-live"
       )
     )}
  end

  @impl true
  def handle_event("color_changed_validate", %{"valueAsString" => value}, socket) do
    params = %{"color" => value}

    changeset =
      %ColorPickerForm{}
      |> ColorPickerForm.changeset_validate(params)
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(
       :validate_form,
       Phoenix.Component.to_form(changeset,
         action: :validate,
         as: :color_picker_validate,
         id: "color-picker-validate-form-live"
       )
     )}
  end

  @impl true
  def handle_event("save_validate", event_params, socket) do
    incoming = Map.get(event_params, "color_picker_validate", %{})
    prior = socket.assigns.validate_form.params || %{}
    params = Map.merge(prior, incoming)

    # Ignore empty submissions (second fire from channel inputs)
    if params["color"] in [nil, ""] do
      {:noreply, socket}
    else
      case ColorPickerForm.changeset_validate(%ColorPickerForm{}, params) do
        %Ecto.Changeset{valid?: true} = changeset ->
          data = Ecto.Changeset.apply_changes(changeset)
          message = "Submitted: color=#{data.color}"

          {:noreply,
           socket
           |> Toast.push_toast("layout-toast", "Submitted", message, :info, 5000)
           |> assign(
             :validate_form,
             Phoenix.Component.to_form(
               ColorPickerForm.changeset_validate(%ColorPickerForm{}, params),
               as: :color_picker_validate,
               id: "color-picker-validate-form-live"
             )
           )}

        %Ecto.Changeset{} = changeset ->
          {:noreply,
           socket
           |> assign(
             :validate_form,
             Phoenix.Component.to_form(changeset,
               action: :insert,
               as: :color_picker_validate,
               id: "color-picker-validate-form-live"
             )
           )}
      end
    end
  end

  @impl true
  def render(assigns) do
    assigns =
      assigns
      |> assign(:basic_color, get_color_from_form(assigns.basic_form))
      |> assign(:validate_color, get_color_from_form(assigns.validate_form))

    ~H"""
    <Layouts.app
      flash={@flash}
      mode={@mode}
      theme={@theme}
      path={@path}
    >
      <.demo_page
        id="color-picker-form-live-page"
        title="Color Picker form"
        subtitle="Live View Form"
      >
        <.demo_section
          id="color-picker-live-form-changeset"
          title="Phoenix form (changeset)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @live_basic_heex},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @live_basic_elixir},
            %{value: "ecto", label: "Ecto", language: :elixir, code: @form_ecto}
          ]}
        >
          <:preview>
            <ColorPickerDemo.form_preview_live_basic
              form={@basic_form}
              color={@basic_color}
            />
          </:preview>
        </.demo_section>

        <.demo_section
          id="color-picker-live-form-validate"
          title="Ecto changeset (validation)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @live_validate_heex},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @live_validate_elixir},
            %{value: "ecto", label: "Ecto", language: :elixir, code: @form_ecto}
          ]}
        >
          <:preview>
            <ColorPickerDemo.form_preview_live_validate
              form={@validate_form}
              color={@validate_color}
            />
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end

  defp get_color_from_form(form) do
    raw =
      form[:color].value || form.params["color"] ||
        Ecto.Changeset.get_change(form.source, :color) ||
        Ecto.Changeset.get_field(form.source, :color)

    case raw do
      nil -> "#3b82f6"
      "" -> "#3b82f6"
      v when is_binary(v) -> v
    end
  end
end
