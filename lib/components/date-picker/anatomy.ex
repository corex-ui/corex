defmodule Corex.DatePicker.Anatomy do
  @moduledoc false

  defmodule Props do
    @moduledoc false
    @enforce_keys [:id]

    # credo:disable-for-next-line Credo.Check.Warning.StructFieldAmount
    defstruct [
      :id,
      :value,
      :locale,
      :time_zone,
      :name,
      :min,
      :max,
      :focused_value,
      :placeholder,
      :positioning,
      :trigger_aria_label,
      :input_aria_label,
      controlled: false,
      disabled: false,
      read_only: false,
      required: false,
      invalid: false,
      outside_day_selectable: false,
      close_on_select: true,
      num_of_months: nil,
      start_of_week: nil,
      fixed_weeks: false,
      selection_mode: nil,
      default_view: nil,
      min_view: nil,
      max_view: nil,
      dir: "ltr",
      on_value_change: nil,
      on_focus_change: nil,
      on_view_change: nil,
      on_visible_range_change: nil,
      on_open_change: nil
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            value: String.t() | nil,
            locale: String.t() | nil,
            time_zone: String.t() | nil,
            name: String.t() | nil,
            min: String.t() | nil,
            max: String.t() | nil,
            focused_value: String.t() | nil,
            placeholder: String.t() | nil,
            positioning: map() | nil,
            controlled: boolean(),
            disabled: boolean(),
            read_only: boolean(),
            required: boolean(),
            invalid: boolean(),
            outside_day_selectable: boolean(),
            close_on_select: boolean(),
            num_of_months: integer() | nil,
            start_of_week: integer() | nil,
            fixed_weeks: boolean(),
            selection_mode: String.t() | nil,
            default_view: String.t() | nil,
            min_view: String.t() | nil,
            max_view: String.t() | nil,
            dir: String.t(),
            on_value_change: String.t() | nil,
            on_focus_change: String.t() | nil,
            on_view_change: String.t() | nil,
            on_visible_range_change: String.t() | nil,
            on_open_change: String.t() | nil
          }
  end

  defmodule Root do
    @moduledoc false
    defstruct [:id, :dir]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t()
          }
  end

  defmodule Label do
    @moduledoc false
    defstruct [:id, :dir]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t()
          }
  end

  defmodule Control do
    @moduledoc false
    defstruct [:id, :dir]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t()
          }
  end

  defmodule Input do
    @moduledoc false
    defstruct [:id, :dir]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t()
          }
  end

  defmodule Trigger do
    @moduledoc false
    defstruct [:id, :dir]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t()
          }
  end

  defmodule Positioner do
    @moduledoc false
    defstruct [:id, :dir]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t()
          }
  end

  defmodule Content do
    @moduledoc false
    defstruct [:id, :dir]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t()
          }
  end
end
