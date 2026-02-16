defmodule Corex.NumberInput.Anatomy do
  @moduledoc false

  defmodule Props do
    @moduledoc false
    @enforce_keys [:id]

    defstruct [
      :id,
      value: nil,
      default_value: nil,
      controlled: false,
      min: nil,
      max: nil,
      step: 1,
      disabled: false,
      read_only: false,
      invalid: false,
      required: false,
      allow_mouse_wheel: false,
      name: nil,
      form: nil,
      on_value_change: nil,
      on_value_change_client: nil
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            value: String.t() | nil,
            default_value: String.t() | nil,
            controlled: boolean(),
            min: number() | nil,
            max: number() | nil,
            step: number(),
            disabled: boolean(),
            read_only: boolean(),
            invalid: boolean(),
            required: boolean(),
            allow_mouse_wheel: boolean(),
            name: String.t() | nil,
            form: String.t() | nil,
            on_value_change: String.t() | nil,
            on_value_change_client: String.t() | nil
          }
  end

  defmodule Root do
    @moduledoc false
    defstruct [:id]

    @type t :: %__MODULE__{id: String.t()}
  end

  defmodule Label do
    @moduledoc false
    defstruct [:id]

    @type t :: %__MODULE__{id: String.t()}
  end

  defmodule Control do
    @moduledoc false
    defstruct [:id]

    @type t :: %__MODULE__{id: String.t()}
  end

  defmodule ValueText do
    @moduledoc false
    defstruct [:id]

    @type t :: %__MODULE__{id: String.t()}
  end

  defmodule Input do
    @moduledoc false
    defstruct [:id, :disabled]

    @type t :: %__MODULE__{id: String.t(), disabled: boolean()}
  end

  defmodule TriggerGroup do
    @moduledoc false
    defstruct []

    @type t :: %__MODULE__{}
  end

  defmodule DecrementTrigger do
    @moduledoc false
    defstruct [:id]

    @type t :: %__MODULE__{id: String.t()}
  end

  defmodule IncrementTrigger do
    @moduledoc false
    defstruct [:id]

    @type t :: %__MODULE__{id: String.t()}
  end

  defmodule Scrubber do
    @moduledoc false
    defstruct [:id]

    @type t :: %__MODULE__{id: String.t()}
  end
end
