defmodule Corex.Slider.Anatomy do
  @moduledoc false

  defmodule Props do
    @moduledoc false
    @enforce_keys [:id]

    defstruct [
      :id,
      form_field: false,
      field_used: false,
      value: [0],
      min: 0,
      max: 100,
      step: 1,
      large_step: nil,
      disabled: false,
      read_only: false,
      invalid: false,
      required: false,
      name: nil,
      submit_name: nil,
      form: nil,
      dir: "ltr",
      orientation: "horizontal",
      origin: "start",
      thumb_alignment: nil,
      min_steps_between_thumbs: nil,
      thumb_collision_behavior: nil,
      on_value_change: nil,
      on_value_change_client: nil,
      on_value_change_end: nil,
      on_value_change_end_client: nil
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            form_field: boolean(),
            field_used: boolean(),
            value: [number()],
            min: number(),
            max: number(),
            step: number(),
            large_step: number() | nil,
            disabled: boolean(),
            read_only: boolean(),
            invalid: boolean(),
            required: boolean(),
            name: String.t() | nil,
            submit_name: String.t() | nil,
            form: String.t() | nil,
            dir: String.t(),
            orientation: String.t(),
            origin: String.t(),
            thumb_alignment: String.t() | nil,
            min_steps_between_thumbs: number() | nil,
            thumb_collision_behavior: String.t() | nil,
            on_value_change: String.t() | nil,
            on_value_change_client: String.t() | nil,
            on_value_change_end: String.t() | nil,
            on_value_change_end_client: String.t() | nil
          }
  end

  defmodule Root do
    @moduledoc false
    defstruct [
      :id,
      :dir,
      :value,
      :min,
      :max,
      origin: "start",
      orientation: "horizontal",
      disabled: false,
      read_only: false,
      invalid: false
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            value: [number()],
            min: number(),
            max: number(),
            origin: String.t(),
            orientation: String.t(),
            disabled: boolean(),
            read_only: boolean(),
            invalid: boolean()
          }

    @ignored_attrs [
      "id",
      "dir",
      "style",
      "data-disabled",
      "data-invalid",
      "data-readonly"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Label do
    @moduledoc false
    defstruct [
      :id,
      :dir,
      orientation: "horizontal",
      disabled: false,
      read_only: false,
      invalid: false
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            orientation: String.t(),
            disabled: boolean(),
            read_only: boolean(),
            invalid: boolean()
          }

    @ignored_attrs [
      "id",
      "for",
      "htmlFor",
      "dir",
      "data-disabled",
      "data-invalid",
      "data-readonly"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule HiddenInput do
    @moduledoc false
    defstruct [
      :id,
      :name,
      :value,
      :index,
      :disabled,
      :dir,
      :form,
      required: false,
      orientation: "horizontal"
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            name: String.t() | nil,
            value: number(),
            index: non_neg_integer(),
            disabled: boolean(),
            dir: String.t(),
            form: String.t() | nil,
            required: boolean(),
            orientation: String.t()
          }

    @ignored_attrs [
      "id",
      "name",
      "value",
      "disabled",
      "type",
      "dir",
      "form",
      "required"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Control do
    @moduledoc false
    defstruct [
      :id,
      :dir,
      orientation: "horizontal",
      disabled: false,
      read_only: false,
      invalid: false
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            orientation: String.t(),
            disabled: boolean(),
            read_only: boolean(),
            invalid: boolean()
          }

    @ignored_attrs [
      "id",
      "dir",
      "data-disabled",
      "data-invalid",
      "data-readonly",
      "style"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Track do
    @moduledoc false
    defstruct [
      :id,
      :dir,
      orientation: "horizontal",
      disabled: false,
      read_only: false,
      invalid: false
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            orientation: String.t(),
            disabled: boolean(),
            read_only: boolean(),
            invalid: boolean()
          }

    @ignored_attrs [
      "id",
      "dir",
      "data-disabled",
      "data-invalid",
      "data-readonly",
      "style"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Range do
    @moduledoc false
    defstruct [
      :id,
      :dir,
      :value,
      :min,
      :max,
      origin: "start",
      orientation: "horizontal",
      disabled: false,
      read_only: false,
      invalid: false
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            value: [number()],
            min: number(),
            max: number(),
            origin: String.t(),
            orientation: String.t(),
            disabled: boolean(),
            read_only: boolean(),
            invalid: boolean()
          }

    @ignored_attrs [
      "id",
      "dir",
      "style",
      "data-disabled",
      "data-invalid",
      "data-readonly"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Thumb do
    @moduledoc false
    defstruct [
      :id,
      :dir,
      :index,
      :value,
      :min,
      :max,
      orientation: "horizontal",
      disabled: false,
      read_only: false,
      invalid: false
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            index: non_neg_integer(),
            value: number(),
            min: number(),
            max: number(),
            orientation: String.t(),
            disabled: boolean(),
            read_only: boolean(),
            invalid: boolean()
          }

    @ignored_attrs [
      "id",
      "dir",
      "data-disabled",
      "data-invalid",
      "data-readonly",
      "data-index",
      "aria-label",
      "aria-labelledby",
      "aria-valuemax",
      "aria-valuemin",
      "aria-valuenow",
      "role",
      "tabindex",
      "tabIndex",
      "style"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule ValueText do
    @moduledoc false
    defstruct [:id, :dir, :value, orientation: "horizontal"]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            value: [number()],
            orientation: String.t()
          }

    @ignored_attrs ["id", "dir"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Value do
    @moduledoc false
    defstruct []

    @type t :: %__MODULE__{}
  end

  defmodule MarkerGroup do
    @moduledoc false
    defstruct [:id, :dir, orientation: "horizontal"]

    @type t :: %__MODULE__{id: String.t(), dir: String.t(), orientation: String.t()}

    @ignored_attrs ["id", "dir"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Marker do
    @moduledoc false
    defstruct [:id, :value, :slider_value, :dir, orientation: "horizontal", disabled: false]

    @type t :: %__MODULE__{
            id: String.t(),
            value: number(),
            slider_value: [number()],
            dir: String.t(),
            orientation: String.t(),
            disabled: boolean()
          }

    @ignored_attrs [
      "id",
      "dir",
      "style",
      "data-disabled",
      "data-state",
      "data-value"
    ]
    def ignored_attrs, do: @ignored_attrs
  end
end
