defmodule E2eWeb.SwitchFormLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias Corex.Toast
  alias E2e.Form.Preferences
  alias E2eWeb.Demos.SwitchDemo, as: SwitchDemo

  @phoenix_form_id "switch-live-form-phoenix"
  @ecto_form_id "switch-live-form-ecto"

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Switch · Form")
     |> assign(:form_ecto, SwitchDemo.form_ecto())
     |> assign(:live_phoenix_heex, SwitchDemo.form_doc_live_phoenix_heex())
     |> assign(:live_phoenix_elixir, SwitchDemo.form_doc_live_phoenix_elixir())
     |> assign(:live_ecto_heex, SwitchDemo.form_doc_live_ecto_heex())
     |> assign(:live_ecto_elixir, SwitchDemo.form_doc_live_ecto_elixir())
     |> assign(:native_heex, SwitchDemo.form_native_heex())
     |> assign_forms()}
  end

  defp assign_forms(socket) do
    phoenix_form =
      Phoenix.Component.to_form(%{"notifications" => false},
        as: :preferences_phoenix,
        id: @phoenix_form_id
      )

    ecto_form =
      %Preferences{}
      |> Preferences.changeset_validate(%{})
      |> Phoenix.Component.to_form(as: :preferences_ecto, id: @ecto_form_id)

    socket
    |> assign(:phoenix_form, phoenix_form)
    |> assign(:ecto_form, ecto_form)
  end

  @impl true
  def handle_event("save_phoenix", %{"preferences_phoenix" => params}, socket) do
    notifications = params["notifications"] in [true, "true", "on", "1", 1]

    {:noreply,
     socket
     |> Toast.create("layout-toast", "Submitted", "notifications=#{notifications}", :info,
       duration: 5000
     )
     |> assign(
       :phoenix_form,
       Phoenix.Component.to_form(%{"notifications" => notifications},
         as: :preferences_phoenix,
         id: @phoenix_form_id
       )
     )}
  end

  @impl true
  def handle_event("validate", %{"preferences_ecto" => params}, socket) do
    changeset =
      %Preferences{}
      |> Preferences.changeset_validate(params)
      |> Map.put(:action, :validate)

    {:noreply,
     assign(
       socket,
       :ecto_form,
       Phoenix.Component.to_form(changeset,
         action: :validate,
         as: :preferences_ecto,
         id: @ecto_form_id
       )
     )}
  end

  @impl true
  def handle_event("save", %{"preferences_ecto" => params}, socket) do
    case Preferences.changeset_validate(%Preferences{}, params) do
      %Ecto.Changeset{valid?: true} = changeset ->
        data = Ecto.Changeset.apply_changes(changeset)
        message = "Submitted: notifications=#{data.notifications}"

        {:noreply,
         socket
         |> Toast.create("layout-toast", "Submitted", message, :info, duration: 5000)
         |> assign(
           :ecto_form,
           Phoenix.Component.to_form(
             Preferences.changeset_validate(%Preferences{}, params),
             as: :preferences_ecto,
             id: @ecto_form_id
           )
         )}

      %Ecto.Changeset{} = changeset ->
        {:noreply,
         assign(
           socket,
           :ecto_form,
           Phoenix.Component.to_form(changeset,
             action: :insert,
             as: :preferences_ecto,
             id: @ecto_form_id
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
        id="switch-form-live-page"
        title={~t"Switch · Form"}
      >
        <.demo_section
          id="switch-live-form-phoenix-section"
          title={~t"Phoenix Form"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @live_phoenix_heex},
            %{value: "elixir", label: ~t"Elixir", language: :elixir, code: @live_phoenix_elixir}
          ]}
        >
          <:preview>
            <SwitchDemo.form_preview_live_phoenix form={@phoenix_form} />
          </:preview>
        </.demo_section>

        <.demo_section
          id="switch-live-form-ecto-section"
          title={~t"Phoenix Form + Ecto"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @live_ecto_heex},
            %{value: "elixir", label: ~t"Elixir", language: :elixir, code: @live_ecto_elixir},
            %{value: "ecto", label: ~t"Ecto", language: :elixir, code: @form_ecto}
          ]}
        >
          <:preview>
            <SwitchDemo.form_preview_live_ecto form={@ecto_form} />
          </:preview>
        </.demo_section>

        <.demo_section
          id="switch-live-form-native"
          title={~t"Native HTML Form"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @native_heex}
          ]}
        >
          <:preview>
            <SwitchDemo.form_preview_controller_native />
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
