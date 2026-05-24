defmodule E2eWeb.PinInputFormLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias Corex.Toast
  alias E2e.Form.PinInputForm
  alias E2eWeb.Demos.PinInputDemo

  @phoenix_form_id "pin-input-live-form-phoenix"
  @ecto_form_id "pin-input-live-form-ecto"

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Pin Input · Form")
     |> assign(:form_ecto, PinInputDemo.form_ecto())
     |> assign(:live_phoenix_heex, PinInputDemo.form_doc_live_phoenix_heex())
     |> assign(:live_phoenix_elixir, PinInputDemo.form_doc_live_phoenix_elixir())
     |> assign(:live_ecto_heex, PinInputDemo.form_doc_live_ecto_heex())
     |> assign(:live_ecto_elixir, PinInputDemo.form_doc_live_ecto_elixir())
     |> assign_forms()}
  end

  defp assign_forms(socket) do
    phoenix_form =
      Phoenix.Component.to_form(%{"pin" => ""}, as: :pin_phoenix, id: @phoenix_form_id)

    ecto_form =
      %PinInputForm{}
      |> PinInputForm.changeset_validate(%{})
      |> Phoenix.Component.to_form(as: :pin_ecto, id: @ecto_form_id)

    socket
    |> assign(:phoenix_form, phoenix_form)
    |> assign(:ecto_form, ecto_form)
  end

  @impl true
  def handle_event("save_phoenix", %{"pin_phoenix" => params}, socket) do
    pin = params["pin"] || ""

    {:noreply,
     socket
     |> Toast.create("layout-toast", "Submitted", "pin=#{pin}", :info, duration: 5000)
     |> assign(
       :phoenix_form,
       Phoenix.Component.to_form(%{"pin" => pin}, as: :pin_phoenix, id: @phoenix_form_id)
     )}
  end

  @impl true
  def handle_event("validate", %{"pin_ecto" => params}, socket) do
    changeset =
      %PinInputForm{}
      |> PinInputForm.changeset_validate(params)
      |> Map.put(:action, :validate)

    {:noreply,
     assign(
       socket,
       :ecto_form,
       Phoenix.Component.to_form(changeset,
         action: :validate,
         as: :pin_ecto,
         id: @ecto_form_id
       )
     )}
  end

  @impl true
  def handle_event("save", %{"pin_ecto" => params}, socket) do
    case PinInputForm.changeset_validate(%PinInputForm{}, params) do
      %Ecto.Changeset{valid?: true} = changeset ->
        data = Ecto.Changeset.apply_changes(changeset)
        message = "Submitted: pin=#{data.pin}"

        {:noreply,
         socket
         |> Toast.create("layout-toast", "Submitted", message, :info, duration: 5000)
         |> assign(
           :ecto_form,
           Phoenix.Component.to_form(
             PinInputForm.changeset_validate(%PinInputForm{}, params),
             as: :pin_ecto,
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
             as: :pin_ecto,
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
        id="pin-input-form-live-page"
        title={~t"Pin Input · Form"}
      >
        <.demo_section
          id="pin-input-live-form-phoenix-section"
          title={~t"Phoenix Form"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @live_phoenix_heex},
            %{value: "elixir", label: ~t"Elixir", language: :elixir, code: @live_phoenix_elixir}
          ]}
        >
          <:preview>
            <PinInputDemo.form_preview_live_phoenix form={@phoenix_form} />
          </:preview>
        </.demo_section>

        <.demo_section
          id="pin-input-live-form-ecto-section"
          title={~t"Phoenix Form + Ecto"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @live_ecto_heex},
            %{value: "elixir", label: ~t"Elixir", language: :elixir, code: @live_ecto_elixir},
            %{value: "ecto", label: ~t"Ecto", language: :elixir, code: @form_ecto}
          ]}
        >
          <:preview>
            <PinInputDemo.form_preview_live_ecto form={@ecto_form} />
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
