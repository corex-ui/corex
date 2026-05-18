defmodule E2eWeb.SwitchFormLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias Corex.Toast
  alias E2e.Form.Preferences
  alias E2eWeb.Demos.SwitchDemo, as: SwitchDemo

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Switch · Live Form")
     |> assign(:form_ecto, SwitchDemo.form_ecto())
     |> assign(:live_basic_heex, SwitchDemo.form_doc_live_changeset_heex())
     |> assign(:live_basic_elixir, SwitchDemo.form_doc_live_changeset_elixir())
     |> assign(:live_validate_heex, SwitchDemo.form_doc_live_validate_heex())
     |> assign(:live_validate_elixir, SwitchDemo.form_doc_live_validate_elixir())
     |> assign_forms()}
  end

  defp assign_forms(socket) do
    form =
      %Preferences{}
      |> Preferences.changeset(%{})
      |> Phoenix.Component.to_form(as: :preferences, id: "switch-form-live")

    strict_form =
      %Preferences{}
      |> Preferences.changeset_validate(%{})
      |> Phoenix.Component.to_form(as: :preferences_strict, id: "switch-strict-form-live")

    socket
    |> assign(:form, form)
    |> assign(:strict_form, strict_form)
  end

  @impl true
  def handle_event("validate", %{"preferences" => params}, socket) do
    changeset =
      %Preferences{}
      |> Preferences.changeset(params)
      |> Map.put(:action, :validate)

    {:noreply,
     assign(
       socket,
       :form,
       Phoenix.Component.to_form(changeset,
         action: :validate,
         as: :preferences,
         id: "switch-form-live"
       )
     )}
  end

  @impl true
  def handle_event("save", %{"preferences" => params}, socket) do
    case Preferences.changeset(%Preferences{}, params) do
      %Ecto.Changeset{valid?: true} = changeset ->
        data = Ecto.Changeset.apply_changes(changeset)
        message = "Submitted: notifications=#{data.notifications}"

        {:noreply,
         socket
         |> Toast.create("layout-toast", "Submitted", message, :info, duration: 5000)
         |> assign(
           :form,
           Phoenix.Component.to_form(Preferences.changeset(%Preferences{}, %{}),
             as: :preferences,
             id: "switch-form-live"
           )
         )}

      %Ecto.Changeset{} = changeset ->
        {:noreply,
         assign(
           socket,
           :form,
           Phoenix.Component.to_form(changeset,
             action: :insert,
             as: :preferences,
             id: "switch-form-live"
           )
         )}
    end
  end

  @impl true
  def handle_event("validate_strict", %{"preferences_strict" => params}, socket) do
    changeset =
      %Preferences{}
      |> Preferences.changeset_validate(params)
      |> Map.put(:action, :validate)

    {:noreply,
     assign(
       socket,
       :strict_form,
       Phoenix.Component.to_form(changeset,
         action: :validate,
         as: :preferences_strict,
         id: "switch-strict-form-live"
       )
     )}
  end

  @impl true
  def handle_event("save_strict", %{"preferences_strict" => params}, socket) do
    case Preferences.changeset_validate(%Preferences{}, params) do
      %Ecto.Changeset{valid?: true} = changeset ->
        data = Ecto.Changeset.apply_changes(changeset)
        message = "Submitted: notifications=#{data.notifications}"

        {:noreply,
         socket
         |> Toast.create("layout-toast", "Submitted", message, :info, duration: 5000)
         |> assign(
           :strict_form,
           Phoenix.Component.to_form(
             Preferences.changeset_validate(%Preferences{}, %{}),
             as: :preferences_strict,
             id: "switch-strict-form-live"
           )
         )}

      %Ecto.Changeset{} = changeset ->
        {:noreply,
         assign(
           socket,
           :strict_form,
           Phoenix.Component.to_form(changeset,
             action: :insert,
             as: :preferences_strict,
             id: "switch-strict-form-live"
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
        id="switch-form-live-page"
        title="Switch · Form"
        subtitle="Live View form"
      >
        <.demo_section
          id="switch-live-form-changeset"
          title="Phoenix form (changeset)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @live_basic_heex},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @live_basic_elixir},
            %{value: "ecto", label: "Ecto", language: :elixir, code: @form_ecto}
          ]}
        >
          <:preview>
            <SwitchDemo.form_preview_live_changeset form={@form} />
          </:preview>
        </.demo_section>

        <.demo_section
          id="switch-live-form-validate"
          title="Ecto changeset (validation)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @live_validate_heex},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @live_validate_elixir},
            %{value: "ecto", label: "Ecto", language: :elixir, code: @form_ecto}
          ]}
        >
          <:preview>
            <SwitchDemo.form_preview_live_validate form={@strict_form} />
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
