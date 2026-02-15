defmodule Corex.RadioGroup.Anatomy do
  @moduledoc false

  defmodule Props do
    @moduledoc false
    @enforce_keys [:id]

    defstruct [
      :id,
      value: nil,
      controlled: false,
      name: nil,
      form: nil,
      disabled: false,
      invalid: false,
      required: false,
      read_only: false,
      dir: "ltr",
      orientation: "vertical",
      on_value_change: nil,
      on_value_change_client: nil
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            value: String.t() | nil,
            controlled: boolean(),
            name: String.t() | nil,
            form: String.t() | nil,
            disabled: boolean(),
            invalid: boolean(),
            required: boolean(),
            read_only: boolean(),
            dir: String.t(),
            orientation: String.t(),
            on_value_change: String.t() | nil,
            on_value_change_client: String.t() | nil
          }
  end

  defmodule Root do
    @moduledoc false
    defstruct [:id, :dir, :orientation]

    @type t :: %__MODULE__{id: String.t(), dir: String.t(), orientation: String.t()}
  end

  defmodule Label do
    @moduledoc false
    defstruct [:id, :dir]

    @type t :: %__MODULE__{id: String.t(), dir: String.t()}
  end

  defmodule Indicator do
    @moduledoc false
    defstruct [:id, :dir]

    @type t :: %__MODULE__{id: String.t(), dir: String.t()}
  end

  defmodule Item do
    @moduledoc false
    defstruct [:id, :value, :disabled, :invalid, :checked]

    @type t :: %__MODULE__{
            id: String.t(),
            value: String.t(),
            disabled: boolean(),
            invalid: boolean(),
            checked: boolean()
          }
  end

  defmodule ItemText do
    @moduledoc false
    defstruct [:id, :value, :disabled, :invalid]

    @type t :: %__MODULE__{id: String.t(), value: String.t(), disabled: boolean(), invalid: boolean()}
  end

  defmodule ItemControl do
    @moduledoc false
    defstruct [:id, :value, :disabled, :invalid]

    @type t :: %__MODULE__{id: String.t(), value: String.t(), disabled: boolean(), invalid: boolean()}
  end

  defmodule ItemHiddenInput do
    @moduledoc false
    defstruct [:id, :value, :disabled, :invalid, :name, :form, :checked]

    @type t :: %__MODULE__{
            id: String.t(),
            value: String.t(),
            disabled: boolean(),
            invalid: boolean(),
            name: String.t() | nil,
            form: String.t() | nil,
            checked: boolean()
          }
  end
end
