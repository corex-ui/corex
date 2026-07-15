defmodule E2eWeb.TagsInputFormLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias Corex.Toast
  alias E2e.Form.TagsInputForm
  alias E2eWeb.Demos.TagsInputDemo, as: Demo

  @phoenix_form_id "tags-input-live-form-phoenix"
  @ecto_form_id "tags-input-live-form-ecto"
  @ecto_invalid_form_id "tags-input-live-form-ecto-invalid"

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Tags Input · Form")
     |> assign(:form_ecto, Demo.form_ecto())
     |> assign(:live_phoenix_heex, Demo.form_doc_live_phoenix_heex())
     |> assign(:live_phoenix_elixir, Demo.form_doc_live_phoenix_elixir())
     |> assign(:live_ecto_heex, Demo.form_doc_live_ecto_heex())
     |> assign(:live_ecto_elixir, Demo.form_doc_live_ecto_elixir())
     |> assign(:live_ecto_invalid_heex, Demo.form_doc_live_ecto_invalid_heex())
     |> assign(:live_ecto_invalid_elixir, Demo.form_doc_live_ecto_invalid_elixir())
     |> assign_forms()}
  end

  defp assign_forms(socket) do
    phoenix_form =
      Phoenix.Component.to_form(%{"tags" => ["alpha", "beta"]},
        as: :tags_input_phoenix,
        id: @phoenix_form_id
      )

    ecto_form =
      %TagsInputForm{}
      |> TagsInputForm.changeset_validate(%{"tags" => ["alpha", "beta"]})
      |> Phoenix.Component.to_form(as: :tags_input_ecto, id: @ecto_form_id)

    ecto_invalid_form =
      %TagsInputForm{}
      |> TagsInputForm.changeset_validate(%{"tags" => ["alpha", "beta"]})
      |> Phoenix.Component.to_form(as: :tags_input_ecto_invalid, id: @ecto_invalid_form_id)

    socket
    |> assign(:phoenix_form, phoenix_form)
    |> assign(:ecto_form, ecto_form)
    |> assign(:ecto_invalid_form, ecto_invalid_form)
  end

  @impl true
  def handle_event("validate", %{"tags_input_ecto" => params}, socket) do
    {:noreply, assign_ecto_form(socket, params, :ecto_form, :tags_input_ecto, @ecto_form_id)}
  end

  def handle_event("validate", _params, socket), do: {:noreply, socket}

  def handle_event("validate_invalid", %{"tags_input_ecto_invalid" => params}, socket) do
    {:noreply,
     assign_ecto_form(
       socket,
       params,
       :ecto_invalid_form,
       :tags_input_ecto_invalid,
       @ecto_invalid_form_id
     )}
  end

  @impl true
  def handle_event("save", %{"tags_input_ecto" => params}, socket) do
    save_ecto(socket, params, :ecto_form, :tags_input_ecto, @ecto_form_id)
  end

  def handle_event("save_invalid", %{"tags_input_ecto_invalid" => params}, socket) do
    save_ecto(socket, params, :ecto_invalid_form, :tags_input_ecto_invalid, @ecto_invalid_form_id)
  end

  def handle_event("save", _params, socket) do
    {:noreply, assign_ecto_form(socket, %{}, :ecto_form, :tags_input_ecto, @ecto_form_id)}
  end

  def handle_event("save_phoenix", %{"tags_input_phoenix" => params}, socket) do
    {:noreply, save_phoenix_tags(socket, params)}
  end

  def handle_event("save_phoenix", _params, socket) do
    tags = socket.assigns.phoenix_form.params["tags"] |> List.wrap()
    {:noreply, save_phoenix_tags(socket, %{"tags" => tags})}
  end

  defp save_phoenix_tags(socket, params) do
    tags = List.wrap(params["tags"])

    Toast.create(
      socket,
      "layout-toast",
      "Submitted",
      "tags=#{inspect(tags)}",
      :info,
      duration: 5000
    )
  end

  defp assign_ecto_form(socket, params, form_key, form_as, form_id) when is_map(params) do
    changeset =
      %TagsInputForm{}
      |> TagsInputForm.changeset_validate(params)
      |> Map.put(:action, :validate)

    assign(
      socket,
      form_key,
      Phoenix.Component.to_form(changeset,
        action: :validate,
        as: form_as,
        id: form_id
      )
    )
  end

  defp save_ecto(socket, params, form_key, form_as, form_id) do
    case TagsInputForm.changeset_validate(%TagsInputForm{}, params) do
      %Ecto.Changeset{valid?: true} = changeset ->
        data = Ecto.Changeset.apply_changes(changeset)
        message = "Submitted: tags=#{inspect(data.tags)}"

        {:noreply,
         socket
         |> Toast.create("layout-toast", "Submitted", message, :info, duration: 5000)
         |> assign(
           form_key,
           Phoenix.Component.to_form(
             TagsInputForm.changeset_validate(%TagsInputForm{}, params),
             as: form_as,
             id: form_id
           )
         )}

      %Ecto.Changeset{} = changeset ->
        {:noreply,
         assign(
           socket,
           form_key,
           Phoenix.Component.to_form(changeset,
             action: :validate,
             as: form_as,
             id: form_id
           )
         )}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} mode={@mode} theme={@theme} path={@path}>
      <.demo_page path={@path} id="tags-input-form-live-page" title={~t"Tags Input · Form"}>
        <.demo_section
          id="tags-input-live-form-phoenix-section"
          title={~t"Phoenix Form"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @live_phoenix_heex},
            %{value: "elixir", label: ~t"Elixir", language: :elixir, code: @live_phoenix_elixir}
          ]}
        >
          <:preview>
            <Demo.form_preview_live_phoenix form={@phoenix_form} />
          </:preview>
        </.demo_section>

        <.demo_section
          id="tags-input-live-form-ecto-section"
          title={~t"Phoenix Form + Ecto"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @live_ecto_heex},
            %{value: "elixir", label: ~t"Elixir", language: :elixir, code: @live_ecto_elixir},
            %{value: "ecto", label: ~t"Ecto", language: :elixir, code: @form_ecto}
          ]}
        >
          <:preview>
            <Demo.form_preview_live_ecto form={@ecto_form} />
          </:preview>
        </.demo_section>

        <.demo_section
          id="tags-input-live-form-ecto-invalid-section"
          title={~t"Phoenix Form + Ecto + Invalid"}
          code_tabs={[
            %{
              value: "heex",
              label: ~t"Heex",
              language: :heex,
              code: @live_ecto_invalid_heex
            },
            %{
              value: "elixir",
              label: ~t"Elixir",
              language: :elixir,
              code: @live_ecto_invalid_elixir
            },
            %{value: "ecto", label: ~t"Ecto", language: :elixir, code: @form_ecto}
          ]}
        >
          <:preview>
            <Demo.form_preview_live_ecto_invalid form={@ecto_invalid_form} />
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
