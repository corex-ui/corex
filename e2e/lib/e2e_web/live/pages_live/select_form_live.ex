defmodule E2eWeb.SelectFormLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias Corex.Toast
  alias E2e.Form.SelectForm
  alias E2eWeb.Demos.SelectDemo, as: SelectDemo

  @phoenix_form_id "select-live-form-phoenix"
  @ecto_form_id "select-live-form-ecto"

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Select · Form")
     |> assign(:form_ecto, SelectDemo.form_ecto())
     |> assign(:live_phoenix_heex, SelectDemo.form_doc_live_phoenix_heex())
     |> assign(:live_phoenix_elixir, SelectDemo.form_doc_live_phoenix_elixir())
     |> assign(:live_ecto_heex, SelectDemo.form_doc_live_ecto_heex())
     |> assign(:live_ecto_elixir, SelectDemo.form_doc_live_ecto_elixir())
     |> assign(:native_heex, SelectDemo.form_native_heex())
     |> assign_forms()}
  end

  defp assign_forms(socket) do
    phoenix_form =
      Phoenix.Component.to_form(%{"country" => ""}, as: :select_phoenix, id: @phoenix_form_id)

    ecto_form =
      %SelectForm{}
      |> SelectForm.changeset_validate(%{})
      |> Phoenix.Component.to_form(as: :select_ecto, id: @ecto_form_id)

    socket
    |> assign(:phoenix_form, phoenix_form)
    |> assign(:ecto_form, ecto_form)
  end

  @impl true
  def handle_event("save_phoenix", %{"select_phoenix" => params}, socket) do
    country = params["country"] || ""

    {:noreply,
     socket
     |> Toast.create("layout-toast", "Submitted", "country=#{country}", :info, duration: 5000)
     |> assign(
       :phoenix_form,
       Phoenix.Component.to_form(%{"country" => country},
         as: :select_phoenix,
         id: @phoenix_form_id
       )
     )}
  end

  @impl true
  def handle_event("select_country_changed", %{"value" => value}, socket) do
    country = List.first(value) || ""
    validate_ecto(socket, %{"country" => country})
  end

  @impl true
  def handle_event("validate", %{"select_ecto" => params}, socket) do
    validate_ecto(socket, params)
  end

  @impl true
  def handle_event("save", %{"select_ecto" => params}, socket) do
    case SelectForm.changeset_validate(%SelectForm{}, params) do
      %Ecto.Changeset{valid?: true} = changeset ->
        data = Ecto.Changeset.apply_changes(changeset)

        {:noreply,
         socket
         |> Toast.create("layout-toast", "Submitted", "country=#{data.country}", :info,
           duration: 5000
         )
         |> assign(
           :ecto_form,
           Phoenix.Component.to_form(
             SelectForm.changeset_validate(%SelectForm{}, params),
             as: :select_ecto,
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
             as: :select_ecto,
             id: @ecto_form_id
           )
         )}
    end
  end

  defp validate_ecto(socket, params) do
    changeset =
      %SelectForm{}
      |> SelectForm.changeset_validate(params)
      |> Map.put(:action, :validate)

    {:noreply,
     assign(
       socket,
       :ecto_form,
       Phoenix.Component.to_form(changeset,
         action: :validate,
         as: :select_ecto,
         id: @ecto_form_id
       )
     )}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} mode={@mode} theme={@theme} path={@path}>
      <.demo_page path={@path} id="select-form-live-page" title={~t"Select · Form"}>
        <.demo_section
          id="select-live-form-phoenix-section"
          title={~t"Phoenix Form"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @live_phoenix_heex},
            %{value: "elixir", label: ~t"Elixir", language: :elixir, code: @live_phoenix_elixir}
          ]}
        >
          <:preview>
            <SelectDemo.form_preview_live_phoenix form={@phoenix_form} />
          </:preview>
        </.demo_section>

        <.demo_section
          id="select-live-form-ecto-section"
          title={~t"Phoenix Form + Ecto"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @live_ecto_heex},
            %{value: "elixir", label: ~t"Elixir", language: :elixir, code: @live_ecto_elixir},
            %{value: "ecto", label: ~t"Ecto", language: :elixir, code: @form_ecto}
          ]}
        >
          <:preview>
            <SelectDemo.form_preview_live_ecto form={@ecto_form} />
          </:preview>
        </.demo_section>

        <.demo_section
          id="select-live-form-native"
          title={~t"Native HTML Form"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @native_heex}
          ]}
        >
          <:preview>
            <SelectDemo.form_preview_controller_native />
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
