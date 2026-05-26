defmodule Corex.DatePicker.Translation do
  @moduledoc """
  Translatable strings for [`Corex.DatePicker`](Corex.DatePicker.html).

  Pass `translation={%Corex.DatePicker.Translation{}}` to override any field. Omitted fields use gettext defaults (see table).

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

  Partial override example:

      translation={%Corex.DatePicker.Translation{
        open_calendar: Corex.Gettext.gettext("Pick a date"),
        input: Corex.Gettext.gettext("Event date")
      }}
  """

  use Corex.Translation,
    camel_keys: [
      content: "content",
      month_select: "monthSelect",
      year_select: "yearSelect",
      clear_trigger: "clearTrigger",
      week_column_header: "weekColumnHeader",
      open_calendar: "openCalendar",
      close_calendar: "closeCalendar",
      view_trigger_year: "viewTriggerYear",
      view_trigger_month: "viewTriggerMonth",
      view_trigger_day: "viewTriggerDay",
      prev_trigger_year: "prevTriggerYear",
      prev_trigger_month: "prevTriggerMonth",
      prev_trigger_day: "prevTriggerDay",
      next_trigger_year: "nextTriggerYear",
      next_trigger_month: "nextTriggerMonth",
      next_trigger_day: "nextTriggerDay",
      week_number: "weekNumber",
      placeholder_day: "placeholderDay",
      placeholder_month: "placeholderMonth",
      placeholder_year: "placeholderYear",
      input: "input",
      range_start: "rangeStart",
      range_end: "rangeEnd"
    ],
    fields: [
      content: "calendar",
      month_select: "Select month",
      year_select: "Select year",
      clear_trigger: "Clear selected dates",
      week_column_header: "Wk",
      open_calendar: "Open calendar",
      close_calendar: "Close calendar",
      view_trigger_year: "Switch to month view",
      view_trigger_month: "Switch to day view",
      view_trigger_day: "Switch to year view",
      prev_trigger_year: "Switch to previous decade",
      prev_trigger_month: "Switch to previous year",
      prev_trigger_day: "Switch to previous month",
      next_trigger_year: "Switch to next decade",
      next_trigger_month: "Switch to next year",
      next_trigger_day: "Switch to next month",
      week_number: "Week __N__",
      placeholder_day: "dd",
      placeholder_month: "mm",
      placeholder_year: "yyyy",
      input: "Select date",
      range_start: "From",
      range_end: "To"
    ]
end
