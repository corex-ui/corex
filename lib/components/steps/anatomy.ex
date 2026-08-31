defmodule Corex.Steps.Anatomy do
  @moduledoc false

  defmodule Props do
    @moduledoc false
    @enforce_keys [:id]
    defstruct [
      :id,
      dir: "ltr",
      count: 3,
      step: 0,
      linear: false,
      orientation: "horizontal",
      on_step_change: nil,
      on_step_change_client: nil
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            count: integer(),
            step: integer(),
            linear: boolean(),
            orientation: String.t(),
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

  defmodule List do
    @moduledoc false
    defstruct [:id, :dir]
    @type t :: %__MODULE__{id: String.t(), dir: String.t()}
    @ignored_attrs ["dir", "id", "data-orientation", "role"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Trigger do
    @moduledoc false
    defstruct [:id, :dir, :index]
    @type t :: %__MODULE__{id: String.t(), dir: String.t(), index: integer()}
    @ignored_attrs ["dir", "id", "data-state", "data-complete", "data-current", "aria-current"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Content do
    @moduledoc false
    defstruct [:id, :dir, :index]
    @type t :: %__MODULE__{id: String.t(), dir: String.t(), index: integer()}
    @ignored_attrs ["dir", "id", "hidden", "data-state"]
    def ignored_attrs, do: @ignored_attrs
  end
end
