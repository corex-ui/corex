defmodule Corex.FileUpload do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js File Upload](https://zagjs.com/components/react/file-upload).

  Use `multipart` on the parent form and read `%Plug.Upload{}` from params in a **controller** action, as in [Phoenix file uploads](https://hexdocs.pm/phoenix/file_uploads.html).

  LiveView `phx-submit` cannot transport raw multipart file bytes over the WebSocket; use a controller route for classic `Plug.Upload`, or [`allow_upload/3`](https://hexdocs.pm/phoenix_live_view/uploads.html) for LiveView-native uploads with [`Corex.FileUploadLive`](Corex.FileUploadLive.html) (`<.file_upload_live>`). Do not combine this Zag component with [`live_file_input`](https://hexdocs.pm/phoenix_live_view/Phoenix.Component.html#live_file_input/1) on the same file control.

  ## Anatomy

  <!-- tabs-open -->

  ### Minimal

  ```heex
  <.file_upload name="document" class="file-upload">
    <:close>
      <.heroicon name="hero-x-mark" />
    </:close>
  </.file_upload>
  ```

  ### With label

  ```heex
  <.file_upload name="document" class="file-upload">
    <:label>Files</:label>
    <:close>
      <.heroicon name="hero-x-mark" />
    </:close>
  </.file_upload>
  ```

  ### Custom slots

  ```heex
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
  ```

  ### Multipart form (controller)

  ```heex
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
    <.action type="submit" class="button button--accent w-full">Submit</.action>
  </.form>
  ```

  <!-- tabs-close -->

  Use `multipart` on the parent form so `%Plug.Upload{}` is available on the server for classic uploads. Optional hidden `_sent` supports `used_input?` when validating empty submits.

  ## API

  Requires a stable `id` on `<.file_upload>`.

  | Function | Action | Returns |
  | -------- | ------ | ------- |
  | [`clear_files/1`](#clear_files/1) | Clear accepted files (client) | `%Phoenix.LiveView.JS{}` |
  | [`clear_files/2`](#clear_files/2) | Clear accepted files (server) | `socket` |
  | [`clear_rejected_files/1`](#clear_rejected_files/1) | Clear rejected list (client) | `%Phoenix.LiveView.JS{}` |
  | [`clear_rejected_files/2`](#clear_rejected_files/2) | Clear rejected list (server) | `socket` |
  | [`open_file_picker/1`](#open_file_picker/1) | Open native picker (client) | `%Phoenix.LiveView.JS{}` |
  | [`open_file_picker/2`](#open_file_picker/2) | Open native picker (server) | `socket` |

  ## Events

  Pick an event name and pass it to `on_*` on `<.file_upload>`. Rejected files are not listed in the DOM; use `on_file_reject` to react to validation failures.

  ### Server events

  | Event | When | Payload |
  | ----- | ---- | ------- |
  | `on_file_change="files_changed"` | Accepted file list changes | `%{"id" => id, ...}` |
  | `on_file_accept="file_accepted"` | File passes validation | `%{"id" => id, ...}` |
  | `on_file_reject="file_rejected"` | File fails validation | `%{"id" => id, ...}` |

  ### Client events

  | Event | When | `event.detail` |
  | ----- | ---- | -------------- |
  | `on_file_change_client="files-changed"` | Accepted list changes | `id`, file metadata |
  | `on_file_accept_client="file-accepted"` | File accepted | `id`, file metadata |
  | `on_file_reject_client="file-rejected"` | File rejected | `id`, reason |

  ## Form

  See **Multipart form** under Anatomy. Use `field={f[:attachment]}` inside `<.form multipart>`.

  '''

  @doc type: :component
  use Phoenix.Component

  import Corex.Api.Doc

  alias Corex.FileUpload.Anatomy.{
    Dropzone,
    HiddenInput,
    InputSentinel,
    ItemGroup,
    Label,
    Props,
    Root,
    Trigger
  }

  alias Corex.FileUpload.Connect
  alias Corex.FileUpload.Translation
  alias Phoenix.LiveView
  alias Phoenix.LiveView.JS

  attr(:id, :string,
    required: false,
    doc: "Stable id for the file upload root; set automatically when using field"
  )

  attr(:disabled, :boolean, default: false, doc: "Whether the file upload is disabled")
  attr(:invalid, :boolean, default: false, doc: "Whether the file upload is invalid")
  attr(:read_only, :boolean, default: false, doc: "Whether the file upload is read-only")
  attr(:required, :boolean, default: false, doc: "Whether at least one file is required")
  attr(:name, :string, doc: "The name attribute of the hidden file input")
  attr(:form, :string, doc: "The id of the form this control belongs to")

  attr(:dir, :string,
    default: nil,
    values: [nil, "ltr", "rtl"],
    doc: "Text direction (ltr or rtl)"
  )

  attr(:max_files, :integer,
    default: 1,
    doc: "Maximum number of files the user may select"
  )

  attr(:max_file_size, :integer,
    default: nil,
    doc: "Maximum file size in bytes; omit for no limit"
  )

  attr(:min_file_size, :integer,
    default: nil,
    doc: "Minimum file size in bytes; omit for no limit"
  )

  attr(:allow_drop, :boolean,
    default: true,
    doc: "Whether drag-and-drop onto the dropzone is enabled"
  )

  attr(:prevent_document_drop, :boolean,
    default: true,
    doc: "When true, prevents dropping files on the document outside the dropzone"
  )

  attr(:accept, :string,
    default: nil,
    doc: "Comma-separated MIME types or extensions (e.g. image/*,.pdf)"
  )

  attr(:directory, :boolean,
    default: false,
    doc: "When true, allow selecting a directory instead of individual files"
  )

  attr(:on_file_change, :string,
    default: nil,
    doc: "Server event when the accepted file list changes"
  )

  attr(:on_file_change_client, :string,
    default: nil,
    doc: "Client event name when the accepted file list changes"
  )

  attr(:on_file_accept, :string,
    default: nil,
    doc: "Server event when a file passes validation"
  )

  attr(:on_file_accept_client, :string,
    default: nil,
    doc: "Client event name when a file passes validation"
  )

  attr(:on_file_reject, :string,
    default: nil,
    doc: "Server event when a file fails validation"
  )

  attr(:on_file_reject_client, :string,
    default: nil,
    doc: "Client event name when a file fails validation"
  )

  attr(:translation, Corex.FileUpload.Translation,
    default: nil,
    doc: "Override translatable strings"
  )

  attr(:errors, :list,
    default: [],
    doc: "List of error messages when not using field="
  )

  attr(:field, Phoenix.HTML.FormField,
    doc: "Form field for id, name, form, invalid, and required wiring"
  )

  attr(:rest, :global)

  slot(:label, required: false, doc: "Label above the dropzone") do
    attr(:class, :string, required: false)
  end

  slot(:dropzone,
    required: false,
    doc: "Custom dropzone content; defaults to translation dropzone text"
  )

  slot(:open,
    required: false,
    doc: "Custom open-picker trigger; defaults to translation open text"
  )

  slot(:close, required: true, doc: "Remove control for each accepted file entry") do
    attr(:class, :string, required: false)
  end

  slot(:error,
    required: false,
    doc: "Error message content; receives the message as slot argument"
  ) do
    attr(:class, :string, required: false)
  end

  def file_upload(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    show_errors? = Phoenix.Component.used_input?(field)

    errors =
      if show_errors? do
        Enum.map(field.errors, &Corex.Gettext.translate_error(&1))
      else
        []
      end

    invalid =
      (field.errors != [] and show_errors?) or Map.get(assigns, :invalid, false)

    assigns =
      assigns
      |> assign_new(:id, fn -> field.id end)
      |> assign_new(:name, fn -> field.name end)
      |> assign_new(:form, fn -> field.form.id end)
      |> assign(:invalid, invalid)
      |> assign(:errors, errors)
      |> assign(field: nil)

    file_upload(assigns)
  end

  def file_upload(assigns) do
    translation = Translation.resolve(Map.get(assigns, :translation))

    assigns =
      assigns
      |> assign_new(:id, fn -> "file-upload-#{System.unique_integer([:positive])}" end)
      |> assign_new(:name, fn -> nil end)
      |> assign_new(:form, fn -> nil end)
      |> assign_new(:dir, fn -> "ltr" end)
      |> assign_new(:max_files, fn -> 1 end)
      |> assign_new(:max_file_size, fn -> nil end)
      |> assign_new(:min_file_size, fn -> nil end)
      |> assign_new(:allow_drop, fn -> true end)
      |> assign_new(:prevent_document_drop, fn -> true end)
      |> assign_new(:accept, fn -> nil end)
      |> assign_new(:directory, fn -> false end)
      |> assign_new(:errors, fn -> [] end)
      |> assign(:translation, translation)

    ~H"""
    <div
      id={@id}
      phx-hook="FileUpload"
      data-loading
      phx-mounted={Phoenix.LiveView.JS.ignore_attributes(["data-loading"])}
      {@rest}
      {Connect.props(%Props{
        id: @id,
        disabled: @disabled,
        invalid: @invalid,
        read_only: @read_only,
        required: @required,
        name: @name,
        form: @form,
        dir: @dir,
        max_files: @max_files,
        max_file_size: @max_file_size,
        min_file_size: @min_file_size,
        allow_drop: @allow_drop,
        prevent_document_drop: @prevent_document_drop,
        accept: @accept,
        directory: @directory,
        on_file_change: @on_file_change,
        on_file_change_client: @on_file_change_client,
        on_file_accept: @on_file_accept,
        on_file_accept_client: @on_file_accept_client,
        on_file_reject: @on_file_reject,
        on_file_reject_client: @on_file_reject_client,
        dropzone: @translation.dropzone
      })}
    >
      <template
        id={"#{@id}-item-close-template"}
        data-file-upload-item-close-template
        phx-update="ignore"
      >
        {render_slot(@close)}
      </template>
      <div phx-mounted={Connect.ignore_root(%Root{id: @id, dir: @dir, read_only: @read_only})} {Connect.root(%Root{id: @id, dir: @dir, read_only: @read_only})}>
        <label :if={@label != []} phx-mounted={Connect.ignore_label(%Label{id: @id, dir: @dir})} {Connect.label(%Label{id: @id, dir: @dir})}>
          {render_slot(@label)}
        </label>
        <div data-scope="file-upload" data-part="region">
          <input
            :if={@name}
            phx-mounted={
              Connect.ignore_input_sentinel(%InputSentinel{id: @id, name: @name, form: @form})
            }
            {Connect.input_sentinel(%InputSentinel{id: @id, name: @name, form: @form})}
          />
          <input
            phx-mounted={
              Connect.ignore_hidden_input(%HiddenInput{
                id: @id,
                disabled: @disabled,
                name: @name,
                form: @form
              })
            }
            {Connect.hidden_input(%HiddenInput{id: @id, disabled: @disabled, name: @name, form: @form})}
          />
          <div phx-mounted={Connect.ignore_dropzone(%Dropzone{id: @id})} {Connect.dropzone(%Dropzone{id: @id})}>
            <%= if @dropzone != [] do %>
              {render_slot(@dropzone)}
            <% else %>
              <span>{@translation.dropzone}</span>
            <% end %>
          </div>
          <button phx-mounted={Connect.ignore_trigger(%Trigger{id: @id, dir: @dir})} {Connect.trigger(%Trigger{id: @id, dir: @dir})}>
            <%= if @open != [] do %>
              {render_slot(@open)}
            <% else %>
              {@translation.open}
            <% end %>
          </button>
        </div>
        <ul
          phx-mounted={
            Connect.ignore_item_group(%ItemGroup{
              id: @id,
              type: "accepted",
              dir: @dir,
              disabled: @disabled
            })
          }
          {Connect.item_group(%ItemGroup{id: @id, type: "accepted", dir: @dir, disabled: @disabled})}
        >
        </ul>
      </div>
      <div :if={@error != []} :for={msg <- @errors} data-scope="file-upload" data-part="error">
        {render_slot(@error, msg)}
      </div>
    </div>
    """
  end

  api_doc(~S"""
  Drop every accepted file entry from `phx-click`. Dispatches `corex:file-upload:clear-files`.

  ```heex
  <.action phx-click={Corex.FileUpload.clear_files("my-fu")}>Clear accepted</.action>
  <.file_upload id="my-fu" class="file-upload" accept="image/*">
    <:close><.heroicon name="hero-x-mark" /></:close>
  </.file_upload>
  ```

  ```javascript
  document.getElementById("my-fu")?.dispatchEvent(new CustomEvent("corex:file-upload:clear-files", { bubbles: false }));
  ```
  """)

  def clear_files(file_upload_id) when is_binary(file_upload_id) do
    JS.dispatch("corex:file-upload:clear-files",
      to: "##{file_upload_id}",
      bubbles: false
    )
  end

  api_doc(~S"""
  Clear accepted files from `handle_event` (`file_upload_clear_files`).

  ```elixir
  def handle_event("clear_files", _, socket) do
    {:noreply, Corex.FileUpload.clear_files(socket, "my-fu")}
  end
  ```
  """)

  def clear_files(socket, file_upload_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(file_upload_id) do
    LiveView.push_event(socket, "file_upload_clear_files", %{"id" => file_upload_id})
  end

  api_doc(~S"""
  Remove rejected entries from `phx-click`. Dispatches `corex:file-upload:clear-rejected`.

  ```heex
  <.action phx-click={Corex.FileUpload.clear_rejected_files("my-fu")}>Clear rejected</.action>
  <.file_upload id="my-fu" class="file-upload">
    <:close><.heroicon name="hero-x-mark" /></:close>
  </.file_upload>
  ```
  """)

  def clear_rejected_files(file_upload_id) when is_binary(file_upload_id) do
    JS.dispatch("corex:file-upload:clear-rejected",
      to: "##{file_upload_id}",
      bubbles: false
    )
  end

  api_doc(~S"""
  Clear rejected files from `handle_event` (`file_upload_clear_rejected`).

  ```elixir
  def handle_event("clear_rejected", _, socket) do
    {:noreply, Corex.FileUpload.clear_rejected_files(socket, "my-fu")}
  end
  ```
  """)

  def clear_rejected_files(socket, file_upload_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(file_upload_id) do
    LiveView.push_event(socket, "file_upload_clear_rejected", %{"id" => file_upload_id})
  end

  api_doc(~S"""
  Open the OS file picker from `phx-click`. Dispatches `corex:file-upload:open`.

  ```heex
  <.action phx-click={Corex.FileUpload.open_file_picker("my-fu")}>Browse</.action>
  <.file_upload id="my-fu" class="file-upload">
    <:close><.heroicon name="hero-x-mark" /></:close>
  </.file_upload>
  ```
  """)

  def open_file_picker(file_upload_id) when is_binary(file_upload_id) do
    JS.dispatch("corex:file-upload:open", to: "##{file_upload_id}", bubbles: false)
  end

  api_doc(~S"""
  Open the OS file picker from `handle_event` (`file_upload_open`).

  ```elixir
  def handle_event("browse", _, socket) do
    {:noreply, Corex.FileUpload.open_file_picker(socket, "my-fu")}
  end
  ```
  """)

  def open_file_picker(socket, file_upload_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(file_upload_id) do
    LiveView.push_event(socket, "file_upload_open", %{"id" => file_upload_id})
  end
end
