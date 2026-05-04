defmodule Corex.Toast.Anatomy do
  @moduledoc false

  defmodule Group do
    @moduledoc false
    defstruct [:id, dir: "ltr", orientation: "horizontal"]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            orientation: String.t()
          }

    @ignored_attrs [
      "role",
      "dir",
      "data-orientation",
      "id",
      "data-state",
      "style",
      "data-focus",
      "tabindex",
      "aria-label",
      "aria-live",
      "aria-relevant",
      "data-placement"
    ]
    def ignored_attrs, do: @ignored_attrs
  end
end
