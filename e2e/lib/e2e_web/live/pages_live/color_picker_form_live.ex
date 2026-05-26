defmodule E2eWeb.ColorPickerFormLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias Corex.Toast
  alias E2e.Form.ColorPickerForm
  alias E2eWeb.Demos.ColorPickerDemo

  @phoenix_form_id "color-picker-live-form-phoenix"

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Color Picker · Form")
     |> assign(:form_ecto, ColorPickerDemo.form_ecto())
     |> assign(:live_phoenix_heex, ColorPickerDemo.form_doc_live_phoenix_heex())
     |> assign(:live_phoenix_elixir, ColorPickerDemo.form_doc_live_phoenix_elixir())
     |> assign(:live_ecto_heex, ColorPickerDemo.form_doc_live_ecto_heex())
     |> assign(:live_ecto_elixir, ColorPickerDemo.form_doc_live_ecto_elixir())
     |> assign_forms()}
  end

  defp assign_forms(socket) do
    phoenix_form =
      Phoenix.Component.to_form(%{"color" => "#3b82f6"},
        as: :color_picker_phoenix,
        id: @phoenix_form_id
      )

    validate_form =
      %ColorPickerForm{}
      |> ColorPickerForm.changeset_validate(%{})
      |> Phoenix.Component.to_form(
        as: :color_picker_validate,
        id: "color-picker-validate-form-live"
      )

    socket
    |> assign(:phoenix_form, phoenix_form)
    |> assign(:validate_form, validate_form)
  end

  @impl true
  def handle_event("save_phoenix", %{"color_picker_phoenix" => params}, socket) do
    color = params["color"] || "#3b82f6"

    {:noreply,
     socket
     |> Toast.create("layout-toast", "Submitted", "Submitted: color=#{color}", :info,
       duration: 5000
     )
     |> assign(
       :phoenix_form,
       Phoenix.Component.to_form(%{"color" => color},
         as: :color_picker_phoenix,
         id: @phoenix_form_id
       )
     )}
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

    if params["color"] in [nil, ""] do
      {:noreply, socket}
    else
      case ColorPickerForm.changeset_validate(%ColorPickerForm{}, params) do
        %Ecto.Changeset{valid?: true} = changeset ->
          data = Ecto.Changeset.apply_changes(changeset)
          message = "Submitted: color=#{data.color}"

          {:noreply,
           socket
           |> Toast.create("layout-toast", "Submitted", message, :info, duration: 5000)
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
    ~H"""
    <Layouts.app
      flash={@flash}
      mode={@mode}
      theme={@theme}
      path={@path}
    >
      <.demo_page
        path={@path}
        id="color-picker-form-live-page"
        title={~t"Color Picker form"}
      >
        <.demo_section
          id="color-picker-live-form-phoenix-section"
          title={~t"Phoenix Form"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @live_phoenix_heex},
            %{value: "elixir", label: ~t"Elixir", language: :elixir, code: @live_phoenix_elixir}
          ]}
        >
          <:preview>
            <ColorPickerDemo.form_preview_live_phoenix form={@phoenix_form} />
          </:preview>
        </.demo_section>

        <.demo_section
          id="color-picker-live-form-ecto-section"
          title={~t"Phoenix Form + Ecto"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @live_ecto_heex},
            %{value: "elixir", label: ~t"Elixir", language: :elixir, code: @live_ecto_elixir},
            %{value: "ecto", label: ~t"Ecto", language: :elixir, code: @form_ecto}
          ]}
        >
          <:preview>
            <ColorPickerDemo.form_preview_live_validate form={@validate_form} />
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
