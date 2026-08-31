defmodule Corex.CascadeSelect.Anatomy do
  @moduledoc false

  @closed_style "position:fixed;isolation:isolate;width:var(--reference-width);pointer-events:none;top:0px;left:0px;transform:translate3d(0, -100vh, 0);z-index:var(--z-index);"

  def closed_positioner_style, do: @closed_style

  defmodule Props do
    @moduledoc false
    @enforce_keys [:id]

    defstruct [
      :id,
      dir: "ltr",
      tree: nil,
      tree_json: nil,
      disabled: false,
      name: nil,
      placeholder: nil,
      positioning: %Corex.Positioning{placement: "bottom-start"},
      on_value_change: nil,
      on_value_change_client: nil
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            tree: map() | nil,
            tree_json: String.t() | nil,
            disabled: boolean(),
            name: String.t() | nil,
            placeholder: String.t() | nil,
            positioning: Corex.Positioning.t(),
            on_value_change: String.t() | nil,
            on_value_change_client: String.t() | nil
          }
  end

  defmodule Root do
    @moduledoc false
    defstruct [:id, :dir, disabled: false]
    @type t :: %__MODULE__{id: String.t(), dir: String.t(), disabled: boolean()}
    @ignored_attrs ["dir", "id", "data-state", "data-disabled", "data-invalid"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Label do
    @moduledoc false
    defstruct [:id, :dir, disabled: false]
    @type t :: %__MODULE__{id: String.t(), dir: String.t(), disabled: boolean()}
    @ignored_attrs ["dir", "id", "data-disabled"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Control do
    @moduledoc false
    defstruct [:id, :dir, disabled: false]
    @type t :: %__MODULE__{id: String.t(), dir: String.t(), disabled: boolean()}
    @ignored_attrs ["dir", "id", "data-disabled"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Trigger do
    @moduledoc false
    defstruct [:id, :dir, disabled: false]
    @type t :: %__MODULE__{id: String.t(), dir: String.t(), disabled: boolean()}
    @ignored_attrs ["dir", "id", "type", "data-state", "data-disabled", "aria-expanded"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Indicator do
    @moduledoc false
    defstruct [:id, :dir]
    @type t :: %__MODULE__{id: String.t(), dir: String.t()}
    @ignored_attrs ["dir", "id", "data-state"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule ClearTrigger do
    @moduledoc false
    defstruct [:id, :dir]
    @type t :: %__MODULE__{id: String.t(), dir: String.t()}
    @ignored_attrs ["dir", "id", "type", "hidden"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule ValueText do
    @moduledoc false
    defstruct [:id, :dir]
    @type t :: %__MODULE__{id: String.t(), dir: String.t()}
    @ignored_attrs ["dir", "id"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Positioner do
    @moduledoc false
    defstruct [:id, :dir]
    @type t :: %__MODULE__{id: String.t(), dir: String.t()}
    @ignored_attrs ["dir", "id", "style", "data-state", "hidden"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Content do
    @moduledoc false
    defstruct [:id, :dir]
    @type t :: %__MODULE__{id: String.t(), dir: String.t()}
    @ignored_attrs ["dir", "id", "hidden", "style", "data-state", "tabindex"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule HiddenInput do
    @moduledoc false
    defstruct [:id, :dir]
    @type t :: %__MODULE__{id: String.t(), dir: String.t()}
    @ignored_attrs ["dir", "id", "name", "value", "aria-hidden"]
    def ignored_attrs, do: @ignored_attrs
  end
end
