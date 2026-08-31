defmodule Corex.DateInput.Anatomy do
  @moduledoc false

  defmodule Props do
    @moduledoc false
    @enforce_keys [:id]
    defstruct [
      :id,
      dir: "ltr",
      name: nil,
      disabled: false,
      on_value_change: nil,
      on_value_change_client: nil
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            name: String.t() | nil,
            disabled: boolean(),
            on_value_change: String.t() | nil,
            on_value_change_client: String.t() | nil
          }
  end

  defmodule Root do
    @moduledoc false
    defstruct [:id, :dir]
    @type t :: %__MODULE__{id: String.t(), dir: String.t()}
    @ignored_attrs ["dir", "id", "data-state", "style"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Control do
    @moduledoc false
    defstruct [:id, :dir]
    @type t :: %__MODULE__{id: String.t(), dir: String.t()}
    @ignored_attrs ["dir", "id", "data-disabled", "data-invalid", "data-focus"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule SegmentGroup do
    @moduledoc false
    defstruct [:id, :dir]
    @type t :: %__MODULE__{id: String.t(), dir: String.t()}
    @ignored_attrs ["dir", "id", "data-disabled", "data-invalid", "data-focus"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule HiddenInput do
    @moduledoc false
    defstruct [:id, :dir]
    @type t :: %__MODULE__{id: String.t(), dir: String.t()}
    @ignored_attrs ["dir", "id", "name", "value", "aria-hidden"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Segment do
    @moduledoc false
    defstruct [:id, :dir, :type]
    @type t :: %__MODULE__{id: String.t(), dir: String.t(), type: String.t()}
    @ignored_attrs [
      "dir",
      "id",
      "data-type",
      "data-placeholder-shown",
      "data-focus",
      "aria-valuemin",
      "aria-valuemax",
      "aria-valuenow"
    ]
    def ignored_attrs, do: @ignored_attrs
  end
end
