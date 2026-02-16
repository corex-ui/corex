defmodule Corex.PasswordInput.Anatomy do
  @moduledoc false

  defmodule Props do
    @moduledoc false
    @enforce_keys [:id]

    defstruct [
      :id,
      visible: false,
      controlled_visible: false,
      disabled: false,
      invalid: false,
      read_only: false,
      required: false,
      ignore_password_managers: false,
      name: nil,
      form: nil,
      dir: "ltr",
      auto_complete: "current-password",
      on_visibility_change: nil,
      on_visibility_change_client: nil
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            visible: boolean(),
            controlled_visible: boolean(),
            disabled: boolean(),
            invalid: boolean(),
            read_only: boolean(),
            required: boolean(),
            ignore_password_managers: boolean(),
            name: String.t() | nil,
            form: String.t() | nil,
            dir: String.t(),
            auto_complete: String.t(),
            on_visibility_change: String.t() | nil,
            on_visibility_change_client: String.t() | nil
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

  defmodule Control do
    @moduledoc false
    defstruct [:id, :dir]

    @type t :: %__MODULE__{id: String.t(), dir: String.t()}
  end

  defmodule Input do
    @moduledoc false
    defstruct [:id, :disabled]

    @type t :: %__MODULE__{id: String.t(), disabled: boolean()}
  end

  defmodule VisibilityTrigger do
    @moduledoc false
    defstruct [:id, :dir]

    @type t :: %__MODULE__{id: String.t(), dir: String.t()}
  end

  defmodule Indicator do
    @moduledoc false
    defstruct [:id, :dir]

    @type t :: %__MODULE__{id: String.t(), dir: String.t()}
  end
end
