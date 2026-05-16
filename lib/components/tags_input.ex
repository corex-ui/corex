defmodule Corex.TagsInput do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Tags Input](https://zagjs.com/components/react/tags-input).

  <!-- tabs-open -->

  ### Basic

  ```heex
  <.tags_input id="tags-1" class="tags-input" value={["a", "b"]}>
    <:label>Keywords</:label>
    <:close><.heroicon name="hero-x-mark" /></:close>
  </.tags_input>
  ```

  ### Phoenix form

  ```heex
  <.form :let={f} for={@form} id={@form.id}>
    <.tags_input field={f[:tags]} class="tags-input">
      <:label>Keywords</:label>
      <:close><.heroicon name="hero-x-mark" /></:close>
      <:error :let={msg}>
        <.heroicon name="hero-exclamation-circle" />
        {msg}
      </:error>
    </.tags_input>
  </.form>
  ```

  With `field={f[:tags]}` or `field={@form[:tags]}`, the component sets `id`, `name`, `form`, initial tag list from the field value (comma-separated string), and shows the `:error` slot when `Phoenix.Component.used_input?/1` and the field has errors. Pass `invalid={true}` only when you want Zag invalid styling; it is not derived from changeset errors.

  ### `on_value_invalid` (Zag `onValueInvalid`)

  Zag invokes `onValueInvalid` when the tag list is invalid for **`max`** (`reason: "rangeOverflow"` once there are more tags than `max`, for example after programmatic `set_value` or when **`allow_overflow`** is true and the user commits another tag past `max`) or when Zag’s optional **`validate`** callback returns false on insert or paste (`reason: "invalidTag"`). With **`allow_overflow` false** (the default), Zag blocks `INSERT_TAG` at `max` and **does not** call `onValueInvalid` for that blocked attempt. Corex forwards these to `on_value_invalid` (LiveView `push_event`) and `on_value_invalid_client` (DOM `CustomEvent` on the hook root) with payload `%{"id" => id, "reason" => reason}`. A custom `validate` function is not passed from HEEx today.

  ### Controlled

  ```heex
  <.tags_input id="tags-1" class="tags-input" controlled value={@tags} on_value_change="tags_changed">
    <:label>Keywords</:label>
    <:close><.heroicon name="hero-x-mark" /></:close>
  </.tags_input>
  ```

  ```elixir
  def handle_event("tags_changed", %{"value" => value}, socket) do
    {:noreply, assign(socket, :tags, value)}
  end
  ```

  <!-- tabs-close -->

  ## Programmatic control

  ```heex
  <button phx-click={Corex.TagsInput.set_value("tags-1", ["x"])}>Set</button>
  <button phx-click={Corex.TagsInput.clear_value("tags-1")}>Clear</button>
  ```

  ```elixir
  socket = Corex.TagsInput.set_value(socket, "tags-1", ["x"])
  ```

  The tag list `value` is JSON-encoded on `data-tags` / `data-default-tags` so strings may contain commas.
  Initial tags are rendered as direct children of `[data-part="control"]` (same markup as the client) so the field shows chips before the hook runs.
  With `name` (or `field`), a `type="hidden"` `[data-part="value-input"]` holds the comma- or delimiter-joined value for Phoenix forms, like `Corex.Select`; Zag keeps a separate internal `[data-part="hidden-input"]` without `name`/`form` so it does not submit a duplicate field.

  ## Localization and `translation`

  Pass `translation={%Corex.TagsInput.Translation{}}` to override strings. Defaults use gettext when configured. The struct covers the main input `placeholder`, per-tag delete `aria-label` (`delete_tag_trigger_label` with `%{tag}`), and inline edit `aria-label` (`tag_edited` with `%{tag}`). The scalar `placeholder` attribute still overrides the merged placeholder when set to a non-empty string.

  ## Styling

  ```css
  [data-scope="tags-input"][data-part="root"] {}
  [data-scope="tags-input"][data-part="control"] {}
  [data-scope="tags-input"][data-part="input"] {}
  ```

  ```css
  @import "../corex/main.css";
  @import "../corex/tokens/themes/neo/light.css";
  @import "../corex/components/tags-input.css";
  ```

  '''

  @doc type: :component
  use Phoenix.Component

  import Corex.Helpers, only: [validate_value!: 1]

  alias Corex.TagsInput.Anatomy.{
    Control,
    HiddenInput,
    Label,
    MainInput,
    Props,
    Root,
    SsrItem,
    SsrItemDeleteTrigger,
    SsrItemInput,
    SsrItemPreview,
    SsrItemText,
    ValueInput
  }

  alias Corex.TagsInput.Connect
  alias Corex.TagsInput.Translation, as: TagsInputTranslation
  alias Phoenix.HTML.Form
  alias Phoenix.LiveView
  alias Phoenix.LiveView.JS

  attr(:id, :string, required: false)

  attr(:value, :list,
    default: [],
    doc: "Initial or controlled list of tag strings; JSON-encoded for the hook"
  )

  attr(:controlled, :boolean, default: false)
  attr(:disabled, :boolean, default: false)
  attr(:read_only, :boolean, default: false)
  attr(:invalid, :boolean, default: false)
  attr(:required, :boolean, default: false)
  attr(:name, :string, default: nil)
  attr(:form, :string, default: nil)

  attr(:errors, :list, default: [], doc: "Error messages when not using field=")

  attr(:field, Phoenix.HTML.FormField,
    default: nil,
    doc:
      "Form field; sets id, name, form, value from the field value, and errors when used_input?/1"
  )

  attr(:dir, :string,
    default: nil,
    values: [nil, "ltr", "rtl"],
    doc: "When nil, derived from document"
  )

  attr(:max, :integer, default: nil, doc: "Maximum number of tags")

  attr(:delimiter, :string,
    default: nil,
    doc: "Delimiter character or string for new tags and paste splitting"
  )

  attr(:blur_behavior, :string,
    default: nil,
    values: [nil, "add", "clear"],
    doc: "Blur behavior for pending input text"
  )

  attr(:add_on_paste, :boolean, default: false)
  attr(:allow_duplicates, :boolean, default: false)
  attr(:allow_overflow, :boolean, default: false)
  attr(:editable, :boolean, default: nil)
  attr(:auto_focus, :boolean, default: false)
  attr(:placeholder, :string, default: nil)

  attr(:translation, TagsInputTranslation,
    default: %TagsInputTranslation{},
    doc: "Translatable strings for placeholder and Zag delete/edit labels."
  )

  attr(:on_value_change, :string, default: nil)
  attr(:on_value_change_client, :string, default: nil)
  attr(:on_input_value_change, :string, default: nil)
  attr(:on_input_value_change_client, :string, default: nil)
  attr(:on_highlight_change, :string, default: nil)
  attr(:on_highlight_change_client, :string, default: nil)

  attr(:on_value_invalid, :string,
    default: nil,
    doc:
      "LiveView event name for Zag onValueInvalid; push_event payload %{\"id\" => id, \"reason\" => \"rangeOverflow\" | \"invalidTag\"}. See moduledoc section on on_value_invalid."
  )

  attr(:on_value_invalid_client, :string,
    default: nil,
    doc:
      "DOM event name on the hook root for Zag onValueInvalid; detail %{id, reason} with reason rangeOverflow or invalidTag. See moduledoc section on on_value_invalid."
  )

  attr(:rest, :global)

  slot :label, required: false do
    attr(:class, :string, required: false)
  end

  slot(:close, required: true, doc: "Content for each delete trigger")

  slot :error, required: false do
    attr(:class, :string, required: false)
  end

  def tags_input(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    errors =
      if Phoenix.Component.used_input?(field) do
        Enum.map(field.errors, &Corex.Gettext.translate_error(&1))
      else
        []
      end

    value = Form.input_value(field.form, field.field)
    tags = tags_from_field_string(value)

    assigns
    |> assign(:field, nil)
    |> assign(:errors, errors)
    |> assign(:id, field.id)
    |> assign(:name, field.name)
    |> assign(:form, field.form.id)
    |> assign(:value, tags)
    |> tags_input()
  end

  def tags_input(assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> "tags-input-#{System.unique_integer([:positive])}" end)
      |> assign_new(:dir, fn -> "ltr" end)
      |> assign(:value_list, validate_value!(assigns.value))
      |> normalize_tags_input_translation()

    ~H"""
    <div
      id={@id}
      phx-hook="TagsInput"
      data-loading
      phx-mounted={Phoenix.LiveView.JS.ignore_attributes(["data-loading"])}
      {@rest}
      {Connect.props(%Props{
        id: @id,
        value: @value,
        controlled: @controlled,
        disabled: @disabled,
        read_only: @read_only,
        invalid: @invalid,
        required: @required,
        name: @name,
        form: @form,
        dir: @dir,
        max: @max,
        delimiter: @delimiter,
        blur_behavior: @blur_behavior,
        add_on_paste: @add_on_paste,
        allow_duplicates: @allow_duplicates,
        allow_overflow: @allow_overflow,
        editable: @editable,
        auto_focus: @auto_focus,
        on_value_change: @on_value_change,
        on_value_change_client: @on_value_change_client,
        on_input_value_change: @on_input_value_change,
        on_input_value_change_client: @on_input_value_change_client,
        on_highlight_change: @on_highlight_change,
        on_highlight_change_client: @on_highlight_change_client,
        on_value_invalid: @on_value_invalid,
        on_value_invalid_client: @on_value_invalid_client,
        translation: @translation
      })}
    >
      <div
        phx-mounted={Connect.ignore_root(%Root{id: @id, dir: @dir})}
        {Connect.root(%Root{id: @id, dir: @dir})}
      >
        <input
          :if={@name}
          phx-mounted={Connect.ignore_value_input(%ValueInput{id: @id, dir: @dir})}
          {Connect.value_input(%ValueInput{id: @id, dir: @dir})}
          name={@name}
          form={@form}
          value={tags_to_form_string(@value_list, @delimiter)}
        />
        <label
          :if={@label != []}
          class={Map.get(Enum.at(@label, 0), :class)}
          phx-mounted={Connect.ignore_label(%Label{id: @id, dir: @dir})}
          {Connect.label(%Label{id: @id, dir: @dir})}
        >
          {render_slot(@label)}
        </label>
        <div phx-mounted={Connect.ignore_control(%Control{id: @id, dir: @dir})} {Connect.control(%Control{id: @id, dir: @dir})}>
            <span
              :for={{tag, index} <- Enum.with_index(@value_list)}
              phx-mounted={
                Connect.ignore_ssr_item(%SsrItem{
                  root_id: @id,
                  dir: @dir,
                  value: tag,
                  index: index,
                  disabled: @disabled
                })
              }
              {Connect.ssr_item(%SsrItem{
                root_id: @id,
                dir: @dir,
                value: tag,
                index: index,
                disabled: @disabled
              })}
            >
              <div
                phx-mounted={
                  Connect.ignore_ssr_item_preview(%SsrItemPreview{
                    root_id: @id,
                    dir: @dir,
                    value: tag,
                    index: index,
                    disabled: @disabled
                  })
                }
                {Connect.ssr_item_preview(%SsrItemPreview{
                  root_id: @id,
                  dir: @dir,
                  value: tag,
                  index: index,
                  disabled: @disabled
                })}
              >
                <span
                  phx-mounted={
                    Connect.ignore_ssr_item_text(%SsrItemText{root_id: @id, index: index})
                  }
                  {Connect.ssr_item_text(%SsrItemText{root_id: @id, index: index})}
                >{tag}</span>
                <button
                  phx-mounted={
                    Connect.ignore_ssr_item_delete_trigger(%SsrItemDeleteTrigger{
                      root_id: @id,
                      dir: @dir,
                      value: tag,
                      index: index,
                      disabled: @disabled
                    })
                  }
                  {Connect.ssr_item_delete_trigger(%SsrItemDeleteTrigger{
                    root_id: @id,
                    dir: @dir,
                    value: tag,
                    index: index,
                    disabled: @disabled,
                    aria_label:
                      TagsInputTranslation.format_tag(
                        @translation.delete_tag_trigger_label,
                        tag
                      )
                  })}
                >
                  {render_slot(@close)}
                </button>
              </div>
              <input
                phx-mounted={
                  Connect.ignore_ssr_item_input(%SsrItemInput{
                    root_id: @id,
                    dir: @dir,
                    value: tag,
                    index: index,
                    disabled: @disabled
                  })
                }
                {Connect.ssr_item_input(%SsrItemInput{
                  root_id: @id,
                  dir: @dir,
                  value: tag,
                  index: index,
                  disabled: @disabled,
                  aria_label:
                    TagsInputTranslation.format_tag(@translation.tag_edited, tag)
                })}
              />
            </span>
            <input
              phx-mounted={Connect.ignore_main_input(%MainInput{id: @id, dir: @dir, placeholder: @placeholder_resolved})}
              {Connect.main_input(%MainInput{id: @id, dir: @dir, placeholder: @placeholder_resolved})}
            />
        </div>
        <input
          :if={@name}
          phx-mounted={Connect.ignore_hidden_input(%HiddenInput{id: @id})}
          {Connect.hidden_input(%HiddenInput{id: @id})}
        />
      </div>
      <div
        :if={@error != []}
        :for={msg <- @errors}
        data-scope="tags-input"
        data-part="error"
      >
        {render_slot(@error, msg)}
      </div>
      <div style="display: none;" data-templates="tags-input">
        <span
          data-scope="tags-input"
          data-part="item"
          data-template="true"
          data-value=""
        >
          <div data-scope="tags-input" data-part="item-preview">
            <span data-scope="tags-input" data-part="item-text"></span>
            <button type="button" data-scope="tags-input" data-part="item-delete-trigger">
              {render_slot(@close)}
            </button>
          </div>
          <input data-scope="tags-input" data-part="item-input" />
        </span>
      </div>
    </div>
    """
  end

  @doc type: :api
  def set_value(tags_input_id, value) when is_binary(tags_input_id) and is_list(value) do
    v = Corex.Helpers.validate_value!(value)

    JS.dispatch("corex:tags-input:set-value",
      to: "##{tags_input_id}",
      detail: %{value: v},
      bubbles: false
    )
  end

  def set_value(socket, tags_input_id, value)
      when is_struct(socket, LiveView.Socket) and is_binary(tags_input_id) and is_list(value) do
    v = Corex.Helpers.validate_value!(value)

    LiveView.push_event(socket, "tags_input_set_value", %{
      id: tags_input_id,
      value: v
    })
  end

  @doc type: :api
  def clear_value(tags_input_id) when is_binary(tags_input_id) do
    JS.dispatch("corex:tags-input:clear-value",
      to: "##{tags_input_id}",
      bubbles: false
    )
  end

  def clear_value(socket, tags_input_id)
      when is_struct(socket, LiveView.Socket) and is_binary(tags_input_id) do
    LiveView.push_event(socket, "tags_input_clear_value", %{id: tags_input_id})
  end

  defp tags_from_field_string(v) when is_binary(v), do: String.split(v, ",", trim: true)
  defp tags_from_field_string(_), do: []

  defp tags_to_form_string(tags_list, delimiter) when is_binary(delimiter) and delimiter != "",
    do: Enum.join(tags_list, delimiter)

  defp tags_to_form_string(tags_list, _), do: Enum.join(tags_list, ",")

  defp normalize_tags_input_translation(assigns) do
    gettext_default = %TagsInputTranslation{
      placeholder: Corex.Gettext.gettext("Add a tag…"),
      delete_tag_trigger_label: Corex.Gettext.gettext("Delete tag %{tag}"),
      tag_edited:
        Corex.Gettext.gettext("Editing tag %{tag}. Press enter to save or escape to cancel.")
    }

    merged = TagsInputTranslation.merge(assigns.translation, gettext_default)

    placeholder_resolved =
      case Map.get(assigns, :placeholder) do
        nil -> merged.placeholder
        "" -> merged.placeholder
        p when is_binary(p) -> p
      end

    assigns
    |> assign(:translation, merged)
    |> assign(:placeholder_resolved, placeholder_resolved)
  end
end
