defmodule E2eWeb.EditableFormLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias Corex.Toast
  alias E2e.Form.EditableForm
  alias E2eWeb.Demos.EditableDemo, as: Demo

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Editable · Form")
     |> assign(:form_ecto, Demo.form_ecto())
     |> assign(:live_basic_heex, Demo.form_doc_live_changeset_heex())
     |> assign(:live_basic_elixir, Demo.form_doc_live_changeset_elixir())
     |> assign_form()}
  end

  defp assign_form(socket) do
    form =
      %EditableForm{}
      |> EditableForm.changeset(%{})
      |> Phoenix.Component.to_form(as: :editable_form, id: "editable-form")

    assign(socket, :form, form)
  end

  @impl true
  def handle_event("validate", event_params, socket) do
    params =
      Map.get(event_params, "editable_form") ||
        socket.assigns.form.params

    changeset =
      %EditableForm{}
      |> EditableForm.changeset(params)
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(
       :form,
       Phoenix.Component.to_form(changeset,
         action: :validate,
         as: :editable_form,
         id: "editable-form"
       )
     )}
  end

  @impl true
  def handle_event("value_changed", %{"value" => value}, socket) do
    params = Map.merge(socket.assigns.form.params || %{}, %{"text" => to_string(value)})

    changeset =
      %EditableForm{}
      |> EditableForm.changeset(params)
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(
       :form,
       Phoenix.Component.to_form(changeset,
         action: :validate,
         as: :editable_form,
         id: "editable-form"
       )
     )}
  end

  @impl true
  def handle_event("save", event_params, socket) do
    params =
      Map.get(event_params, "editable_form") ||
        socket.assigns.form.params

    case EditableForm.changeset(%EditableForm{}, params) do
      %Ecto.Changeset{valid?: true} = changeset ->
        data = Ecto.Changeset.apply_changes(changeset)
        message = "Submitted: text=#{data.text}"

        {:noreply,
         socket
         |> Toast.create("layout-toast", "Submitted", message, :info, duration: 5000)
         |> assign(
           :form,
           Phoenix.Component.to_form(EditableForm.changeset(%EditableForm{}, params),
             as: :editable_form,
             id: "editable-form"
           )
         )}

      %Ecto.Changeset{} = changeset ->
        {:noreply,
         socket
         |> assign(
           :form,
           Phoenix.Component.to_form(changeset,
             action: :insert,
             as: :editable_form,
             id: "editable-form"
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
        id="editable-form-live-page"
        title="Editable · Form"
        subtitle="Live View form"
      >
        <.demo_section
          id="editable-live-form-changeset"
          title="Phoenix form (changeset)"
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
      </.demo_page>
    </Layouts.app>
    """
  end
end
