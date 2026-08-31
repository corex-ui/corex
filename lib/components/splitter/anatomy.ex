defmodule Corex.Splitter.Anatomy do
  @moduledoc false

  defmodule Props do
    @moduledoc false
    @enforce_keys [:id]
    defstruct [
      :id,
      dir: "ltr",
      orientation: "horizontal",
      on_resize: nil,
      on_resize_client: nil
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            orientation: String.t(),
            on_resize: String.t() | nil,
            on_resize_client: String.t() | nil
          }
  end

  defmodule Root do
    @moduledoc false
    defstruct [:id, :dir, orientation: "horizontal"]
    @type t :: %__MODULE__{id: String.t(), dir: String.t(), orientation: String.t()}
    @ignored_attrs ["dir", "id", "data-state", "style", "data-orientation"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Panel do
    @moduledoc false
    defstruct [:id, :dir, :panel_id]
    @type t :: %__MODULE__{id: String.t(), dir: String.t(), panel_id: String.t()}
    @ignored_attrs ["dir", "id", "style", "data-orientation", "data-dragging"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule ResizeTrigger do
    @moduledoc false
    defstruct [:id, :dir, :trigger_id]
    @type t :: %__MODULE__{id: String.t(), dir: String.t(), trigger_id: String.t()}
    @ignored_attrs ["dir", "id", "style", "data-orientation", "data-focus", "data-dragging"]
    def ignored_attrs, do: @ignored_attrs
  end
end
