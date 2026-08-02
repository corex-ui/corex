defmodule Corex.DatePicker do
  @moduledoc ~S'''
  Date picker for Phoenix LiveView forms. Behavior follows [Zag.js Date Picker](https://zagjs.com/components/react/date-picker).
  ## Anatomy

  ### Basic Usage

  ```heex
  <.date_picker>
    <:label>Select a date</:label>
    <:trigger>
      <.heroicon name="hero-calendar" />
    </:trigger>
           <:prev_trigger>
          <.heroicon name="hero-chevron-left" class="icon" />
        </:prev_trigger>
        <:next_trigger>
          <.heroicon name="hero-chevron-right" class="icon" />
        </:next_trigger>
  </.date_picker>
  ```

  ## Form

  When using with Phoenix forms, set the form `id` in `to_form/2` (for example `to_form(changeset, as: :name, id: "my-form")`) and use `<.form for={@form}>`.

  For cross-cutting invalid styling and error presentation, see the [Forms](forms.html) guide. With `field={@form[:…]}`, pass `auto_invalid` for alert borders from visible errors, or `invalid={true}` to force the alert state.

  ### Wire format vs domain types

  The component and LiveView events use **ISO-8601 strings** (`value`, `on_value_change`, hidden inputs). Ecto schemas should use `:date` and `{:array, :date}`. After cast, work with `%Date{}` in application code.

  | Layer | Format |
  | ----- | ------ |
  | `value`, events, HTML | ISO strings (comma-joined for multiple/range) |
  | `field={@form[:date]}` | Accepts `%Date{}` or string; displayed as ISO |
  | Ecto | `:date`, `{:array, :date}` |
  | Flash / logs | [`format_value/2`](#format_value/2), not `inspect/1` |

  Use [`cast_params/2`](#cast_params/2) in `handle_event` to normalize `on_value_change` or form params before `cast/3`:

  ```elixir
  def handle_event("date_changed", %{"value" => value}, socket) do
    params = Corex.DatePicker.cast_params("single", %{"value" => value})

    changeset =
      MyApp.Form.DateForm.changeset_validate(%MyApp.Form.DateForm{}, params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :form, to_form(changeset, action: :validate))}
  end
  ```

  ### Controller

  Build the form from an Ecto changeset:

  ```elixir
  def form_page(conn, _params) do
    form =
      %MyApp.Form.DateForm{}
      |> MyApp.Form.DateForm.changeset(%{})
      |> Phoenix.Component.to_form(as: :date_form, id: "date-form")
    render(conn, :form_page, form: form)
  end
  ```

  ```heex
  <.form :let={f} for={@form} action={@action} method="post">
    <.date_picker
      field={f[:date]}
      class="date-picker"
      translation={%Corex.DatePicker.Translation{
        open_calendar: "Select date",
        close_calendar: "Select date",
        input: "Select date"
      }}
    >
      <:label>Date</:label>
      <:trigger>
        <.heroicon name="hero-calendar" class="icon" />
      </:trigger>
      <:prev_trigger>
        <.heroicon name="hero-chevron-left" class="icon" />
      </:prev_trigger>
      <:next_trigger>
        <.heroicon name="hero-chevron-right" class="icon" />
      </:next_trigger>
      <:error :let={msg}>
        <.heroicon name="hero-exclamation-circle" class="icon" />
        {msg}
      </:error>
    </.date_picker>
    <button type="submit">Submit</button>
  </.form>
  ```

  ### Live View

  Prefer building the form from an Ecto changeset (see "With Ecto changeset" below). Use `phx-change` on the form so params stay in sync after validation.

  ### With Ecto changeset

  Use `field={@form[:birth_date]}` inside `<.form for={@form}>`. The component resyncs from the server value on patch.

  First create your schema and changeset:

  ```elixir
  defmodule MyApp.Accounts.User do
    use Ecto.Schema
    import Ecto.Changeset

    schema "users" do
      field :name, :string
      field :birth_date, :date
      timestamps(type: :utc_datetime)
    end

    def changeset(user, attrs) do
      user
      |> cast(attrs, [:name, :birth_date])
      |> validate_required([:name, :birth_date])
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
        <.date_picker field={@form[:birth_date]} class="date-picker">
          <:label>Birth date</:label>
          <:trigger>
            <.heroicon name="hero-calendar" class="icon" />
          </:trigger>
          <:prev_trigger>
            <.heroicon name="hero-chevron-left" class="icon" />
          </:prev_trigger>
          <:next_trigger>
            <.heroicon name="hero-chevron-right" class="icon" />
          </:next_trigger>
          <:error :let={msg}>
            <.heroicon name="hero-exclamation-circle" class="icon" />
            {msg}
          </:error>
        </.date_picker>
      </.form>
      """
    end
  end
  ```

  ## API

  Requires a stable `id` on `<.date_picker>`.

  | Function | Action | Returns |
  | -------- | ------ | ------- |
  | [`set_value/2`](#set_value/2) | Set selected date(s) (client) | `%Phoenix.LiveView.JS{}` |
  | [`set_value/3`](#set_value/3) | Set selected date(s) (server) | `socket` |
  | [`format_value/2`](#format_value/2) | Format value for flash/logs | ISO string |
  | [`cast_params/2`](#cast_params/2) | Normalize params for Ecto cast | map |

  ## Events

  Pick an event name and pass it to `on_*` on `<.date_picker>`.

  ### Server events

  | Event | When | Payload |
  | ----- | ---- | ------- |
  | `on_value_change="date_changed"` | Selection changes | `%{"id" => id, "value" => iso}` |
  | `on_open_change="open_changed"` | Popover opens/closes | `%{"id" => id, "open" => boolean}` |
  | `on_focus_change="focus_changed"` | Focus moves | `%{"id" => id, "value" => value}` |
  | `on_view_change="view_changed"` | Visible month changes | `%{"id" => id, ...}` |

  <!-- tabs-open -->

  ### on_value_change

  ```heex
  <.date_picker
    class="date-picker"
    value={@date_value}
    on_value_change="date_changed"
  >
    <:label>Select a date</:label>
    <:trigger><.heroicon name="hero-calendar" class="icon" /></:trigger>
    <:prev_trigger><.heroicon name="hero-chevron-left" class="icon" /></:prev_trigger>
    <:next_trigger><.heroicon name="hero-chevron-right" class="icon" /></:next_trigger>
  </.date_picker>
  ```

  ```elixir
  def handle_event("date_changed", %{"value" => value}, socket) do
    params = Corex.DatePicker.cast_params("single", %{"value" => value})
    changeset = MyApp.Form.DateForm.changeset_validate(%MyApp.Form.DateForm{}, params)
    {:noreply, assign(socket, :form, to_form(changeset, action: :validate))}
  end
  ```

  Event `value` is always an ISO string (comma-joined for multiple/range). Use [`cast_params/2`](#cast_params/2) before Ecto `cast/3`.

  <!-- tabs-close -->

  ### Client events

  | Event | When | `event.detail` |
  | ----- | ---- | -------------- |
  | `on_value_change_client="date-changed"` | Selection changes | `id`, `value` |
  | `on_open_change_client="open-changed"` | Popover opens/closes | `id`, `open` |
  | `on_focus_change_client="focus-changed"` | Focus moves | `id`, `value` |
  | `on_view_change_client="view-changed"` | Visible month changes | `id`, ... |
  | `on_visible_range_change_client="range-changed"` | Visible range changes | `id`, ... |

  ## Patterns

  Pass `value` for the initial selection on mount (ISO-8601 strings or `Date.to_iso8601/1`). The machine owns updates after that unless you use [`set_value/2`](#set_value/2) or form `field`.

  ## Style

  Use data attributes to target elements:

  ```css
  [data-scope="date-picker"][data-part="root"] {}
  [data-scope="date-picker"][data-part="label"] {}
  [data-scope="date-picker"][data-part="control"] {}
  [data-scope="date-picker"][data-part="input"] {}
  [data-scope="date-picker"][data-part="trigger"] {}
  [data-scope="date-picker"][data-part="positioner"] {}
  [data-scope="date-picker"][data-part="content"] {}
  ```

  ```css
  @import "../corex/corex.css";
  ```

  Stack modifiers on the host (`class` on `<.date_picker>`). Combine axes, for example `date-picker ui-accent ui-size-lg` or `date-picker ui-info ui-solid`.

  Axes: **Semantic** (`ui-accent`, `ui-brand`, `ui-alert`, `ui-info`, `ui-success`), **Variant** (`ui-solid`), **Size** (`ui-size-sm` … `ui-size-xl`), **Radius** (`ui-rounded-*`). See the [modifier guide](modifiers.html).

  Semantic modifiers set palette variables on the input and calendar trigger. Variant modifiers control field surface treatment. Default is subtle; add `date-picker ui-solid` for a filled control.

  <!-- tabs-open -->

  ### Semantic

  Palette variables for date picker ink and fill. Does not change surface treatment by itself.

  | Modifier | Classes |
  | -------- | ------- |
  | Default | `date-picker` |
  | Accent | `date-picker ui-accent` |
  | Brand | `date-picker ui-brand` |
  | Alert | `date-picker ui-alert` |
  | Info | `date-picker ui-info` |
  | Success | `date-picker ui-success` |

  ### Variant

  Visual treatment of the input and calendar trigger surfaces. Combine with a semantic modifier for palette-driven ink and fill.

  | Modifier | Classes |
  | -------- | ------- |
  | Subtle (default) | `date-picker` or `date-picker ui-accent` |
  | Solid | `date-picker ui-accent ui-solid` |

  ### Size

  | Modifier | Classes |
  | -------- | ------- |
  | SM | `date-picker ui-size-sm` |
  | MD | `date-picker ui-size-md` |
  | LG | `date-picker ui-size-lg` |
  | XL | `date-picker ui-size-xl` |

  <!-- tabs-close -->

  In `selection_mode` `"range"`, the control shows two fields with side labels from `translation` (**From** / **To** by default, via gettext). In `"multiple"`, a single field shows a comma‑separated list of the formatted selected dates. Use `max_selected_dates` to cap how many days can be selected in multiple mode; omit for no cap.

  ## Localization and `translation`

  Pass `translation={%Corex.DatePicker.Translation{}}` to override any string. Omitted fields use gettext defaults (see [`Corex.DatePicker.Translation`](`Corex.DatePicker.Translation`)).

  '''

  @doc type: :component
  use Phoenix.Component
  use Corex.Component, :form

  import Corex.Api.Doc
  alias Corex.DatePicker.Anatomy
  alias Corex.DatePicker.Connect
  alias Corex.DatePicker.Translation, as: DatePickerTranslation
  alias Corex.Selectors
  alias Phoenix.LiveView
  alias Phoenix.LiveView.JS

  @doc """
  Renders a date picker component.
  """
  form_control_attrs(
    except: [:form, :controlled],
    docs: [
      id:
        "The unique identifier for the date picker. Required; use field={} to derive from field.id.",
      field:
        "A form field struct from the form, e.g. @form[:birth_date]. Sets id, name, value, and errors from the field for form submission and LiveView resync.",
      name: "The name attribute of the input element",
      read_only: "Whether the calendar is read-only",
      disabled: "Whether the calendar is disabled"
    ]
  )

  attr(:value, :string,
    default: nil,
    doc: "The initial value (ISO date string)"
  )

  attr(:locale, :string,
    default: nil,
    doc: "The locale for date formatting"
  )

  attr(:time_zone, :string,
    default: nil,
    doc: "The time zone for date operations"
  )

  attr(:dir, :string,
    default: nil,
    values: [nil, "ltr", "rtl"],
    doc:
      "The direction of the date picker. When nil, derived from document (html lang + config :rtl_locales)"
  )

  attr(:on_value_change, :string,
    default: nil,
    doc: "The server event name when the value changes"
  )

  attr(:on_focus_change, :string,
    default: nil,
    doc: "The server event name when focus changes"
  )

  attr(:on_view_change, :string,
    default: nil,
    doc: "The server event name when the view changes"
  )

  attr(:outside_day_selectable, :boolean,
    default: false,
    doc: "Whether day outside the visible range can be selected"
  )

  attr(:close_on_select, :boolean,
    default: false,
    doc:
      "If true, close the popover when selection is complete. For `selection_mode` :multiple or :range, the default false keeps the panel open until dismissed unless you set this to true."
  )

  attr(:min, :string,
    default: nil,
    doc: "The minimum date that can be selected (ISO date string)"
  )

  attr(:max, :string,
    default: nil,
    doc: "The maximum date that can be selected (ISO date string)"
  )

  attr(:focused_value, :string,
    default: nil,
    doc:
      "The initial focused date when the calendar opens (ISO date string). Used as default in the picker."
  )

  attr(:start_of_week, :integer,
    default: 0,
    doc: "The first day of the week (0=Sunday, 1=Monday, etc.)"
  )

  attr(:fixed_weeks, :boolean,
    default: true,
    doc: "Whether the calendar should have a fixed number of weeks (6 weeks)"
  )

  attr(:selection_mode, :string,
    default: "single",
    values: ["single", "multiple", "range"],
    doc: "The selection mode of the calendar"
  )

  attr(:placeholder, :string,
    default: nil,
    doc: "The placeholder text to display in the input"
  )

  attr(:translation, :any,
    default: nil,
    doc:
      "Partial `Corex.DatePicker.Translation` struct; omitted fields use gettext defaults (see localization section)."
  )

  attr(:max_selected_dates, :integer,
    default: nil,
    doc:
      "When `selection_mode` is \"multiple\", limits how many days can be selected. Omit for no cap."
  )

  attr(:view, :string,
    default: "day",
    values: ["day", "month", "year"],
    doc:
      "The initial view of the calendar (day, month, or year); passed to the client as the default view"
  )

  attr(:min_view, :string,
    default: "day",
    values: ["day", "month", "year"],
    doc: "The minimum view of the calendar"
  )

  attr(:max_view, :string,
    default: "year",
    values: ["day", "month", "year"],
    doc: "The maximum view of the calendar"
  )

  attr(:positioning, Corex.Positioning,
    default: %Corex.Positioning{},
    doc: "Positioning options for the date picker content"
  )

  attr(:on_visible_range_change, :string,
    default: nil,
    doc: "The server event name when the visible range changes"
  )

  attr(:on_open_change, :string,
    default: nil,
    doc: "The server event name when the calendar opens or closes"
  )

  attr(:on_value_change_client, :string,
    default: nil,
    doc:
      "Fires a window-bubbling CustomEvent with this name when the value changes (optional; use with on_value_change for both)"
  )

  attr(:on_open_change_client, :string,
    default: nil,
    doc:
      "Fires a window-bubbling CustomEvent with this name when the calendar opens or closes (optional; use with on_open_change for both)"
  )

  attr(:on_focus_change_client, :string,
    default: nil,
    doc: "The client event name when focus changes"
  )

  attr(:on_view_change_client, :string,
    default: nil,
    doc: "The client event name when the view changes"
  )

  attr(:on_visible_range_change_client, :string,
    default: nil,
    doc: "The client event name when the visible range changes"
  )

  attr(:errors, :list,
    default: [],
    doc: "List of error messages to display"
  )

  attr(:rest, :global)

  slot :label, required: false do
    attr(:class, :string, required: false)
  end

  slot :error, required: false do
    attr(:class, :string, required: false)
  end

  slot :trigger, required: false do
    attr(:class, :string, required: false)
  end

  slot :prev_trigger, required: false do
    attr(:class, :string, required: false)
  end

  slot :next_trigger, required: false do
    attr(:class, :string, required: false)
  end

  def date_picker(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    mode = Map.get(assigns, :selection_mode, "single")

    assigns
    |> Corex.FormField.assign_form_field(field)
    |> assign(:value, date_field_value(assigns[:value] || field.value, mode))
    |> date_picker_render(Phoenix.Component.used_input?(field))
  end

  def date_picker(assigns), do: date_picker_render(assigns, false)

  defp assign_connect_props(assigns) do
    assign(
      assigns,
      :connect_props,
      Connect.props(%Anatomy.Props{
        id: assigns.id,
        form_field: assigns.form_field,
        field_used: assigns.field_used,
        value: assigns.value,
        locale: assigns.locale,
        time_zone: assigns.time_zone,
        name: assigns.name,
        disabled: assigns.disabled,
        read_only: assigns.read_only,
        required: assigns.required,
        invalid: assigns.invalid,
        outside_day_selectable: assigns.outside_day_selectable,
        close_on_select: assigns.close_on_select,
        min: assigns.min,
        max: assigns.max,
        focused_value: assigns.focused_value,
        start_of_week: assigns.start_of_week,
        fixed_weeks: assigns.fixed_weeks,
        selection_mode: assigns.selection_mode,
        placeholder: assigns.placeholder,
        view: assigns.view,
        min_view: assigns.min_view,
        max_view: assigns.max_view,
        positioning: assigns.positioning,
        dir: assigns.dir,
        on_value_change: assigns.on_value_change,
        on_focus_change: assigns.on_focus_change,
        on_view_change: assigns.on_view_change,
        on_visible_range_change: assigns.on_visible_range_change,
        on_open_change: assigns.on_open_change,
        on_value_change_client: assigns.on_value_change_client,
        on_focus_change_client: assigns.on_focus_change_client,
        on_view_change_client: assigns.on_view_change_client,
        on_visible_range_change_client: assigns.on_visible_range_change_client,
        on_open_change_client: assigns.on_open_change_client,
        max_selected_dates: assigns.max_selected_dates,
        translation: assigns.translation,
        submit_name: assigns.submit_name
      })
    )
  end

  defp date_picker_render(assigns, field_used) do
    assigns =
      assigns
      |> Corex.FormField.require_id!("Corex component (date-picker)")
      |> assign(:field_used, field_used)
      |> merge_date_picker_assigns()
      |> assign_array_form_submit(field_used)
      |> assign_connect_props()

    ~H"""
    <div
      id={@id}
      phx-hook="DatePicker"
      {Corex.Hook.loading()}
      {@rest}
      {@connect_props}
    >
      <div {Connect.mounted_root(%Anatomy.Root{id: @id, dir: @dir, read_only: @read_only})}>
        <label
          :if={@label != []}
          {Connect.mounted_label(%Anatomy.Label{id: @id, dir: @dir})}
        >
          {render_slot(@label)}
        </label>
        <div {Connect.mounted_control(%Anatomy.Control{id: @id, dir: @dir})}>
          <div
            :if={@array_form_submit}
            data-scope="date-picker"
            data-part="array-inputs"
            id={"date-picker:#{@id}:array-inputs"}
          >
            <input
              :for={{iso, index} <- Enum.with_index(@array_iso_values)}
              type="hidden"
              id={"date-picker:#{@id}:array-input-#{index}"}
              data-scope="date-picker"
              data-part="array-input"
              name={@submit_name}
              value={iso}
              phx-mounted={
                JS.ignore_attributes(["value", "name"],
                  to: Selectors.css_id("date-picker:#{@id}:array-input-#{index}")
                )
              }
            />
            <input
              :if={@array_iso_values == []}
              type="hidden"
              id={"date-picker:#{@id}:array-input-empty"}
              data-scope="date-picker"
              data-part="array-input"
              data-empty
              name={@empty_array_name}
              value=""
              phx-mounted={
                JS.ignore_attributes(["value", "name"],
                  to: Selectors.css_id("date-picker:#{@id}:array-input-empty")
                )
              }
            />
          </div>
          <input
            :if={!@array_form_submit}
            type="text"
            hidden
            id={"#{@id}-value"}
            name={@name}
            value={normalize_date_value(@value) || ""}
            data-scope="date-picker"
            data-part="value-input"
            aria-hidden="true"
            phx-mounted={Connect.ignore_value_input(@id)}
          />
          <%= if @selection_mode == "range" do %>
            <div data-scope="date-picker" data-part="control-inputs" data-range>
              <span data-scope="date-picker" data-part="range-label" id={"#{@id}-range-start-label"}>{@translation.range_start}</span>
              <input
                {Connect.mounted_input(%Anatomy.Input{id: @id, dir: @dir, index: 0})}
                aria-labelledby={@id <> "-range-start-label"}
                aria-label={@translation.input}
              />
              <span data-scope="date-picker" data-part="range-label" id={"#{@id}-range-end-label"}>{@translation.range_end}</span>
              <input
                {Connect.mounted_input(%Anatomy.Input{id: @id, dir: @dir, index: 1})}
                aria-labelledby={@id <> "-range-end-label"}
                aria-label={@translation.input}
              />
            </div>
          <% else %>
            <input
              {Connect.mounted_input(%Anatomy.Input{id: @id, dir: @dir, index: 0})}
              aria-label={@translation.input}
            />
          <% end %>
          <button
            :if={@trigger != []}
            {Connect.mounted_trigger(%Anatomy.Trigger{id: @id, dir: @dir})}
            aria-label={@translation.open_calendar}
          >
            {render_slot(@trigger)}
          </button>
        </div>
        <div
          :if={@error != []}
          :for={{msg, idx} <- Enum.with_index(@errors)}
          {Connect.mounted_error(%Anatomy.Error{id: @id, index: idx})}
        >
          {render_slot(@error, msg)}
        </div>
        <div
          {Connect.mounted_positioner(%Anatomy.Positioner{id: @id, dir: @dir, positioning: @positioning})}
        >
          <div {Connect.mounted_content(%Anatomy.Content{id: @id, dir: @dir})}>
            <div id={@id <> "-day-view"} data-scope="date-picker" data-part="day-view" hidden>
              <div data-scope="date-picker" data-part="view-control" data-view="day">
                <button
                  phx-mounted={Connect.ignore_view_prev(%{id: @id, view: "day"})}
                  {Connect.view_prev(%{id: @id, view: "day", dir: @dir || "ltr"})}
                >
                {render_slot(@prev_trigger)}
                </button>
                <button
                  phx-mounted={Connect.ignore_view_trigger(%{id: @id, view: "day"})}
                  {Connect.view_trigger(%{id: @id, view: "day", dir: @dir || "ltr"})}
                ></button>
                <button
                  phx-mounted={Connect.ignore_view_next(%{id: @id, view: "day"})}
                  {Connect.view_next(%{id: @id, view: "day", dir: @dir || "ltr"})}
                >
                {render_slot(@next_trigger)}
                </button>
              </div>
              <table data-scope="date-picker" data-part="day-table">
                <thead data-scope="date-picker" data-part="day-table-header">
                  <tr data-scope="date-picker" data-part="day-table-row">
                  </tr>
                </thead>
                <tbody data-scope="date-picker" data-part="day-table-body">

                </tbody>
              </table>
            </div>
            <div data-scope="date-picker" data-part="month-view" hidden>
              <div data-scope="date-picker" data-part="view-control" data-view="month">
                <button
                  phx-mounted={Connect.ignore_view_prev(%{id: @id, view: "month"})}
                  {Connect.view_prev(%{id: @id, view: "month", dir: @dir || "ltr"})}
                >
                {render_slot(@prev_trigger)}
                </button>
                <button
                  phx-mounted={Connect.ignore_view_trigger(%{id: @id, view: "month"})}
                  {Connect.view_trigger(%{id: @id, view: "month", dir: @dir || "ltr"})}
                ></button>
                <button
                  phx-mounted={Connect.ignore_view_next(%{id: @id, view: "month"})}
                  {Connect.view_next(%{id: @id, view: "month", dir: @dir || "ltr"})}
                >
                {render_slot(@next_trigger)}
                </button>
              </div>
              <table data-scope="date-picker" data-part="month-table">
                <tbody data-scope="date-picker" data-part="month-table-body">
                </tbody>
              </table>
            </div>
            <div data-scope="date-picker" data-part="year-view" hidden>
              <div data-scope="date-picker" data-part="view-control" data-view="year">
                <button
                  phx-mounted={Connect.ignore_view_prev(%{id: @id, view: "year"})}
                  {Connect.view_prev(%{id: @id, view: "year", dir: @dir || "ltr"})}
                >
                {render_slot(@prev_trigger)}
                </button>
                <span {Connect.mounted_decade(%Anatomy.Decade{id: @id, dir: @dir || "ltr"})}></span>
                <button
                  phx-mounted={Connect.ignore_view_next(%{id: @id, view: "year"})}
                  {Connect.view_next(%{id: @id, view: "year", dir: @dir || "ltr"})}
                >
                {render_slot(@next_trigger)}
                </button>
              </div>
              <table data-scope="date-picker" data-part="year-table">
                <tbody data-scope="date-picker" data-part="year-table-body">
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  api_doc(~S"""
  Set the selected date from a control (`phx-click`). Pass an ISO-8601 date string or `Date`.

  ```heex
  <.action phx-click={Corex.DatePicker.set_value("my-date-picker", "2024-06-01")}>June</.action>
  <.date_picker id="my-date-picker" class="date-picker" value="2024-01-15">
    <:label>Date</:label>
    <:trigger><.heroicon name="hero-calendar" class="icon" /></:trigger>
  </.date_picker>
  ```

  ```javascript
  document.getElementById("my-date-picker")?.dispatchEvent(
    new CustomEvent("corex:date-picker:set-value", {
      bubbles: false,
      detail: { value: "2024-06-01" },
    })
  );
  ```
  """)

  @spec set_value(String.t(), Corex.Value.coercible()) :: Phoenix.LiveView.JS.t()
  @spec set_value(Phoenix.LiveView.Socket.t(), String.t(), Corex.Value.coercible()) ::
          Phoenix.LiveView.Socket.t()
  def set_value(date_picker_id, value) when is_binary(date_picker_id) do
    case normalize_date_value(value) do
      nil ->
        raise ArgumentError,
              "set_value/2 expected an ISO-8601 date string or a Date, got: #{inspect(value)}"

      iso ->
        JS.dispatch("corex:date-picker:set-value",
          to: Selectors.css_id(date_picker_id),
          detail: %{value: iso},
          bubbles: false
        )
    end
  end

  api_doc(~S"""
  Set the selected date from `handle_event`. Accepts ISO strings or `Date` (same as [`set_value/2`](#set_value/2)).

  ```heex
  <.action phx-click="pick_june" phx-value-value="2024-06-01">June</.action>
  <.date_picker id="my-date-picker" class="date-picker" value="2024-01-15">
    <:label>Date</:label>
    <:trigger><.heroicon name="hero-calendar" class="icon" /></:trigger>
  </.date_picker>
  ```

  ```elixir
  def handle_event("pick_june", %{"value" => iso}, socket) do
    {:noreply, Corex.DatePicker.set_value(socket, "my-date-picker", iso)}
  end
  ```
  """)

  def set_value(socket, date_picker_id, value)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(date_picker_id) do
    case normalize_date_value(value) do
      nil ->
        raise ArgumentError,
              "set_value/3 expected an ISO-8601 date string or a Date, got: #{inspect(value)}"

      iso ->
        LiveView.push_event(socket, "date_picker_set_value", %{
          date_picker_id: date_picker_id,
          value: iso
        })
    end
  end

  @selection_modes ~W(single multiple range)

  @doc """
  Formats a date picker value for flash messages, toasts, and logs.

  `mode` is `"single"`, `"multiple"`, or `"range"`. Accepts `%Date{}`, ISO strings,
  lists of dates, or comma-separated ISO strings. Never produces `~D[...]` output.
  """
  @spec format_value(String.t(), term()) :: String.t()
  def format_value("single", %Date{} = date), do: Date.to_iso8601(date)
  def format_value("single", value) when is_binary(value), do: String.trim(value)
  def format_value("single", nil), do: ""

  def format_value(mode, value) when mode in ["multiple", "range"] and is_list(value) do
    value
    |> Enum.map(&format_value("single", &1))
    |> Enum.reject(&(&1 == ""))
    |> Enum.join(", ")
  end

  def format_value(mode, value) when mode in ["multiple", "range"] and is_binary(value) do
    format_value(mode, split_iso_list(value))
  end

  def format_value(_mode, nil), do: ""
  def format_value(_mode, _), do: ""

  @doc """
  Normalizes form or `on_value_change` params for Ecto `cast/3`.

  Returns a map with the field key for the mode: `"date"`, `"dates"`, or `"date_range"`.
  Accepts ISO strings, comma-separated strings, lists, or `%Date{}` values.
  """
  @spec cast_params(String.t(), map()) :: map()
  def cast_params(mode, params) when mode in @selection_modes and is_map(params) do
    case mode do
      "single" -> %{"date" => cast_single_param(params)}
      "multiple" -> %{"dates" => cast_list_param(params, "dates")}
      "range" -> %{"date_range" => cast_list_param(params, "date_range")}
    end
  end

  defp cast_single_param(params) do
    params
    |> Map.get("date", Map.get(params, "value"))
    |> param_to_iso_string()
  end

  defp cast_list_param(params, field) do
    values =
      cond do
        is_list(params[field]) -> params[field]
        is_binary(params[field]) -> split_iso_list(params[field])
        is_binary(params["value"]) -> split_iso_list(params["value"])
        true -> []
      end

    values
    |> Enum.map(&param_to_iso_string/1)
    |> Enum.reject(&(&1 == ""))
  end

  defp param_to_iso_string(%Date{} = date), do: Date.to_iso8601(date)
  defp param_to_iso_string(value) when is_binary(value), do: String.trim(value)
  defp param_to_iso_string(nil), do: ""
  defp param_to_iso_string(_), do: ""

  defp split_iso_list(value) when is_binary(value) do
    value
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
  end

  defp merge_date_picker_assigns(%{} = assigns) do
    assigns
    |> assign_new(:form_field, fn -> false end)
    |> assign(translation: DatePickerTranslation.resolve(Map.get(assigns, :translation)))
  end

  defp assign_array_form_submit(%{selection_mode: mode, name: name} = assigns, field_used)
       when mode in ["multiple", "range"] and is_binary(name) do
    assigns =
      assigns
      |> Corex.FormField.assign_list_submit()
      |> assign(:array_form_submit, true)
      |> assign(
        :array_iso_values,
        iso_values_for_array_submit(assigns.value, assigns.selection_mode)
      )

    assign(assigns, :empty_array_name, empty_array_name(field_used, assigns.submit_name))
  end

  defp assign_array_form_submit(assigns, _field_used) do
    assigns
    |> assign(:array_form_submit, false)
    |> assign(:submit_name, nil)
    |> assign(:empty_array_name, nil)
    |> assign(:array_iso_values, [])
  end

  defp empty_array_name(field_used, submit_name) when field_used not in [nil, false],
    do: submit_name

  defp empty_array_name(_field_used, _submit_name), do: nil

  defp iso_values_for_array_submit(nil, _), do: []

  defp iso_values_for_array_submit(value, _mode) when is_list(value) do
    Enum.map(value, &to_string/1)
  end

  defp iso_values_for_array_submit(value, _mode) when is_binary(value) do
    value
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
  end

  defp iso_values_for_array_submit(_, _), do: []

  defp normalize_date_value(nil), do: nil
  defp normalize_date_value(%Date{} = d), do: Date.to_iso8601(d)
  defp normalize_date_value(s) when is_binary(s), do: s
  defp normalize_date_value(_), do: nil

  defp date_field_value(nil, _), do: nil
  defp date_field_value(%Date{} = d, _), do: Date.to_iso8601(d)
  defp date_field_value(s, _) when is_binary(s), do: s

  defp date_field_value([single | _], "single"), do: date_field_value(single, "single")
  defp date_field_value([], "single"), do: nil

  defp date_field_value(values, mode) when is_list(values) and mode in ["multiple", "range"] do
    values
    |> Enum.map(&date_field_value(&1, "single"))
    |> Enum.reject(&is_nil/1)
    |> case do
      [] -> nil
      list -> Enum.join(list, ",")
    end
  end

  defp date_field_value(_, _), do: nil
end
