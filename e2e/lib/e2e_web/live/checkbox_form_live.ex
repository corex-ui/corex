defmodule E2eWeb.CheckboxFormLive do
  use E2eWeb, :live_view

  alias Corex.Toast
  alias E2e.Form.Terms
  alias Corex.Form

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Checkbox form")
     |> assign_form()}
  end

  defp assign_form(socket) do
    form =
      %Terms{}
      |> Terms.changeset(%{})
      |> Phoenix.Component.to_form(as: :terms)

    assign(socket, :form, form)
  end

  @impl true
  def handle_event("validate", %{"terms" => params}, socket) do
    changeset =
      %Terms{}
      |> Terms.changeset(params)
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(:form, Phoenix.Component.to_form(changeset, action: :validate, as: :terms))}
  end

  @impl true
  def handle_event("save", %{"terms" => params}, socket) do
    case Terms.changeset(%Terms{}, params) do
      %Ecto.Changeset{valid?: true} = changeset ->
        data = Ecto.Changeset.apply_changes(changeset)
        message = "Submitted: terms=#{data.terms}"

        {:noreply,
         socket
         |> Toast.push_toast("layout-toast", "Submitted", message, :info, 5000)
         |> assign(
           :form,
           Phoenix.Component.to_form(Terms.changeset(%Terms{}, params), as: :terms)
         )}

      %Ecto.Changeset{} = changeset ->
        {:noreply,
         socket
         |> assign(:form, Phoenix.Component.to_form(changeset, action: :insert, as: :terms))}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app
      flash={@flash}
      mode={@mode}
      theme={@theme}
      locale={@locale}
      current_path={@current_path}
    >
      <.layout_heading>
        <:title>Checkbox form</:title>
        <:subtitle>Live View Form</:subtitle>
      </.layout_heading>
      <p>Phoenix form with Ecto changeset and controlled checkbox</p>

      <.form
        for={@form}
        id={Form.get_form_id(@form)}
        phx-change="validate"
        phx-submit="save"
      >
        <.checkbox field={@form[:terms]} class="checkbox" controlled id="checkbox-form-terms">
          <:label>Accept terms</:label>
          <:error :let={msg}>
            <.heroicon name="hero-exclamation-circle" class="icon" />
            {msg}
          </:error>
        </.checkbox>
        <.action type="submit" id="checkbox-form-live-submit" class="button button--accent">
          Submit
        </.action>
      </.form>
    </Layouts.app>
    """
  end
end
