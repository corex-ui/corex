defmodule Corex.Listbox.Anatomy do
  @moduledoc false

  defmodule Props do
    @moduledoc false
    @enforce_keys [:id]

    defstruct [
      :id,
      collection: [],
      value: [],
      controlled: false,
      disabled: false,
      dir: "ltr",
      orientation: "vertical",
      loop_focus: false,
      selection_mode: "single",
      select_on_highlight: false,
      deselectable: false,
      typeahead: false,
      on_value_change: nil,
      on_value_change_client: nil
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            collection: list(map()),
            value: list(String.t()),
            controlled: boolean(),
            disabled: boolean(),
            dir: String.t(),
            orientation: String.t(),
            loop_focus: boolean(),
            selection_mode: String.t(),
            select_on_highlight: boolean(),
            deselectable: boolean(),
            typeahead: boolean(),
            on_value_change: String.t() | nil,
            on_value_change_client: String.t() | nil
          }
  end

  defmodule Root do
    @moduledoc false
    defstruct [:id, :dir]

    @type t :: %__MODULE__{id: String.t(), dir: String.t()}
  end

  defmodule Label do
    @moduledoc false
    defstruct [:id, :dir]

    @type t :: %__MODULE__{id: String.t(), dir: String.t()}
  end

  defmodule ValueText do
    @moduledoc false
    defstruct [:id]

    @type t :: %__MODULE__{id: String.t()}
  end

  defmodule Input do
    @moduledoc false
    defstruct [:id]

    @type t :: %__MODULE__{id: String.t()}
  end

  defmodule Content do
    @moduledoc false
    defstruct [:id, :dir]

    @type t :: %__MODULE__{id: String.t(), dir: String.t()}
  end

  defmodule ItemGroup do
    @moduledoc false
    defstruct [:id, :group_id]

    @type t :: %__MODULE__{id: String.t(), group_id: String.t()}
  end

  defmodule ItemGroupLabel do
    @moduledoc false
    defstruct [:id, :html_for]

    @type t :: %__MODULE__{id: String.t(), html_for: String.t()}
  end

  defmodule Item do
    @moduledoc false
    defstruct [:id, :item, :value]

    @type t :: %__MODULE__{id: String.t(), item: map(), value: String.t()}
  end

  defmodule ItemText do
    @moduledoc false
    defstruct [:id, :item]

    @type t :: %__MODULE__{id: String.t(), item: map()}
  end

  defmodule ItemIndicator do
    @moduledoc false
    defstruct [:id, :item]

    @type t :: %__MODULE__{id: String.t(), item: map()}
  end
end
