defmodule E2eWeb.CascadeSelectFormLive do
  use E2eWeb, :live_view
  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]
  alias Corex.Toast
  alias E2e.Form.CascadeSelectForm

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       page_title: "Cascade select · Live Form",
       form:
         %CascadeSelectForm{}
         |> CascadeSelectForm.changeset(%{})
         |> to_form(as: :cascade, id: "cascade-select-live-form")
     )}
  end

  @impl true
  def handle_event("save", %{"cascade" => params}, socket) do
    changeset = CascadeSelectForm.changeset(%CascadeSelectForm{}, params)

    {:noreply,
     socket
     |> Toast.create("layout-toast", "Submitted", inspect(params), :info, duration: 4000)
     |> assign(:form, to_form(changeset, as: :cascade, id: "cascade-select-live-form"))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} mode={@mode} theme={@theme} path={@path}>
      <.demo_page path={@path} id="cascade-select-live-form-page" title="Cascade select · Live Form">
        <.demo_section id="cascade-select-live-form" title="Phoenix Form">
          <:preview>
            <.form for={@form} id="cascade-select-live-form" phx-submit="save" class="flex flex-col gap-space">
              <.cascade_select class="cascade-select" name="cascade[category]">
                <:label>Category</:label>
                <:indicator>▾</:indicator>
              </.cascade_select>
              <.action type="submit" class="button ui-size-sm">Submit</.action>
            </.form>
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
