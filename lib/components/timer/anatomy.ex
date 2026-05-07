defmodule Corex.Timer.Anatomy do
  @moduledoc false

  defmodule Props do
    @moduledoc false
    @enforce_keys [:id]

    defstruct [
      :id,
      countdown: false,
      start_ms: 0,
      target_ms: nil,
      auto_start: true,
      interval: 1000,
      on_tick: nil,
      on_tick_client: nil,
      on_complete: nil,
      on_complete_client: nil,
      dir: nil,
      orientation: "horizontal",
      collapse_leading_zeros: nil,
      segments: nil,
      translation: nil
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            countdown: boolean(),
            start_ms: non_neg_integer(),
            target_ms: non_neg_integer() | nil,
            auto_start: boolean(),
            interval: non_neg_integer(),
            on_tick: String.t() | nil,
            on_tick_client: String.t() | nil,
            on_complete: String.t() | nil,
            on_complete_client: String.t() | nil,
            dir: String.t() | nil,
            orientation: String.t(),
            collapse_leading_zeros: boolean() | nil,
            segments: list(atom()) | nil,
            translation: Corex.Timer.Translation.t() | nil
          }
  end

  defmodule Root do
    @moduledoc false
    defstruct [:id, dir: nil, orientation: "horizontal"]

    @ignored_attrs ["data-orientation", "dir", "id", "data-scope", "data-part"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Area do
    @moduledoc false
    defstruct [:id, dir: nil, orientation: "horizontal"]

    @ignored_attrs [
      "data-orientation",
      "dir",
      "id",
      "role",
      "aria-label",
      "aria-atomic",
      "data-scope",
      "data-part"
    ]

    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Control do
    @moduledoc false
    defstruct [:id, dir: nil, orientation: "horizontal"]

    @ignored_attrs ["data-orientation", "dir", "id", "data-scope", "data-part"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Item do
    @moduledoc false
    defstruct [:id, :type, :value, dir: nil, orientation: "horizontal", hidden: false]

    @ignored_attrs [
      "id",
      "data-type",
      "style",
      "data-orientation",
      "dir",
      "data-scope",
      "data-part",
      "data-value",
      "data-state",
      "hidden",
      "aria-hidden"
    ]

    def ignored_attrs, do: @ignored_attrs
  end

  defmodule ItemLabel do
    @moduledoc false
    defstruct [:id, :type, dir: nil, orientation: "horizontal"]

    @ignored_attrs [
      "id",
      "data-type",
      "data-orientation",
      "dir",
      "data-part",
      "data-scope",
      "aria-labelledby",
      "aria-label"
    ]

    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Segment do
    @moduledoc false
    defstruct [:id, :type, hidden: false]

    @ignored_attrs ["hidden", "id", "data-type"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Separator do
    @moduledoc false
    defstruct [:id, dir: nil, orientation: "horizontal", hidden: false]

    @ignored_attrs [
      "id",
      "aria-hidden",
      "data-orientation",
      "dir",
      "hidden",
      "data-scope",
      "data-part"
    ]

    def ignored_attrs, do: @ignored_attrs
  end

  defmodule ActionTrigger do
    @moduledoc false
    defstruct [:action, :id, hidden: false, dir: nil, orientation: "horizontal"]

    @ignored_attrs [
      "hidden",
      "type",
      "aria-label",
      "data-action",
      "data-orientation",
      "dir",
      "id",
      "disabled",
      "data-disabled",
      "data-scope",
      "data-part",
      "tabindex",
      "tabIndex"
    ]

    def ignored_attrs, do: @ignored_attrs
  end
end
