defmodule Corex.FileUpload do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js File Upload](https://zagjs.com/components/react/file-upload).

  Use `multipart` on the parent form and read `%Plug.Upload{}` from params in a **controller** action, as in [Phoenix file uploads](https://hexdocs.pm/phoenix/file_uploads.html).

  LiveView `phx-submit` cannot transport raw multipart file bytes over the WebSocket; use a controller route for classic `Plug.Upload`, or [`allow_upload/3`](https://hexdocs.pm/phoenix_live_view/uploads.html) for LiveView-native uploads with [`Corex.FileUploadLive`](Corex.FileUploadLive.html) (`<.file_upload_live>`). Do not combine this Zag component with [`live_file_input`](https://hexdocs.pm/phoenix_live_view/Phoenix.Component.html#live_file_input/1) on the same file control.

  ## API

  Client DOM dispatches:

  - `corex:file-upload:clear-files`
  - `corex:file-upload:clear-rejected`
  - `corex:file-upload:open`

  Server pushes (from `clear_files/2`, `clear_rejected_files/2`, `open_file_picker/2`):

  - `file_upload_clear_files`  -  `%{"id" => id}`
  - `file_upload_clear_rejected`  -  `%{"id" => id}`
  - `file_upload_open`  -  `%{"id" => id}`

  The template renders a single list of **accepted** files (Zag’s default). Rejected
  files are not listed in the DOM; use `on_file_change` (e.g. `rejectedCount`) and
  `on_file_reject` / `on_file_reject_client` to react to validation failures.

  ## Examples

  <!-- tabs-open -->

  ### Minimal

  ```heex
  <.file_upload id="file-upload-anatomy-minimal" name="document" class="file-upload">
    <:close>
      <.heroicon name="hero-x-mark" />
    </:close>
  </.file_upload>
  ```

  ### With label

  ```heex
  <.file_upload id="file-upload-anatomy-label" name="document" class="file-upload">
    <:label>Files</:label>
    <:close>
      <.heroicon name="hero-x-mark" />
    </:close>
  </.file_upload>
  ```

  ### Custom slots

  ```heex
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
  ```

  ### Multipart form (controller)

  ```heex
  <.form for={@form} action={~p"/file-upload/form"} method="post" id={@form.id} multipart>
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
  '''

  defmodule Translation do
    @moduledoc """
    Translation struct for FileUpload component strings.

    Without gettext: `translation={%FileUpload.Translation{dropzone: "Drop files"}}`

    With gettext: `translation={%FileUpload.Translation{dropzone: Corex.Gettext.gettext("Drag your file(s) here")}}`
    """
    defstruct [:dropzone, :open]
  end

  use Phoenix.Component

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
  alias Phoenix.LiveView
  alias Phoenix.LiveView.JS

  attr(:id, :string, required: false)
  attr(:disabled, :boolean, default: false)
  attr(:invalid, :boolean, default: false)
  attr(:read_only, :boolean, default: false)
  attr(:required, :boolean, default: false)
  attr(:name, :string)
  attr(:form, :string)
  attr(:dir, :string, default: nil, values: [nil, "ltr", "rtl"])
  attr(:max_files, :integer, default: 1)
  attr(:max_file_size, :integer, default: nil)
  attr(:min_file_size, :integer, default: nil)
  attr(:allow_drop, :boolean, default: true)
  attr(:prevent_document_drop, :boolean, default: true)
  attr(:accept, :string, default: nil)
  attr(:directory, :boolean, default: false)
  attr(:on_file_change, :string, default: nil)
  attr(:on_file_change_client, :string, default: nil)
  attr(:on_file_accept, :string, default: nil)
  attr(:on_file_accept_client, :string, default: nil)
  attr(:on_file_reject, :string, default: nil)
  attr(:on_file_reject_client, :string, default: nil)

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

  slot(:label, required: false) do
    attr(:class, :string, required: false)
  end

  slot(:dropzone, required: false)

  slot(:open, required: false)

  slot :close, required: true do
    attr(:class, :string, required: false)
  end

  slot :error, required: false do
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
    default_translation = %Translation{
      dropzone: Corex.Gettext.gettext("Drag your file(s) here"),
      open: Corex.Gettext.gettext("Upload file(s)")
    }

    translation = merge_translation(Map.get(assigns, :translation), default_translation)

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
      <div phx-mounted={Connect.ignore_root(%Root{id: @id, dir: @dir})} {Connect.root(%Root{id: @id, dir: @dir})}>
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

  defp merge_translation(nil, default), do: default

  defp merge_translation(%Translation{} = partial, %Translation{} = default) do
    %Translation{
      dropzone: partial.dropzone || default.dropzone,
      open: partial.open || default.open
    }
  end

  def clear_files(file_upload_id) when is_binary(file_upload_id) do
    JS.dispatch("corex:file-upload:clear-files",
      to: "##{file_upload_id}",
      bubbles: false
    )
  end

  def clear_files(socket, file_upload_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(file_upload_id) do
    LiveView.push_event(socket, "file_upload_clear_files", %{"id" => file_upload_id})
  end

  def clear_rejected_files(file_upload_id) when is_binary(file_upload_id) do
    JS.dispatch("corex:file-upload:clear-rejected",
      to: "##{file_upload_id}",
      bubbles: false
    )
  end

  def clear_rejected_files(socket, file_upload_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(file_upload_id) do
    LiveView.push_event(socket, "file_upload_clear_rejected", %{"id" => file_upload_id})
  end

  def open_file_picker(file_upload_id) when is_binary(file_upload_id) do
    JS.dispatch("corex:file-upload:open", to: "##{file_upload_id}", bubbles: false)
  end

  def open_file_picker(socket, file_upload_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(file_upload_id) do
    LiveView.push_event(socket, "file_upload_open", %{"id" => file_upload_id})
  end
end
