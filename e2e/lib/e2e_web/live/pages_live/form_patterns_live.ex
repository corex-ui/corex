defmodule E2eWeb.FormPatternsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias Corex.Toast
  alias E2e.Form.PatternsForm
  alias E2eWeb.Demos.FormPatternsDemo

  @custom_form_id "form-patterns-custom-error"
  @invalid_form_id "form-patterns-invalid-on-error"

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Forms · Pattern")
     |> assign(:form_ecto, FormPatternsDemo.form_ecto())
     |> assign(:custom_error_heex, FormPatternsDemo.custom_error_heex())
     |> assign(:custom_error_elixir, FormPatternsDemo.custom_error_elixir())
     |> assign(:invalid_on_error_heex, FormPatternsDemo.invalid_on_error_heex())
     |> assign(:invalid_on_error_elixir, FormPatternsDemo.invalid_on_error_elixir())
     |> assign_forms()}
  end

  defp assign_forms(socket) do
    socket
    |> assign(:custom_form, new_form(:patterns_custom, @custom_form_id))
    |> assign(:invalid_form, new_form(:patterns_invalid, @invalid_form_id))
  end

  defp new_form(as, id) do
    %PatternsForm{}
    |> PatternsForm.changeset_validate(%{})
    |> Phoenix.Component.to_form(as: as, id: id)
  end

  def handle_event("validate_custom", %{"patterns_custom" => params}, socket) do
    {:noreply, assign_form(socket, :custom_form, params, :patterns_custom, @custom_form_id)}
  end

  def handle_event("validate_invalid", %{"patterns_invalid" => params}, socket) do
    {:noreply, assign_form(socket, :invalid_form, params, :patterns_invalid, @invalid_form_id)}
  end

  def handle_event("save_custom", %{"patterns_custom" => params}, socket) do
    {:noreply, save_form(socket, params, :custom_form, @custom_form_id, :patterns_custom)}
  end

  def handle_event("save_invalid", %{"patterns_invalid" => params}, socket) do
    {:noreply, save_form(socket, params, :invalid_form, @invalid_form_id, :patterns_invalid)}
  end

  defp assign_form(socket, form_key, params, form_as, form_id) do
    form =
      %PatternsForm{}
      |> PatternsForm.changeset_validate(params)
      |> Phoenix.Component.to_form(as: form_as, id: form_id, action: :validate)

    assign(socket, form_key, form)
  end

  defp save_form(socket, params, form_key, form_id, form_as) do
    case PatternsForm.changeset_validate(%PatternsForm{}, params) do
      %Ecto.Changeset{valid?: true} = changeset ->
        data = Ecto.Changeset.apply_changes(changeset)

        socket
        |> Toast.create(
          "layout-toast",
          "Submitted",
          PatternsForm.format_for_toast(data),
          :info,
          duration: 5000
        )
        |> assign(
          form_key,
          Phoenix.Component.to_form(
            PatternsForm.changeset_validate(%PatternsForm{}, params),
            as: form_as,
            id: form_id
          )
        )

      %Ecto.Changeset{} = changeset ->
        assign(
          socket,
          form_key,
          Phoenix.Component.to_form(changeset, as: form_as, id: form_id, action: :insert)
        )
    end
  end

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
        id="form-patterns-page"
        title={~t"Forms · Pattern"}
        subtitle={~t"Ways to surface validation errors on form fields."}
      >
        <.demo_section
          id="form-patterns-custom-error-section"
          title={~t"Custom error"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @custom_error_heex},
            %{value: "elixir", label: ~t"Elixir", language: :elixir, code: @custom_error_elixir},
            %{value: "ecto", label: ~t"Ecto", language: :elixir, code: @form_ecto}
          ]}
        >
          <:preview>
            <FormPatternsDemo.custom_error_preview form={@custom_form} />
          </:preview>
        </.demo_section>

        <.demo_section
          id="form-patterns-invalid-on-error-section"
          title={~t"Invalid on error"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @invalid_on_error_heex},
            %{value: "elixir", label: ~t"Elixir", language: :elixir, code: @invalid_on_error_elixir},
            %{value: "ecto", label: ~t"Ecto", language: :elixir, code: @form_ecto}
          ]}
        >
          <:preview>
            <FormPatternsDemo.invalid_on_error_preview form={@invalid_form} />
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
