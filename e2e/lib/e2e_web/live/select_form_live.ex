defmodule E2eWeb.SelectFormLive do
  use E2eWeb, :live_view

  alias E2e.Form.SelectForm
  alias Corex.Form
  alias Corex.Toast

  @country_collection [
    %{label: "France", id: "fra"},
    %{label: "Belgium", id: "bel"},
    %{label: "Germany", id: "deu"},
    %{label: "Netherlands", id: "nld"},
    %{label: "Switzerland", id: "che"},
    %{label: "Austria", id: "aut"}
  ]

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Select form")
     |> assign(:country_collection, @country_collection)
     |> assign_form()}
  end

  defp assign_form(socket) do
    form =
      %SelectForm{}
      |> SelectForm.changeset(%{})
      |> Phoenix.Component.to_form(as: :select_form, id: "select-form")

    assign(socket, :form, form)
  end

  @impl true
  def handle_event("validate", event_params, socket) do
    params =
      Map.get(event_params, "select_form") ||
        socket.assigns.form.params

    changeset =
      %SelectForm{}
      |> SelectForm.changeset(params)
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(
       :form,
       Phoenix.Component.to_form(changeset,
         action: :validate,
         as: :select_form,
         id: "select-form"
       )
     )}
  end

  @impl true
  def handle_event("save", event_params, socket) do
    params =
      Map.get(event_params, "select_form") ||
        socket.assigns.form.params

    case SelectForm.changeset(%SelectForm{}, params) do
      %Ecto.Changeset{valid?: true} = changeset ->
        data = Ecto.Changeset.apply_changes(changeset)
        message = "Submitted: country=#{data.country}"

        {:noreply,
         socket
         |> Toast.push_toast("layout-toast", "Submitted", message, :info, 5000)
         |> assign(
           :form,
           Phoenix.Component.to_form(SelectForm.changeset(%SelectForm{}, params),
             as: :select_form,
             id: "select-form"
           )
         )}

      %Ecto.Changeset{} = changeset ->
        {:noreply,
         socket
         |> assign(
           :form,
           Phoenix.Component.to_form(changeset,
             action: :insert,
             as: :select_form,
             id: "select-form"
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
      locale={@locale}
      current_path={@current_path}
    >
      <.layout_heading>
        <:title>Select form</:title>
        <:subtitle>Live View Form</:subtitle>
      </.layout_heading>
      <p>Phoenix form with Ecto changeset and select</p>

      <.form
        for={@form}
        id={Form.get_form_id(@form)}
        phx-change="validate"
        phx-submit="save"
      >
        <.select
          field={@form[:country]}
          class="select"
          id="select-form-country"
          placeholder="Select a country"
          items={@country_collection}
        >
          <:label>Country</:label>
          <:trigger>
            <.heroicon name="hero-chevron-down" />
          </:trigger>
          <:error :let={msg}>
            <.heroicon name="hero-exclamation-circle" class="icon" />
            {msg}
          </:error>
        </.select>
        <.action type="submit" id="select-form-live-submit" class="button button--accent">
          Submit
        </.action>
      </.form>
    </Layouts.app>
    """
  end
end
