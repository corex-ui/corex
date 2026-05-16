defmodule E2eWeb.TagsInputFormLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  import E2eWeb.Demos.TagsInputDemo,
    only: [form_preview_live_changeset: 1, form_preview_controller_native: 1]

  alias E2e.Form.TagsInputForm
  alias Corex.Toast
  alias E2eWeb.Demos.TagsInputDemo, as: Demo

  @live_changeset_id "tags-input-live-changeset-form"

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Tags Input · Live Form")
     |> assign(:form_ecto, Demo.form_ecto())
     |> assign(:live_changeset_heex, Demo.form_doc_live_changeset_heex())
     |> assign(:live_changeset_elixir, Demo.form_doc_live_changeset_elixir())
     |> assign(:native_heex, Demo.form_native_heex())
     |> assign_forms()}
  end

  defp assign_forms(socket) do
    form =
      %TagsInputForm{}
      |> TagsInputForm.changeset_validate(%{"tags" => "alpha,beta"})
      |> Phoenix.Component.to_form(as: :tags_input_changeset, id: @live_changeset_id)

    assign(socket, :form, form)
  end

  @impl true
  def handle_event("validate", event_params, socket) do
    params = Map.get(event_params, "tags_input_changeset", %{})

    changeset =
      %TagsInputForm{}
      |> TagsInputForm.changeset_validate(params)
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(
       :form,
       Phoenix.Component.to_form(changeset,
         action: :validate,
         as: :tags_input_changeset,
         id: @live_changeset_id
       )
     )}
  end

  @impl true
  def handle_event("save", event_params, socket) do
    params = Map.get(event_params, "tags_input_changeset", %{})

    case TagsInputForm.changeset_validate(%TagsInputForm{}, params) do
      %Ecto.Changeset{valid?: true} = changeset ->
        data = Ecto.Changeset.apply_changes(changeset)
        message = "Submitted: tags=#{data.tags}"

        {:noreply,
         socket
         |> Toast.create("layout-toast", "Submitted", message, :info, duration: 5000)
         |> assign(
           :form,
           Phoenix.Component.to_form(
             TagsInputForm.changeset_validate(%TagsInputForm{}, %{"tags" => "alpha,beta"}),
             as: :tags_input_changeset,
             id: @live_changeset_id
           )
         )}

      %Ecto.Changeset{} = changeset ->
        {:noreply,
         socket
         |> assign(
           :form,
           Phoenix.Component.to_form(changeset,
             action: :insert,
             as: :tags_input_changeset,
             id: @live_changeset_id
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
        id="tags-input-form-live-page"
        title="Tags Input · Live Form"
        subtitle="LiveView phx-change and phx-submit with a changeset-backed form."
      >
        <.demo_section
          id="tags-input-live-form-changeset"
          title="Phoenix Form (changeset)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @live_changeset_heex},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @live_changeset_elixir},
            %{value: "ecto", label: "Ecto", language: :elixir, code: @form_ecto}
          ]}
        >
          <:preview>
            <.form_preview_live_changeset form={@form} />
          </:preview>
        </.demo_section>

        <.demo_section
          id="tags-input-live-form-native"
          title="Native form (plain HTML)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @native_heex}
          ]}
        >
          <:preview>
            <.form_preview_controller_native />
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
