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
      read_only: false,
      invalid: false,
      required: false,
      indeterminate: false,
      on_checked_change: nil,
      on_checked_change_client: nil
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            checked: boolean(),
            controlled: boolean(),
            name: String.t(),
            form: String.t(),
            label: String.t(),
            disabled: boolean(),
            value: String.t(),
            dir: String.t(),
            read_only: boolean(),
            invalid: boolean(),
            required: boolean(),
            on_checked_change: String.t(),
            on_checked_change_client: String.t()
          }
  end

  defmodule Root do
    @moduledoc false
    defstruct [:id, :dir, :checked]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            checked: boolean()
          }
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

    @type t :: %__MODULE__{
            id: String.t(),
            name: String.t(),
            checked: boolean(),
            disabled: boolean(),
            required: boolean(),
            invalid: boolean(),
            value: String.t(),
            controlled: boolean()
          }
  end

  defmodule Control do
    @moduledoc false
    defstruct [:id, :dir, :checked]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            checked: boolean()
          }
  end

  defmodule Label do
    @moduledoc false
    defstruct [:id, :dir, :checked]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            checked: boolean()
          }
  end

  defmodule Indicator do
    @moduledoc false
    defstruct [:id, :dir, :checked]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            checked: boolean()
          }
  end
end
