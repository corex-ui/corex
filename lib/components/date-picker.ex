defmodule Corex.DatePicker do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Date Picker](https://zagjs.com/components/react/date-picker).

  ## Examples

  ### Basic Usage

  ```heex
  <.date_picker id="my-date-picker">
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

  ### Controlled Mode

  ```heex
  <.date_picker
    id="my-date-picker"
    controlled
    value={@date_value}
    on_value_change="date_changed">
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

  ```elixir
  def handle_event("date_changed", %{"value" => value}, socket) do
    {:noreply, assign(socket, :date_value, value)}
  end
  ```

  Pass an ISO-8601 string, or a `Date` struct via `Date.to_iso8601/1` (for a single day use `~D[...]`):

  ```heex
  <.date_picker
    id="due"
    controlled
    value={@due && Date.to_iso8601(@due)}
    on_value_change="date_changed"
  >
    <:label>Due</:label>
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

  ```elixir
  assign(socket, :due, ~D[2024-01-15])
  ```

  ## Phoenix Form Integration

  When using with Phoenix forms, you must add an id to the form using the `Corex.Form.get_form_id/1` function.

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
  <.form :let={f} for={@form} id={Corex.Form.get_form_id(@form)} action={@action} method="post">
    <.date_picker field={f[:date]} class="date-picker" trigger_aria_label="Select date" input_aria_label="Select date">
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
      <.form for={@form} id={get_form_id(@form)} phx-change="validate">
        <.date_picker field={@form[:birth_date]} class="date-picker" controlled>
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

  ## API Control

  In order to use the API, you must use an id on the component

  ***Client-side***

  ```heex
  <button phx-click={Corex.DatePicker.set_value("my-date-picker", "2024-01-15")}>
    Set Date
  </button>
  ```

  ***Server-side***

  ```elixir
  def handle_event("set_date", _, socket) do
    {:noreply, Corex.DatePicker.set_value(socket, "my-date-picker", "2024-01-15")}
  end
  ```

  ## Styling

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

  If you wish to use the default Corex styling, you can use the class `date-picker` on the component.
  This requires to install `Mix.Tasks.Corex.Design` first and import the component css file.

  ```css
  @import "../corex/main.css";
  @import "../corex/tokens/themes/neo/light.css";
  @import "../corex/components/date-picker.css";
  ```

  You can then use modifiers

  ```heex
  <.date_picker class="date-picker date-picker--accent date-picker--lg" id="my-date-picker">
  </.date_picker>
  ```

  In `selection_mode` `"range"`, the control shows two fields with optional `range_start_label` and `range_end_label` (overrides the `translation` map’s range labels, defaulting to **From** / **To** with gettext). In `"multiple"`, a single field shows a comma‑separated list of the formatted selected dates. Use `max_selected_dates` to cap how many days can be selected in multiple mode; omit for no cap.

  ## Localization and `translation`

  Pass `translation={%Corex.DatePicker.Translation{}}` to override any string. The component merges with `Corex.DatePicker.default_translation/0` (Zag’s `translations` for open/close, prev/next, view, month/year, week, placeholders, and `input`). Without gettext, the defaults are English. With gettext, call `translation={%Corex.DatePicker.Translation{ open_calendar: gettext("Open calendar") }}` for partial overrides.

  The `trigger_aria_label` and `input_aria_label` attributes are merged with `translation` and sent to the client in `data-translation` (JSON): they set the open/close trigger strings and the input label (`translation.open_calendar`, `translation.close_calendar`, and `translation.input`).

  '''

  use Phoenix.Component
  import Corex.Gettext, only: [gettext: 1]
  alias Corex.DatePicker.Anatomy
  alias Corex.DatePicker.Connect
  alias Corex.DatePicker.Translation, as: DatePickerTranslation
  alias Phoenix.LiveView
  alias Phoenix.LiveView.JS

  @doc """
  Renders a date picker component.
  """
  attr(:id, :string,
    default: nil,
    doc: "The unique identifier for the date picker. Set automatically when using the field attr."
  )

  attr(:value, :string,
    default: nil,
    doc: "The initial value or the controlled value (ISO date string)"
  )

  attr(:controlled, :boolean,
    default: false,
    doc:
      "Whether the date picker is controlled. Only in LiveView, the on_value_change event is required"
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
    default: "ltr",
    values: ["ltr", "rtl"],
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

  attr(:name, :string,
    default: nil,
    doc: "The name attribute of the input element"
  )

  attr(:disabled, :boolean,
    default: false,
    doc: "Whether the calendar is disabled"
  )

  attr(:read_only, :boolean,
    default: false,
    doc: "Whether the calendar is read-only"
  )

  attr(:required, :boolean,
    default: false,
    doc: "Whether the date picker is required"
  )

  attr(:invalid, :boolean,
    default: false,
    doc: "Whether the date picker is invalid"
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
      "Merges with `default_translation/0` to override Zag and Corex strings; see the module section on localization."
  )

  attr(:trigger_aria_label, :string,
    default: nil,
    doc:
      "Overrides `translation` for the popover button’s accessible name (same in open and closed state). If unset, the client uses open/close strings from the translation (Zag: open vs. closed calendar labels)."
  )

  attr(:input_aria_label, :string,
    default: nil,
    doc:
      "Overrides `translation.input` for the text input when the slot label is not used. Zag does not provide this; it is a Corex field."
  )

  attr(:range_start_label, :string,
    default: nil,
    doc:
      "When `selection_mode` is \"range\", overrides `translation.range_start` for the first field side label (default in `default_translation/0` is **From**)."
  )

  attr(:range_end_label, :string,
    default: nil,
    doc: "When `selection_mode` is \"range\", overrides `translation.range_end` (default **To**)."
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

  attr(:errors, :list,
    default: [],
    doc: "List of error messages to display"
  )

  attr(:field, Phoenix.HTML.FormField,
    doc:
      "A form field struct from the form, e.g. @form[:birth_date]. Sets id, name, value, and errors from the field; enables controlled mode for LiveView."
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
    errors = if Phoenix.Component.used_input?(field), do: field.errors, else: []

    assigns
    |> assign(field: nil)
    |> assign(:errors, Enum.map(errors, &Corex.Gettext.translate_error(&1)))
    |> assign(:id, field.id)
    |> assign(:name, field.name)
    |> assign(:value, normalize_date_value(field.value))
    |> date_picker()
  end

  def date_picker(assigns) do
    assigns =
      assigns
      |> assign(:id, assigns[:id] || "date-picker-#{System.unique_integer([:positive])}")
      |> merge_date_picker_assigns()

    ~H"""
    <div
      id={@id}
      phx-hook="DatePicker"
      data-loading
      phx-mounted={Phoenix.LiveView.JS.ignore_attributes(["data-loading"])}
      {@rest}
      {Connect.props(%Anatomy.Props{
        id: @id,
        controlled: @controlled,
        value: @value,
        trigger_aria_label: @trigger_aria_label,
        input_aria_label: @input_aria_label,
        locale: @locale,
        time_zone: @time_zone,
        name: @name,
        disabled: @disabled,
        read_only: @read_only,
        required: @required,
        invalid: @invalid,
        outside_day_selectable: @outside_day_selectable,
        close_on_select: @close_on_select,
        min: @min,
        max: @max,
        focused_value: @focused_value,
        start_of_week: @start_of_week,
        fixed_weeks: @fixed_weeks,
        selection_mode: @selection_mode,
        placeholder: @placeholder,
        view: @view,
        min_view: @min_view,
        max_view: @max_view,
        positioning: @positioning,
        dir: @dir,
        on_value_change: @on_value_change,
        on_focus_change: @on_focus_change,
        on_view_change: @on_view_change,
        on_visible_range_change: @on_visible_range_change,
        on_open_change: @on_open_change,
        on_value_change_client: @on_value_change_client,
        on_open_change_client: @on_open_change_client,
        max_selected_dates: @max_selected_dates,
        translation: @translation
      })}
    >
      <div phx-mounted={Connect.ignore_root(%Anatomy.Root{id: @id, dir: @dir})} {Connect.root(%Anatomy.Root{id: @id, dir: @dir})}>
        <label
          :if={@label != []}
          phx-mounted={Connect.ignore_label(%Anatomy.Label{id: @id, dir: @dir})}
          {Connect.label(%Anatomy.Label{id: @id, dir: @dir})}
        >
          {render_slot(@label)}
        </label>
        <div phx-mounted={Connect.ignore_control(%Anatomy.Control{id: @id, dir: @dir})} {Connect.control(%Anatomy.Control{id: @id, dir: @dir})}>
          <input type="text" hidden id={"#{@id}-value"} name={@name} value={Phoenix.HTML.Form.normalize_value("date", @value)} aria-hidden="true" />
          <%= if @selection_mode == "range" do %>
            <div class="date-picker__control-inputs date-picker__control-inputs--range">
              <span class="date-picker__range-label" id={"#{@id}-range-start-label"}>{@range_start_label}</span>
              <input
                phx-mounted={Connect.ignore_input(%Anatomy.Input{id: @id, dir: @dir, index: 0})}
                {Connect.input(%Anatomy.Input{id: @id, dir: @dir, index: 0})}
                aria-labelledby={if @label == [], do: @id <> "-range-start-label"}
              />
              <span class="date-picker__range-label" id={"#{@id}-range-end-label"}>{@range_end_label}</span>
              <input
                phx-mounted={Connect.ignore_input(%Anatomy.Input{id: @id, dir: @dir, index: 1})}
                {Connect.input(%Anatomy.Input{id: @id, dir: @dir, index: 1})}
                aria-labelledby={@id <> "-range-end-label"}
              />
            </div>
          <% else %>
            <input
              phx-mounted={Connect.ignore_input(%Anatomy.Input{id: @id, dir: @dir, index: 0})}
              {Connect.input(%Anatomy.Input{id: @id, dir: @dir, index: 0})}
              aria-label={if @label == [], do: @input_aria_label || @translation.input}
            />
          <% end %>
          <button
            :if={@trigger != []}
            phx-mounted={Connect.ignore_trigger(%Anatomy.Trigger{id: @id, dir: @dir})}
            {Connect.trigger(%Anatomy.Trigger{id: @id, dir: @dir})}
            aria-label={@trigger_aria_label || @translation.open_calendar}
          >
            {render_slot(@trigger)}
          </button>
        </div>
        <div
          :if={@error != []}
          :for={{msg, idx} <- Enum.with_index(@errors)}
          phx-mounted={Connect.ignore_error(%Anatomy.Error{id: @id, index: idx})}
          {Connect.error(%Anatomy.Error{id: @id, index: idx})}
        >
          {render_slot(@error, msg)}
        </div>
        <div
          phx-mounted={Connect.ignore_positioner(%Anatomy.Positioner{id: @id, dir: @dir})}
          {Connect.positioner(%Anatomy.Positioner{id: @id, dir: @dir})}
          
        >
          <div phx-mounted={Connect.ignore_content(%Anatomy.Content{id: @id, dir: @dir})} {Connect.content(%Anatomy.Content{id: @id, dir: @dir})}>
            <div id={@id <> "-day-view"} data-scope="date-picker" data-part="day-view">
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
                <span phx-mounted={Connect.ignore_decade(%Anatomy.Decade{id: @id, dir: @dir || "ltr"})} {Connect.decade(%Anatomy.Decade{id: @id, dir: @dir || "ltr"})}></span>
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

  @doc type: :api
  @doc """
  Sets the date picker value from client-side. Returns a `Phoenix.LiveView.JS` command.

  ## Examples

      <button phx-click={Corex.DatePicker.set_value("my-date-picker", "2024-01-15")}>
        Set Date
      </button>
  """
  def set_value(date_picker_id, value) when is_binary(date_picker_id) do
    case normalize_date_value(value) do
      nil ->
        raise ArgumentError,
              "set_value/2 expected an ISO-8601 date string or a Date, got: #{inspect(value)}"

      iso ->
        JS.dispatch("corex:date-picker:set-value",
          to: "##{date_picker_id}",
          detail: %{value: iso},
          bubbles: false
        )
    end
  end

  @doc type: :api
  @doc """
  Sets the date picker value from server-side. Pushes a LiveView event.

  ## Examples

      def handle_event("set_date", _params, socket) do
        socket = Corex.DatePicker.set_value(socket, "my-date-picker", "2024-01-15")
        {:noreply, socket}
      end

      def handle_event("set_birthdate", _params, socket) do
        socket = Corex.DatePicker.set_value(socket, "my-date-picker", ~D[2024-01-15])
        {:noreply, socket}
      end
  """
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

  defp merge_date_picker_assigns(%{} = assigns) do
    default = default_translation()
    t = merge_date_picker_translation(Map.get(assigns, :translation), default)
    range_start = Map.get(assigns, :range_start_label) || t.range_start
    range_end = Map.get(assigns, :range_end_label) || t.range_end
    assign(assigns, translation: t, range_start_label: range_start, range_end_label: range_end)
  end

  defp merge_date_picker_translation(nil, default), do: default

  defp merge_date_picker_translation(%DatePickerTranslation{} = p, %DatePickerTranslation{} = d) do
    m_p = Map.from_struct(p)
    m_d = Map.from_struct(d)

    merged =
      for {k, fallback} <- Map.to_list(m_d), into: %{} do
        {k, take_translation_override(Map.get(m_p, k), fallback)}
      end

    struct!(DatePickerTranslation, merged)
  end

  defp take_translation_override(override, fallback) do
    if is_binary(override) and String.trim(override) != "" do
      override
    else
      fallback
    end
  end

  @doc """
  Returns the merged default translatable strings. Uses gettext; override per call site with the `translation` attr.
  """
  @spec default_translation() :: DatePickerTranslation.t()
  def default_translation do
    %DatePickerTranslation{
      content: gettext("calendar"),
      month_select: gettext("Select month"),
      year_select: gettext("Select year"),
      clear_trigger: gettext("Clear selected dates"),
      week_column_header: gettext("Wk"),
      open_calendar: gettext("Open calendar"),
      close_calendar: gettext("Close calendar"),
      view_trigger_year: gettext("Switch to month view"),
      view_trigger_month: gettext("Switch to day view"),
      view_trigger_day: gettext("Switch to year view"),
      prev_trigger_year: gettext("Switch to previous decade"),
      prev_trigger_month: gettext("Switch to previous year"),
      prev_trigger_day: gettext("Switch to previous month"),
      next_trigger_year: gettext("Switch to next decade"),
      next_trigger_month: gettext("Switch to next year"),
      next_trigger_day: gettext("Switch to next month"),
      week_number: gettext("Week __N__"),
      placeholder_day: gettext("dd"),
      placeholder_month: gettext("mm"),
      placeholder_year: gettext("yyyy"),
      input: gettext("Select date"),
      range_start: gettext("From"),
      range_end: gettext("To")
    }
  end

  defp normalize_date_value(nil), do: nil
  defp normalize_date_value(%Date{} = d), do: Date.to_iso8601(d)
  defp normalize_date_value(s) when is_binary(s), do: s
  defp normalize_date_value(_), do: nil
end
