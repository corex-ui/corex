defmodule Corex.TreeView.Anatomy do
  @moduledoc false

  defmodule Props do
    @moduledoc false
    @enforce_keys [:id]

    defstruct [
      :id,
      :tree,
      value: [],
      expanded_value: [],
      controlled: false,
      selection_mode: "single",
      redirect: false,
      dir: "ltr",
      on_selection_change: nil,
      on_expanded_change: nil
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            tree: map() | nil,
            value: list(String.t()),
            expanded_value: list(String.t()),
            controlled: boolean(),
            selection_mode: String.t(),
            redirect: boolean(),
            dir: String.t(),
            on_selection_change: String.t() | nil,
            on_expanded_change: String.t() | nil
          }
  end

  defmodule Root do
    @moduledoc false
    defstruct [:id, dir: "ltr"]

    @type t :: %__MODULE__{id: String.t(), dir: String.t()}
  end

  defmodule Label do
    @moduledoc false
    defstruct [:id, dir: "ltr"]

    @type t :: %__MODULE__{id: String.t(), dir: String.t()}
  end

  defmodule Item do
    @moduledoc false
    defstruct [
      :id,
      :value,
      :index_path,
      :name,
      dir: "ltr",
      disabled: false,
      data: %{},
      redirect: nil,
      new_tab: false
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            value: String.t(),
            index_path: list(integer()),
            name: String.t() | nil,
            dir: String.t(),
            disabled: boolean(),
            data: map(),
            redirect: boolean() | nil,
            new_tab: boolean()
          }
  end

  defmodule Branch do
    @moduledoc false
    defstruct [
      :id,
      :value,
      :index_path,
      :name,
      dir: "ltr",
      disabled: false,
      data: %{},
      expanded: false
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            value: String.t(),
            index_path: list(integer()),
            name: String.t() | nil,
            dir: String.t(),
            disabled: boolean(),
            data: map(),
            expanded: boolean()
          }
  end
end
