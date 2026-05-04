defmodule Corex.Collapsible.Anatomy do
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
      orientation: "vertical",
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
            on_open_change: String.t() | nil,
            on_open_change_client: String.t() | nil
          }
  end

  defmodule Root do
    @moduledoc false
    defstruct [:id, :dir, :open, orientation: "vertical"]

    @ignored_attrs ["data-state", "dir", "id"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Trigger do
    @moduledoc false
    defstruct [:id, :dir, :open, :disabled, orientation: "vertical"]

    @ignored_attrs [
      "type",
      "tabindex",
      "aria-expanded",
      "aria-disabled",
      "data-disabled",
      "disabled",
      "dir",
      "data-state",
      "id",
      "data-controls",
      "aria-controls"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Content do
    @moduledoc false
    defstruct [:id, :dir, :open, :disabled, orientation: "vertical"]

    @ignored_attrs [
      "hidden",
      "data-state",
      "data-disabled",
      "dir",
      "id",
      "aria-labelledby",
      "style",
      "data-collapsible",
      "data-has-collapsed-size"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Closed do
    @moduledoc false
    defstruct [:id, :dir, :disabled, orientation: "vertical"]

    @ignored_attrs ["aria-hidden", "dir", "id", "data-disabled"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Opened do
    @moduledoc false
    defstruct [:id, :dir, :disabled, orientation: "vertical"]

    @ignored_attrs ["aria-hidden", "dir", "id", "data-disabled"]
    def ignored_attrs, do: @ignored_attrs
  end
end
