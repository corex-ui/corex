defmodule Corex.AngleSlider.Anatomy do
  @moduledoc false

  defmodule Props do
    @moduledoc false
    @enforce_keys [:id]

    defstruct [
      :id,
      form_field: false,
      value: 0,
      controlled: false,
      step: 1,
      disabled: false,
      read_only: false,
      invalid: false,
      name: nil,
      dir: "ltr",
      orientation: "horizontal",
      on_value_change: nil,
      on_value_change_client: nil,
      on_value_change_end: nil,
      on_value_change_end_client: nil,
      value_text_as: "degree"
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            form_field: boolean(),
            value: number(),
            controlled: boolean(),
            step: number(),
            disabled: boolean(),
            read_only: boolean(),
            invalid: boolean(),
            name: String.t() | nil,
            dir: String.t(),
            orientation: String.t(),
            on_value_change: String.t() | nil,
            on_value_change_client: String.t() | nil,
            on_value_change_end: String.t() | nil,
            on_value_change_end_client: String.t() | nil,
            value_text_as: String.t()
          }
  end

  defmodule Root do
    @moduledoc false
    defstruct [
      :id,
      :dir,
      :value,
      orientation: "horizontal",
      disabled: false,
      read_only: false,
      invalid: false
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            value: number(),
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
    defstruct [:id, :name, :value, :disabled, :dir, orientation: "horizontal"]

    @type t :: %__MODULE__{
            id: String.t(),
            name: String.t() | nil,
            value: number(),
            disabled: boolean(),
            dir: String.t(),
            orientation: String.t()
          }

    @ignored_attrs [
      "id",
      "name",
      "value",
      "disabled",
      "type",
      "dir"
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
      "role",
      "style"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Thumb do
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
            value: number(),
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

  defmodule Text do
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
            slider_value: number(),
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
