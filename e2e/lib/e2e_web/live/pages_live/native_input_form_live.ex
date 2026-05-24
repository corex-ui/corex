defmodule E2eWeb.NativeInputFormLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias Corex.Toast
  alias E2e.Form.NativeInputProfile
  alias E2eWeb.Demos.NativeInputDemo, as: Demo

  @phoenix_form_id "native-input-live-form-phoenix"
  @live_strict_form_id "native-input-live-strict-form"

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Native Input · Form")
     |> assign(:form_ecto, Demo.form_ecto())
     |> assign(:live_phoenix_heex, Demo.form_doc_live_phoenix_heex())
     |> assign(:live_phoenix_elixir, Demo.form_doc_live_phoenix_elixir())
     |> assign(:live_ecto_heex, Demo.form_doc_live_ecto_heex())
     |> assign(:live_ecto_elixir, Demo.form_doc_live_ecto_elixir())
     |> assign(:native_heex, Demo.form_native_heex())
     |> assign_forms()}
  end

  defp assign_forms(socket) do
    phoenix_form =
      Phoenix.Component.to_form(%{"email" => ""},
        as: :native_input_phoenix,
        id: @phoenix_form_id
      )

    strict_form =
      %NativeInputProfile{}
      |> NativeInputProfile.changeset_validate(%{})
      |> Phoenix.Component.to_form(as: :profile_strict, id: @live_strict_form_id)

    socket
    |> assign(:phoenix_form, phoenix_form)
    |> assign(:strict_form, strict_form)
  end

  @impl true
  def handle_event("save_phoenix", params, socket) do
    email = get_in(params, ["native_input_phoenix", "email"]) || ""

    {:noreply,
     socket
     |> Toast.create("layout-toast", "Submitted", "Submitted: email=#{email}", :info, duration: 5000)
     |> assign(
       :phoenix_form,
       Phoenix.Component.to_form(%{"email" => email},
         as: :native_input_phoenix,
         id: @phoenix_form_id
       )
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
      >
        <.demo_section
          id="native-input-live-form-phoenix-section"
          title={~t"Phoenix Form"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @live_phoenix_heex},
            %{value: "elixir", label: ~t"Elixir", language: :elixir, code: @live_phoenix_elixir}
          ]}
        >
          <:preview>
            <Demo.form_preview_live_phoenix form={@phoenix_form} />
          </:preview>
        </.demo_section>

        <.demo_section
          id="native-input-live-form-ecto-section"
          title={~t"Phoenix Form + Ecto"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @live_ecto_heex},
            %{value: "elixir", label: ~t"Elixir", language: :elixir, code: @live_ecto_elixir},
            %{value: "ecto", label: ~t"Ecto", language: :elixir, code: @form_ecto}
          ]}
        >
          <:preview>
            <Demo.form_preview_live_validate form={@strict_form} />
          </:preview>
        </.demo_section>

        <.demo_section
          id="native-input-live-form-native"
          title={~t"Native HTML Form"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @native_heex}
          ]}
        >
          <:preview>
            <Demo.form_preview_controller_native />
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
