defmodule Corex.Select do
  @moduledoc ~S'''
  Select for Phoenix LiveView forms and navigation. Behavior follows [Zag.js Select](https://zagjs.com/components/react/select).
  ## Anatomy

  <!-- tabs-open -->

  The placeholder text comes from the `translation` attribute (default English `"Select"` is passed through the host Phoenix gettext backend at render time when unchanged). Pass `translation={%Select.Translation{placeholder: …}}` to customize.

  ### Minimal

  ```heex
  <.select
    class="select"
    items={Corex.List.new([
      %{label: "France", value: "fra", disabled: true},
      %{label: "Belgium", value: "bel"},
      %{label: "Germany", value: "deu"},
      %{label: "Netherlands", value: "nld"},
      %{label: "Switzerland", value: "che"},
      %{label: "Austria", value: "aut"}
    ])}
  >
    <:trigger>
      <.heroicon name="hero-chevron-down" />
    </:trigger>
  </.select>
  ```

  ### Grouped

  ```heex
  <.select
    class="select"
    items={Corex.List.new([
      %{label: "France", value: "fra", group: "Europe"},
      %{label: "Belgium", value: "bel", group: "Europe"},
      %{label: "Germany", value: "deu", group: "Europe"},
      %{label: "Netherlands", value: "nld", group: "Europe"},
      %{label: "Switzerland", value: "che", group: "Europe"},
      %{label: "Austria", value: "aut", group: "Europe"},
      %{label: "Japan", value: "jpn", group: "Asia"},
      %{label: "China", value: "chn", group: "Asia"},
      %{label: "South Korea", value: "kor", group: "Asia"},
      %{label: "Thailand", value: "tha", group: "Asia"},
      %{label: "USA", value: "usa", group: "North America"},
      %{label: "Canada", value: "can", group: "North America"},
      %{label: "Mexico", value: "mex", group: "North America"}
    ])}
  >
    <:trigger>
      <.heroicon name="hero-chevron-down" />
    </:trigger>
  </.select>
  ```

  ### Custom

  This example requires the installation of [Flagpack](https://hex.pm/packages/flagpack) to display the use of custom item rendering.
  ```heex
  <.select
    class="select"
    items={Corex.List.new([
      %{label: "France", value: "fra"},
      %{label: "Belgium", value: "bel"},
      %{label: "Germany", value: "deu"},
      %{label: "Netherlands", value: "nld"},
      %{label: "Switzerland", value: "che"},
      %{label: "Austria", value: "aut"}
    ])}
  >
    <:label>
      Country of residence
    </:label>
    <:item :let={item}>
      <Flagpack.flag name={String.to_existing_atom(to_string(item.value))} />
      {item.label}
    </:item>
    <:trigger>
      <.heroicon name="hero-chevron-down" />
    </:trigger>
    <:item_indicator>
      <.heroicon name="hero-check" />
    </:item_indicator>
  </.select>
  ```

  ### Custom Grouped

  This example requires the installation of [Flagpack](https://hex.pm/packages/flagpack) to display the use of custom item rendering.
  ```heex
  <.select
    class="select"
    items={Corex.List.new([
      %{label: "France", value: "fra", group: "Europe"},
      %{label: "Belgium", value: "bel", group: "Europe"},
      %{label: "Germany", value: "deu", group: "Europe"},
      %{label: "Japan", value: "jpn", group: "Asia"},
      %{label: "China", value: "chn", group: "Asia"},
      %{label: "South Korea", value: "kor", group: "Asia"}
    ])}
  >
    <:item :let={item}>
      <Flagpack.flag name={String.to_existing_atom(to_string(item.value))} />
      {item.label}
    </:item>
    <:trigger>
      <.heroicon name="hero-chevron-down" />
    </:trigger>
    <:item_indicator>
      <.heroicon name="hero-check" />
    </:item_indicator>
  </.select>
  ```

  <!-- tabs-close -->

  ## Patterns

  <!-- tabs-open -->

  ### Navigation

  Set `redirect` on the component so the first selected value is used as the destination URL.
  Per item, choose the navigation kind explicitly via the item's `:redirect` field:

    * `:href` (default) - full page redirect via `window.location` (safe everywhere)
    * `:patch` - LiveView `js().patch(url)` (caller asserts: same LV mount + matching live route)
    * `:navigate` - LiveView `js().navigate(url)` (caller asserts: another LV in the same `live_session`)
    * `false` - disable redirect for this item (e.g. let your `on_value_change` server handler decide)

  Set `new_tab: true` on an item to open its destination in a new tab via `window.open`.
  An item may also set `:to` to override the destination (defaults to the item id).

  Build items with `Corex.List.new/1`. When `redirect` is true, the client runs **single-select in Zag** even if `multiple` is set on the component.

  ### Controller

  When not connected to LiveView, the hook always performs a full page redirect via `window.location`.

  ```heex
  <.select
    class="select"
    redirect
    translation={%Corex.Select.Translation{placeholder: "Go to"}}
    items={Corex.List.new([
      %{label: "Account", id: ~p"/account"},
      %{label: "Settings", id: ~p"/settings"}
    ])}
  >
    <:trigger>
      <.heroicon name="hero-chevron-down" />
    </:trigger>
  </.select>
  ```

  ### LiveView

  When connected to LiveView, use `on_value_change` and redirect in the callback. The payload includes `value` (list); use `Enum.at(value, 0)` for the destination.

  ```elixir
  defmodule MyAppWeb.NavLive do
    use MyAppWeb, :live_view

    def handle_event("nav_change", %{"value" => value}, socket) do
      path = Enum.at(value, 0) || ~p"/"
      {:noreply, push_navigate(socket, to: path)}
    end

    def render(assigns) do
      ~H"""
      <.select
        id="nav-select"
        class="select"
        redirect
        on_value_change="nav_change"
        translation={%Corex.Select.Translation{placeholder: "Go to"}}
        items={Corex.List.new([
          %{label: "Account", id: ~p"/account"},
          %{label: "Settings", id: ~p"/settings"}
        ])}
      >
        <:trigger>
          <.heroicon name="hero-chevron-down" />
        </:trigger>
      </.select>
      """
    end
  end
  ```

  ### Dynamic items

  Grow or shrink options at runtime by updating a list assign and passing `Corex.List.new(@items)` as `items`. Select options are rebuilt from props after morph (not a LiveView stream consumer); use `Phoenix.LiveView.stream/3` only with components that render `@streams.*` (for example `data_table`).

  ```heex
  <.select class="select" items={Corex.List.new(@items)}>
    <:label>Country</:label>
    <:trigger>
      <.heroicon name="hero-chevron-down" class="icon" />
    </:trigger>
  </.select>
  ```

  <!-- tabs-close -->

  ## Form

  When using with Phoenix forms, set the form `id` in `to_form/2` (for example `to_form(changeset, as: :name, id: "my-form")`) and use `<.form for={@form}>`.

  For cross-cutting invalid styling and error presentation, see the [Forms](forms.html) guide. With `field={@form[:…]}`, pass `auto_invalid` for alert borders from visible errors, or `invalid={true}` to force the alert state.

  ### Multiple selection and `{:array, :string}` fields

  With `multiple` and `field={f[:tags]}`, the hidden native `<select>` submits list params (`post[tags][]`), matching Phoenix's multi-select convention:

  ```elixir
  %{"post" => %{"tags" => ["option1", "option2"]}}
  ```

  Pair with `field :tags, {:array, :string}` in your schema. Single-select forms still submit one scalar through the hidden `value-input`.

  ```heex
  <.select
    field={@form[:tags]}
    class="select"
    multiple
    controlled
    items={Corex.List.new([
      %{label: "Option 1", value: "option1"},
      %{label: "Option 2", value: "option2"}
    ])}
    translation={%Corex.Select.Translation{placeholder: "Choose tags"}}
  >
    <:label>Tags</:label>
    <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    <:error :let={msg}>
      <.heroicon name="hero-exclamation-circle" class="icon" />
      {msg}
    </:error>
  </.select>
  ```

  For **free-form** tags (not limited to `items`), use [`Corex.TagsInput`](Corex.TagsInput.html) with the same `{:array, :string}` field type.

  ### Controller

  Build the form from an Ecto changeset:

  ```elixir
  def form_page(conn, _params) do
    form =
      %MyApp.Form.SelectForm{}
      |> MyApp.Form.SelectForm.changeset(%{})
      |> Phoenix.Component.to_form(as: :select_form, id: "select-form")
    render(conn, :form_page, form: form)
  end
  ```

  ```heex
  <.form :let={f} for={@form} action={@action} method="post">
    <.select
      field={f[:country]}
      class="select"
      translation={%Corex.Select.Translation{placeholder: "Select a country"}}
      items={Corex.List.new([
        %{label: "France", value: "fra", disabled: true},
        %{label: "Belgium", value: "bel"},
        %{label: "Germany", value: "deu"},
        %{label: "Netherlands", value: "nld"},
        %{label: "Switzerland", value: "che"},
        %{label: "Austria", value: "aut"}
      ])}
    >
      <:label>Your country of residence</:label>
      <:trigger>
        <.heroicon name="hero-chevron-down" />
      </:trigger>
      <:error :let={msg}>
        <.heroicon name="hero-exclamation-circle" class="icon" />
        {msg}
      </:error>
    </.select>
    <button type="submit">Submit</button>
  </.form>
  ```

  ### Live View

  When using in a Live view you must add controlled mode. Prefer building the form from an Ecto changeset (see "With Ecto changeset" below).

  ### With Ecto changeset

  When using Ecto changeset for validation and inside a Live view you must enable the controlled mode.

  This allows the Live View to be the source of truth and the component to be in sync accordingly.

  First create your schema and changeset:

  ```elixir
  defmodule MyApp.Accounts.User do
    use Ecto.Schema
    import Ecto.Changeset

    schema "users" do
      field :name, :string
      field :country, :string
      timestamps(type: :utc_datetime)
    end

    def changeset(user, attrs) do
      user
      |> cast(attrs, [:name, :country])
      |> validate_required([:name, :country])
    end
  end
  ```

  ```elixir
  defmodule MyAppWeb.UserLive do
    use MyAppWeb, :live_view
    alias MyApp.Accounts.User

    def mount(_params, _session, socket) do
      {:ok, assign(socket, :form, to_form(User.changeset(%User{}, %{})))}
    end

    def handle_event("validate", %{"user" => user_params}, socket) do
      changeset = User.changeset(%User{}, user_params)
      {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
    end

    def render(assigns) do
      ~H"""
      <.form for={@form} phx-change="validate">
        <.select
          field={@form[:country]}
          class="select"
          controlled
          translation={%Corex.Select.Translation{placeholder: "Select a country"}}
          items={Corex.List.new([
            %{label: "France", value: "fra"},
            %{label: "Belgium", value: "bel"},
            %{label: "Germany", value: "deu"}
          ])}
        >
          <:label>Your country of residence</:label>
          <:trigger>
            <.heroicon name="hero-chevron-down" />
          </:trigger>
          <:error :let={msg}>
            <.heroicon name="hero-exclamation-circle" class="icon" />
            {msg}
          </:error>
        </.select>
      </.form>
      """
    end
  end
  ```

  ## API

  Requires a stable `id` on `<.select>`.

  | Function | Action | Returns |
  | -------- | ------ | ------- |
  | [`set_value/2`](#set_value/2) | Set selection (client) | `%Phoenix.LiveView.JS{}` |
  | [`set_value/3`](#set_value/3) | Set selection (server) | `socket` |
  | [`set_open/2`](#set_open/2) | Open or close menu (client) | `%Phoenix.LiveView.JS{}` |
  | [`set_open/3`](#set_open/3) | Open or close menu (server) | `socket` |

  <!-- tabs-open -->

  ### set_value

  ```heex
  <.action phx-click={Corex.Select.set_value("select-api-bind", ["fra"])} class="button ui-size-sm">France</.action>
  <.select id="select-api-bind" class="select" items={
    Corex.List.new([
      %{label: "France", value: "fra"},
      %{label: "Belgium", value: "bel"},
      %{label: "Germany", value: "deu"}
    ])
  }>
    <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
  </.select>
  ```

  ```elixir
  def handle_event("select_api_set_value", _, socket) do
    {:noreply, Corex.Select.set_value(socket, "select-api-srv", ["fra"])}
  end
  ```

  <!-- tabs-close -->

  ## Events

  ### Server events

  | Event | When | Payload |
  | ----- | ---- | ------- |
  | `on_value_change="select_value_changed"` | Selection changes | `%{"id" => id, "value" => values, "path" => path, "items" => items}` |

  <!-- tabs-open -->

  ### on_value_change

  ```heex
  <.select
    class="select"
    items={Corex.List.new([
      %{label: "France", value: "fra"},
      %{label: "Belgium", value: "bel"},
      %{label: "Germany", value: "deu"}
    ])}
    on_value_change="select_value_changed"
  >
    <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
  </.select>
  ```

  ```elixir
  def handle_event("select_value_changed", %{"value" => value}, socket) do
    {:noreply, assign(socket, :selected, value)}
  end
  ```

  <!-- tabs-close -->

  ### Client events

  | Event | When | `event.detail` |
  | ----- | ---- | -------------- |
  | `on_value_change_client="select-value-changed"` | Selection changes | `id`, `value`, `items` |

  <!-- tabs-open -->

  ### on_value_change_client

  ```heex
  <.select
    id="select-events-client"
    class="select"
    items={Corex.List.new([
      %{label: "France", value: "fra"},
      %{label: "Belgium", value: "bel"},
      %{label: "Germany", value: "deu"}
    ])}
    on_value_change_client="select-value-changed"
  >
    <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
  </.select>
  ```

  ```javascript
  document.getElementById("select-events-client")?.addEventListener("select-value-changed", (e) => {
    console.log(e.detail);
  });
  ```

  <!-- tabs-close -->

  ## Style

  Target parts with `data-scope` and `data-part`:

  ```css
  [data-scope="select"][data-part="root"] {}
  [data-scope="select"][data-part="control"] {}
  [data-scope="select"][data-part="label"] {}
  [data-scope="select"][data-part="input"] {}
  [data-scope="select"][data-part="error"] {}
  [data-scope="select"][data-part="trigger"] {}
  [data-scope="select"][data-part="item-group"] {}
  [data-scope="select"][data-part="item-group-label"] {}
  [data-scope="select"][data-part="item"] {}
  [data-scope="select"][data-part="item-text"] {}
  [data-scope="select"][data-part="item-indicator"] {}
  ```

  ```css
  @import "../corex/corex.css";
  ```

  Stack modifiers on `<.select class="select ...">`. Combine axes, for example `select ui-accent ui-size-lg` or `select ui-info ui-solid`.

  Axes: **Semantic** (`ui-accent`, `ui-brand`, `ui-alert`, `ui-info`, `ui-success`), **Variant** (`ui-solid`), **Size** (`ui-size-sm` … `ui-size-xl`), **Radius** (`ui-rounded-*`), **Max height** (`ui-max-height-*` on the host; clamps content). See the [modifier guide](modifiers.html).

  Semantic modifiers set palette variables on the trigger. Variant modifiers control trigger surface treatment. Default is subtle; add `ui-solid` for a filled trigger. Selected menu items still use the semantic palette.

  <!-- tabs-open -->

  ### Semantic

  Palette variables for select ink and fill. Does not change surface treatment by itself.

  | Modifier | Classes |
  | -------- | ------- |
  | Default | `select` |
  | Accent | `select ui-accent` |
  | Brand | `select ui-brand` |
  | Alert | `select ui-alert` |
  | Success | `select ui-success` |
  | Info | `select ui-info` |

  ### Variant

  Visual treatment of the trigger surface. Combine with a semantic modifier for palette-driven ink and fill.

  | Modifier | Classes |
  | -------- | ------- |
  | Subtle (default) | `select` or `select ui-accent` |
  | Solid | `select ui-accent ui-solid` |

  ### Size

  | Modifier | Classes |
  | -------- | ------- |
  | SM | `select ui-size-sm` |
  | MD | `select ui-size-md` |
  | LG | `select ui-size-lg` |
  | XL | `select ui-size-xl` |

  ### Max height

  Opt-in clamp on the dropdown content. Example: `select ui-max-height-xs`.

  ### Rounded

  | Modifier | Classes |
  | -------- | ------- |
  | None | `select ui-rounded-none` |
  | SM | `select ui-rounded-sm` |
  | MD | `select ui-rounded-md` |
  | LG | `select ui-rounded-lg` |
  | XL | `select ui-rounded-xl` |
  | Full | `select ui-rounded-full` |

  ### Max width

  | Modifier | Classes |
  | -------- | ------- |
  | SM | `select max-w-sm` |
  | MD | `select max-w-md` |
  | LG | `select max-w-lg` |
  | XL | `select max-w-xl` |

  <!-- tabs-close -->
  '''

  @doc type: :component
  use Phoenix.Component

  use Corex.Component, [:list, :api]

  import Corex.Api.Doc

  import Corex.Component, only: [form_control_attrs: 1]

  alias Phoenix.LiveView.JS

  alias Corex.Select.Anatomy.{
    Content,
    Control,
    HiddenSelect,
    Item,
    ItemGroup,
    ItemGroupLabel,
    ItemIndicator,
    ItemText,
    Label,
    Positioner,
    Props,
    Root,
    Trigger,
    ValueInput
  }

  alias Corex.Api.RespondTo

  alias Corex.Select.Connect

  alias Corex.Select.Translation

  alias Corex.Selectors

  form_control_attrs(
    docs: [
      id: "The id of the select component",
      name: "The name of the select",
      form: "The id of the form of the select",
      read_only: "Whether the select is read only",
      field:
        "A form field struct retrieved from the form, for example: @form[:country]. Automatically sets id, name, value, and errors from the form field"
    ]
  )

  attr(:items, :list,
    default: [],
    doc:
      "Items from `Corex.List.new/1`, or plain maps with `:label` (see `Corex.List` for the full contract)"
  )

  attr(:form_field, :boolean, default: false, doc: false)
  attr(:field_used, :boolean, default: false, doc: false)

  attr(:value, :list, default: [], doc: "The value of the select")
  attr(:close_on_select, :boolean, default: true, doc: "Whether to close the select on select")

  attr(:dir, :string,
    default: nil,
    values: [nil, "ltr", "rtl"],
    doc: "The direction of the select (ltr or rtl)."
  )

  attr(:orientation, :string,
    default: "vertical",
    values: ["vertical", "horizontal"],
    doc: "Layout orientation for CSS (vertical or horizontal)"
  )

  attr(:loop_focus, :boolean, default: false, doc: "Whether to loop focus the select")

  attr(:multiple, :boolean,
    default: false,
    doc:
      "Allow multiple selection. With field and form, submits name[] list params for Ecto {:array, :string}"
  )

  attr(:deselectable, :boolean,
    default: false,
    doc: "Whether the selected items can be deselected"
  )

  attr(:update_trigger, :boolean,
    default: true,
    doc: "When false, the hook does not overwrite trigger item-text from the selected label."
  )

  attr(:on_value_change, :string,
    default: nil,
    doc:
      "Server event name to push on value change. Payload includes `value` (list), `path` (current path without locale), `id`, `items`. Use `Enum.at(value, 0)` for the first selected value."
  )

  attr(:on_value_change_client, :any,
    default: nil,
    doc: """
    Client-side only: either a string (CustomEvent name to dispatch) or a `Phoenix.LiveView.JS` command.
    For JS commands, placeholders are replaced at run time: `__VALUE__` (selected value(s) as JSON array), `__VALUE_0__` (first value).
    For redirect-on-select use `redirect` instead (no placeholders).
    """
  )

  attr(:redirect, :boolean,
    default: false,
    doc: """
    When true, selecting a value triggers redirect-on-select. Each item picks
    the navigation kind via `:redirect` (`:href` (default) | `:patch` | `:navigate` | `false`).
    Items may also set `:to` (overrides the destination) and `:new_tab` (opens in a new tab).
    When true, the client runs single-select in Zag even if `multiple` is set on this component.
    """
  )

  attr(:positioning, Corex.Positioning,
    default: %Corex.Positioning{same_width: true},
    doc: "Positioning options for the dropdown"
  )

  attr(:translation, Corex.Select.Translation,
    default: nil,
    doc: "Translatable strings for the select"
  )

  attr(:rest, :global)

  slot :label, required: false, doc: "The label content" do
    attr(:class, :string, required: false)
  end

  slot :trigger, required: true, doc: "The trigger button content" do
    attr(:class, :string, required: false)
  end

  slot :item_indicator, required: false, doc: "Optional indicator for selected items" do
    attr(:class, :string, required: false)
  end

  slot :error, required: false do
    attr(:class, :string, required: false)
  end

  slot :item,
    required: false,
    doc: "Custom content for each item. Receives the item as :let binding" do
    attr(:class, :string, required: false)
  end

  attr(:errors, :list,
    default: [],
    doc: "List of error messages to display"
  )

  def select(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    value = field_value_list(field.value)

    assigns
    |> Corex.FormField.assign_form_field(field)
    |> assign(:value, value)
    |> select()
  end

  def select(assigns) do
    assigns = prepare_select(assigns)

    ~H"""
    <div 
    id={@id} 
    phx-hook="Select"
    {Corex.Hook.loading()}
    {@rest}
    {@connect_props}>
      <div {Connect.mounted_root(%Root{id: @id, invalid: @invalid, read_only: @read_only, orientation: @orientation, dir: @dir})}>

      <input
        {Connect.mounted_value_input(%ValueInput{id: @id, dir: @dir, orientation: @orientation})}
        name={@value_input_name}
        value={@value_for_hidden_input}
      />

      <select
        {Connect.mounted_hidden_select(%HiddenSelect{id: @id, dir: @dir, orientation: @orientation})}
        name={@hidden_select_name}
        multiple={@multiple}
      >
        {Phoenix.HTML.Form.options_for_select(@options_with_prompt, @selected_for_options)}
      </select>

        <div :if={!Enum.empty?(@label)} class={Map.get(Enum.at(@label, 0), :class, nil)} {Connect.mounted_label(%Label{id: @id, invalid: @invalid, read_only: @read_only, required: @required, disabled: @disabled, dir: @dir, orientation: @orientation})}>
          {render_slot(@label)}
        </div>
        <div {Connect.mounted_control(%Control{id: @id, invalid: @invalid, dir: @dir, disabled: @disabled, orientation: @orientation})}>
          <button {Connect.mounted_trigger(%Trigger{id: @id, invalid: @invalid, dir: @dir, disabled: @disabled, orientation: @orientation})} :if={!Enum.empty?(@trigger)} aria-label={@selected_label}>
            <span {Connect.mounted_item_text(%ItemText{id: @id, value: "value-label", orientation: @orientation})}>
              {@selected_label}
            </span>
            {render_slot(@trigger)}
          </button>
        </div>
        <Corex.Component.Errors.field_errors scope="select" errors={@errors} error={@error} />
        <div {Connect.mounted_positioner(%Positioner{id: @id, dir: @dir, orientation: @orientation})}>
          <ul {Connect.mounted_content(%Content{id: @id, dir: @dir, orientation: @orientation})}>
            <li :if={@has_groups} :for={{group, group_items} <- @grouped_items} {Connect.mounted_item_group(%ItemGroup{id: @id, group_id: group || "default", dir: @dir, orientation: @orientation})}>
              <div :if={group} {Connect.mounted_item_group_label(%ItemGroupLabel{id: @id, group_id: group, dir: @dir, orientation: @orientation})}>
                {group}
              </div>
              <ul>
                <li :for={item <- group_items} phx-mounted={Connect.ignore_item(%Item{id: @id, value: to_string(Map.fetch!(item, :value)), dir: @dir, orientation: @orientation})} {Connect.item(%Item{id: @id, value: to_string(Map.fetch!(item, :value)), dir: @dir, orientation: @orientation, to: Map.get(item, :to), redirect: Map.get(item, :redirect), new_tab: Map.get(item, :new_tab, false)})}>
                  <span :if={!Enum.empty?(@item)} {Connect.mounted_item_text(%ItemText{id: @id, value: to_string(Map.fetch!(item, :value)), orientation: @orientation})}>
                    {render_slot(@item, item)}
                  </span>
                  <span :if={Enum.empty?(@item)} {Connect.mounted_item_text(%ItemText{id: @id, value: to_string(Map.fetch!(item, :value)), orientation: @orientation})}>
                    {item.label}
                  </span>
                  <span :if={!Enum.empty?(@item_indicator)} {Connect.mounted_item_indicator(%ItemIndicator{id: @id, value: to_string(Map.fetch!(item, :value)), orientation: @orientation})}>
                    {render_slot(@item_indicator)}
                  </span>
                </li>
              </ul>
            </li>
            <li :if={!@has_groups} :for={item <- @items} phx-mounted={Connect.ignore_item(%Item{id: @id, value: to_string(Map.fetch!(item, :value)), dir: @dir, orientation: @orientation})} {Connect.item(%Item{id: @id, value: to_string(Map.fetch!(item, :value)), dir: @dir, orientation: @orientation, to: Map.get(item, :to), redirect: Map.get(item, :redirect), new_tab: Map.get(item, :new_tab, false)})}>
              <span :if={!Enum.empty?(@item)} {Connect.mounted_item_text(%ItemText{id: @id, value: to_string(Map.fetch!(item, :value)), orientation: @orientation})}>
                {render_slot(@item, item)}
              </span>
              <span :if={Enum.empty?(@item)} {Connect.mounted_item_text(%ItemText{id: @id, value: to_string(Map.fetch!(item, :value)), orientation: @orientation})}>
                {item.label}
              </span>
              <span :if={!Enum.empty?(@item_indicator)} {Connect.mounted_item_indicator(%ItemIndicator{id: @id, value: to_string(Map.fetch!(item, :value)), orientation: @orientation})}>
                {render_slot(@item_indicator)}
              </span>
            </li>
          </ul>
        </div>
      </div>
    </div>
    """
  end

  defp prepare_select(assigns) do
    assigns =
      assigns
      |> Corex.FormField.require_id!("Corex component (select)")
      |> assign(:translation, Translation.resolve(assigns.translation))
      |> assign_new(:name, fn -> nil end)
      |> assign_new(:form, fn -> nil end)

    items = normalize_items(assigns.items)
    value_list = field_value_list(assigns[:value])
    grouped_items = grouped_items(items)
    sorted_items = Enum.flat_map(grouped_items, fn {_group, group_items} -> group_items end)

    assigns
    |> assign(:items, items)
    |> assign(:value, value_list)
    |> assign(:grouped_items, grouped_items)
    |> assign(:sorted_items, sorted_items)
    |> assign(:items_json, Corex.Dataset.encode_json(sorted_items))
    |> assign(:has_groups, has_groups?(items))
    |> assign(:options, transform_collection_to_options(items))
    |> assign(:options_with_prompt, [{"", ""} | transform_collection_to_options(items)])
    |> assign(:selected_for_options, selected_for_options(assigns.multiple, value_list))
    |> assign(:disabled_values, get_disabled_values(items))
    |> assign(:value_for_hidden_input, value_for_hidden_input(value_list, assigns.multiple))
    |> assign(
      :selected_label,
      selected_label(items, value_list) || assigns.translation.placeholder
    )
    |> assign_select_submit_names()
    |> then(&assign(&1, :connect_props, select_connect_props(&1)))
  end

  defp grouped_items(items) do
    items
    |> group_by_group()
    |> Enum.sort_by(fn {group, _items} -> group || "" end, :asc)
  end

  defp selected_for_options(true, value_list), do: value_list
  defp selected_for_options(_multiple, []), do: ""
  defp selected_for_options(_multiple, [selected | _rest]), do: selected

  defp assign_select_submit_names(%{multiple: true, name: name} = assigns) when is_binary(name) do
    assigns
    |> assign(:array_form_submit, true)
    |> assign(:hidden_select_name, Corex.FormField.list_submit_name(name))
    |> assign(:value_input_name, nil)
  end

  defp assign_select_submit_names(assigns) do
    assigns
    |> assign(:array_form_submit, false)
    |> assign(:hidden_select_name, nil)
    |> assign(:value_input_name, assigns.name)
  end

  api_doc(~S"""
  Set selected value(s) from a control (`phx-click`). Pass one value or a list (wrapped internally).

  ```heex
  <.action phx-click={Corex.Select.set_value("my-select", "bel")}>Belgium</.action>
  <.select
    id="my-select"
    class="select"
    items={Corex.List.new([
      %{label: "Belgium", value: "bel"},
      %{label: "Germany", value: "deu"}
    ])}
  >
    <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
  </.select>
  ```

  ```javascript
  document.getElementById("my-select")?.dispatchEvent(
    new CustomEvent("corex:select:set-value", {
      bubbles: false,
      detail: { value: ["bel"] },
    })
  );
  ```
  """)

  @spec set_value(String.t(), Corex.Value.coercible()) :: Phoenix.LiveView.JS.t()
  @spec set_value(Phoenix.LiveView.Socket.t(), String.t(), Corex.Value.coercible()) ::
          Phoenix.LiveView.Socket.t()
  def set_value(select_id, value) when is_binary(select_id) do
    JS.dispatch("corex:select:set-value",
      to: Selectors.css_id(select_id),
      detail: %{value: coerce_string_list(List.wrap(value), "Corex.Select.set_value/2")},
      bubbles: false
    )
  end

  api_doc(~S"""
  Set selected value(s) from `handle_event`. Pushes `select_set_value`.

  ```heex
  <.action phx-click="pick_bel" phx-value-value="bel">Belgium</.action>
  <.select
    id="my-select"
    class="select"
    items={Corex.List.new([
      %{label: "Belgium", value: "bel"},
      %{label: "Germany", value: "deu"}
    ])}
  >
    <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
  </.select>
  ```

  ```elixir
  def handle_event("pick_bel", %{"value" => v}, socket) do
    {:noreply, Corex.Select.set_value(socket, "my-select", v)}
  end
  ```
  """)

  def set_value(socket, select_id, value)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(select_id) do
    RespondTo.push_set_value(
      socket,
      "select_set_value",
      select_id,
      coerce_string_list(List.wrap(value), "Corex.Select.set_value/2")
    )
  end

  api_doc(~S"""
  Open or close the listbox from a control (`phx-click`).

  ```heex
  <.action phx-click={Corex.Select.set_open("my-select", true)}>Open</.action>
  <.select
    id="my-select"
    class="select"
    items={Corex.List.new([%{label: "Belgium", value: "bel"}])}
  >
    <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
  </.select>
  ```

  ```javascript
  document.getElementById("my-select")?.dispatchEvent(
    new CustomEvent("corex:select:set-open", {
      bubbles: false,
      detail: { open: true },
    })
  );
  ```
  """)

  @spec set_open(String.t(), boolean()) :: Phoenix.LiveView.JS.t()
  @spec set_open(Phoenix.LiveView.Socket.t(), String.t(), boolean()) ::
          Phoenix.LiveView.Socket.t()
  def set_open(select_id, open) when is_binary(select_id) and is_boolean(open) do
    JS.dispatch("corex:select:set-open",
      to: Selectors.css_id(select_id),
      detail: %{open: open},
      bubbles: false
    )
  end

  api_doc(~S"""
  Set open state from `handle_event`. Pushes `select_set_open`.

  ```heex
  <.action phx-click="open_select">Open</.action>
  <.select
    id="my-select"
    class="select"
    items={Corex.List.new([%{label: "Belgium", value: "bel"}])}
  >
    <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
  </.select>
  ```

  ```elixir
  def handle_event("open_select", _, socket) do
    {:noreply, Corex.Select.set_open(socket, "my-select", true)}
  end
  ```
  """)

  def set_open(socket, select_id, open)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(select_id) and
             is_boolean(open) do
    RespondTo.push_set_open(socket, "select_set_open", select_id, open)
  end

  defp get_disabled_values(collection) do
    collection
    |> Enum.filter(&Map.get(&1, :disabled, false))
    |> Enum.map(& &1.value)
  end

  defp transform_collection_to_options(items) do
    grouped = group_by_group(items)

    case grouped do
      [{nil, all_items}] -> Enum.map(all_items, &{&1.label, &1.value})
      _ -> Enum.flat_map(grouped, &group_to_options/1)
    end
  end

  defp group_to_options({nil, items}), do: Enum.map(items, &{&1.label, &1.value})
  defp group_to_options({group, items}), do: [{group, Enum.map(items, &{&1.label, &1.value})}]

  defp select_connect_props(assigns) do
    props = %Props{
      id: assigns.id,
      items: Map.get(assigns, :sorted_items) || assigns.items,
      items_json: Map.get(assigns, :items_json),
      controlled: assigns.controlled,
      form_field: assigns[:form_field] == true,
      placeholder: assigns.translation.placeholder,
      value: assigns.value,
      disabled: assigns.disabled,
      close_on_select: assigns.close_on_select,
      dir: assigns.dir,
      orientation: assigns.orientation,
      loop_focus: assigns.loop_focus,
      multiple: assigns.multiple,
      invalid: assigns.invalid,
      name: assigns.name,
      form: assigns.form,
      read_only: assigns.read_only,
      required: assigns.required,
      on_value_change: assigns.on_value_change,
      on_value_change_client: assigns.on_value_change_client,
      redirect: assigns.redirect,
      positioning: assigns.positioning,
      deselectable: Map.get(assigns, :deselectable, false),
      update_trigger: Map.get(assigns, :update_trigger, true),
      hidden_select_name: Map.get(assigns, :hidden_select_name)
    }

    props
    |> Connect.props()
    |> Corex.FormField.put_form_field_attrs(assigns)
  end
end
