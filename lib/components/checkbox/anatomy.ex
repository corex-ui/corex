defmodule Corex.Checkbox.Anatomy do
  @moduledoc false

  defmodule Props do
    @moduledoc false
    @enforce_keys [:id]

    defstruct [
      :id,
      :name,
      :form,
      :label,
      checked: false,
      controlled: false,
      disabled: false,
      value: "true",
      dir: "ltr",
      orientation: "horizontal",
      read_only: false,
      invalid: false,
      required: false,
      on_checked_change: nil,
      on_checked_change_client: nil
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            checked: boolean() | :indeterminate,
            controlled: boolean(),
            name: String.t(),
            form: String.t(),
            label: String.t(),
            disabled: boolean(),
            value: String.t(),
            dir: String.t(),
            orientation: String.t(),
            read_only: boolean(),
            invalid: boolean(),
            required: boolean(),
            on_checked_change: String.t(),
            on_checked_change_client: String.t()
          }
  end

  defmodule Root do
    @moduledoc false
    defstruct [:id, :dir, :checked, orientation: "horizontal"]

    @ignored_attrs [
      "data-state",
      "dir",
      "id",
      "htmlFor",
      "for",
      "data-active",
      "data-focus",
      "data-focus-visible",
      "data-hover",
      "data-disabled",
      "data-readonly",
      "data-invalid",
      "data-required"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule HiddenInput do
    @moduledoc false
    defstruct [
      :id,
      :name,
      :checked,
      :disabled,
      :required,
      :invalid,
      :value,
      controlled: false
    ]

    @ignored_attrs [
      "checked",
      "disabled",
      "aria-invalid",
      "data-focus",
      "data-focus-visible",
      "data-active",
      "data-hover",
      "data-disabled",
      "data-readonly",
      "data-invalid",
      "data-required",
      "data-state",
      "aria-checked"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Control do
    @moduledoc false
    defstruct [:id, :dir, :checked, orientation: "horizontal"]

    @ignored_attrs [
      "data-state",
      "dir",
      "id",
      "data-active",
      "data-focus",
      "data-focus-visible",
      "data-hover",
      "data-disabled",
      "data-readonly",
      "data-invalid",
      "data-required"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Label do
    @moduledoc false
    defstruct [:id, :dir, :checked, orientation: "horizontal"]

    @ignored_attrs [
      "data-state",
      "dir",
      "id",
      "data-active",
      "data-focus",
      "data-focus-visible",
      "data-hover",
      "data-disabled",
      "data-readonly",
      "data-invalid",
      "data-required"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Indicator do
    @moduledoc false
    defstruct [:id, :dir, :checked, orientation: "horizontal"]

    @ignored_attrs [
      "hidden",
      "data-state",
      "dir",
      "id",
      "data-active",
      "data-focus",
      "data-focus-visible",
      "data-hover",
      "data-disabled",
      "data-readonly",
      "data-invalid",
      "data-required"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Indeterminate do
    @moduledoc false
    defstruct [:id, :dir, :checked, orientation: "horizontal"]

    @ignored_attrs [
      "hidden",
      "data-state",
      "dir",
      "id",
      "data-active",
      "data-focus",
      "data-focus-visible",
      "data-hover",
      "data-disabled",
      "data-readonly",
      "data-invalid",
      "data-required"
    ]
    def ignored_attrs, do: @ignored_attrs
  end
end
