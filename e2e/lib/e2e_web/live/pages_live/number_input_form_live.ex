defmodule E2eWeb.NumberInputFormLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias Corex.Toast
  alias E2e.Form.NumberInputForm
  alias E2eWeb.Demos.NumberInputDemo, as: Demo

  @live_form_id "number-input-live-changeset-form"
  @live_strict_form_id "number-input-live-validate-form"

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Number Input form")
     |> assign(:form_ecto, Demo.form_ecto())
     |> assign(:live_basic_heex, Demo.form_doc_live_changeset_heex())
     |> assign(:live_basic_elixir, Demo.form_doc_live_changeset_elixir())
     |> assign(:live_validate_heex, Demo.form_doc_live_validate_heex())
     |> assign(:live_validate_elixir, Demo.form_doc_live_validate_elixir())
     |> assign_forms()}
  end

  defp assign_forms(socket) do
    form =
      %NumberInputForm{}
      |> NumberInputForm.changeset(%{"value" => "1234"})
      |> Phoenix.Component.to_form(as: :number_input_changeset, id: @live_form_id)

    strict_form =
      %NumberInputForm{}
      |> NumberInputForm.changeset_validate(%{"value" => "1234"})
      |> Phoenix.Component.to_form(as: :number_input_validate, id: @live_strict_form_id)

    socket
    |> assign(:form, form)
    |> assign(:strict_form, strict_form)
  end

  @impl true
  def handle_event("validate", params, socket) do
    rparams = Map.get(params, "number_input_changeset", %{})

    changeset =
      %NumberInputForm{}
      |> NumberInputForm.changeset(rparams)
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(
       :form,
       Phoenix.Component.to_form(changeset,
         action: :validate,
         as: :number_input_changeset,
         id: @live_form_id
       )
     )}
  end

  def handle_event("validate_strict", params, socket) do
    rparams = Map.get(params, "number_input_validate", %{})

    changeset =
      %NumberInputForm{}
      |> NumberInputForm.changeset_validate(rparams)
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(
       :strict_form,
       Phoenix.Component.to_form(changeset,
         action: :validate,
         as: :number_input_validate,
         id: @live_strict_form_id
       )
     )}
  end

  @impl true
  def handle_event("save", params, socket) do
    rparams = Map.get(params, "number_input_changeset", %{})

    case NumberInputForm.changeset(%NumberInputForm{}, rparams) do
      %Ecto.Changeset{valid?: true} = changeset ->
        data = Ecto.Changeset.apply_changes(changeset)
        message = "Submitted: #{data.value}"

        {:noreply,
         socket
         |> Toast.push_toast("layout-toast", "Submitted", message, :info, 5000)
         |> assign(
           :form,
           Phoenix.Component.to_form(
             NumberInputForm.changeset(%NumberInputForm{}, rparams),
             as: :number_input_changeset,
             id: @live_form_id
           )
         )}

      %Ecto.Changeset{} = changeset ->
        {:noreply,
         socket
         |> assign(
           :form,
           Phoenix.Component.to_form(changeset,
             action: :insert,
             as: :number_input_changeset,
             id: @live_form_id
           )
         )}
    end
  end

  def handle_event("save_strict", params, socket) do
    rparams = Map.get(params, "number_input_validate", %{})

    case NumberInputForm.changeset_validate(%NumberInputForm{}, rparams) do
      %Ecto.Changeset{valid?: true} = changeset ->
        data = Ecto.Changeset.apply_changes(changeset)
        message = "Submitted (strict): #{data.value}"

        {:noreply,
         socket
         |> Toast.push_toast("layout-toast", "Submitted", message, :info, 5000)
         |> assign(
           :strict_form,
           Phoenix.Component.to_form(
             NumberInputForm.changeset_validate(%NumberInputForm{}, rparams),
             as: :number_input_validate,
             id: @live_strict_form_id
           )
         )}

      %Ecto.Changeset{} = changeset ->
        {:noreply,
         socket
         |> assign(
           :strict_form,
           Phoenix.Component.to_form(changeset,
             action: :insert,
             as: :number_input_validate,
             id: @live_strict_form_id
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
      path={@path}
    >
      <.demo_page
        id="number-input-form-live-page"
        title="Number Input · Form"
        subtitle="LiveView phx-change / phx-submit with basic vs stricter validation."
      >
        <.demo_section
          id="number-input-live-form-changeset"
          title="Phoenix Form (changeset)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @live_basic_heex},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @live_basic_elixir},
            %{value: "ecto", label: "Ecto", language: :elixir, code: @form_ecto}
          ]}
        >
          <:preview>
            <Demo.form_preview_live_changeset form={@form} />
          </:preview>
        </.demo_section>

        <.demo_section
          id="number-input-live-form-validate"
          title="Ecto changeset (validation)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @live_validate_heex},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @live_validate_elixir},
            %{value: "ecto", label: "Ecto", language: :elixir, code: @form_ecto}
          ]}
        >
          <:preview>
            <Demo.form_preview_live_validate form={@strict_form} />
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
