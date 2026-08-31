defmodule Corex.Tour.Anatomy do
  @moduledoc false

  defmodule Props do
    @moduledoc false
    @enforce_keys [:id]

    defstruct [
      :id,
      dir: "ltr",
      steps: nil,
      steps_json: nil,
      on_step_change: nil,
      on_step_change_client: nil
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            steps: list() | nil,
            steps_json: String.t() | nil,
            on_step_change: String.t() | nil,
            on_step_change_client: String.t() | nil
          }
  end

  defmodule Root do
    @moduledoc false
    defstruct [:id, :dir]
    @type t :: %__MODULE__{id: String.t(), dir: String.t()}
    @ignored_attrs ["dir", "id", "data-state", "style"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Spotlight do
    @moduledoc false
    defstruct [:id, :dir]
    @type t :: %__MODULE__{id: String.t(), dir: String.t()}
    @ignored_attrs ["dir", "id", "data-state", "hidden", "aria-hidden", "style"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Backdrop do
    @moduledoc false
    defstruct [:id, :dir]
    @type t :: %__MODULE__{id: String.t(), dir: String.t()}
    @ignored_attrs ["dir", "id", "data-state", "hidden", "aria-hidden", "style"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Positioner do
    @moduledoc false
    defstruct [:id, :dir]
    @type t :: %__MODULE__{id: String.t(), dir: String.t()}
    @ignored_attrs ["dir", "id", "data-state", "style", "hidden"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Content do
    @moduledoc false
    defstruct [:id, :dir]
    @type t :: %__MODULE__{id: String.t(), dir: String.t()}
    @ignored_attrs ["dir", "id", "data-state", "hidden", "aria-hidden", "style", "role"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Title do
    @moduledoc false
    defstruct [:id, :dir]
    @type t :: %__MODULE__{id: String.t(), dir: String.t()}
    @ignored_attrs ["dir", "id"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Description do
    @moduledoc false
    defstruct [:id, :dir]
    @type t :: %__MODULE__{id: String.t(), dir: String.t()}
    @ignored_attrs ["dir", "id"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule CloseTrigger do
    @moduledoc false
    defstruct [:id, :dir]
    @type t :: %__MODULE__{id: String.t(), dir: String.t()}
    @ignored_attrs ["dir", "id", "type"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule ProgressText do
    @moduledoc false
    defstruct [:id, :dir]
    @type t :: %__MODULE__{id: String.t(), dir: String.t()}
    @ignored_attrs ["dir", "id"]
    def ignored_attrs, do: @ignored_attrs
  end
end
