defmodule Corex.Menu.Anatomy do
  @moduledoc false

  defmodule Props do
    @moduledoc false
    @enforce_keys [:id]

    defstruct [
      :id,
      open: false,
      controlled: false,
      close_on_select: true,
      loop_focus: false,
      typeahead: true,
      composite: false,
      value: nil,
      dir: "ltr",
      aria_label: nil,
      on_select: nil,
      on_select_client: nil,
      redirect: false,
      on_open_change: nil,
      on_open_change_client: nil
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            open: boolean(),
            controlled: boolean(),
            close_on_select: boolean(),
            loop_focus: boolean(),
            typeahead: boolean(),
            composite: boolean(),
            value: String.t() | nil,
            dir: String.t(),
            aria_label: String.t() | nil,
            on_select: String.t() | nil,
            on_select_client: String.t() | nil,
            redirect: boolean(),
            on_open_change: String.t() | nil,
            on_open_change_client: String.t() | nil
          }
  end

  defmodule Root do
    @moduledoc false
    defstruct [:id, dir: "ltr", open: false]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            open: boolean()
          }
  end

  defmodule Trigger do
    @moduledoc false
    defstruct [
      :id,
      disabled: false,
      dir: "ltr"
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            disabled: boolean(),
            dir: String.t()
          }
  end

  defmodule Item do
    @moduledoc false
    defstruct [
      :id,
      :value,
      disabled: false,
      dir: "ltr",
      has_nested: false,
      nested_menu_id: nil,
      redirect: nil,
      new_tab: false
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            value: String.t() | nil,
            disabled: boolean(),
            dir: String.t(),
            has_nested: boolean(),
            nested_menu_id: String.t() | nil,
            redirect: boolean() | nil,
            new_tab: boolean()
          }
  end

  defmodule Group do
    @moduledoc false
    defstruct [
      :id,
      :group_id,
      dir: "ltr"
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            group_id: String.t(),
            dir: String.t()
          }
  end
end
