defmodule E2eWeb.NestedFieldsPatternsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias E2eWeb.Demos.NestedFieldsDemo
  alias E2eWeb.Demos.NestedFieldsDemo.Profile

  @impl true
  def mount(_params, _session, socket) do
    changeset =
      Profile.changeset(%Profile{}, %{
        "social_links" => [
          %{"label" => "Docs", "url" => "https://example.test/docs"}
        ]
      })

    {:ok,
     socket
     |> assign(:form, to_form(changeset, as: :profile))
     |> assign(:code, NestedFieldsDemo.minimal_code())}
  end

  @impl true
  def handle_event("validate", %{"profile" => params}, socket) do
    changeset =
      %Profile{}
      |> Profile.changeset(params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :form, to_form(changeset, as: :profile))}
  end

  def handle_event("save", %{"profile" => params}, socket) do
    changeset = Profile.changeset(%Profile{}, params)

    if changeset.valid? do
      {:noreply, assign(socket, :form, to_form(changeset, as: :profile))}
    else
      {:noreply,
       assign(socket, :form, to_form(Map.put(changeset, :action, :insert), as: :profile))}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.demo_page
      path={@path}
      id="nested-fields-patterns-page"
      title={~t"Nested Fields · Patterns"}
      heading_class="layout-heading"
    >
      <.demo_section id="nested-fields-patterns-form" title={~t"Live form"} code={@code}>
        <:preview>
          <.form
            for={@form}
            id="nested-fields-patterns-form"
            phx-change="validate"
            phx-submit="save"
            class="flex w-full flex-col gap-space"
          >
            <.nested_fields field={@form[:social_links]} class="nested-fields">
              <:label>Social links</:label>
              <:description>Optional profile URLs for this ticket.</:description>
              <:empty>No links yet.</:empty>
              <:col :let={f} label="Label">
                <.native_input field={f[:label]} type="text" class="native-input">
                  <:label>Label</:label>
                </.native_input>
              </:col>
              <:col :let={f} label="URL">
                <.native_input field={f[:url]} type="url" class="native-input">
                  <:label>URL</:label>
                </.native_input>
              </:col>
              <:add_trigger>Add link</:add_trigger>
              <:remove_trigger><.heroicon name="hero-trash" class="icon" /></:remove_trigger>
            </.nested_fields>
            <.action type="submit" class="button ui-accent">Save</.action>
          </.form>
        </:preview>
      </.demo_section>
    </.demo_page>
    """
  end
end
