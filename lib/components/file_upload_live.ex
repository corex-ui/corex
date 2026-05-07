defmodule Corex.FileUploadLive do
  @moduledoc ~S'''
  LiveView uploads wrapper that shares [`Corex.FileUpload`](Corex.FileUpload.html) layout tokens (`data-scope` / `data-part`) and styling.

  Use after [`allow_upload/3`](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html#allow_upload/3). Pass `upload={@uploads.name}` and `field` matching the atom given to `allow_upload`. Renders [`live_file_input`](https://hexdocs.pm/phoenix_live_view/Phoenix.Component.html#live_file_input/1) and `phx-drop-target`; **no** Zag `FileUpload` hook. Do not combine this component with `<.file_upload>` on the same file control.

  Forms must bind [`phx-change`](https://hexdocs.pm/phoenix_live_view/uploads.html) (and typically `phx-submit`) as in the [uploads guide](https://hexdocs.pm/phoenix_live_view/uploads.html).

  ## Examples

  <!-- tabs-open -->

  ### Minimal

  ```heex
  <form phx-change="validate">
    <.file_upload_live upload={@uploads.anatomy_minimal} field={:anatomy_minimal} id="file-upload-live-anatomy-minimal">
      <:close>
        <.heroicon name="hero-x-mark" />
      </:close>
    </.file_upload_live>
  </form>
  ```

  ### With label

  ```heex
  <form phx-change="validate">
    <.file_upload_live upload={@uploads.anatomy_label} field={:anatomy_label} id="file-upload-live-anatomy-label">
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
    <.file_upload_live upload={@uploads.anatomy_custom} field={:anatomy_custom} id="file-upload-live-anatomy-custom">
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
  <form phx-change="validate" phx-submit="save" id="file-upload-live-form">
    <.file_upload_live upload={@uploads.attachment} field={:attachment} id="file-upload-live-field">
      <:label>Attachment</:label>
      <:close>
        <.heroicon name="hero-x-mark" />
      </:close>
    </.file_upload_live>
    <.action type="submit" class="button button--accent w-full">Submit</.action>
  </form>
  ```

  ```elixir
  def mount(_params, _session, socket) do
    {:ok,
     allow_upload(socket, :attachment,
       accept: ~w(.jpg .jpeg .png .pdf .txt),
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
  ```

  <!-- tabs-close -->

  The Minimal / With label / Custom slots HEEx matches the e2e anatomy page; each expects `allow_upload` for `:anatomy_minimal`, `:anatomy_label`, or `:anatomy_custom` respectively (same names as `field`).

  Implement `file_upload_live_cancel` so remove-entry works; optional `cancel_event` on the component overrides the event name.
  '''

  use Phoenix.Component

  alias Phoenix.LiveView.UploadConfig
  alias Phoenix.LiveView.UploadEntry

  attr(:upload, UploadConfig, required: true)

  attr(:field, :atom,
    required: true,
    doc: "Upload name passed to `allow_upload` (for cancel events)"
  )

  attr(:id, :string,
    default: nil,
    doc: "Stable prefix for internal ids; defaults to a generated id"
  )

  attr(:dir, :string, default: "ltr", values: ["ltr", "rtl"])
  attr(:invalid, :boolean, default: false)
  attr(:disabled, :boolean, default: false)

  attr(:cancel_event, :string,
    default: "file_upload_live_cancel",
    doc: "LiveView `handle_event` name; receives ref and upload_field"
  )

  attr(:translation, Corex.FileUpload.Translation,
    default: nil,
    doc: "Same translatable strings as `<.file_upload>`"
  )

  attr(:rest, :global)

  slot(:label, required: false)

  slot(:dropzone, required: false)

  slot(:open, required: false)

  slot(:close, required: true)

  slot(:error, required: false) do
    attr(:class, :string, required: false)
  end

  def file_upload_live(assigns) do
    default_translation = %Corex.FileUpload.Translation{
      dropzone: Corex.Gettext.gettext("Drag your file(s) here"),
      open: Corex.Gettext.gettext("Upload file(s)")
    }

    translation = merge_translation(Map.get(assigns, :translation), default_translation)

    assigns =
      assigns
      |> assign_new(:id, fn -> "file-upload-live-#{System.unique_integer([:positive])}" end)
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
                  width="40"
                  height="40"
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

  defp merge_translation(nil, default), do: default

  defp merge_translation(
         %Corex.FileUpload.Translation{} = partial,
         %Corex.FileUpload.Translation{} = default
       ) do
    %Corex.FileUpload.Translation{
      dropzone: partial.dropzone || default.dropzone,
      open: partial.open || default.open
    }
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
