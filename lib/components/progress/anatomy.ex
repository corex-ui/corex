defmodule Corex.Progress.Anatomy do
  @moduledoc false

  defmodule Props do
    @moduledoc false
    @enforce_keys [:id]
    defstruct [
      :id,
      dir: "ltr",
      value: 40,
      min: 0,
      max: 100,
      variant: "linear",
      orientation: "horizontal",
      on_value_change: nil,
      on_value_change_client: nil
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            value: number() | nil,
            min: integer(),
            max: integer(),
            variant: String.t(),
            orientation: String.t(),
            on_value_change: String.t() | nil,
            on_value_change_client: String.t() | nil
          }
  end

  defmodule Root do
    @moduledoc false
    defstruct [:id, :dir, value: 40, min: 0, max: 100]
    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            value: number() | nil,
            min: integer(),
            max: integer()
          }
    @ignored_attrs ["dir", "id", "data-state", "style"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Track do
    @moduledoc false
    defstruct [:id, :dir]
    @type t :: %__MODULE__{id: String.t(), dir: String.t()}
    @ignored_attrs ["dir", "id", "data-state"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Range do
    @moduledoc false
    defstruct [:id, :dir, value: 40, min: 0, max: 100]
    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            value: number() | nil,
            min: integer(),
            max: integer()
          }
    @ignored_attrs ["dir", "id", "data-state", "style"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Circle do
    @moduledoc false
    defstruct [:id, :dir]
    @type t :: %__MODULE__{id: String.t(), dir: String.t()}
    @ignored_attrs ["dir", "id", "data-state", "style"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule CircleTrack do
    @moduledoc false
    defstruct [:id, :dir]
    @type t :: %__MODULE__{id: String.t(), dir: String.t()}
    @ignored_attrs ["dir", "id", "style"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule CircleRange do
    @moduledoc false
    defstruct [:id, :dir]
    @type t :: %__MODULE__{id: String.t(), dir: String.t()}
    @ignored_attrs ["dir", "id", "data-state", "style"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule ValueText do
    @moduledoc false
    defstruct [:id, :dir]
    @type t :: %__MODULE__{id: String.t(), dir: String.t()}
    @ignored_attrs ["dir", "id"]
    def ignored_attrs, do: @ignored_attrs
  end

  @spec percent(number() | nil, number(), number()) :: float() | nil
  def percent(nil, _min, _max), do: nil

  def percent(value, min, max) when max > min do
    (value - min) / (max - min) * 100
  end

  def percent(_value, _min, _max), do: 0.0
end
