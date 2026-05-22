defmodule E2eWeb.NativeInputFormLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias Corex.Toast
  alias E2e.Form.NativeInputProfile
  alias E2eWeb.Demos.NativeInputDemo, as: Demo

  @live_form_id "native-input-live-profile-form"
  @live_strict_form_id "native-input-live-strict-form"

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "NativeInput form")
     |> assign(:form_ecto, Demo.form_ecto())
     |> assign(:live_basic_heex, Demo.form_doc_live_changeset_heex())
     |> assign(:live_basic_elixir, Demo.form_doc_live_changeset_elixir())
     |> assign(:live_validate_heex, Demo.form_doc_live_validate_heex())
     |> assign(:live_validate_elixir, Demo.form_doc_live_validate_elixir())
     |> assign_forms()}
  end

  defp assign_forms(socket) do
    form =
      %NativeInputProfile{}
      |> NativeInputProfile.changeset(%{})
      |> Phoenix.Component.to_form(as: :profile, id: @live_form_id)

    strict_form =
      %NativeInputProfile{}
      |> NativeInputProfile.changeset_validate(%{})
      |> Phoenix.Component.to_form(as: :profile_strict, id: @live_strict_form_id)

    socket
    |> assign(:form, form)
    |> assign(:strict_form, strict_form)
  end

  @impl true
  def handle_event("validate", params, socket) do
    p = Map.get(params, "profile", %{})

    changeset =
      %NativeInputProfile{}
      |> NativeInputProfile.changeset(p)
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(
       :form,
       Phoenix.Component.to_form(changeset, action: :validate, as: :profile, id: @live_form_id)
     )}
  end

  def handle_event("validate_strict", params, socket) do
    p = Map.get(params, "profile_strict", %{})

    changeset =
      %NativeInputProfile{}
      |> NativeInputProfile.changeset_validate(p)
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(
       :strict_form,
       Phoenix.Component.to_form(changeset,
         action: :validate,
         as: :profile_strict,
         id: @live_strict_form_id
       )
     )}
  end

  @impl true
  def handle_event("save", params, socket) do
    p = Map.get(params, "profile", %{})

    case NativeInputProfile.changeset(%NativeInputProfile{}, p) do
      %Ecto.Changeset{valid?: true} = changeset ->
        data = Ecto.Changeset.apply_changes(changeset)
        message = "Submitted: #{NativeInputProfile.format_for_toast(data)}"

        {:noreply,
         socket
         |> Toast.create("layout-toast", "Submitted", message, :info, duration: 5000)
         |> assign(
           :form,
           Phoenix.Component.to_form(
             NativeInputProfile.changeset(%NativeInputProfile{}, p),
             as: :profile,
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
             as: :profile,
             id: @live_form_id
           )
         )}
    end
  end

  def handle_event("save_strict", params, socket) do
    p = Map.get(params, "profile_strict", %{})

    case NativeInputProfile.changeset_validate(%NativeInputProfile{}, p) do
      %Ecto.Changeset{valid?: true} = changeset ->
        data = Ecto.Changeset.apply_changes(changeset)
        message = "Submitted: #{NativeInputProfile.format_for_toast(data)}"

        {:noreply,
         socket
         |> Toast.create("layout-toast", "Submitted", message, :info, duration: 5000)
         |> assign(
           :strict_form,
           Phoenix.Component.to_form(
             NativeInputProfile.changeset_validate(%NativeInputProfile{}, p),
             as: :profile_strict,
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
             as: :profile_strict,
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
        path={@path}
        id="native-input-form-live-page"
        title="Native Input · Form"
        subtitle="LiveView phx-change / phx-submit with grouped fields (changeset vs stricter validation)."
      >
        <.demo_section
          id="native-input-live-form-changeset"
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
          id="native-input-live-form-validate"
          title="Ecto Changeset (validation)"
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
