defmodule Corex.NavigationMenu.Anatomy do
  @moduledoc false

  defmodule Props do
    @moduledoc false
    @enforce_keys [:id]
    defstruct [:id, dir: "ltr", on_value_change: nil, on_value_change_client: nil]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
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

  defmodule List do
    @moduledoc false
    defstruct [:id, :dir]
    @type t :: %__MODULE__{id: String.t(), dir: String.t()}
    @ignored_attrs ["dir", "id", "data-orientation"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Content do
    @moduledoc false
    defstruct [:id, :dir, :value]
    @type t :: %__MODULE__{id: String.t(), dir: String.t(), value: String.t()}
    @ignored_attrs ["dir", "id", "hidden", "data-state", "style"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Trigger do
    @moduledoc false
    defstruct [:id, :dir, :value]
    @type t :: %__MODULE__{id: String.t(), dir: String.t(), value: String.t()}
    @ignored_attrs ["dir", "id", "data-state", "aria-expanded", "data-value"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Link do
    @moduledoc false
    defstruct [:id, :dir, :value]
    @type t :: %__MODULE__{id: String.t(), dir: String.t(), value: String.t()}
    @ignored_attrs ["dir", "id", "data-state", "data-value", "data-current"]
    def ignored_attrs, do: @ignored_attrs
  end
end
