defmodule Corex.PinInput.Anatomy do
  @moduledoc false

  defmodule Props do
    @moduledoc false
    @enforce_keys [:id]

    defstruct [
      :id,
      value: [],
      controlled: false,
      count: 4,
      disabled: false,
      invalid: false,
      required: false,
      read_only: false,
      mask: false,
      otp: false,
      blur_on_complete: false,
      select_on_focus: false,
      name: nil,
      form: nil,
      dir: "ltr",
      type: "numeric",
      placeholder: "○",
      on_value_change: nil,
      on_value_change_client: nil,
      on_value_complete: nil
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            value: list(String.t()),
            controlled: boolean(),
            count: non_neg_integer(),
            disabled: boolean(),
            invalid: boolean(),
            required: boolean(),
            read_only: boolean(),
            mask: boolean(),
            otp: boolean(),
            blur_on_complete: boolean(),
            select_on_focus: boolean(),
            name: String.t() | nil,
            form: String.t() | nil,
            dir: String.t(),
            type: String.t(),
            placeholder: String.t(),
            on_value_change: String.t() | nil,
            on_value_change_client: String.t() | nil,
            on_value_complete: String.t() | nil
          }
  end

  defmodule Root do
    @moduledoc false
    defstruct [:id, :dir]

    @type t :: %__MODULE__{id: String.t(), dir: String.t()}
  end

  defmodule Label do
    @moduledoc false
    defstruct [:id, :dir]

    @type t :: %__MODULE__{id: String.t(), dir: String.t()}
  end

  defmodule HiddenInput do
    @moduledoc false
    defstruct [:id, :name, :value]

    @type t :: %__MODULE__{id: String.t(), name: String.t() | nil, value: String.t()}
  end

  defmodule Control do
    @moduledoc false
    defstruct [:id, :dir]

    @type t :: %__MODULE__{id: String.t(), dir: String.t()}
  end

  defmodule Input do
    @moduledoc false
    defstruct [:id, :index]

    @type t :: %__MODULE__{id: String.t(), index: non_neg_integer()}
  end
end
