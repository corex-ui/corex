defmodule Corex.Select.Anatomy do
  @moduledoc false
  alias Corex.Collection

  defmodule Props do
    @moduledoc false
    @enforce_keys [:id]

    defstruct [
      :id,
      collection: [],
      controlled: false,
      placeholder: nil,
      value: [],
      disabled: false,
      close_on_select: true,
      dir: "ltr",
      loop_focus: false,
      multiple: false,
      invalid: false,
      name: nil,
      form: nil,
      read_only: false,
      required: false,
      on_value_change: nil,
      on_value_change_client: nil,
      on_value_change_js: nil,
      redirect: false,
      redirect_new_tab: false,
      positioning: nil
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            collection: list(Collection.Item.t() | map()),
            controlled: boolean(),
            placeholder: String.t() | nil,
            value: list(String.t()),
            disabled: boolean(),
            close_on_select: boolean(),
            dir: String.t(),
            loop_focus: boolean(),
            multiple: boolean(),
            invalid: boolean(),
            name: String.t() | nil,
            form: String.t() | nil,
            read_only: boolean(),
            required: boolean(),
            on_value_change: String.t() | nil,
            on_value_change_client: String.t() | nil,
            on_value_change_js: String.t() | nil,
            redirect: boolean(),
            positioning: Corex.Positioning.t() | nil
          }
  end

  defmodule Root do
    @moduledoc false
    defstruct [:id, invalid: false, read_only: false]

    @type t :: %__MODULE__{
            id: String.t(),
            invalid: boolean(),
            read_only: boolean()
          }
  end

  defmodule Label do
    @moduledoc false
    defstruct [
      :id,
      invalid: false,
      read_only: false,
      required: false,
      disabled: false,
      dir: "ltr"
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            invalid: boolean(),
            read_only: boolean(),
            required: boolean(),
            disabled: boolean(),
            dir: String.t()
          }
  end

  defmodule Control do
    @moduledoc false
    defstruct [:id, :dir, :disabled, :invalid]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            disabled: boolean(),
            invalid: boolean()
          }
  end

  defmodule Positioner do
    @moduledoc false
    defstruct [:id, :dir]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t()
          }
  end

  defmodule Content do
    @moduledoc false
    defstruct [:id, :dir]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t()
          }
  end

  defmodule HiddenSelect do
    @moduledoc false
    defstruct [:id, :dir]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t()
          }
  end
end
