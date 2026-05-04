defmodule Corex.Accordion.Anatomy do
  @moduledoc false

  defmodule Props do
    @moduledoc false
    @enforce_keys [:id]

    defstruct [
      :id,
      value: [],
      controlled: false,
      collapsible: true,
      multiple: true,
      orientation: "vertical",
      dir: "ltr",
      on_value_change: nil,
      on_value_change_client: nil,
      on_focus_change: nil,
      on_focus_change_client: nil,
      animation: "js",
      animation_options: %Corex.Animation.Height{}
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            value: list(String.t()),
            controlled: boolean(),
            collapsible: boolean(),
            multiple: boolean(),
            orientation: String.t(),
            dir: String.t(),
            on_value_change: String.t(),
            on_value_change_client: String.t(),
            on_focus_change: String.t(),
            on_focus_change_client: String.t(),
            animation: String.t(),
            animation_options: Corex.Animation.Height.t()
          }
  end

  defmodule Root do
    @moduledoc false
    defstruct [:id, orientation: "vertical", dir: "ltr"]

    @type t :: %__MODULE__{
            id: String.t(),
            orientation: String.t(),
            dir: String.t()
          }

    @ignored_attrs ["data-orientation", "dir", "id"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Item do
    @moduledoc false
    defstruct [
      :id,
      orientation: "vertical",
      dir: "ltr",
      values: [],
      value: nil,
      disabled: false,
      animation: "instant",
      data: %{}
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            data: map(),
            orientation: String.t(),
            dir: String.t(),
            value: String.t() | nil,
            disabled: boolean(),
            values: list(String.t()),
            animation: String.t()
          }

    @ignored_attrs ["data-state", "data-focus", "data-orientation", "dir"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule ItemTrigger do
    @moduledoc false

    @ignored_attrs [
      "aria-expanded",
      "disabled",
      "aria-disabled",
      "data-state",
      "data-focus",
      "data-orientation",
      "dir"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule ItemContent do
    @moduledoc false

    @ignored_attrs [
      "hidden",
      "style",
      "data-state",
      "data-disabled",
      "data-focus",
      "data-orientation",
      "dir",
      "aria-label",
      "aria-labelledby"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule ItemIndicator do
    @moduledoc false

    @ignored_attrs [
      "aria-hidden",
      "data-state",
      "data-disabled",
      "data-focus",
      "data-orientation",
      "dir"
    ]
    def ignored_attrs, do: @ignored_attrs
  end
end
