defmodule Corex.Popover.Anatomy do
  @moduledoc false

  defmodule Props do
    @moduledoc false
    @enforce_keys [:id]

    defstruct [
      :id,
      positioning: %Corex.Positioning{},
      dir: "ltr",
      modal: false,
      portalled: true,
      auto_focus: true,
      restore_focus: true,
      close_on_interact_outside: true,
      close_on_escape: true,
      on_open_change: nil,
      on_open_change_client: nil,
      on_trigger_value_change: nil,
      on_trigger_value_change_client: nil
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            positioning: Corex.Positioning.t(),
            dir: String.t(),
            modal: boolean(),
            portalled: boolean(),
            auto_focus: boolean(),
            restore_focus: boolean(),
            close_on_interact_outside: boolean(),
            close_on_escape: boolean(),
            on_open_change: String.t() | nil,
            on_open_change_client: String.t() | nil,
            on_trigger_value_change: String.t() | nil,
            on_trigger_value_change_client: String.t() | nil
          }
  end

  defmodule Trigger do
    @moduledoc false
    defstruct [:id, :dir, :open, value: nil]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            open: boolean() | nil,
            value: term()
          }

    @ignored_attrs [
      "type",
      "dir",
      "data-state",
      "id",
      "data-placement",
      "aria-expanded",
      "aria-controls",
      "aria-haspopup",
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

    @ignored_attrs [
      "dir",
      "data-state",
      "id",
      "role",
      "data-placement",
      "data-side",
      "style",
      "hidden",
      "tabindex"
    ]
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

    @ignored_attrs ["type", "dir", "id", "aria-label"]
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
