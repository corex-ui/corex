defmodule E2eWeb.EditableFormLive do
  use E2eWeb, :live_view

  alias E2e.Form.EditableForm
  alias Corex.Form
  alias Corex.Toast

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Editable form")
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
  def handle_event("validate", %{"editable_form" => params}, socket) do
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
  def handle_event("save", %{"editable_form" => params}, socket) do
    case EditableForm.changeset(%EditableForm{}, params) do
      %Ecto.Changeset{valid?: true} = changeset ->
        data = Ecto.Changeset.apply_changes(changeset)
        message = "Submitted: text=#{data.text}"

        {:noreply,
         socket
         |> Toast.push_toast("layout-toast", "Submitted", message, :info, 5000)
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
    assigns = assign(assigns, :text_value, get_text_from_form(assigns.form))

    ~H"""
    <Layouts.app
      flash={@flash}
      mode={@mode}
      theme={@theme}
      locale={@locale}
      current_path={@current_path}
    >
      <.layout_heading>
        <:title>Editable form</:title>
        <:subtitle>Live View Form</:subtitle>
      </.layout_heading>
      <p>Phoenix form with Ecto changeset and controlled editable</p>

      <.form
        for={@form}
        id={Form.get_form_id(@form)}
        phx-change="validate"
        phx-submit="save"
      >
        <.editable
          id="editable-form-text"
          name="editable_form[text]"
          value={@text_value}
          placeholder="Enter text"
          activation_mode="dblclick"
          select_on_focus
          class="editable"
        >
          <:label>Text</:label>
          <:edit_trigger><.heroicon name="hero-pencil-square" class="icon" /></:edit_trigger>
          <:submit_trigger><.heroicon name="hero-check" class="icon" /></:submit_trigger>
          <:cancel_trigger><.heroicon name="hero-x-mark" class="icon" /></:cancel_trigger>
        </.editable>
        <.action type="submit" id="editable-form-live-submit" class="button button--accent">
          Submit
        </.action>
      </.form>
    </Layouts.app>
    """
  end

  defp get_text_from_form(form) do
    form.params["text"] ||
      Ecto.Changeset.get_change(form.source, :text) ||
      Ecto.Changeset.get_field(form.source, :text) ||
      ""
  end
end
