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
     |> assign(:phoenix_attachment_names, [])
     |> assign(:ecto_attachment_names, [])
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
  def handle_event("file_upload_changed", params, socket) do
    names = file_upload_accepted_names(params)
    id = Map.get(params, "id", "")

    socket =
      socket
      |> assign_attachment_names(id, names)
      |> maybe_revalidate_ecto_form(id, names)

    {:noreply, socket}
  end

  def handle_event("save_phoenix", _params, socket) do
    label = FileUploadForm.names_label(socket.assigns.phoenix_attachment_names)

    {:noreply,
     socket
     |> Toast.create("layout-toast", "Submitted", "attachment=#{label}", :info, duration: 5000)}
  end

  def handle_event("validate", params, socket) do
    p = ecto_form_params(params, socket.assigns.ecto_attachment_names)

    {:noreply, assign(socket, :ecto_form, ecto_validate_form(p))}
  end

  def handle_event("save", params, socket) do
    p = ecto_form_params(params, socket.assigns.ecto_attachment_names)

    case FileUploadForm.changeset_validate(%FileUploadForm{}, p) do
      %Ecto.Changeset{valid?: true} ->
        label = FileUploadForm.names_label(socket.assigns.ecto_attachment_names)

        {:noreply,
         socket
         |> Toast.create("layout-toast", "Submitted", "attachment=#{label}", :info,
           duration: 5000
         )}

      %Ecto.Changeset{} = changeset ->
        changeset = Map.put(changeset, :action, :insert)

        {:noreply,
         assign(
           socket,
           :ecto_form,
           Phoenix.Component.to_form(changeset,
             action: :insert,
             as: :file_upload_ecto,
             id: @ecto_form_id
           )
         )}
    end
  end

  defp file_upload_accepted_names(%{"acceptedNames" => names}) when is_list(names), do: names

  defp file_upload_accepted_names(%{"firstAcceptedName" => name})
       when is_binary(name) and name != "",
       do: [name]

  defp file_upload_accepted_names(_), do: []

  defp assign_attachment_names(socket, id, names) do
    cond do
      String.contains?(id, "phoenix") ->
        assign(socket, :phoenix_attachment_names, names)

      String.contains?(id, "ecto") ->
        assign(socket, :ecto_attachment_names, names)

      true ->
        socket
    end
  end

  defp maybe_revalidate_ecto_form(socket, id, names) do
    if String.contains?(id, "ecto") do
      assign(socket, :ecto_form, ecto_validate_form(ecto_form_params(%{}, names)))
    else
      socket
    end
  end

  defp ecto_form_params(params, names) do
    sent = Map.get(params, "file_upload_ecto", %{})["_sent"] || "1"

    params
    |> Map.get("file_upload_ecto", %{})
    |> Map.drop(["attachment", "attachment_label"])
    |> put_ecto_attachment_param(names)
    |> Map.put("_sent", sent)
  end

  defp put_ecto_attachment_param(attrs, []), do: Map.put(attrs, "attachment", "")

  defp put_ecto_attachment_param(attrs, names),
    do: FileUploadForm.put_attachment_label(attrs, names)

  defp ecto_validate_form(params) do
    changeset =
      %FileUploadForm{}
      |> FileUploadForm.changeset_validate(params)
      |> Map.put(:action, :validate)

    Phoenix.Component.to_form(changeset,
      action: :validate,
      as: :file_upload_ecto,
      id: @ecto_form_id
    )
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
