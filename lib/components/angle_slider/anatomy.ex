defmodule Corex.AngleSlider.Anatomy do
  @moduledoc false

  defmodule Props do
    @moduledoc false
    @enforce_keys [:id]

    defstruct [
      :id,
      value: 0,
      controlled: false,
      step: 1,
      disabled: false,
      read_only: false,
      invalid: false,
      name: nil,
      dir: "ltr",
      on_value_change: nil,
      on_value_change_client: nil,
      on_value_change_end: nil,
      on_value_change_end_client: nil
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            value: number(),
            controlled: boolean(),
            step: number(),
            disabled: boolean(),
            read_only: boolean(),
            invalid: boolean(),
            name: String.t() | nil,
            dir: String.t(),
            on_value_change: String.t() | nil,
            on_value_change_client: String.t() | nil,
            on_value_change_end: String.t() | nil,
            on_value_change_end_client: String.t() | nil
          }
  end

  defmodule Root do
    @moduledoc false
    defstruct [:id, :dir, :value]

    @type t :: %__MODULE__{id: String.t(), dir: String.t(), value: number()}
  end

  defmodule Label do
    @moduledoc false
    defstruct [:id, :dir]

    @type t :: %__MODULE__{id: String.t(), dir: String.t()}
  end

  defmodule HiddenInput do
    @moduledoc false
    defstruct [:id, :name, :value, :disabled]

    @type t :: %__MODULE__{
            id: String.t(),
            name: String.t() | nil,
            value: number(),
            disabled: boolean()
          }
  end

  defmodule Control do
    @moduledoc false
    defstruct [:id, :dir]

    @type t :: %__MODULE__{id: String.t(), dir: String.t()}
  end

  defmodule Thumb do
    @moduledoc false
    defstruct [:id, :dir]

    @type t :: %__MODULE__{id: String.t(), dir: String.t()}
  end

  defmodule ValueText do
    @moduledoc false
    defstruct [:id, :dir, :value]

    @type t :: %__MODULE__{id: String.t(), dir: String.t(), value: number()}
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
    defstruct [:id, :dir]

    @type t :: %__MODULE__{id: String.t(), dir: String.t()}
  end

  defmodule Marker do
    @moduledoc false
    defstruct [:id, :value, :slider_value]

    @type t :: %__MODULE__{id: String.t(), value: number(), slider_value: number()}
  end
end
