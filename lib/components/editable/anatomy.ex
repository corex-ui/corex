defmodule Corex.Editable.Anatomy do
  @moduledoc false

  defmodule Props do
    @moduledoc false
    @enforce_keys [:id]

    defstruct [
      :id,
      value: "",
      controlled: false,
      disabled: false,
      read_only: false,
      required: false,
      invalid: false,
      name: nil,
      form: nil,
      dir: "ltr",
      edit: false,
      controlled_edit: false,
      default_edit: false,
      placeholder: nil,
      activation_mode: nil,
      select_on_focus: true,
      on_value_change: nil,
      on_value_change_client: nil
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            value: String.t(),
            controlled: boolean(),
            disabled: boolean(),
            read_only: boolean(),
            required: boolean(),
            invalid: boolean(),
            name: String.t() | nil,
            form: String.t() | nil,
            dir: String.t(),
            edit: boolean(),
            controlled_edit: boolean(),
            default_edit: boolean(),
            placeholder: String.t() | nil,
            activation_mode: String.t() | nil,
            select_on_focus: boolean(),
            on_value_change: String.t() | nil,
            on_value_change_client: String.t() | nil
          }
  end

  defmodule Root do
    @moduledoc false
    defstruct [:id, :dir]

    @type t :: %__MODULE__{id: String.t(), dir: String.t()}
  end

  defmodule Area do
    @moduledoc false
    defstruct [:id, :dir, empty: false, editing: false, auto_resize: true]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            empty: boolean(),
            editing: boolean(),
            auto_resize: boolean()
          }
  end

  defmodule Label do
    @moduledoc false
    defstruct [:id, :dir]

    @type t :: %__MODULE__{id: String.t(), dir: String.t()}
  end

  defmodule Input do
    @moduledoc false
    defstruct [
      :id,
      :disabled,
      :value,
      :placeholder,
      :name,
      :form,
      :aria_label,
      required: false,
      read_only: false,
      editing: false
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            disabled: boolean(),
            value: String.t() | nil,
            placeholder: String.t() | nil,
            name: String.t() | nil,
            form: String.t() | nil,
            aria_label: String.t() | nil,
            required: boolean(),
            read_only: boolean(),
            editing: boolean()
          }
  end

  defmodule Preview do
    @moduledoc false
    defstruct [:id, :dir, :value_text, empty: false, editing: false]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            value_text: String.t() | nil,
            empty: boolean(),
            editing: boolean()
          }
  end

  defmodule EditTrigger do
    @moduledoc false
    defstruct [:id, :dir, editing: false]

    @type t :: %__MODULE__{id: String.t(), dir: String.t(), editing: boolean()}
  end

  defmodule Control do
    @moduledoc false
    defstruct [:id, :dir]

    @type t :: %__MODULE__{id: String.t(), dir: String.t()}
  end

  defmodule Triggers do
    @moduledoc false
    defstruct []

    @type t :: %__MODULE__{}
  end

  defmodule SubmitTrigger do
    @moduledoc false
    defstruct [:id, :dir, editing: false]

    @type t :: %__MODULE__{id: String.t(), dir: String.t(), editing: boolean()}
  end

  defmodule CancelTrigger do
    @moduledoc false
    defstruct [:id, :dir, editing: false]

    @type t :: %__MODULE__{id: String.t(), dir: String.t(), editing: boolean()}
  end
end
