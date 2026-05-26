defmodule E2eWeb.SignatureFormLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias Corex.Toast
  alias E2e.Form.SignatureForm
  alias E2eWeb.Demos.SignatureDemo, as: Demo

  @phoenix_form_id "signature-live-form-phoenix"
  @ecto_form_id "signature-live-form-ecto"

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Signature · Form")
     |> assign(:form_ecto, Demo.form_ecto())
     |> assign(:live_phoenix_heex, Demo.form_doc_live_phoenix_heex())
     |> assign(:live_phoenix_elixir, Demo.form_doc_live_phoenix_elixir())
     |> assign(:live_ecto_heex, Demo.form_doc_live_ecto_heex())
     |> assign(:live_ecto_elixir, Demo.form_doc_live_ecto_elixir())
     |> assign_forms()}
  end

  defp assign_forms(socket) do
    phoenix_form =
      Phoenix.Component.to_form(%{"signature" => []},
        as: :signature_phoenix,
        id: @phoenix_form_id
      )

    ecto_form =
      %SignatureForm{}
      |> SignatureForm.changeset_validate(%{})
      |> Phoenix.Component.to_form(as: :signature_ecto, id: @ecto_form_id)

    socket
    |> assign(:phoenix_form, phoenix_form)
    |> assign(:ecto_form, ecto_form)
  end

  @impl true
  def handle_event("save_phoenix", %{"signature_phoenix" => params}, socket) do
    sig = Map.get(params, "signature", [])

    {:noreply,
     socket
     |> Toast.create(
       "layout-toast",
       "Submitted",
       SignatureForm.format_for_toast(sig),
       :info,
       duration: 5000
     )
     |> assign(
       :phoenix_form,
       Phoenix.Component.to_form(%{"signature" => sig},
         as: :signature_phoenix,
         id: @phoenix_form_id
       )
     )}
  end

  @impl true
  def handle_event("validate", params, socket) do
    sparams = Map.get(params, "signature_ecto", %{})

    changeset =
      %SignatureForm{}
      |> SignatureForm.changeset_validate(sparams)
      |> Map.put(:action, :validate)

    {:noreply,
     assign(
       socket,
       :ecto_form,
       Phoenix.Component.to_form(changeset,
         action: :validate,
         as: :signature_ecto,
         id: @ecto_form_id
       )
     )}
  end

  @impl true
  def handle_event("signature_drawn", %{"paths" => paths}, socket) when is_list(paths) do
    validate_ecto(socket, %{"signature" => paths})
  end

  @impl true
  def handle_event("save", params, socket) do
    sparams = Map.get(params, "signature_ecto", %{})

    case SignatureForm.changeset_validate(%SignatureForm{}, sparams) do
      %Ecto.Changeset{valid?: true} = changeset ->
        data = Ecto.Changeset.apply_changes(changeset)

        {:noreply,
         socket
         |> Toast.create(
           "layout-toast",
           "Submitted",
           SignatureForm.format_for_toast(data),
           :info,
           duration: 5000
         )
         |> assign(
           :ecto_form,
           Phoenix.Component.to_form(
             SignatureForm.changeset_validate(%SignatureForm{}, sparams),
             as: :signature_ecto,
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
             as: :signature_ecto,
             id: @ecto_form_id
           )
         )}
    end
  end

  defp validate_ecto(socket, params) when is_map(params) do
    changeset =
      %SignatureForm{}
      |> SignatureForm.changeset_validate(params)
      |> Map.put(:action, :validate)

    {:noreply,
     assign(
       socket,
       :ecto_form,
       Phoenix.Component.to_form(changeset,
         action: :validate,
         as: :signature_ecto,
         id: @ecto_form_id
       )
     )}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} mode={@mode} theme={@theme} path={@path}>
      <.demo_page path={@path} id="signature-form-live-page" title={~t"Signature · Form"}>
        <.demo_section
          id="signature-live-form-phoenix-section"
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
          id="signature-live-form-ecto-section"
          title={~t"Phoenix Form + Ecto"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @live_ecto_heex},
            %{value: "elixir", label: ~t"Elixir", language: :elixir, code: @live_ecto_elixir},
            %{value: "ecto", label: ~t"Ecto", language: :elixir, code: @form_ecto}
          ]}
        >
          <:preview>
            <Demo.form_preview_live_ecto form={@ecto_form} />
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
