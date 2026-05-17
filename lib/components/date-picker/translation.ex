defmodule Corex.DatePicker.Translation do
  @moduledoc """
  Translatable UI strings for the date picker ([Zag `translations`](https://zagjs.com/components/react/date-picker) plus Corex field labels).

  Pass `translation={%Corex.DatePicker.Translation{}}` to override any field. Omitted fields use gettext defaults from [`default/0`](#default/0).

  | Field | Default | Used for |
  | ----- | ------- | -------- |
  | `content` | calendar | Popover content region |
  | `month_select` | Select month | Month view select |
  | `year_select` | Select year | Year view select |
  | `clear_trigger` | Clear selected dates | Clear button |
  | `week_column_header` | Wk | Week column header |
  | `open_calendar` | Open calendar | Open trigger `aria-label` |
  | `close_calendar` | Close calendar | Close trigger `aria-label` |
  | `view_trigger_year` | Switch to month view | Year view trigger |
  | `view_trigger_month` | Switch to day view | Month view trigger |
  | `view_trigger_day` | Switch to year view | Day view trigger |
  | `prev_trigger_year` | Switch to previous decade | Prev (year view) |
  | `prev_trigger_month` | Switch to previous year | Prev (month view) |
  | `prev_trigger_day` | Switch to previous month | Prev (day view) |
  | `next_trigger_year` | Switch to next decade | Next (year view) |
  | `next_trigger_month` | Switch to next year | Next (month view) |
  | `next_trigger_day` | Switch to next month | Next (day view) |
  | `week_number` | Week __N__ | Week number label |
  | `placeholder_day` | dd | Day field placeholder |
  | `placeholder_month` | mm | Month field placeholder |
  | `placeholder_year` | yyyy | Year field placeholder |
  | `input` | Select date | Input / trigger label |
  | `range_start` | From | Range mode start label |
  | `range_end` | To | Range mode end label |
  """

  alias Corex.Gettext
  alias Corex.Translation, as: T

  @enforce_keys []

  defstruct [
    :content,
    :month_select,
    :year_select,
    :clear_trigger,
    :week_column_header,
    :open_calendar,
    :close_calendar,
    :view_trigger_year,
    :view_trigger_month,
    :view_trigger_day,
    :prev_trigger_year,
    :prev_trigger_month,
    :prev_trigger_day,
    :next_trigger_year,
    :next_trigger_month,
    :next_trigger_day,
    :week_number,
    :placeholder_day,
    :placeholder_month,
    :placeholder_year,
    :input,
    :range_start,
    :range_end
  ]

  @type t :: %__MODULE__{
          content: String.t(),
          month_select: String.t(),
          year_select: String.t(),
          clear_trigger: String.t(),
          week_column_header: String.t(),
          open_calendar: String.t(),
          close_calendar: String.t(),
          view_trigger_year: String.t(),
          view_trigger_month: String.t(),
          view_trigger_day: String.t(),
          prev_trigger_year: String.t(),
          prev_trigger_month: String.t(),
          prev_trigger_day: String.t(),
          next_trigger_year: String.t(),
          next_trigger_month: String.t(),
          next_trigger_day: String.t(),
          week_number: String.t(),
          placeholder_day: String.t(),
          placeholder_month: String.t(),
          placeholder_year: String.t(),
          input: String.t(),
          range_start: String.t(),
          range_end: String.t()
        }

  def default do
    %__MODULE__{
      content: Gettext.gettext("calendar"),
      month_select: Gettext.gettext("Select month"),
      year_select: Gettext.gettext("Select year"),
      clear_trigger: Gettext.gettext("Clear selected dates"),
      week_column_header: Gettext.gettext("Wk"),
      open_calendar: Gettext.gettext("Open calendar"),
      close_calendar: Gettext.gettext("Close calendar"),
      view_trigger_year: Gettext.gettext("Switch to month view"),
      view_trigger_month: Gettext.gettext("Switch to day view"),
      view_trigger_day: Gettext.gettext("Switch to year view"),
      prev_trigger_year: Gettext.gettext("Switch to previous decade"),
      prev_trigger_month: Gettext.gettext("Switch to previous year"),
      prev_trigger_day: Gettext.gettext("Switch to previous month"),
      next_trigger_year: Gettext.gettext("Switch to next decade"),
      next_trigger_month: Gettext.gettext("Switch to next year"),
      next_trigger_day: Gettext.gettext("Switch to next month"),
      week_number: Gettext.gettext("Week __N__"),
      placeholder_day: Gettext.gettext("dd"),
      placeholder_month: Gettext.gettext("mm"),
      placeholder_year: Gettext.gettext("yyyy"),
      input: Gettext.gettext("Select date"),
      range_start: Gettext.gettext("From"),
      range_end: Gettext.gettext("To")
    }
  end

  def merge(nil, default), do: default

  def merge(%__MODULE__{} = p, %__MODULE__{} = d) do
    %__MODULE__{
      content: T.take(p.content, d.content),
      month_select: T.take(p.month_select, d.month_select),
      year_select: T.take(p.year_select, d.year_select),
      clear_trigger: T.take(p.clear_trigger, d.clear_trigger),
      week_column_header: T.take(p.week_column_header, d.week_column_header),
      open_calendar: T.take(p.open_calendar, d.open_calendar),
      close_calendar: T.take(p.close_calendar, d.close_calendar),
      view_trigger_year: T.take(p.view_trigger_year, d.view_trigger_year),
      view_trigger_month: T.take(p.view_trigger_month, d.view_trigger_month),
      view_trigger_day: T.take(p.view_trigger_day, d.view_trigger_day),
      prev_trigger_year: T.take(p.prev_trigger_year, d.prev_trigger_year),
      prev_trigger_month: T.take(p.prev_trigger_month, d.prev_trigger_month),
      prev_trigger_day: T.take(p.prev_trigger_day, d.prev_trigger_day),
      next_trigger_year: T.take(p.next_trigger_year, d.next_trigger_year),
      next_trigger_month: T.take(p.next_trigger_month, d.next_trigger_month),
      next_trigger_day: T.take(p.next_trigger_day, d.next_trigger_day),
      week_number: T.take(p.week_number, d.week_number),
      placeholder_day: T.take(p.placeholder_day, d.placeholder_day),
      placeholder_month: T.take(p.placeholder_month, d.placeholder_month),
      placeholder_year: T.take(p.placeholder_year, d.placeholder_year),
      input: T.take(p.input, d.input),
      range_start: T.take(p.range_start, d.range_start),
      range_end: T.take(p.range_end, d.range_end)
    }
  end

  @doc false
  def to_camel_map(%__MODULE__{} = t) do
    %{
      "content" => t.content,
      "monthSelect" => t.month_select,
      "yearSelect" => t.year_select,
      "clearTrigger" => t.clear_trigger,
      "weekColumnHeader" => t.week_column_header,
      "openCalendar" => t.open_calendar,
      "closeCalendar" => t.close_calendar,
      "viewTriggerYear" => t.view_trigger_year,
      "viewTriggerMonth" => t.view_trigger_month,
      "viewTriggerDay" => t.view_trigger_day,
      "prevTriggerYear" => t.prev_trigger_year,
      "prevTriggerMonth" => t.prev_trigger_month,
      "prevTriggerDay" => t.prev_trigger_day,
      "nextTriggerYear" => t.next_trigger_year,
      "nextTriggerMonth" => t.next_trigger_month,
      "nextTriggerDay" => t.next_trigger_day,
      "weekNumber" => t.week_number,
      "placeholderDay" => t.placeholder_day,
      "placeholderMonth" => t.placeholder_month,
      "placeholderYear" => t.placeholder_year,
      "input" => t.input,
      "rangeStart" => t.range_start,
      "rangeEnd" => t.range_end
    }
  end
end
