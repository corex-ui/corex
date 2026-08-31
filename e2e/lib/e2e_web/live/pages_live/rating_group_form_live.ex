defmodule E2eWeb.RatingGroupFormLive do
  use E2eWeb, :live_view
  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]
  alias Corex.Toast
  alias E2e.Form.RatingGroupForm

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       page_title: "Rating group · Live Form",
       form:
         %RatingGroupForm{}
         |> RatingGroupForm.changeset(%{})
         |> to_form(as: :rating, id: "rating-group-live-form")
     )}
  end

  @impl true
  def handle_event("save", %{"rating" => params}, socket) do
    changeset = RatingGroupForm.changeset(%RatingGroupForm{}, params)

    {:noreply,
     socket
     |> Toast.create("layout-toast", "Submitted", inspect(params), :info, duration: 4000)
     |> assign(:form, to_form(changeset, as: :rating, id: "rating-group-live-form"))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} mode={@mode} theme={@theme} path={@path}>
      <.demo_page path={@path} id="rating-group-live-form-page" title="Rating group · Live Form">
        <.demo_section id="rating-group-live-form" title="Phoenix Form">
          <:preview>
            <.form
              for={@form}
              id="rating-group-live-form"
              phx-submit="save"
              class="flex flex-col gap-space"
            >
              <.rating_group class="rating-group" name="rating[score]" allow_half />
              <.action type="submit" class="button ui-size-sm">Submit</.action>
            </.form>
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
