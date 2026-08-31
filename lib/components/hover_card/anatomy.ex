defmodule Corex.HoverCard.Anatomy do
  @moduledoc false

  defmodule Props do
    @moduledoc false
    @enforce_keys [:id]

    defstruct [
      :id,
      positioning: %Corex.Positioning{},
      disabled: false,
      dir: "ltr",
      open_delay: nil,
      close_delay: nil,
      on_open_change: nil,
      on_open_change_client: nil,
      on_trigger_value_change: nil,
      on_trigger_value_change_client: nil
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            positioning: Corex.Positioning.t(),
            disabled: boolean(),
            dir: String.t(),
            open_delay: non_neg_integer() | nil,
            close_delay: non_neg_integer() | nil,
            on_open_change: String.t() | nil,
            on_open_change_client: String.t() | nil,
            on_trigger_value_change: String.t() | nil,
            on_trigger_value_change_client: String.t() | nil
          }
  end

  defmodule Trigger do
    @moduledoc false
    defstruct [:id, :dir, :open, :disabled, value: nil]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            open: boolean() | nil,
            disabled: boolean(),
            value: term()
          }

    @ignored_attrs [
      "dir",
      "data-disabled",
      "data-state",
      "id",
      "data-placement",
      "data-value",
      "data-current"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Positioner do
    @moduledoc false
    defstruct [:id, :dir]

    @type t :: %__MODULE__{id: String.t(), dir: String.t()}

    @ignored_attrs ["dir", "id", "style", "data-state", "data-side", "data-placement"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Content do
    @moduledoc false
    defstruct [:id, :dir, :open]

    @type t :: %__MODULE__{id: String.t(), dir: String.t(), open: boolean() | nil}

    @ignored_attrs ["dir", "data-state", "id", "data-placement", "data-side", "style", "hidden"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Arrow do
    @moduledoc false
    defstruct [:id, :dir]

    @type t :: %__MODULE__{id: String.t(), dir: String.t()}

    @ignored_attrs ["dir", "id", "style", "data-side", "data-placement"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule ArrowTip do
    @moduledoc false
    defstruct [:id, :dir]

    @type t :: %__MODULE__{id: String.t(), dir: String.t()}

    @ignored_attrs ["dir", "id", "style"]
    def ignored_attrs, do: @ignored_attrs
  end
end
