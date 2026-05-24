defmodule E2eWeb.Demos.FileUploadDemo do
  use E2eWeb, :html

  alias Phoenix.LiveView.JS

  def anatomy_minimal_code do
    ~S"""
    <.file_upload name="document" class="file-upload">
      <:close>
        <.heroicon name="hero-x-mark" />
      </:close>
    </.file_upload>
    """
  end

  def anatomy_minimal_example(assigns) do
    _ = assigns

    ~H"""
    <.file_upload id="file-upload-anatomy-minimal" name="document" class="file-upload">
      <:close>
        <.heroicon name="hero-x-mark" />
      </:close>
    </.file_upload>
    """
  end

  def anatomy_with_label_code do
    ~S"""
    <.file_upload name="document" class="file-upload">
      <:label>Files</:label>
      <:close>
        <.heroicon name="hero-x-mark" />
      </:close>
    </.file_upload>
    """
  end

  def anatomy_with_label_example(assigns) do
    _ = assigns

    ~H"""
    <.file_upload id="file-upload-anatomy-label" name="document" class="file-upload">
      <:label>Files</:label>
      <:close>
        <.heroicon name="hero-x-mark" />
      </:close>
    </.file_upload>
    """
  end

  def live_anatomy_minimal_code do
    ~S"""
    <form phx-change="validate">
      <.file_upload_live upload={@uploads.anatomy_minimal} field={:anatomy_minimal}>
        <:close>
          <.heroicon name="hero-x-mark" />
        </:close>
      </.file_upload_live>
    </form>
    """
  end

  def live_anatomy_with_label_code do
    ~S"""
    <form phx-change="validate">
      <.file_upload_live upload={@uploads.anatomy_label} field={:anatomy_label}>
        <:label>Files</:label>
        <:close>
          <.heroicon name="hero-x-mark" />
        </:close>
      </.file_upload_live>
    </form>
    """
  end

  def anatomy_custom_slots_code do
    ~S"""
    <.file_upload name="document" class="file-upload">
      <:dropzone>
        <span>Custom dropzone</span>
      </:dropzone>
      <:open>
        <span>Custom trigger</span>
      </:open>
      <:close>
        <.heroicon name="hero-x-mark" />
      </:close>
    </.file_upload>
    """
  end

  def anatomy_custom_slots_example(assigns) do
    _ = assigns

    ~H"""
    <.file_upload id="file-upload-anatomy-custom" name="document" class="file-upload">
      <:dropzone>
        <span>Custom dropzone</span>
      </:dropzone>
      <:open>
        <span>Custom trigger</span>
      </:open>
      <:close>
        <.heroicon name="hero-x-mark" />
      </:close>
    </.file_upload>
    """
  end

  def live_anatomy_custom_slots_code do
    ~S"""
    <form phx-change="validate">
      <.file_upload_live upload={@uploads.anatomy_custom} field={:anatomy_custom}>
        <:dropzone>
          <span>Custom dropzone</span>
        </:dropzone>
        <:open>
          <span>Custom trigger</span>
        </:open>
        <:close>
          <.heroicon name="hero-x-mark" />
        </:close>
      </.file_upload_live>
    </form>
    """
  end

  def form_ecto do
    ~S"""
    defmodule MyApp.Form.FileUploadForm do
      use Ecto.Schema
      import Ecto.Changeset

      embedded_schema do
        field :attachment, :map, virtual: true
      end

      def changeset(form, attrs \\ %{}) do
        cast(form, attrs, [:attachment])
      end

      def changeset_validate(form, attrs \\ %{}) do
        form
        |> cast(attrs, [:attachment])
        |> validate_attachment_required()
      end

      defp validate_attachment_required(changeset) do
        upload = get_change(changeset, :attachment)

        if present_upload?(upload) do
          changeset
        else
          add_error(changeset, :attachment, "can't be blank", validation: :required)
        end
      end

      defp present_upload?(%Plug.Upload{filename: name}) when is_binary(name) and name != "", do: true
      defp present_upload?(_), do: false
    end
    """
  end

  def form_doc_controller_phoenix_heex do
    ~S"""
    <.form for={@phoenix_form} action={~p"/file-upload/form"} method="post" multipart>
      <.file_upload field={@phoenix_form[:attachment]} class="file-upload">
        <:label>Attachment</:label>
        <:close>
          <.heroicon name="hero-x-mark" />
        </:close>
      </.file_upload>
      <.action type="submit" class="button button--accent">Submit</.action>
    </.form>
    """
  end

  def form_doc_controller_phoenix_elixir do
    ~S"""
    def file_upload_form_page(conn, _params) do
      phoenix_form =
        Phoenix.Component.to_form(%{"attachment" => nil}, as: :file_upload_phoenix, id: "file-upload-form-phoenix")

      render(conn, :file_upload_form_page, phoenix_form: phoenix_form)
    end

    def file_upload_form_submit(conn, _params) do
      conn
      |> put_flash(:info, "Submitted")
      |> redirect(to: ~p"/file-upload/form#file-upload-form-phoenix")
    end
    """
  end

  def form_doc_live_phoenix_heex do
    ~S"""
    <.form for={@phoenix_form} phx-submit="save_phoenix" multipart>
      <.file_upload field={@phoenix_form[:attachment]} class="file-upload" id="file-upload-live-phoenix-field">
        <:label>Attachment</:label>
        <:close>
          <.heroicon name="hero-x-mark" />
        </:close>
      </.file_upload>
      <.action type="submit" id="file-upload-live-phoenix-submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_changeset_heex do
    ~S"""
    <.form for={@form} action={~p"/file-upload/form"} method="post" multipart>
      <input type="hidden" name="file_upload_changeset[_sent]" value="1" />
      <.file_upload field={@form[:attachment]} class="file-upload">
        <:label>Attachment</:label>
        <:close>
          <.heroicon name="hero-x-mark" />
        </:close>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.file_upload>
      <.action type="submit" class="button button--accent">Submit</.action>
    </.form>
    """
  end

  def form_changeset_elixir do
    ~S"""
    changeset = MyApp.Form.FileUploadForm.changeset(%MyApp.Form.FileUploadForm{}, %{})
    to_form(changeset, as: :file_upload_changeset, id: "file-upload-changeset-form")
    """
  end

  def form_validate_heex do
    ~S"""
    <.form for={@form} action={~p"/file-upload/form"} method="post" multipart>
      <input type="hidden" name="file_upload_validate[_sent]" value="1" />
      <.file_upload field={@form[:attachment]} class="file-upload">
        <:label>Attachment</:label>
        <:close>
          <.heroicon name="hero-x-mark" />
        </:close>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.file_upload>
      <.action type="submit" class="button button--accent">Submit</.action>
    </.form>
    """
  end

  def form_validate_elixir do
    ~S"""
    changeset = MyApp.Form.FileUploadForm.changeset_validate(%MyApp.Form.FileUploadForm{}, %{})
    to_form(changeset, as: :file_upload_validate, id: "file-upload-validate-form")
    """
  end

  def form_native_heex do
    ~S"""
    <form action={~p"/file-upload/form"} method="post" multipart class="w-full max-w-2xs flex flex-col gap-space">
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <.file_upload name="user[avatar]" class="file-upload">
        <:label>Avatar</:label>
        <:close>
          <.heroicon name="hero-x-mark" />
        </:close>
      </.file_upload>
      <.action type="submit" class="button button--accent">Submit</.action>
    </form>
    """
  end

  def form_doc_controller_native_elixir do
    ~S"""
    def file_upload_form_submit(conn, %{"user" => %{"avatar" => upload}}) do
      conn
      |> put_flash(:info, "Submitted: avatar=#{file_upload_attachment_label(upload)}")
      |> redirect(to: ~p"/file-upload/form#file-upload-form-native")
    end

    defp file_upload_attachment_label(%Plug.Upload{filename: name}) when name != "", do: name
    defp file_upload_attachment_label(_), do: "(none)"
    """
  end

  def form_native_elixir, do: form_doc_controller_native_elixir()

  attr(:form, :any, required: true)

  def form_preview_controller_changeset(assigns) do
    ~H"""
    <.form
      for={@form}
      action={~p"/file-upload/form"}
      method="post"
      multipart
    >
      <input type="hidden" name="file_upload_changeset[_sent]" value="1" />
      <.file_upload id="file-upload-cs-field" field={@form[:attachment]} class="file-upload">
        <:label>Attachment</:label>
        <:close>
          <.heroicon name="hero-x-mark" />
        </:close>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.file_upload>
      <.action type="submit" id="file-upload-cs-submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end

  attr(:form, :any, required: true)

  def form_preview_controller_validate(assigns) do
    ~H"""
    <.form
      for={@form}
      action={~p"/file-upload/form"}
      method="post"
      multipart
    >
      <input type="hidden" name="file_upload_validate[_sent]" value="1" />
      <.file_upload id="file-upload-val-field" field={@form[:attachment]} class="file-upload">
        <:label>Attachment</:label>
        <:close>
          <.heroicon name="hero-x-mark" />
        </:close>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.file_upload>
      <.action type="submit" id="file-upload-val-submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_preview_controller_native(assigns) do
    _ = assigns

    ~H"""
    <form
      action={~p"/file-upload/form"}
      method="post"
      id="file-upload-plain-form"
      multipart
    >
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <.file_upload id="file-upload-native" name="user[avatar]" class="file-upload">
        <:label>Avatar</:label>
        <:close>
          <.heroicon name="hero-x-mark" />
        </:close>
      </.file_upload>
      <.action type="submit" id="file-upload-native-submit" class="button button--accent">
        Submit
      </.action>
    </form>
    """
  end

  def api_open_phoenix_binding_heex do
    ~S"""
    <.action phx-click={Corex.FileUpload.open_file_picker("file-upload-api-phx")} class="button button--sm">
      Open picker
    </.action>
    <.file_upload id="file-upload-api-phx" name="demo[]" class="file-upload" max_files={3}>
      <:label>Upload</:label>
      <:close>
        <.heroicon name="hero-x-mark" />
      </:close>
    </.file_upload>
    """
  end

  def api_open_server_heex do
    ~S"""
    <.action phx-click="api_fu_open_server" phx-value-id="file-upload-api-server" class="button button--sm">
      Open picker
    </.action>
    <.file_upload id="file-upload-api-server" name="demo[]" class="file-upload" max_files={3}>
      <:label>Upload</:label>
      <:close>
        <.heroicon name="hero-x-mark" />
      </:close>
    </.file_upload>
    """
  end

  def api_open_server_elixir do
    ~S"""
    def handle_event("api_fu_open_server", %{"id" => id}, socket) do
      {:noreply, Corex.FileUpload.open_file_picker(socket, id)}
    end
    """
  end

  def api_open_client_js do
    ~S"""
    const el = document.getElementById("file-upload-api-js");
    el?.dispatchEvent(
      new CustomEvent("corex:file-upload:open", {
        bubbles: false,
      })
    );
    """
  end

  def api_open_phoenix_binding_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-2 mb-4 items-center w-full justify-center">
      <.action
        phx-click={Corex.FileUpload.open_file_picker("file-upload-api-phx")}
        class="button button--sm"
      >
        Open picker
      </.action>
    </div>
    <.file_upload id="file-upload-api-phx" name="demo[]" class="file-upload" max_files={3}>
      <:label>Upload</:label>
      <:close>
        <.heroicon name="hero-x-mark" />
      </:close>
    </.file_upload>
    """
  end

  def api_open_server_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-2 mb-4 items-center w-full justify-center">
      <.action
        phx-click="api_fu_open_server"
        phx-value-id="file-upload-api-server"
        class="button button--sm"
      >
        Open picker
      </.action>
    </div>
    <.file_upload id="file-upload-api-server" name="demo[]" class="file-upload" max_files={3}>
      <:label>Upload</:label>
      <:close>
        <.heroicon name="hero-x-mark" />
      </:close>
    </.file_upload>
    """
  end

  def api_open_client_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-2 mb-4 items-center w-full justify-center">
      <.action
        type="button"
        class="button button--sm"
        phx-click={JS.dispatch("corex:file-upload:open", to: "#file-upload-api-js", bubbles: false)}
      >
        Open picker (JS)
      </.action>
    </div>
    <.file_upload id="file-upload-api-js" name="demo[]" class="file-upload" max_files={3}>
      <:label>Upload</:label>
      <:close>
        <.heroicon name="hero-x-mark" />
      </:close>
    </.file_upload>
    """
  end

  def events_server_heex do
    ~S"""
    <.file_upload
      class="file-upload"
      name="ev-server[]"
      on_file_change="fu_ev_server"
    >
      <:label>Upload</:label>
      <:close>
        <.heroicon name="hero-x-mark" />
      </:close>
    </.file_upload>
    """
  end

  def events_server_elixir do
    E2eWeb.Demos.DocExamples.event_handler_snippet(
      "fu_ev_server",
      ~S|%{"id" => id, "acceptedCount" => c, "rejectedCount" => r} = params|
    )
  end

  def events_client_heex do
    ~S"""
    <.file_upload
      id="file-upload-events-client"
      class="file-upload"
      name="ev-client[]"
      on_file_change_client="file-upload-file-change"
    >
      <:label>Upload</:label>
      <:close>
        <.heroicon name="hero-x-mark" />
      </:close>
    </.file_upload>
    """
  end

  def events_client_js do
    ~S"""
    const el = document.getElementById("file-upload-events-client");
    el?.addEventListener("file-upload-file-change", (event) => console.log(event.detail));
    """
  end

  def events_client_elixir do
    E2eWeb.Demos.DocExamples.event_handler_snippet(
      "fu_ev_client",
      ~S|%{"id" => id, "acceptedCount" => c, "rejectedCount" => r} = params|
    )
  end

  def form_live_upload_heex do
    ~S"""
    <form phx-change="validate" phx-submit="save">
      <.file_upload_live upload={@uploads.attachment} field={:attachment}>
        <:label>Attachment</:label>
        <:close>
          <.heroicon name="hero-x-mark" />
        </:close>
      </.file_upload_live>
      <.action type="submit" class="button button--accent">Submit</.action>
    </form>
    """
  end

  def form_live_upload_file do
    ~S"""
    allow_upload(socket, :attachment,
      accept: ~W(.jpg .jpeg .png .gif .webp .pdf .txt),
      max_entries: 3,
      max_file_size: 8_000_000
    )
    """
  end

  def form_live_upload_elixir do
    ~S"""
    def mount(_params, _session, socket) do
      {:ok,
       socket
       |> allow_upload(:attachment,
         accept: ~W(.jpg .jpeg .png .gif .webp .pdf .txt),
         max_entries: 3,
         max_file_size: 8_000_000
       )}
    end

    def handle_event("validate", _params, socket), do: {:noreply, socket}

    def handle_event("save", _params, socket) do
      _results =
        consume_uploaded_entries(socket, :attachment, fn %{path: path}, entry ->
          File.rm!(path)
          {:ok, entry.client_name}
        end)

      {:noreply, socket}
    end

    def handle_event("file_upload_live_cancel", params, socket) do
      %{"ref" => ref, "upload_field" => field} = params
      {:noreply, cancel_upload(socket, String.to_existing_atom(field), ref)}
    end
    """
  end

  def form_live_upload_code_tabs do
    [
      %{value: "heex", label: "Heex", language: :heex, code: form_live_upload_heex()},
      %{value: "elixir", label: "Elixir", language: :elixir, code: form_live_upload_elixir()},
      %{value: "file", label: "File", language: :elixir, code: form_live_upload_file()}
    ]
  end

  def form_changeset_code_tabs do
    [
      %{value: "heex", label: "Heex", language: :heex, code: form_changeset_heex()},
      %{value: "elixir", label: "Elixir", language: :elixir, code: form_changeset_elixir()},
      %{value: "ecto", label: "Ecto", language: :elixir, code: form_ecto()}
    ]
  end

  def form_validate_code_tabs do
    [
      %{value: "heex", label: "Heex", language: :heex, code: form_validate_heex()},
      %{value: "elixir", label: "Elixir", language: :elixir, code: form_validate_elixir()},
      %{value: "ecto", label: "Ecto", language: :elixir, code: form_ecto()}
    ]
  end

  def form_native_code_tabs do
    [
      %{value: "heex", label: "Heex", language: :heex, code: form_native_heex()},
      %{value: "ecto", label: "Ecto", language: :elixir, code: form_ecto()}
    ]
  end

  attr(:form, :any, required: true)

  def form_preview_controller_phoenix(assigns) do
    ~H"""
    <.form for={@form} action={~p"/file-upload/form"} method="post" multipart>
      <.file_upload field={@form[:attachment]} class="file-upload">
        <:label>Attachment</:label>
        <:close>
          <.heroicon name="hero-x-mark" />
        </:close>
      </.file_upload>
      <.action type="submit" class="button button--accent">Submit</.action>
    </.form>
    """
  end

  def form_preview_controller_ecto(assigns), do: form_preview_controller_validate(assigns)
  def form_phoenix_heex, do: form_doc_controller_phoenix_heex()
  def form_phoenix_elixir, do: form_doc_controller_phoenix_elixir()
  def form_ecto_heex, do: form_validate_heex()
  def form_ecto_elixir, do: form_validate_elixir()
  def form_doc_live_ecto_heex, do: form_validate_heex()

  attr(:form, :any, required: true)

  def form_preview_live_phoenix(assigns) do
    ~H"""
    <.form for={@form} phx-submit="save_phoenix" multipart>
      <.file_upload id="file-upload-live-phoenix-field" field={@form[:attachment]} class="file-upload">
        <:label>Attachment</:label>
        <:close>
          <.heroicon name="hero-x-mark" />
        </:close>
      </.file_upload>
      <.action type="submit" id="file-upload-live-phoenix-submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end

  attr(:form, :any, required: true)

  def form_preview_live_ecto(assigns) do
    ~H"""
    <.form for={@form} phx-change="validate" phx-submit="save" multipart>
      <.file_upload id="file-upload-live-ecto-field" field={@form[:attachment]} class="file-upload">
        <:label>Attachment</:label>
        <:close>
          <.heroicon name="hero-x-mark" />
        </:close>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.file_upload>
      <.action type="submit" id="file-upload-live-ecto-submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_doc_live_phoenix_elixir do
    ~S"""
    defmodule MyAppWeb.FileUploadFormLive do
      use MyAppWeb, :live_view

      def mount(_params, _session, socket) do
        phoenix_form =
          Phoenix.Component.to_form(%{"attachment" => nil}, as: :file_upload_phoenix, id: "file-upload-live-form-phoenix")

        {:ok, assign(socket, :phoenix_form, phoenix_form)}
      end

      def handle_event("save_phoenix", %{"file_upload_phoenix" => params}, socket) do
    {:noreply, socket}
      end
    end
    """
  end

  def form_doc_live_ecto_elixir do
    ~S"""
    defmodule MyAppWeb.FileUploadFormLive do
      use MyAppWeb, :live_view

      def mount(_params, _session, socket) do
        ecto_form =
          %MyApp.Form.FileUploadForm{}
          |> MyApp.Form.FileUploadForm.changeset_validate(%{})
          |> Phoenix.Component.to_form(as: :file_upload_ecto, id: "file-upload-live-form-ecto")

        {:ok, assign(socket, :ecto_form, ecto_form)}
      end

      def handle_event("validate", %{"file_upload_ecto" => params}, socket) do
        changeset =
          %MyApp.Form.FileUploadForm{}
          |> MyApp.Form.FileUploadForm.changeset_validate(params)
          |> Map.put(:action, :validate)

        {:noreply,
         assign(
           socket,
           :ecto_form,
           Phoenix.Component.to_form(changeset,
             action: :validate,
             as: :file_upload_ecto,
             id: "file-upload-live-form-ecto"
           )
         )}
      end

      def handle_event("save", %{"file_upload_ecto" => params}, socket) do
        case MyApp.Form.FileUploadForm.changeset_validate(%MyApp.Form.FileUploadForm{}, params) do
          %Ecto.Changeset{valid?: true} = changeset ->
            _data = Ecto.Changeset.apply_changes(changeset)

            {:noreply,
             assign(
               socket,
               :ecto_form,
               Phoenix.Component.to_form(
                 MyApp.Form.FileUploadForm.changeset_validate(%MyApp.Form.FileUploadForm{}, params),
                 as: :file_upload_ecto,
                 id: "file-upload-live-form-ecto"
               )
             )}

          changeset ->
            {:noreply,
             assign(
               socket,
               :ecto_form,
               Phoenix.Component.to_form(changeset,
                 action: :insert,
                 as: :file_upload_ecto,
                 id: "file-upload-live-form-ecto"
               )
             )}
        end
      end
    end
    """
  end
end
