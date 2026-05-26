defmodule E2eWeb.RadioGroupFormLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias Corex.Toast
  alias E2e.Form.RadioGroupForm
  alias E2eWeb.Demos.RadioGroupDemo, as: Demo

  @phoenix_form_id "radio-group-live-form-phoenix"
  @ecto_form_id "radio-group-live-form-ecto"

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Radio Group · Form")
     |> assign(:form_ecto, Demo.form_ecto())
     |> assign(:live_phoenix_heex, Demo.form_doc_live_phoenix_heex())
     |> assign(:live_phoenix_elixir, Demo.form_doc_live_phoenix_elixir())
     |> assign(:live_ecto_heex, Demo.form_doc_live_ecto_heex())
     |> assign(:live_ecto_elixir, Demo.form_doc_live_ecto_elixir())
     |> assign_forms()}
  end

  defp assign_forms(socket) do
    phoenix_form =
      Phoenix.Component.to_form(%{"choice" => ""}, as: :radio_group_phoenix, id: @phoenix_form_id)

    ecto_form =
      %RadioGroupForm{}
      |> RadioGroupForm.changeset_validate(%{})
      |> Phoenix.Component.to_form(as: :radio_group_ecto, id: @ecto_form_id)

    socket
    |> assign(:phoenix_form, phoenix_form)
    |> assign(:ecto_form, ecto_form)
  end

  @impl true
  def handle_event("save_phoenix", %{"radio_group_phoenix" => params}, socket) do
    {:noreply, save_phoenix_choice(socket, params["choice"] || "")}
  end

  def handle_event("save_phoenix", _params, socket) do
    {:noreply, save_phoenix_choice(socket, "")}
  end

  def handle_event("validate", params, socket) do
    p = Map.get(params, "radio_group_ecto", %{})

    changeset =
      %RadioGroupForm{}
      |> RadioGroupForm.changeset_validate(p)
      |> Map.put(:action, :validate)

    {:noreply,
     assign(
       socket,
       :ecto_form,
       Phoenix.Component.to_form(changeset,
         action: :validate,
         as: :radio_group_ecto,
         id: @ecto_form_id
       )
     )}
  end

  @impl true
  def handle_event("save", params, socket) do
    p = Map.get(params, "radio_group_ecto", %{})

    case RadioGroupForm.changeset_validate(%RadioGroupForm{}, p) do
      %Ecto.Changeset{valid?: true} = changeset ->
        data = Ecto.Changeset.apply_changes(changeset)
        message = "Submitted: choice=#{data.choice}"

        {:noreply,
         socket
         |> Toast.create("layout-toast", "Submitted", message, :info, duration: 5000)
         |> assign(
           :ecto_form,
           Phoenix.Component.to_form(
             RadioGroupForm.changeset_validate(%RadioGroupForm{}, p),
             as: :radio_group_ecto,
             id: @ecto_form_id
           )
         )}

      %Ecto.Changeset{} = changeset ->
        changeset = Map.put(changeset, :action, :insert)

        {:noreply,
         assign(
           socket,
           :ecto_form,
           Phoenix.Component.to_form(changeset,
             action: :insert,
             as: :radio_group_ecto,
             id: @ecto_form_id
           )
         )}
    end
  end

  defp save_phoenix_choice(socket, choice) do
    socket
    |> Toast.create("layout-toast", "Submitted", "choice=#{choice}", :info, duration: 5000)
    |> assign(
      :phoenix_form,
      Phoenix.Component.to_form(%{"choice" => choice},
        as: :radio_group_phoenix,
        id: @phoenix_form_id
      )
    )
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} mode={@mode} theme={@theme} path={@path}>
      <.demo_page path={@path} id="radio-group-form-live-page" title={~t"Radio Group · Form"}>
        <.demo_section
          id="radio-group-live-form-phoenix-section"
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
          id="radio-group-live-form-ecto-section"
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
