defmodule Corex.Toggle.Anatomy do
  @moduledoc false

  defmodule Props do
    @moduledoc false

    @enforce_keys [:id]

    defstruct [
      :id,
      pressed: false,
      controlled: false,
      disabled: false,
      dir: "ltr",
      on_pressed_change: nil,
      on_pressed_change_client: nil
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            pressed: boolean(),
            controlled: boolean(),
            disabled: boolean(),
            dir: String.t(),
            on_pressed_change: String.t() | nil,
            on_pressed_change_client: String.t() | nil
          }
  end

  defmodule Root do
    @moduledoc false

    defstruct [:id, :dir, pressed: false, disabled: false]

    @ignored_attrs [
      "data-state",
      "data-pressed",
      "dir",
      "id",
      "type",
      "disabled",
      "aria-pressed",
      "data-disabled",
      "data-active",
      "data-focus",
      "data-focus-visible",
      "data-hover"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Indicator do
    @moduledoc false

    defstruct [:id, :dir, pressed: false, disabled: false]

    @ignored_attrs [
      "data-state",
      "data-pressed",
      "dir",
      "id",
      "data-disabled",
      "data-active",
      "data-focus",
      "data-focus-visible",
      "data-hover"
    ]
    def ignored_attrs, do: @ignored_attrs
  end
end
