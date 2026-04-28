defmodule E2eWeb.EditableFormLive do
  use E2eWeb, :live_view

  alias E2e.Form.EditableForm
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
    ~H"""
    <Layouts.app
      flash={@flash}
      mode={@mode}
      theme={@theme}
      path={@path}
    >
      <article id="editable-form-live-page" class="w-full flex flex-col gap-4">
        <.layout_heading>
          <:title>Editable form</:title>
          <:subtitle>Live View Form</:subtitle>
        </.layout_heading>
        <p>Phoenix form with Ecto changeset and editable (field=)</p>

        <.form
          for={@form}
          id={@form.id}
          phx-change="validate"
          phx-submit="save"
        >
          <.editable
            field={@form[:text]}
            on_value_change="value_changed"
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
      </article>
    </Layouts.app>
    """
  end
end
