defmodule Corex.DatePicker.Anatomy do
  @moduledoc false
  alias Corex.DatePicker.Translation, as: DatePickerTranslation

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
      controlled: false,
      disabled: false,
      read_only: false,
      required: false,
      invalid: false,
      outside_day_selectable: false,
      close_on_select: true,
      start_of_week: nil,
      fixed_weeks: false,
      selection_mode: nil,
      view: nil,
      min_view: nil,
      max_view: nil,
      dir: "ltr",
      on_value_change: nil,
      on_focus_change: nil,
      on_view_change: nil,
      on_visible_range_change: nil,
      on_open_change: nil,
      on_value_change_client: nil,
      on_focus_change_client: nil,
      on_view_change_client: nil,
      on_visible_range_change_client: nil,
      on_open_change_client: nil,
      max_selected_dates: nil,
      translation: nil
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
            start_of_week: integer() | nil,
            fixed_weeks: boolean(),
            selection_mode: String.t() | nil,
            view: String.t() | nil,
            min_view: String.t() | nil,
            max_view: String.t() | nil,
            dir: String.t(),
            on_value_change: String.t() | nil,
            on_focus_change: String.t() | nil,
            on_view_change: String.t() | nil,
            on_visible_range_change: String.t() | nil,
            on_open_change: String.t() | nil,
            on_value_change_client: String.t() | nil,
            on_focus_change_client: String.t() | nil,
            on_view_change_client: String.t() | nil,
            on_visible_range_change_client: String.t() | nil,
            on_open_change_client: String.t() | nil,
            max_selected_dates: pos_integer() | nil,
            translation: DatePickerTranslation.t() | nil
          }
  end

  defmodule Root do
    @moduledoc false
    defstruct [:id, :dir, read_only: false]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            read_only: boolean()
          }

    @ignored_attrs ["id", "dir", "data-state", "data-open", "data-focus"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Label do
    @moduledoc false
    defstruct [:id, :dir]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t()
          }

    @ignored_attrs ["id", "dir", "data-state", "data-disabled", "data-readonly", "data-index"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Control do
    @moduledoc false
    defstruct [:id, :dir]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t()
          }

    @ignored_attrs ["id", "dir", "data-state", "data-disabled"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Input do
    @moduledoc false
    defstruct [:id, :dir, index: 0]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            index: non_neg_integer()
          }

    @ignored_attrs [
      "id",
      "dir",
      "value",
      "placeholder",
      "readonly",
      "disabled",
      "aria-expanded",
      "aria-controls",
      "aria-haspopup",
      "data-state",
      "data-placeholder-shown",
      "data-readonly",
      "data-disabled",
      "data-value"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Trigger do
    @moduledoc false
    defstruct [:id, :dir]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t()
          }

    @ignored_attrs [
      "id",
      "dir",
      "type",
      "hidden",
      "disabled",
      "aria-label",
      "aria-expanded",
      "aria-controls",
      "data-state",
      "data-disabled"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Positioner do
    @moduledoc false
    defstruct id: nil, dir: nil, positioning: nil

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            positioning: Corex.Positioning.t() | nil
          }

    @ignored_attrs ["id", "dir", "style", "data-state", "data-placement", "hidden"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Content do
    @moduledoc false
    defstruct [:id, :dir]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t()
          }

    @ignored_attrs ["id", "dir", "hidden", "data-state", "role", "tabindex", "style"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule ViewNav do
    @moduledoc false

    @ignored_attrs [
      "id",
      "dir",
      "type",
      "disabled",
      "aria-label",
      "aria-expanded",
      "aria-controls",
      "data-state",
      "hidden",
      "data-scope",
      "data-part",
      "data-view"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Decade do
    @moduledoc false
    defstruct [:id, :dir]

    @type t :: %__MODULE__{id: String.t(), dir: String.t()}

    @ignored_attrs ["id", "dir", "data-scope", "data-part"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Error do
    @moduledoc false
    defstruct [:id, :index]

    @type t :: %__MODULE__{id: String.t(), index: non_neg_integer()}

    @ignored_attrs ["id", "dir", "data-scope", "data-part", "role", "aria-live", "hidden"]
    def ignored_attrs, do: @ignored_attrs
  end
end
