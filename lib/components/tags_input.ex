defmodule Corex.TagsInput do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Tags Input](https://zagjs.com/components/react/tags-input).

  ## Anatomy

  <!-- tabs-open -->

  ### Minimal

  ```heex
  <.tags_input value={["alpha", "beta"]}>
    <:close><.heroicon name="hero-x-mark" /></:close>
  </.tags_input>
  ```

  ### With label

  ```heex
  <.tags_input value={["alpha", "beta"]}>
    <:label>Tags</:label>
    <:close><.heroicon name="hero-x-mark" /></:close>
  </.tags_input>
  ```

  ### Translation

  ```heex
  <.tags_input
    value={["lorem", "duis"]}
    translation={%Corex.TagsInput.Translation{
      placeholder: "Add lorem or duis",
      delete_tag_trigger_label: "Remove %{tag}",
      tag_edited: "Edit %{tag}. Press enter to save or escape to cancel."
    }}
  >
    <:label>Keywords</:label>
    <:close><.heroicon name="hero-x-mark" /></:close>
  </.tags_input>
  ```

  <!-- tabs-close -->

  ## Styling

  Style attrs and BEM classes are equivalent. See [Unstyled](unstyled.html). Axes: `semantic`, `size`, `text`, `radius`.

  <!-- tabs-open -->

  ### With attributes

  ```heex
  <.tags_input semantic="accent" size="md" class="tags-input" value={["alpha", "beta"]}>
    <:close><.heroicon name="hero-x-mark" /></:close>
  </.tags_input>
  ```

  ### With classes

  ```heex
  <.tags_input class="tags-input tags-input--semantic-accent tags-input--size-md" value={["alpha", "beta"]}>
    <:close><.heroicon name="hero-x-mark" /></:close>
  </.tags_input>
  ```

  <!-- tabs-close -->

  ## API

  Requires a stable `id` on `<.tags_input>`.

  | Function | Action | Returns |
  | -------- | ------ | ------- |
  | [`set_value/2`](#set_value/2) | Set tag list (client) | `%Phoenix.LiveView.JS{}` |
  | [`set_value/3`](#set_value/3) | Set tag list (server) | `socket` |
  | [`add_value/2`](#add_value/2) | Add one tag (client) | `%Phoenix.LiveView.JS{}` |
  | [`add_value/3`](#add_value/3) | Add one tag (server) | `socket` |
  | [`remove_value/2`](#remove_value/2) | Remove one tag (client) | `%Phoenix.LiveView.JS{}` |
  | [`remove_value/3`](#remove_value/3) | Remove one tag (server) | `socket` |
  | [`clear_value/1`](#clear_value/1) | Clear all tags (client) | `%Phoenix.LiveView.JS{}` |
  | [`clear_value/2`](#clear_value/2) | Clear all tags (server) | `socket` |

  ## Events

  Pick an event name and pass it to `on_*` on `<.tags_input>`.

  ### Server events

  | Event | When | Payload |
  | ----- | ---- | ------- |
  | `on_value_change="tags_value_changed"` | Tag list changes | `%{"id" => id, "value" => tags}` |
  | `on_value_invalid="tags_value_invalid"` | Invalid tag or max overflow | `%{"id" => id, "reason" => reason}` |

  <!-- tabs-open -->

  ### on_value_change

  ```heex
  <.tags_input
    value={["lorem", "duis", "donec"]}
    on_value_change="tags_value_changed"
  >
    <:label>Tags</:label>
    <:close><.heroicon name="hero-x-mark" /></:close>
  </.tags_input>
  ```

  ```elixir
  def handle_event("tags_value_changed", %{"id" => _id, "value" => value}, socket) do
    {:noreply, assign(socket, :tags, value)}
  end
  ```

  <!-- tabs-close -->

  ### Client events

  | Event | When | `event.detail` |
  | ----- | ---- | -------------- |
  | `on_value_change_client="tags-client-changed"` | Tag list changes | `id`, `value` |
  | `on_value_invalid_client="tags-client-invalid"` | Invalid tag or max | `id`, `reason` |

  ## Patterns

  <!-- tabs-open -->

  ### Controlled

  ```heex
  <.tags_input
    controlled
    value={@tags}
    on_value_change="tags_changed"
  >
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

  ## Form

  For cross-cutting invalid styling and error presentation, see the [Forms](forms.html) guide. Pass `invalid={Corex.FormField.invalid?(@form[:tags])}` when you want alert borders after validation.

  With `field={f[:tags]}`, each tag is submitted as its own request param (`post[tags][]`), so Phoenix receives a **list**:

  ```elixir
  %{"post" => %{"tags" => ["alpha", "beta"]}}
  ```

  Use an Ecto field typed `{:array, :string}` (or cast a list in your changeset). A `:string` column with comma-splitting in the changeset is not supported by this component.

  When there are no tags, the component still submits one `name[]` hidden input (empty string) so the form param is present. Phoenix decodes that as `[""]`; Ecto `cast/3` on `{:array, :string}` turns it into `[]`.

  `validate_required/3` alone does not treat an empty list as blank. Pair `{:array, :string}` with `validate_length(:tags, min: 1)` (or equivalent) so cleared tags surface errors.

  The `delimiter` attribute only controls how **new** tags are split when typing or pasting in the control (default `,`). It does not affect form submission.

  In LiveView, rebuild the form from the changeset on `phx-change` so validation stays in sync. Do not use `controlled` on form examples; use `field={@form[:tags]}` only.

  ```elixir
  embedded_schema do
    field :tags, {:array, :string}
  end

  def changeset(profile, attrs) do
    profile
    |> cast(attrs, [:tags])
    |> validate_required([:tags])
    |> validate_length(:tags, min: 1)
  end
  ```

  ```heex
  <.form for={@form} phx-change="validate" phx-submit="save">
    <.tags_input field={@form[:tags]}>
      <:label>Keywords</:label>
      <:close><.heroicon name="hero-x-mark" /></:close>
      <:error :let={msg}>
        <.heroicon name="hero-exclamation-circle" />
        {msg}
      </:error>
    </.tags_input>
    <.action type="submit">Save</.action>
  </.form>
  ```

  ## Style

  Target parts with `data-scope` and `data-part`, or use [Corex Design](styled.html): `@import "./corex.tailwind.css"` in `app.css`.

  ```css
  [data-scope="tags-input"][data-part="root"] {}
  [data-scope="tags-input"][data-part="control"] {}
  [data-scope="tags-input"][data-part="input"] {}
  ```

  Stack modifiers on the host (`class` on `<.tags_input>`).

  <!-- tabs-open -->

  ### Color

  | Modifier | Classes |
  | -------- | ------- |
  | Default | `tags-input` |
  | Accent | `tags-input tags-input--semantic-accent` |
  | Brand | `tags-input tags-input--semantic-brand` |
  | Alert | `tags-input tags-input--semantic-alert` |
  | Info | `tags-input tags-input--semantic-info` |
  | Success | `tags-input tags-input--semantic-success` |

  ### Size

  | Modifier | Classes |
  | -------- | ------- |
  | SM | `tags-input tags-input--size-sm` |
  | MD | `tags-input tags-input--size-md` |
  | LG | `tags-input tags-input--size-lg` |
  | XL | `tags-input tags-input--size-xl` |

  <!-- tabs-close -->

  '''

  @doc type: :component
  use Phoenix.Component

  use Corex.Bem.Variants,
    base: "tags-input",
    axes: [:width, :max_width, :height, :max_height, :semantic, :size, :text, :radius]

  import Corex.Api.Doc

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
    SsrItemText
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
    doc:
      "Delimiter for splitting typed or pasted text into new tags in the UI (default comma). Form submission always uses name[] list params when field or name is set."
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
    value = Form.input_value(field.form, field.field)
    tags = tags_from_field_value(value)

    assigns
    |> Corex.FormField.assign_form_field(field)
    |> assign(:value, tags)
    |> tags_input_render(true, Phoenix.Component.used_input?(field))
  end

  def tags_input(assigns) do
    tags_input_render(assigns, false, false)
  end

  defp tags_input_render(assigns, form_field, field_used) do
    assigns =
      assigns
      |> assign_new(:id, fn -> "tags-input-#{System.unique_integer([:positive])}" end)
      |> assign_new(:dir, fn -> "ltr" end)
      |> assign(:value_list, validate_value!(assigns.value))
      |> normalize_tags_input_translation()
      |> Corex.FormField.assign_list_submit()

    connect_props =
      Connect.props(%Props{
        id: assigns.id,
        form_field: form_field,
        field_used: field_used,
        value: assigns.value,
        controlled: assigns.controlled,
        disabled: assigns.disabled,
        read_only: assigns.read_only,
        invalid: assigns.invalid,
        required: assigns.required,
        name: assigns.name,
        form: assigns.form,
        dir: assigns.dir,
        max: assigns.max,
        delimiter: assigns.delimiter,
        blur_behavior: assigns.blur_behavior,
        add_on_paste: assigns.add_on_paste,
        allow_duplicates: assigns.allow_duplicates,
        allow_overflow: assigns.allow_overflow,
        editable: assigns.editable,
        auto_focus: assigns.auto_focus,
        on_value_change: assigns.on_value_change,
        on_value_change_client: assigns.on_value_change_client,
        on_input_value_change: assigns.on_input_value_change,
        on_input_value_change_client: assigns.on_input_value_change_client,
        on_highlight_change: assigns.on_highlight_change,
        on_highlight_change_client: assigns.on_highlight_change_client,
        on_value_invalid: assigns.on_value_invalid,
        on_value_invalid_client: assigns.on_value_invalid_client,
        translation: assigns.translation,
        submit_name: assigns.submit_name
      })

    assigns =
      assign(assigns,
        connect_props: connect_props,
        empty_array_name: if(field_used, do: assigns.submit_name)
      )

    ~H"""
    <div
      id={@id}
      phx-hook="TagsInput"
      class={corex_style_class(assigns)}
     
      data-loading
      phx-mounted={Phoenix.LiveView.JS.ignore_attributes(["data-loading"])}
      {@rest}
      {@connect_props}
    >
      <div
        phx-mounted={Connect.ignore_root(%Root{id: @id, dir: @dir, read_only: @read_only})}
        {Connect.root(%Root{id: @id, dir: @dir, read_only: @read_only})}
      >
        <div
          :if={@submit_name}
          data-scope="tags-input"
          data-part="array-inputs"
          phx-update="ignore"
          id={"tags-input:#{@id}:array-inputs"}
        >
          <input
            :for={tag <- @value_list}
            type="hidden"
            data-scope="tags-input"
            data-part="array-input"
            name={@submit_name}
            value={tag}
          />
          <input
            :if={@value_list == []}
            type="hidden"
            data-scope="tags-input"
            data-part="array-input"
            data-empty
            name={@empty_array_name}
            value=""
          />
        </div>
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
        :if={@error != [] and !Enum.empty?(@errors)}
        :for={msg <- @errors}
        class={Map.get(Enum.at(@error, 0), :class, nil)}
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

  api_doc(~S"""
  Replace all tags from `phx-click`. Dispatches `corex:tags-input:set-value` with `detail.value` as a string list.

  ```heex
  <.action phx-click={Corex.TagsInput.set_value("my-tags", ["a", "b"])}>Reset tags</.action>
  <.tags_input id="my-tags" value={[]} class="tags-input">
    <:control><span /></:control>
    <:close><.heroicon name="hero-x-mark" /></:close>
  </.tags_input>
  ```

  ```javascript
  document.getElementById("my-tags")?.dispatchEvent(
    new CustomEvent("corex:tags-input:set-value", {
      bubbles: false,
      detail: { value: ["a", "b"] },
    })
  );
  ```
  """)

  def set_value(tags_input_id, value) when is_binary(tags_input_id) and is_list(value) do
    v = Corex.Helpers.validate_value!(value)

    JS.dispatch("corex:tags-input:set-value",
      to: "##{tags_input_id}",
      detail: %{value: v},
      bubbles: false
    )
  end

  api_doc(~S"""
  Replace all tags from `handle_event` (`tags_input_set_value`).

  ```elixir
  def handle_event("set_tags", _, socket) do
    {:noreply, Corex.TagsInput.set_value(socket, "my-tags", ["x"])}
  end
  ```
  """)

  def set_value(socket, tags_input_id, value)
      when is_struct(socket, LiveView.Socket) and is_binary(tags_input_id) and is_list(value) do
    v = Corex.Helpers.validate_value!(value)

    LiveView.push_event(socket, "tags_input_set_value", %{
      id: tags_input_id,
      value: v
    })
  end

  api_doc(~S"""
  Clear tags from `phx-click`. Dispatches `corex:tags-input:clear-value`.

  ```heex
  <.action phx-click={Corex.TagsInput.clear_value("my-tags")}>Clear</.action>
  <.tags_input id="my-tags" class="tags-input">
    <:control><span /></:control>
    <:close><.heroicon name="hero-x-mark" /></:close>
  </.tags_input>
  ```
  """)

  def clear_value(tags_input_id) when is_binary(tags_input_id) do
    JS.dispatch("corex:tags-input:clear-value",
      to: "##{tags_input_id}",
      bubbles: false
    )
  end

  api_doc(~S"""
  Clear tags from `handle_event` (`tags_input_clear_value`).

  ```elixir
  def handle_event("clear_tags", _, socket) do
    {:noreply, Corex.TagsInput.clear_value(socket, "my-tags")}
  end
  ```
  """)

  def clear_value(socket, tags_input_id)
      when is_struct(socket, LiveView.Socket) and is_binary(tags_input_id) do
    LiveView.push_event(socket, "tags_input_clear_value", %{id: tags_input_id})
  end

  api_doc(~S"""
  Append one tag from `phx-click`. Dispatches `corex:tags-input:add-value` with `detail.value`.

  ```heex
  <.action phx-click={Corex.TagsInput.add_value("my-tags", "new")}>Add tag</.action>
  <.tags_input id="my-tags" class="tags-input">
    <:control><span /></:control>
    <:close><.heroicon name="hero-x-mark" /></:close>
  </.tags_input>
  ```
  """)

  def add_value(tags_input_id, value)
      when is_binary(tags_input_id) and is_binary(value) and value != "" do
    JS.dispatch("corex:tags-input:add-value",
      to: "##{tags_input_id}",
      detail: %{value: value},
      bubbles: false
    )
  end

  api_doc(~S"""
  Append one tag from `handle_event` (`tags_input_add_value`).

  ```elixir
  def handle_event("add_tag", %{"tag" => t}, socket) do
    {:noreply, Corex.TagsInput.add_value(socket, "my-tags", t)}
  end
  ```
  """)

  def add_value(socket, tags_input_id, value)
      when is_struct(socket, LiveView.Socket) and is_binary(tags_input_id) and is_binary(value) and
             value != "" do
    LiveView.push_event(socket, "tags_input_add_value", %{id: tags_input_id, value: value})
  end

  api_doc(~S"""
  Remove one tag from `phx-click`. Dispatches `corex:tags-input:remove-value` with `detail.value`.

  ```heex
  <.action phx-click={Corex.TagsInput.remove_value("my-tags", "a")}>Remove a</.action>
  <.tags_input id="my-tags" class="tags-input">
    <:control><span /></:control>
    <:close><.heroicon name="hero-x-mark" /></:close>
  </.tags_input>
  ```
  """)

  def remove_value(tags_input_id, value)
      when is_binary(tags_input_id) and is_binary(value) and value != "" do
    JS.dispatch("corex:tags-input:remove-value",
      to: "##{tags_input_id}",
      detail: %{value: value},
      bubbles: false
    )
  end

  api_doc(~S"""
  Remove one tag from `handle_event` (`tags_input_remove_value`).

  ```elixir
  def handle_event("remove_tag", %{"tag" => t}, socket) do
    {:noreply, Corex.TagsInput.remove_value(socket, "my-tags", t)}
  end
  ```
  """)

  def remove_value(socket, tags_input_id, value)
      when is_struct(socket, LiveView.Socket) and is_binary(tags_input_id) and is_binary(value) and
             value != "" do
    LiveView.push_event(socket, "tags_input_remove_value", %{id: tags_input_id, value: value})
  end

  defp tags_from_field_value(tags) when is_list(tags), do: Enum.map(tags, &to_string/1)
  defp tags_from_field_value(_), do: []

  defp normalize_tags_input_translation(assigns) do
    merged = TagsInputTranslation.resolve(assigns.translation)

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
