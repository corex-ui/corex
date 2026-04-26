defmodule Corex.DatePicker.Translation do
  @moduledoc """
  Translatable UI strings for the date picker.

  These map to the [Zag.js date picker `translations` prop](https://zagjs.com/components/react/date-picker) (plus `input` and range labels, which the Corex host applies because Zag does not set every label from one place).

  Without gettext: `translation={%DatePicker.Translation{ content: "calendar" }}`

  With gettext: `translation={%DatePicker.Translation{ content: gettext("calendar") }}`
  """

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
