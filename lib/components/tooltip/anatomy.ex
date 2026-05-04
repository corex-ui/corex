defmodule Corex.Tooltip.Anatomy do
  @moduledoc false

  defmodule Props do
    @moduledoc false
    @enforce_keys [:id]

    defstruct [
      :id,
      open: false,
      controlled: false,
      disabled: false,
      dir: "ltr",
      orientation: "horizontal",
      open_delay: nil,
      close_delay: nil,
      placement: nil,
      close_on_escape: nil,
      close_on_click: nil,
      close_on_pointer_down: nil,
      close_on_scroll: nil,
      interactive: false,
      on_open_change: nil,
      on_open_change_client: nil
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            open: boolean(),
            controlled: boolean(),
            disabled: boolean(),
            dir: String.t(),
            orientation: String.t(),
            open_delay: non_neg_integer() | nil,
            close_delay: non_neg_integer() | nil,
            placement: String.t() | nil,
            close_on_escape: boolean() | nil,
            close_on_click: boolean() | nil,
            close_on_pointer_down: boolean() | nil,
            close_on_scroll: boolean() | nil,
            interactive: boolean(),
            on_open_change: String.t() | nil,
            on_open_change_client: String.t() | nil
          }
  end

  defmodule Trigger do
    @moduledoc false
    defstruct [:id, :dir, :open, :disabled, orientation: "horizontal", tag: :button]

    @ignored_attrs [
      "type",
      "tabindex",
      "data-disabled",
      "dir",
      "data-orientation",
      "data-state",
      "id",
      "data-placement",
      "aria-describedby",
      "aria-expanded",
      "data-focus"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Positioner do
    @moduledoc false
    defstruct [:id, :dir, orientation: "horizontal"]

    @ignored_attrs [
      "dir",
      "data-orientation",
      "id",
      "style",
      "data-state",
      "data-side",
      "data-placement"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Content do
    @moduledoc false
    defstruct [:id, :dir, :open, orientation: "horizontal"]

    @ignored_attrs [
      "dir",
      "data-orientation",
      "data-state",
      "id",
      "role",
      "data-placement",
      "data-side",
      "style",
      "hidden",
      "data-focus"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Arrow do
    @moduledoc false
    defstruct [:id, :dir, orientation: "horizontal"]

    @ignored_attrs ["dir", "data-orientation", "id", "style", "data-side", "data-placement"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule ArrowTip do
    @moduledoc false
    defstruct [:id, :dir, orientation: "horizontal"]

    @ignored_attrs ["dir", "data-orientation", "id", "style"]
    def ignored_attrs, do: @ignored_attrs
  end
end
