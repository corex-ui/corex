defmodule Corex.DatePicker do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Date Picker](https://zagjs.com/components/react/date-picker).

  ## Examples

  ### Basic Usage

  This example assumes the import of `.icon` from `Core Components`

  ```heex
  <.date_picker id="my-date-picker">
    <:label>Select a date</:label>
    <:trigger>
      <.icon name="hero-calendar" />
    </:trigger>
           <:prev_trigger>
          <.icon name="hero-chevron-left" class="icon" />
        </:prev_trigger>
        <:next_trigger>
          <.icon name="hero-chevron-right" class="icon" />
        </:next_trigger>
  </.date_picker>
  ```

  ### Controlled Mode

  This example assumes the import of `.icon` from `Core Components`

  ```heex
  <.date_picker
    id="my-date-picker"
    controlled
    value={@date_value}
    on_value_change="date_changed">
    <:label>Select a date</:label>
    <:trigger>
      <.icon name="hero-calendar" />
    </:trigger>
           <:prev_trigger>
          <.icon name="hero-chevron-left" class="icon" />
        </:prev_trigger>
        <:next_trigger>
          <.icon name="hero-chevron-right" class="icon" />
        </:next_trigger>
  </.date_picker>
  ```

  ```elixir
  def handle_event("date_changed", %{"value" => value}, socket) do
    {:noreply, assign(socket, :date_value, value)}
  end
  ```

  ## Phoenix Form Integration

  When using with Phoenix forms, you must add an id to the form using the `Corex.Form.get_form_id/1` function.

  ### Controller

  ```elixir
  defmodule MyAppWeb.PageController do
    use MyAppWeb, :controller

    def home(conn, params) do
      form = Phoenix.Component.to_form(Map.get(params, "user", %{}), as: :user)
      render(conn, :home, form: form)
    end
  end
  ```

  ```heex
  <.form :let={f} as={:user} for={@form} id={get_form_id(@form)} method="get">
    <.date_picker field={f[:birth_date]} class="date-picker">
      <:label>Birth date</:label>
      <:trigger>
        <.icon name="hero-calendar" class="icon" />
      </:trigger>
      <:prev_trigger>
        <.icon name="hero-chevron-left" class="icon" />
      </:prev_trigger>
      <:next_trigger>
        <.icon name="hero-chevron-right" class="icon" />
      </:next_trigger>
      <:error :let={msg}>
        <.icon name="hero-exclamation-circle" class="icon" />
        {msg}
      </:error>
    </.date_picker>
    <button type="submit">Submit</button>
  </.form>
  ```

  ### Live View

  When using Phoenix form in a Live view you must also add controlled mode. This allows the Live view to be the source of truth and the component to be in sync accordingly.

  ```elixir
  defmodule MyAppWeb.DatePickerLive do
    use MyAppWeb, :live_view

    def mount(_params, _session, socket) do
      form = to_form(%{"birth_date" => nil}, as: :user)
      {:ok, assign(socket, :form, form)}
    end

    def render(assigns) do
      ~H"""
      <.form as={:user} for={@form} id={get_form_id(@form)}>
        <.date_picker field={@form[:birth_date]} class="date-picker" controlled>
          <:label>Birth date</:label>
          <:trigger>
            <.icon name="hero-calendar" class="icon" />
          </:trigger>
          <:prev_trigger>
            <.icon name="hero-chevron-left" class="icon" />
          </:prev_trigger>
          <:next_trigger>
            <.icon name="hero-chevron-right" class="icon" />
          </:next_trigger>
          <:error :let={msg}>
            <.icon name="hero-exclamation-circle" class="icon" />
            {msg}
          </:error>
        </.date_picker>
        <button type="submit">Submit</button>
      </.form>
      """
    end
  end
  ```

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
            <.icon name="hero-calendar" class="icon" />
          </:trigger>
          <:prev_trigger>
            <.icon name="hero-chevron-left" class="icon" />
          </:prev_trigger>
          <:next_trigger>
            <.icon name="hero-chevron-right" class="icon" />
          </:next_trigger>
          <:error :let={msg}>
            <.icon name="hero-exclamation-circle" class="icon" />
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
  '''

  use Phoenix.Component
  alias Corex.DatePicker.{Anatomy, Connect}

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
    doc: "The direction of the date picker"
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
    default: true,
    doc: "Whether the calendar should close after the date selection is complete"
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

  attr(:num_of_months, :integer,
    default: 1,
    doc: "The number of months to display"
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

  attr(:trigger_aria_label, :string,
    default: nil,
    doc:
      "Accessible name for the trigger button when it contains only an icon (e.g. \"Select date\")"
  )

  attr(:input_aria_label, :string,
    default: nil,
    doc:
      "Accessible name for the input when it's not associated with a visible label (e.g. \"Select date\")"
  )

  attr(:default_view, :string,
    default: "day",
    values: ["day", "month", "year"],
    doc: "The initial view of the calendar (day, month, or year)"
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

  attr(:default_open, :boolean,
    default: nil,
    doc: "The initial open state of the date picker when rendered"
  )

  attr(:inline, :boolean,
    default: false,
    doc: "Whether to render the date picker inline"
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
    |> assign(
      :id,
      assigns[:id] || field.id || "date-picker-#{System.unique_integer([:positive])}"
    )
    |> assign(:name, field.name)
    |> assign(:value, normalize_date_value(field.value))
    |> assign(:controlled, true)
    |> date_picker()
  end

  def date_picker(assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> "date-picker-#{System.unique_integer([:positive])}" end)
      |> assign(:id, assigns[:id] || "date-picker-#{System.unique_integer([:positive])}")

    ~H"""
    <div
      id={@id}
      phx-hook="DatePicker"
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
        num_of_months: @num_of_months,
        start_of_week: @start_of_week,
        fixed_weeks: @fixed_weeks,
        selection_mode: @selection_mode,
        placeholder: @placeholder,
        default_view: @default_view,
        min_view: @min_view,
        max_view: @max_view,
        default_open: @default_open,
        inline: @inline,
        positioning: @positioning,
        dir: @dir,
        on_value_change: @on_value_change,
        on_focus_change: @on_focus_change,
        on_view_change: @on_view_change,
        on_visible_range_change: @on_visible_range_change,
        on_open_change: @on_open_change
      })}
    >
      <div {Connect.root(%Anatomy.Root{id: @id, dir: @dir, changed: Map.get(assigns, :__changed__, nil) != nil})}>
        <label :if={@label != []} {Connect.label(%Anatomy.Label{id: @id, dir: @dir, changed: Map.get(assigns, :__changed__, nil) != nil})}>
          {render_slot(@label)}
        </label>
        <div {Connect.control(%Anatomy.Control{id: @id, dir: @dir, changed: Map.get(assigns, :__changed__, nil) != nil})}>
          <input type="hidden" id={"#{@id}-value"} name={@name} value={Phoenix.HTML.Form.normalize_value("date", @value)} />
          <input
            {Connect.input(%Anatomy.Input{id: @id, dir: @dir, changed: Map.get(assigns, :__changed__, nil) != nil})}
            aria-label={@input_aria_label}
          />
          <button
            :if={@trigger != []}
            {Connect.trigger(%Anatomy.Trigger{id: @id, dir: @dir, changed: Map.get(assigns, :__changed__, nil) != nil})}
            aria-label={@trigger_aria_label}
          >
            {render_slot(@trigger)}
          </button>
        </div>
        <div :if={@error != []} :for={msg <- @errors} data-scope="date-picker" data-part="error">
          {render_slot(@error, msg)}
        </div>
        <div {Connect.positioner(%Anatomy.Positioner{id: @id, dir: @dir, changed: Map.get(assigns, :__changed__, nil) != nil})}>
          <div {Connect.content(%Anatomy.Content{id: @id, dir: @dir, changed: Map.get(assigns, :__changed__, nil) != nil})}>
            <div phx-update="ignore" id={@id <> "-day-view"} data-scope="date-picker" data-part="day-view">
              <div data-scope="date-picker" data-part="view-control" data-view="day">
                <button data-scope="date-picker" data-part="prev-trigger">
                  <%= if @prev_trigger != [] do %>
                    {render_slot(@prev_trigger)}
                  <% else %>
                    Prev
                  <% end %>
                </button>
                <button data-scope="date-picker" data-part="view-trigger"></button>
                <button data-scope="date-picker" data-part="next-trigger">
                  <%= if @next_trigger != [] do %>
                    {render_slot(@next_trigger)}
                  <% else %>
                    Next
                  <% end %>
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
                <button data-scope="date-picker" data-part="prev-trigger">
                  <%= if @prev_trigger != [] do %>
                    {render_slot(@prev_trigger)}
                  <% else %>
                    Prev
                  <% end %>
                </button>
                <button data-scope="date-picker" data-part="view-trigger"></button>
                <button data-scope="date-picker" data-part="next-trigger">
                  <%= if @next_trigger != [] do %>
                    {render_slot(@next_trigger)}
                  <% else %>
                    Next
                  <% end %>
                </button>
              </div>
              <table data-scope="date-picker" data-part="month-table">
                <tbody data-scope="date-picker" data-part="month-table-body">
                </tbody>
              </table>
            </div>
            <div data-scope="date-picker" data-part="year-view" hidden>
              <div data-scope="date-picker" data-part="view-control" data-view="year">
                <button data-scope="date-picker" data-part="prev-trigger">
                  <%= if @prev_trigger != [] do %>
                    {render_slot(@prev_trigger)}
                  <% else %>
                    Prev
                  <% end %>
                </button>
                <span data-scope="date-picker" data-part="decade"></span>
                <button data-scope="date-picker" data-part="next-trigger">
                  <%= if @next_trigger != [] do %>
                    {render_slot(@next_trigger)}
                  <% else %>
                    Next
                  <% end %>
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
  def set_value(date_picker_id, value) when is_binary(date_picker_id) and is_binary(value) do
    Phoenix.LiveView.JS.dispatch("phx:date-picker:set-value",
      to: "##{date_picker_id}",
      detail: %{value: value},
      bubbles: false
    )
  end

  @doc type: :api
  @doc """
  Sets the date picker value from server-side. Pushes a LiveView event.

  ## Examples

      def handle_event("set_date", _params, socket) do
        socket = Corex.DatePicker.set_value(socket, "my-date-picker", "2024-01-15")
        {:noreply, socket}
      end
  """
  def set_value(socket, date_picker_id, value)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(date_picker_id) and
             is_binary(value) do
    Phoenix.LiveView.push_event(socket, "date_picker_set_value", %{
      date_picker_id: date_picker_id,
      value: value
    })
  end

  defp normalize_date_value(nil), do: nil
  defp normalize_date_value(%Date{} = d), do: Date.to_iso8601(d)
  defp normalize_date_value(s) when is_binary(s), do: s
  defp normalize_date_value(_), do: nil
end
