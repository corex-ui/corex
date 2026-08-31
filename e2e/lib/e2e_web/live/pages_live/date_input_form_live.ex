defmodule E2eWeb.DateInputFormLive do
  use E2eWeb, :live_view
  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]
  alias Corex.Toast
  alias E2e.Form.DateInputForm

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       page_title: "Date input · Live Form",
       form:
         %DateInputForm{}
         |> DateInputForm.changeset(%{})
         |> to_form(as: :date_input, id: "date-input-live-form")
     )}
  end

  @impl true
  def handle_event("save", %{"date_input" => params}, socket) do
    changeset = DateInputForm.changeset(%DateInputForm{}, params)

    if changeset.valid? do
      {:noreply,
       socket
       |> Toast.create("layout-toast", "Submitted", inspect(params), :info, duration: 4000)
       |> assign(:form, to_form(changeset, as: :date_input, id: "date-input-live-form"))}
    else
      {:noreply,
       assign(
         socket,
         :form,
         to_form(changeset, action: :insert, as: :date_input, id: "date-input-live-form")
       )}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} mode={@mode} theme={@theme} path={@path}>
      <.demo_page path={@path} id="date-input-live-form-page" title="Date input · Live Form">
        <.demo_section id="date-input-live-form" title="Phoenix Form">
          <:preview>
            <.form
              for={@form}
              id="date-input-live-form"
              phx-submit="save"
              class="flex flex-col gap-space"
            >
              <.date_input class="date-input" name="date_input[born_on]" />
              <.action type="submit" class="button ui-size-sm">Submit</.action>
            </.form>
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
