defmodule E2eWeb.CheckboxFormLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias Corex.Toast
  alias E2e.Form.Terms
  alias E2eWeb.Demos.CheckboxDemo

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Checkbox form")
     |> assign(:form_ecto, CheckboxDemo.form_ecto())
     |> assign(:live_basic_heex, CheckboxDemo.form_doc_live_changeset_heex())
     |> assign(:live_basic_elixir, CheckboxDemo.form_doc_live_changeset_elixir())
     |> assign(:live_validate_heex, CheckboxDemo.form_doc_live_validate_heex())
     |> assign(:live_validate_elixir, CheckboxDemo.form_doc_live_validate_elixir())
     |> assign_forms()}
  end

  defp assign_forms(socket) do
    form =
      %Terms{}
      |> Terms.changeset(%{})
      |> Phoenix.Component.to_form(as: :terms, id: "checkbox-live-form")

    strict_form =
      %Terms{}
      |> Terms.changeset_validate(%{})
      |> Phoenix.Component.to_form(as: :terms_strict, id: "checkbox-strict-form-live")

    socket
    |> assign(:form, form)
    |> assign(:strict_form, strict_form)
  end

  def handle_event("validate", %{"terms" => params}, socket) do
    changeset =
      %Terms{}
      |> Terms.changeset(params)
      |> Map.put(:action, :validate)

    {:noreply,
     assign(
       socket,
       :form,
       Phoenix.Component.to_form(changeset,
         action: :validate,
         as: :terms,
         id: "checkbox-live-form"
       )
     )}
  end

  def handle_event("save", %{"terms" => params}, socket) do
    case Terms.changeset(%Terms{}, params) do
      %Ecto.Changeset{valid?: true} = changeset ->
        data = Ecto.Changeset.apply_changes(changeset)
        message = "Submitted: terms=#{data.terms}"

        {:noreply,
         socket
         |> Toast.push_toast("layout-toast", "Submitted", message, :info, 5000)
         |> assign(
           :form,
           Phoenix.Component.to_form(Terms.changeset(%Terms{}, params),
             as: :terms,
             id: "checkbox-live-form"
           )
         )}

      %Ecto.Changeset{} = changeset ->
        {:noreply,
         assign(
           socket,
           :form,
           Phoenix.Component.to_form(changeset,
             action: :insert,
             as: :terms,
             id: "checkbox-live-form"
           )
         )}
    end
  end

  def handle_event("validate_strict", %{"terms_strict" => params}, socket) do
    changeset =
      %Terms{}
      |> Terms.changeset_validate(params)
      |> Map.put(:action, :validate)

    {:noreply,
     assign(
       socket,
       :strict_form,
       Phoenix.Component.to_form(changeset,
         action: :validate,
         as: :terms_strict,
         id: "checkbox-strict-form-live"
       )
     )}
  end

  def handle_event("save_strict", %{"terms_strict" => params}, socket) do
    case Terms.changeset_validate(%Terms{}, params) do
      %Ecto.Changeset{valid?: true} = changeset ->
        data = Ecto.Changeset.apply_changes(changeset)
        message = "Submitted: terms=#{data.terms}"

        {:noreply,
         socket
         |> Toast.push_toast("layout-toast", "Submitted", message, :info, 5000)
         |> assign(
           :strict_form,
           Phoenix.Component.to_form(
             Terms.changeset_validate(%Terms{}, params),
             as: :terms_strict,
             id: "checkbox-strict-form-live"
           )
         )}

      %Ecto.Changeset{} = changeset ->
        {:noreply,
         assign(
           socket,
           :strict_form,
           Phoenix.Component.to_form(changeset,
             action: :insert,
             as: :terms_strict,
             id: "checkbox-strict-form-live"
           )
         )}
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
        id="checkbox-form-live-page"
        title="Checkbox · Form"
        subtitle="Live View form"
      >
        <.demo_section
          id="checkbox-live-form-changeset"
          title="Phoenix Form (changeset)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @live_basic_heex},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @live_basic_elixir},
            %{value: "ecto", label: "Ecto", language: :elixir, code: @form_ecto}
          ]}
        >
          <:preview>
            <CheckboxDemo.form_preview_live_changeset form={@form} />
          </:preview>
        </.demo_section>

        <.demo_section
          id="checkbox-live-form-validate"
          title="Ecto Changeset (validation)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @live_validate_heex},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @live_validate_elixir},
            %{value: "ecto", label: "Ecto", language: :elixir, code: @form_ecto}
          ]}
        >
          <:preview>
            <CheckboxDemo.form_preview_live_validate form={@strict_form} />
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
