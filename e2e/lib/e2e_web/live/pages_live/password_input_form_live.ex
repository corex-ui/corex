defmodule E2eWeb.PasswordInputFormLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias Corex.Toast
  alias E2e.Form.PasswordInputForm
  alias E2eWeb.Demos.PasswordInputDemo

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Password Input form")
     |> assign(:form_ecto, PasswordInputDemo.form_ecto())
     |> assign(:live_basic_heex, PasswordInputDemo.form_doc_live_changeset_heex())
     |> assign(:live_basic_elixir, PasswordInputDemo.form_doc_live_changeset_elixir())
     |> assign(:live_validate_heex, PasswordInputDemo.form_doc_live_validate_heex())
     |> assign(:live_validate_elixir, PasswordInputDemo.form_doc_live_validate_elixir())
     |> assign_forms()}
  end

  defp assign_forms(socket) do
    form =
      %PasswordInputForm{}
      |> PasswordInputForm.changeset(%{})
      |> Phoenix.Component.to_form(as: :password_input_live, id: "password-input-live-form")

    strict_form =
      %PasswordInputForm{}
      |> PasswordInputForm.changeset_validate(%{})
      |> Phoenix.Component.to_form(
        as: :password_input_strict,
        id: "password-input-strict-form-live"
      )

    socket
    |> assign(:form, form)
    |> assign(:strict_form, strict_form)
  end

  @impl true
  def handle_event("validate", params, socket) do
    rparams = Map.get(params, "password_input_live", %{})

    changeset =
      %PasswordInputForm{}
      |> PasswordInputForm.changeset(rparams)
      |> Map.put(:action, :validate)

    {:noreply,
     assign(
       socket,
       :form,
       Phoenix.Component.to_form(changeset,
         action: :validate,
         as: :password_input_live,
         id: "password-input-live-form"
       )
     )}
  end

  @impl true
  def handle_event("save", params, socket) do
    rparams = Map.get(params, "password_input_live", %{})

    case PasswordInputForm.changeset(%PasswordInputForm{}, rparams) do
      %Ecto.Changeset{valid?: true} ->
        message = "Submitted: password=***"

        {:noreply,
         socket
         |> Toast.push_toast("layout-toast", "Submitted", message, :info, 5000)
         |> assign(
           :form,
           Phoenix.Component.to_form(PasswordInputForm.changeset(%PasswordInputForm{}, %{}),
             as: :password_input_live,
             id: "password-input-live-form"
           )
         )}

      %Ecto.Changeset{} = changeset ->
        {:noreply,
         assign(
           socket,
           :form,
           Phoenix.Component.to_form(changeset,
             action: :insert,
             as: :password_input_live,
             id: "password-input-live-form"
           )
         )}
    end
  end

  @impl true
  def handle_event("validate_strict", params, socket) do
    rparams = Map.get(params, "password_input_strict", %{})

    changeset =
      %PasswordInputForm{}
      |> PasswordInputForm.changeset_validate(rparams)
      |> Map.put(:action, :validate)

    {:noreply,
     assign(
       socket,
       :strict_form,
       Phoenix.Component.to_form(changeset,
         action: :validate,
         as: :password_input_strict,
         id: "password-input-strict-form-live"
       )
     )}
  end

  @impl true
  def handle_event("save_strict", params, socket) do
    rparams = Map.get(params, "password_input_strict", %{})

    case PasswordInputForm.changeset_validate(%PasswordInputForm{}, rparams) do
      %Ecto.Changeset{valid?: true} ->
        message = "Submitted: password=***"

        {:noreply,
         socket
         |> Toast.push_toast("layout-toast", "Submitted", message, :info, 5000)
         |> assign(
           :strict_form,
           Phoenix.Component.to_form(
             PasswordInputForm.changeset_validate(%PasswordInputForm{}, %{}),
             as: :password_input_strict,
             id: "password-input-strict-form-live"
           )
         )}

      %Ecto.Changeset{} = changeset ->
        {:noreply,
         assign(
           socket,
           :strict_form,
           Phoenix.Component.to_form(changeset,
             action: :insert,
             as: :password_input_strict,
             id: "password-input-strict-form-live"
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
        id="password-input-form-live-page"
        title="Password Input · Form"
        subtitle="Live View form"
      >
        <.demo_section
          id="password-input-live-form-changeset"
          title="Phoenix Form (changeset)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @live_basic_heex},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @live_basic_elixir},
            %{value: "ecto", label: "Ecto", language: :elixir, code: @form_ecto}
          ]}
        >
          <:preview>
            <PasswordInputDemo.form_preview_live_changeset form={@form} />
          </:preview>
        </.demo_section>

        <.demo_section
          id="password-input-live-form-validate"
          title="Ecto Changeset (validation)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @live_validate_heex},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @live_validate_elixir},
            %{value: "ecto", label: "Ecto", language: :elixir, code: @form_ecto}
          ]}
        >
          <:preview>
            <PasswordInputDemo.form_preview_live_validate form={@strict_form} />
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
