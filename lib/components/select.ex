defmodule Corex.Select do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Select](https://zagjs.com/components/react/select).

  ## Examples
  <!-- tabs-open -->

  The placeholder text comes from the `translation` attribute (default English `"Select"` is passed through `Corex.Gettext` at render time when unchanged). Pass `translation={%Select.Translation{placeholder: …}}` to customize.

  ### Minimal

  ```heex
  <.select
    id="my-select"
    class="select"
    items={Corex.List.new([
      %{label: "France", id: "fra", disabled: true},
      %{label: "Belgium", id: "bel"},
      %{label: "Germany", id: "deu"},
      %{label: "Netherlands", id: "nld"},
      %{label: "Switzerland", id: "che"},
      %{label: "Austria", id: "aut"}
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
      %{label: "France", id: "fra", group: "Europe"},
      %{label: "Belgium", id: "bel", group: "Europe"},
      %{label: "Germany", id: "deu", group: "Europe"},
      %{label: "Netherlands", id: "nld", group: "Europe"},
      %{label: "Switzerland", id: "che", group: "Europe"},
      %{label: "Austria", id: "aut", group: "Europe"},
      %{label: "Japan", id: "jpn", group: "Asia"},
      %{label: "China", id: "chn", group: "Asia"},
      %{label: "South Korea", id: "kor", group: "Asia"},
      %{label: "Thailand", id: "tha", group: "Asia"},
      %{label: "USA", id: "usa", group: "North America"},
      %{label: "Canada", id: "can", group: "North America"},
      %{label: "Mexico", id: "mex", group: "North America"}
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
      %{label: "France", id: "fra"},
      %{label: "Belgium", id: "bel"},
      %{label: "Germany", id: "deu"},
      %{label: "Netherlands", id: "nld"},
      %{label: "Switzerland", id: "che"},
      %{label: "Austria", id: "aut"}
    ])}
  >
    <:label>
      Country of residence
    </:label>
    <:item :let={item}>
      <Flagpack.flag name={String.to_atom(item.id)} />
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
      %{label: "France", id: "fra", group: "Europe"},
      %{label: "Belgium", id: "bel", group: "Europe"},
      %{label: "Germany", id: "deu", group: "Europe"},
      %{label: "Japan", id: "jpn", group: "Asia"},
      %{label: "China", id: "chn", group: "Asia"},
      %{label: "South Korea", id: "kor", group: "Asia"}
    ])}
  >
    <:item :let={item}>
      <Flagpack.flag name={String.to_atom(item.id)} />
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

  ## Use as Navigation

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
    id="nav-select"
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

  ## Phoenix Form Integration

  When using with Phoenix forms, set the form `id` in `to_form/2` (for example `to_form(changeset, as: :name, id: "my-form")`) and use `id={@form.id}` on `<.form>`.

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
  <.form :let={f} for={@form} id={@form.id} action={@action} method="post">
    <.select
      field={f[:country]}
      class="select"
      translation={%Corex.Select.Translation{placeholder: "Select a country"}}
      items={Corex.List.new([
        %{label: "France", id: "fra", disabled: true},
        %{label: "Belgium", id: "bel"},
        %{label: "Germany", id: "deu"},
        %{label: "Netherlands", id: "nld"},
        %{label: "Switzerland", id: "che"},
        %{label: "Austria", id: "aut"}
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
      <.form for={@form} id={@form.id} phx-change="validate">
        <.select
          field={@form[:country]}
          class="select"
          controlled
          translation={%Corex.Select.Translation{placeholder: "Select a country"}}
          items={Corex.List.new([
            %{label: "France", id: "fra"},
            %{label: "Belgium", id: "bel"},
            %{label: "Germany", id: "deu"}
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

  ## API Control

  ```heex
  <.action phx-click={Corex.Select.set_value("my-select", ["fra"])} class="button button--sm">France</.action>
  <.action phx-click={Corex.Select.set_open("my-select", true)} class="button button--sm">Open</.action>
  ```
  ```elixir
  def handle_event("api", _, socket) do
    {:noreply, Corex.Select.set_value(socket, "my-select", ["bel"])}
  end
  ```

  ## Styling

  Use data attributes to target elements:

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

  If you wish to use the default Corex styling, you can use the class `select` on the component.
  This requires to install `Mix.Tasks.Corex.Design` first and import the component css file.

  ```css
  @import "../corex/main.css";
  @import "../corex/tokens/themes/neo/light.css";
  @import "../corex/components/select.css";
  ```

  You can then use modifiers

  ```heex
  <.select class="select select--accent select--lg">
  ```


  '''

  use Phoenix.Component

  alias Phoenix.LiveView
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

  alias Corex.Select.Connect

  import Corex.Helpers,
    only: [normalize_items: 1, has_groups?: 1, group_by_group: 1, validate_value!: 1]

  attr(:id, :string, required: false, doc: "The id of the select component")

  attr(:items, :list,
    default: [],
    doc: "List of items from `Corex.List.new/1` (or maps with :id and :label)"
  )

  attr(:controlled, :boolean, default: false, doc: "Whether the select is controlled")

  attr(:value, :list, default: [], doc: "The value of the select")
  attr(:disabled, :boolean, default: false, doc: "Whether the select is disabled")
  attr(:close_on_select, :boolean, default: true, doc: "Whether to close the select on select")

  attr(:dir, :string,
    default: "ltr",
    values: ["ltr", "rtl"],
    doc: "The direction of the select (ltr or rtl)."
  )

  attr(:orientation, :string,
    default: "vertical",
    values: ["vertical", "horizontal"],
    doc: "Layout orientation for CSS (vertical or horizontal)"
  )

  attr(:loop_focus, :boolean, default: false, doc: "Whether to loop focus the select")
  attr(:multiple, :boolean, default: false, doc: "Whether to allow multiple selection")
  attr(:invalid, :boolean, default: false, doc: "Whether the select is invalid")
  attr(:name, :string, doc: "The name of the select")
  attr(:form, :string, doc: "The id of the form of the select")
  attr(:read_only, :boolean, default: false, doc: "Whether the select is read only")
  attr(:required, :boolean, default: false, doc: "Whether the select is required")

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
    default: %Corex.Select.Translation{placeholder: "Select"},
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

  attr(:field, Phoenix.HTML.FormField,
    doc:
      "A form field struct retrieved from the form, for example: @form[:country]. Automatically sets id, name, value, and errors from the form field"
  )

  attr(:errors, :list,
    default: [],
    doc: "List of error messages to display"
  )

  def select(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    errors = if Phoenix.Component.used_input?(field), do: field.errors, else: []

    value = get_value(field.value)

    assigns
    |> assign(field: nil)
    |> assign(:errors, Enum.map(errors, &Corex.Gettext.translate_error(&1)))
    |> assign_new(:id, fn -> field.id end)
    |> assign_new(:form, fn -> field.form.id end)
    |> assign_new(:name, fn -> field.name end)
    |> assign(:value, value)
    |> select()
  end

  def select(assigns) do
    assigns =
      case assigns.translation do
        %Corex.Select.Translation{placeholder: "Select"} ->
          assign(assigns, :translation, %Corex.Select.Translation{
            placeholder: Corex.Gettext.gettext("Select")
          })

        _ ->
          assigns
      end

    items = normalize_items(assigns.items)

    assigns =
      assigns
      |> assign(:items, items)
      |> assign_new(:id, fn -> "select-#{System.unique_integer([:positive])}" end)
      |> assign_new(:name, fn -> "name-#{System.unique_integer([:positive])}" end)
      |> assign_new(:form, fn -> nil end)

    value_list = get_value(assigns[:value])

    assigns =
      assigns
      |> assign(:value, value_list)

    options = transform_collection_to_options(items)

    grouped_items =
      group_by_group(items)
      |> Enum.sort_by(fn {group, _items} -> group || "" end, :asc)

    has_groups = has_groups?(items)

    selected_for_options =
      if assigns.multiple do
        value_list
      else
        if value_list == [], do: "", else: List.first(value_list)
      end

    options_with_prompt = [{"", ""} | options]

    assigns =
      assigns
      |> assign(:grouped_items, grouped_items)
      |> assign(:has_groups, has_groups)
      |> assign(:options, options)
      |> assign(:options_with_prompt, options_with_prompt)
      |> assign(:selected_for_options, selected_for_options)
      |> assign(:disabled_values, get_disabled_values(items))
      |> assign(:value_for_hidden_input, value_for_hidden_input(value_list, assigns.multiple))

    ~H"""
    <div 
    id={@id} 
    phx-hook="Select"
    data-loading
    phx-mounted={Phoenix.LiveView.JS.ignore_attributes(["data-loading"])} 
    {@rest}
    {Connect.props(%Props{
      id: @id, items: @items, controlled: @controlled, placeholder: @translation.placeholder, value: @value,
      disabled: @disabled, close_on_select: @close_on_select, dir: @dir, orientation: @orientation, loop_focus: @loop_focus,
      multiple: @multiple, invalid: @invalid, name: @name, form: @form, read_only: @read_only,
      required: @required, on_value_change: @on_value_change, on_value_change_client: @on_value_change_client,
      redirect: @redirect,
      positioning: @positioning,
      deselectable: @deselectable,
      update_trigger: @update_trigger
    })}>
      <div phx-mounted={Connect.ignore_root(%Root{id: @id, invalid: @invalid, read_only: @read_only, orientation: @orientation, dir: @dir})} {Connect.root(%Root{id: @id, invalid: @invalid, read_only: @read_only, orientation: @orientation, dir: @dir})}>

      <input phx-mounted={Connect.ignore_value_input(%ValueInput{id: @id, dir: @dir, orientation: @orientation})} {Connect.value_input(%ValueInput{id: @id, dir: @dir, orientation: @orientation})} name={@name} form={@form} value={@value_for_hidden_input} />

      <select phx-mounted={Connect.ignore_hidden_select(%HiddenSelect{id: @id, dir: @dir, orientation: @orientation})} {Connect.hidden_select(%HiddenSelect{id: @id, dir: @dir, orientation: @orientation})} multiple={@multiple} name={@name} form={@form}>
        {Phoenix.HTML.Form.options_for_select(@options_with_prompt, @selected_for_options)}
      </select>

        <div :if={!Enum.empty?(@label)} class={Map.get(Enum.at(@label, 0), :class, nil)} phx-mounted={Connect.ignore_label(%Label{id: @id, invalid: @invalid, read_only: @read_only, required: @required, disabled: @disabled, dir: @dir, orientation: @orientation})} {Connect.label(%Label{id: @id, invalid: @invalid, read_only: @read_only, required: @required, disabled: @disabled, dir: @dir, orientation: @orientation})}>
          {render_slot(@label)}
        </div>
        <div phx-mounted={Connect.ignore_control(%Control{id: @id, invalid: @invalid, dir: @dir, disabled: @disabled, orientation: @orientation})} {Connect.control(%Control{id: @id, invalid: @invalid, dir: @dir, disabled: @disabled, orientation: @orientation})}>
          <button phx-mounted={Connect.ignore_trigger(%Trigger{id: @id, invalid: @invalid, dir: @dir, disabled: @disabled, orientation: @orientation})} {Connect.trigger(%Trigger{id: @id, invalid: @invalid, dir: @dir, disabled: @disabled, orientation: @orientation})} :if={!Enum.empty?(@trigger)} aria-label={get_selected_label(@items, @value) || @translation.placeholder}>
            <span phx-mounted={Connect.ignore_item_text(%ItemText{id: @id, value: "value-label", dir: @dir, orientation: @orientation})} {Connect.item_text(%ItemText{id: @id, value: "value-label", dir: @dir, orientation: @orientation})}>
              {get_selected_label(@items, @value) || @translation.placeholder}
            </span>
            {render_slot(@trigger)}
          </button>
        </div>
        <div :if={!Enum.empty?(@errors)} :for={msg <- @errors} data-scope="select" data-part="error">
          {render_slot(@error, msg)}
        </div>
        <div phx-mounted={Connect.ignore_positioner(%Positioner{id: @id, dir: @dir, orientation: @orientation})} {Connect.positioner(%Positioner{id: @id, dir: @dir, orientation: @orientation})}>
          <ul phx-mounted={Connect.ignore_content(%Content{id: @id, dir: @dir, orientation: @orientation})} {Connect.content(%Content{id: @id, dir: @dir, orientation: @orientation})}>
            <li :if={@has_groups} :for={{group, group_items} <- @grouped_items} phx-mounted={Connect.ignore_item_group(%ItemGroup{id: @id, group_id: group || "default", dir: @dir, orientation: @orientation})} {Connect.item_group(%ItemGroup{id: @id, group_id: group || "default", dir: @dir, orientation: @orientation})}>
              <div :if={group} phx-mounted={Connect.ignore_item_group_label(%ItemGroupLabel{id: @id, group_id: group, dir: @dir, orientation: @orientation})} {Connect.item_group_label(%ItemGroupLabel{id: @id, group_id: group, dir: @dir, orientation: @orientation})}>
                {group}
              </div>
              <ul>
                <li :for={item <- group_items} phx-mounted={Connect.ignore_item(%Item{id: @id, value: to_string(item.id), dir: @dir, orientation: @orientation})} {Connect.item(%Item{id: @id, value: to_string(item.id), dir: @dir, orientation: @orientation, to: Map.get(item, :to), redirect: Map.get(item, :redirect), new_tab: Map.get(item, :new_tab, false)})}>
                  <span :if={!Enum.empty?(@item)} phx-mounted={Connect.ignore_item_text(%ItemText{id: @id, value: to_string(item.id), dir: @dir, orientation: @orientation})} {Connect.item_text(%ItemText{id: @id, value: to_string(item.id), dir: @dir, orientation: @orientation})}>
                    {render_slot(@item, item)}
                  </span>
                  <span :if={Enum.empty?(@item)} phx-mounted={Connect.ignore_item_text(%ItemText{id: @id, value: to_string(item.id), dir: @dir, orientation: @orientation})} {Connect.item_text(%ItemText{id: @id, value: to_string(item.id), dir: @dir, orientation: @orientation})}>
                    {item.label}
                  </span>
                  <span :if={!Enum.empty?(@item_indicator)} phx-mounted={Connect.ignore_item_indicator(%ItemIndicator{id: @id, value: to_string(item.id), dir: @dir, orientation: @orientation})} {Connect.item_indicator(%ItemIndicator{id: @id, value: to_string(item.id), dir: @dir, orientation: @orientation})}>
                    {render_slot(@item_indicator)}
                  </span>
                </li>
              </ul>
            </li>
            <li :if={!@has_groups} :for={item <- @items} phx-mounted={Connect.ignore_item(%Item{id: @id, value: to_string(item.id), dir: @dir, orientation: @orientation})} {Connect.item(%Item{id: @id, value: to_string(item.id), dir: @dir, orientation: @orientation, to: Map.get(item, :to), redirect: Map.get(item, :redirect), new_tab: Map.get(item, :new_tab, false)})}>
              <span :if={!Enum.empty?(@item)} phx-mounted={Connect.ignore_item_text(%ItemText{id: @id, value: to_string(item.id), dir: @dir, orientation: @orientation})} {Connect.item_text(%ItemText{id: @id, value: to_string(item.id), dir: @dir, orientation: @orientation})}>
                {render_slot(@item, item)}
              </span>
              <span :if={Enum.empty?(@item)} phx-mounted={Connect.ignore_item_text(%ItemText{id: @id, value: to_string(item.id), dir: @dir, orientation: @orientation})} {Connect.item_text(%ItemText{id: @id, value: to_string(item.id), dir: @dir, orientation: @orientation})}>
                {item.label}
              </span>
              <span :if={!Enum.empty?(@item_indicator)} phx-mounted={Connect.ignore_item_indicator(%ItemIndicator{id: @id, value: to_string(item.id), dir: @dir, orientation: @orientation})} {Connect.item_indicator(%ItemIndicator{id: @id, value: to_string(item.id), dir: @dir, orientation: @orientation})}>
                {render_slot(@item_indicator)}
              </span>
            </li>
          </ul>
        </div>
      </div>
    </div>
    """
  end

  @doc type: :api
  @doc """
  Sets select value in the client. Dispatches `corex:select:set-value` on the hook root.
  """
  def set_value(select_id, value) when is_binary(select_id) do
    JS.dispatch("corex:select:set-value",
      to: "##{select_id}",
      detail: %{value: validate_value!(List.wrap(value))},
      bubbles: false
    )
  end

  @doc type: :api
  @doc """
  Sets select value from the server via `push_event` (`select_set_value`).
  """
  def set_value(socket, select_id, value)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(select_id) do
    LiveView.push_event(socket, "select_set_value", %{
      id: select_id,
      value: validate_value!(List.wrap(value))
    })
  end

  @doc type: :api
  @doc """
  Opens or closes the menu. Dispatches `corex:select:set-open` on the hook root.
  """
  def set_open(select_id, open) when is_binary(select_id) and is_boolean(open) do
    JS.dispatch("corex:select:set-open",
      to: "##{select_id}",
      detail: %{open: open},
      bubbles: false
    )
  end

  @doc type: :api
  @doc """
  Sets open state from the server via `push_event` (`select_set_open`).
  """
  def set_open(socket, select_id, open)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(select_id) and
             is_boolean(open) do
    LiveView.push_event(socket, "select_set_open", %{
      id: select_id,
      open: open
    })
  end

  defp get_disabled_values(collection) do
    collection
    |> Enum.filter(&Map.get(&1, :disabled, false))
    |> Enum.map(& &1.id)
  end

  defp value_for_hidden_input(value_list, _multiple) when value_list == [], do: ""
  defp value_for_hidden_input(value_list, false), do: List.first(value_list)
  defp value_for_hidden_input(value_list, true), do: Enum.join(value_list, ",")

  defp transform_collection_to_options(items) do
    grouped = group_by_group(items)

    case grouped do
      [{nil, all_items}] -> Enum.map(all_items, &{&1.label, &1.id})
      _ -> Enum.flat_map(grouped, &group_to_options/1)
    end
  end

  defp group_to_options({nil, items}), do: Enum.map(items, &{&1.label, &1.id})
  defp group_to_options({group, items}), do: [{group, Enum.map(items, &{&1.label, &1.id})}]

  defp get_value(field_value) do
    case field_value do
      nil -> []
      [] -> []
      value when is_list(value) -> Enum.map(value, &to_string/1)
      value -> [to_string(value)]
    end
  end

  defp get_selected_label(collection, value) do
    case value do
      [] ->
        nil

      _ ->
        value
        |> Enum.map(fn val ->
          collection
          |> Enum.find(&(&1.id == val))
        end)
        |> Enum.filter(& &1)
        |> Enum.map(& &1.label)
        |> case do
          [] -> nil
          labels -> Enum.join(labels, ", ")
        end
    end
  end
end
