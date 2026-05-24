defmodule E2eWeb.FileUploadFormLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias Corex.Toast
  alias E2e.Form.FileUploadForm
  alias E2eWeb.Demos.FileUploadDemo, as: Demo

  @phoenix_form_id "file-upload-live-form-phoenix"
  @ecto_form_id "file-upload-live-form-ecto"

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "File Upload · Form")
     |> assign(:form_ecto, Demo.form_ecto())
     |> assign(:live_phoenix_heex, Demo.form_doc_live_phoenix_heex())
     |> assign(:live_phoenix_elixir, Demo.form_doc_live_phoenix_elixir())
     |> assign(:live_ecto_heex, Demo.form_doc_live_ecto_heex())
     |> assign(:live_ecto_elixir, Demo.form_doc_live_ecto_elixir())
     |> assign_forms()}
  end

  defp assign_forms(socket) do
    phoenix_form =
      Phoenix.Component.to_form(%{"attachment" => nil},
        as: :file_upload_phoenix,
        id: @phoenix_form_id
      )

    ecto_form =
      %FileUploadForm{}
      |> FileUploadForm.changeset_validate(%{})
      |> Phoenix.Component.to_form(as: :file_upload_ecto, id: @ecto_form_id)

    socket
    |> assign(:phoenix_form, phoenix_form)
    |> assign(:ecto_form, ecto_form)
  end

  @impl true
  def handle_event("save_phoenix", _params, socket) do
    {:noreply,
     socket
     |> Toast.create("layout-toast", "Submitted", "attachment uploaded", :info, duration: 5000)}
  end

  @impl true
  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("save", _params, socket) do
    {:noreply,
     socket
     |> Toast.create("layout-toast", "Submitted", "attachment saved", :info, duration: 5000)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} mode={@mode} theme={@theme} path={@path}>
      <.demo_page path={@path} id="file-upload-form-live-page" title={~t"File Upload · Form"}>
        <.demo_section
          id="file-upload-live-form-phoenix-section"
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
          id="file-upload-live-form-ecto-section"
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
      </.demo_page>
    </Layouts.app>
    """
  end
end
