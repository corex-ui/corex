defmodule Corex.FileUploadLive do
  @moduledoc ~S'''
  LiveView uploads wrapper that shares [`Corex.FileUpload`](Corex.FileUpload.html) layout tokens (`data-scope` / `data-part`) and styling.

  Use after [`allow_upload/3`](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html#allow_upload/3). Pass `upload={@uploads.name}` and `field` matching the atom given to `allow_upload`. Renders [`live_file_input`](https://hexdocs.pm/phoenix_live_view/Phoenix.Component.html#live_file_input/1) and `phx-drop-target`; **no** Zag `FileUpload` hook. Do not combine this component with `<.file_upload>` on the same file control.

  Forms must bind [`phx-change`](https://hexdocs.pm/phoenix_live_view/uploads.html) (and typically `phx-submit`) as in the [uploads guide](https://hexdocs.pm/phoenix_live_view/uploads.html). For shared form patterns, see the [Forms](forms.html) guide.

  ## Anatomy

  <!-- tabs-open -->

  ### Minimal

  ```heex
  <form phx-change="validate">
    <.file_upload_live upload={@uploads.document} field={:document} class="file-upload">
      <:close>
        <.heroicon name="hero-x-mark" />
      </:close>
    </.file_upload_live>
  </form>
  ```

  ### With label

  ```heex
  <form phx-change="validate">
    <.file_upload_live upload={@uploads.document} field={:document} class="file-upload">
      <:label>Files</:label>
      <:close>
        <.heroicon name="hero-x-mark" />
      </:close>
    </.file_upload_live>
  </form>
  ```

  ### Custom slots

  ```heex
  <form phx-change="validate">
    <.file_upload_live upload={@uploads.document} field={:document} class="file-upload">
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
  ```

  ### Form with submit

  ```heex
  <form phx-change="validate" phx-submit="save">
    <.file_upload_live upload={@uploads.attachment} field={:attachment} class="file-upload">
      <:label>Attachment</:label>
      <:close>
        <.heroicon name="hero-x-mark" />
      </:close>
    </.file_upload_live>
    <.action type="submit" class="button ui-accent">Submit</.action>
  </form>
  ```

  ```elixir
  def mount(_params, _session, socket) do
    {:ok,
     allow_upload(socket, :attachment,
       accept: ~W(.jpg .jpeg .png .pdf .txt),
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
    {:noreply, Corex.FileUploadLive.cancel_upload_from_params(socket, :attachment, params)}
  end
  ```

  <!-- tabs-close -->

  ### LiveView setup

  ```elixir
  def mount(_params, _session, socket) do
    {:ok,
     allow_upload(socket, :document,
       accept: ~w(.jpg .jpeg .png .pdf),
       max_entries: 3,
       max_file_size: 8_000_000
     )}
  end

  def handle_event("file_upload_live_cancel", params, socket) do
    {:noreply, Corex.FileUploadLive.cancel_upload_from_params(socket, :document, params)}
  end
  ```

  The `field` atom must match the name passed to `allow_upload/3`. Implement `file_upload_live_cancel` so remove-entry works; optional `cancel_event` on the component overrides the event name.
  '''

  @doc type: :component
  use Phoenix.Component

  alias Corex.FileUpload.Translation
  alias Phoenix.LiveView.UploadConfig
  alias Phoenix.LiveView.UploadEntry

  attr(:upload, UploadConfig,
    required: true,
    doc: "Upload config from `allow_upload/3` on the LiveView socket"
  )

  attr(:field, :atom,
    required: true,
    doc: "Upload name passed to `allow_upload` (for cancel events)"
  )

  attr(:id, :string,
    default: nil,
    doc: "Stable prefix for internal ids; defaults to a generated id"
  )

  attr(:dir, :string,
    default: nil,
    values: [nil, "ltr", "rtl"],
    doc: "Text direction (ltr or rtl)"
  )

  attr(:invalid, :boolean, default: nil, doc: "Whether the file upload is invalid")

  attr(:auto_invalid, :boolean,
    default: false,
    doc: "When true with `field`, set invalid from visible changeset errors"
  )

  attr(:disabled, :boolean, default: false, doc: "Whether the file upload is disabled")

  attr(:cancel_event, :string,
    default: "file_upload_live_cancel",
    doc: "LiveView `handle_event` name; receives ref and upload_field"
  )

  attr(:translation, Corex.FileUpload.Translation,
    default: nil,
    doc: "Same translatable strings as `<.file_upload>`"
  )

  attr(:rest, :global)

  slot(:label, required: false, doc: "Label above the dropzone")

  slot(:dropzone,
    required: false,
    doc: "Custom dropzone content; defaults to translation dropzone text"
  )

  slot(:open,
    required: false,
    doc: "Custom open-picker trigger; defaults to translation open text"
  )

  slot(:close, required: true, doc: "Remove control for each upload entry")

  slot(:error,
    required: false,
    doc: "Error message content; receives the message as slot argument"
  ) do
    attr(:class, :string, required: false)
  end

  def file_upload_live(assigns) do
    translation = Translation.resolve(Map.get(assigns, :translation))

    assigns =
      assigns
      |> Corex.FormField.require_id!("Corex component (file-upload-live)")
      |> assign(:translation, translation)

    ~H"""
    <div id={@id} class="file-upload" {@rest}>
      <div
        data-scope="file-upload"
        data-part="root"
        id={"file:#{@id}"}
        dir={@dir}
        data-invalid={@invalid && ""}
      >
        <label
          :if={@label != []}
          data-scope="file-upload"
          data-part="label"
          for={@upload.ref}
          id={"file:#{@id}:label"}
          dir={@dir}
        >
          {render_slot(@label)}
        </label>
        <div data-scope="file-upload" data-part="region">
          <.live_file_input
            upload={@upload}
            disabled={@disabled}
            data-scope="file-upload"
            data-part="hidden-input"
          />
          <label
            for={@upload.ref}
            phx-drop-target={@upload.ref}
            data-scope="file-upload"
            data-part="dropzone"
            id={"file:#{@id}:dropzone"}
            dir={@dir}
          >
            <%= if @dropzone != [] do %>
              {render_slot(@dropzone)}
            <% else %>
              <span>{@translation.dropzone}</span>
            <% end %>
          </label>
          <label
            for={@upload.ref}
            data-scope="file-upload"
            data-part="trigger"
            id={"file:#{@id}:trigger"}
            dir={@dir}
          >
            <%= if @open != [] do %>
              {render_slot(@open)}
            <% else %>
              {@translation.open}
            <% end %>
          </label>
        </div>
        <ul
          :if={@upload.entries != []}
          data-scope="file-upload"
          data-part="item-group"
          data-file-type="accepted"
          data-type="accepted"
          id={"file:#{@id}:item-group:accepted"}
          dir={@dir}
        >
          <li
            :for={entry <- @upload.entries}
            data-scope="file-upload"
            data-part="item"
          >
            <div data-scope="file-upload" data-part="item-lead">
              <div :if={image_entry?(entry)} data-scope="file-upload" data-part="item-preview">
                <.live_img_preview
                  entry={entry}
                  data-scope="file-upload"
                  data-part="item-preview-image"
                />
              </div>
            </div>
            <span data-scope="file-upload" data-part="item-name">{entry.client_name}</span>
            <span data-scope="file-upload" data-part="item-size-text">{format_bytes(entry.client_size)}</span>
            <button
              type="button"
              phx-click={@cancel_event}
              phx-value-ref={entry.ref}
              phx-value-upload_field={Atom.to_string(@field)}
              data-scope="file-upload"
              data-part="item-delete-trigger"
            >
              {render_slot(@close)}
            </button>
          </li>
        </ul>
        <%= for err <- upload_errors(@upload) do %>
          <div data-scope="file-upload" data-part="error">
            <%= if @error != [] do %>
              {render_slot(@error, upload_err_text(err))}
            <% else %>
              {upload_err_text(err)}
            <% end %>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  @doc """
  Cancels an upload entry from a LiveView `handle_event/3` callback.

  Pass the same `field` atom given to `allow_upload/3`. Forged or unknown
  `upload_field` values are ignored without raising.
  """
  @spec cancel_upload_from_params(Phoenix.LiveView.Socket.t(), atom(), map()) ::
          Phoenix.LiveView.Socket.t()
  def cancel_upload_from_params(socket, expected_field, %{"ref" => ref, "upload_field" => field})
      when is_atom(expected_field) and is_binary(ref) and is_binary(field) do
    if field == Atom.to_string(expected_field) do
      case safe_existing_atom(field) do
        {:ok, atom} -> Phoenix.LiveView.cancel_upload(socket, atom, ref)
        :error -> socket
      end
    else
      socket
    end
  end

  def cancel_upload_from_params(socket, _expected_field, _params), do: socket

  defp safe_existing_atom(param) when is_binary(param) do
    {:ok, String.to_existing_atom(param)}
  rescue
    ArgumentError -> :error
  end

  defp image_entry?(%UploadEntry{} = entry) do
    case entry.client_type do
      nil -> false
      type when is_binary(type) -> String.starts_with?(type, "image/")
      _ -> false
    end
  end

  defp format_bytes(nil), do: ""

  defp format_bytes(n) when is_integer(n) and n >= 1_048_576 do
    "#{Float.round(n / 1_048_576, 1)} MB"
  end

  defp format_bytes(n) when is_integer(n) and n >= 1024 do
    "#{Float.round(n / 1024, 1)} KB"
  end

  defp format_bytes(n) when is_integer(n), do: Integer.to_string(n) <> " B"

  defp upload_err_text(:too_many_files), do: Corex.Gettext.gettext("Too many files")

  defp upload_err_text(:too_large), do: Corex.Gettext.gettext("File is too large")

  defp upload_err_text(:not_accepted), do: Corex.Gettext.gettext("Unacceptable file type")

  defp upload_err_text(:external_client_failure), do: Corex.Gettext.gettext("Upload failed")

  defp upload_err_text({:writer_failure, _reason}), do: Corex.Gettext.gettext("Upload failed")

  defp upload_err_text(other), do: inspect(other)
end
