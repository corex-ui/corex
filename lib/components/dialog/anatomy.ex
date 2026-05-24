defmodule Corex.Dialog.Anatomy do
  @moduledoc false

  defmodule Props do
    @moduledoc false
    @enforce_keys [:id]

    defstruct [
      :id,
      open: false,
      controlled: false,
      modal: true,
      close_on_interact_outside: true,
      close_on_escape: true,
      prevent_scroll: false,
      restore_focus: true,
      role: "dialog",
      initial_focus: nil,
      final_focus: nil,
      dir: "ltr",
      on_open_change: nil,
      on_open_change_client: nil,
      animation: "js",
      animation_options: %Corex.Animation.Scale{scale_start: 0.96, scale_end: 1.0},
      label: nil
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            open: boolean(),
            controlled: boolean(),
            modal: boolean(),
            close_on_interact_outside: boolean(),
            close_on_escape: boolean(),
            prevent_scroll: boolean(),
            restore_focus: boolean(),
            role: String.t(),
            initial_focus: String.t() | nil,
            final_focus: String.t() | nil,
            dir: String.t(),
            on_open_change: String.t() | nil,
            on_open_change_client: String.t() | nil,
            animation: String.t(),
            animation_options: Corex.Animation.Scale.t(),
            label: String.t() | nil
          }
  end

  defmodule Trigger do
    @moduledoc false
    defstruct [:id, :dir, :open]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            open: boolean()
          }

    @ignored_attrs [
      "type",
      "tabindex",
      "aria-expanded",
      "aria-controls",
      "aria-haspopup",
      "data-state",
      "dir",
      "id",
      "data-focus",
      "aria-disabled",
      "disabled"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Backdrop do
    @moduledoc false
    defstruct [:id, :dir, :open]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            open: boolean()
          }

    @ignored_attrs [
      "hidden",
      "data-state",
      "dir",
      "id",
      "style",
      "data-focus",
      "aria-hidden"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Positioner do
    @moduledoc false
    defstruct [:id, :dir, :open]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            open: boolean()
          }

    @ignored_attrs [
      "hidden",
      "data-state",
      "dir",
      "id",
      "style",
      "data-focus",
      "data-side",
      "data-placement"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Content do
    @moduledoc false
    defstruct [:id, :dir, :open, role: "dialog"]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            open: boolean(),
            role: String.t()
          }

    @ignored_attrs [
      "hidden",
      "data-state",
      "dir",
      "id",
      "role",
      "aria-modal",
      "aria-labelledby",
      "aria-describedby",
      "tabindex",
      "style",
      "data-focus",
      "data-placement",
      "data-side"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Title do
    @moduledoc false
    defstruct [:id, :dir, :open]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            open: boolean()
          }

    @ignored_attrs [
      "id",
      "dir",
      "data-state",
      "data-focus",
      "tabindex",
      "aria-hidden"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Description do
    @moduledoc false
    defstruct [:id, :dir, :open]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            open: boolean()
          }

    @ignored_attrs ["id", "dir", "data-state", "data-focus", "aria-hidden"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule CloseTrigger do
    @moduledoc false
    defstruct [:id, :dir, :open, :aria_label]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            open: boolean(),
            aria_label: String.t() | nil
          }

    @ignored_attrs [
      "type",
      "tabindex",
      "dir",
      "id",
      "data-focus",
      "aria-label",
      "data-state"
    ]
    def ignored_attrs, do: @ignored_attrs
  end
end
