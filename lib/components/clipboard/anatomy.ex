defmodule Corex.Clipboard.Anatomy do
  @moduledoc false

  defmodule Props do
    @moduledoc false
    @enforce_keys [:id]

    defstruct [
      :id,
      :value,
      :timeout,
      :trigger_aria_label,
      :input_aria_label,
      dir: "ltr",
      orientation: "horizontal",
      on_copy: nil,
      on_copy_client: nil
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            value: String.t() | nil,
            timeout: integer() | nil,
            dir: String.t(),
            orientation: String.t(),
            on_copy: String.t() | nil,
            on_copy_client: String.t() | nil
          }
  end

  defmodule Root do
    @moduledoc false
    defstruct [:id, :dir, orientation: "horizontal"]

    @ignored_attrs ["data-orientation", "dir", "id"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Label do
    @moduledoc false
    defstruct [:id, :dir, orientation: "horizontal"]

    @ignored_attrs ["data-orientation", "dir", "id"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Control do
    @moduledoc false
    defstruct [:id, :dir, orientation: "horizontal"]

    @ignored_attrs ["data-orientation", "dir", "id"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Input do
    @moduledoc false
    defstruct [:id, :dir, :value, orientation: "horizontal"]

    @ignored_attrs ["value", "readonly", "data-orientation", "dir", "id"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Trigger do
    @moduledoc false
    defstruct [:id, :dir, orientation: "horizontal"]

    @ignored_attrs [
      "type",
      "data-orientation",
      "dir",
      "id",
      "data-copied",
      "data-disabled",
      "data-hover",
      "data-focus",
      "data-focus-visible"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Copy do
    @moduledoc false
    defstruct [:id, :dir, orientation: "horizontal"]

    @ignored_attrs [
      "data-orientation",
      "dir",
      "id",
      "data-active",
      "data-focus",
      "data-focus-visible",
      "data-hover",
      "data-disabled"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Copied do
    @moduledoc false
    defstruct [:id, :dir, orientation: "horizontal"]

    @ignored_attrs [
      "data-orientation",
      "dir",
      "id",
      "data-active",
      "data-focus",
      "data-focus-visible",
      "data-hover",
      "data-disabled"
    ]
    def ignored_attrs, do: @ignored_attrs
  end
end
