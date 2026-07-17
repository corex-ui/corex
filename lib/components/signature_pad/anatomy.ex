defmodule Corex.SignaturePad.Anatomy do
  @moduledoc false

  defmodule Props do
    @moduledoc false
    @enforce_keys [:id]

    defstruct [
      :id,
      form_field: false,
      field_used: false,
      paths: nil,
      drawing_fill: "black",
      drawing_size: 2,
      drawing_simulate_pressure: false,
      drawing_smoothing: nil,
      drawing_easing: nil,
      drawing_thinning: nil,
      drawing_streamline: nil,
      dir: "ltr",
      on_draw_end: nil,
      on_draw_end_client: nil,
      name: nil,
      submit_name: nil
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            form_field: boolean(),
            field_used: boolean(),
            paths: list() | String.t() | nil,
            drawing_fill: String.t(),
            drawing_size: integer(),
            drawing_simulate_pressure: boolean(),
            drawing_smoothing: integer() | float() | nil,
            drawing_easing: String.t() | nil,
            drawing_thinning: integer() | float() | nil,
            drawing_streamline: integer() | float() | nil,
            dir: String.t(),
            on_draw_end: String.t() | nil,
            on_draw_end_client: String.t() | nil,
            name: String.t() | nil,
            submit_name: String.t() | nil
          }
  end

  defmodule Root do
    @moduledoc false
    defstruct [:id, :dir]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t()
          }

    @ignored_attrs ["id", "dir", "data-state", "data-focus"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Label do
    @moduledoc false
    defstruct [:id, :dir]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t()
          }

    @ignored_attrs ["id", "dir", "data-disabled"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Control do
    @moduledoc false
    defstruct [:id, :dir]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t()
          }

    @ignored_attrs [
      "id",
      "dir",
      "data-state",
      "data-disabled",
      "tabindex",
      "role",
      "aria-roledescription",
      "aria-label",
      "aria-disabled",
      "style"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Segment do
    @moduledoc false
    defstruct [:id, :dir]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t()
          }

    @ignored_attrs ["id", "dir", "data-state", "viewBox", "width", "height", "style"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Path do
    @moduledoc false
    defstruct [:id, :index]

    @type t :: %__MODULE__{id: String.t(), index: non_neg_integer()}

    @ignored_attrs ["id", "d", "data-scope", "data-part", "style", "stroke", "fill", "opacity"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Guide do
    @moduledoc false
    defstruct [:id, :dir]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t()
          }

    @ignored_attrs ["id", "dir", "data-state", "style", "hidden"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule ClearTrigger do
    @moduledoc false
    defstruct [:id, :dir, aria_label: nil, has_paths: false]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            aria_label: String.t() | nil,
            has_paths: boolean()
          }

    @ignored_attrs ["id", "dir", "type", "hidden", "disabled", "aria-label", "data-state"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule HiddenInput do
    @moduledoc false
    defstruct [:id, :dir, :name, :form]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            name: String.t() | nil,
            form: String.t() | nil
          }

    @ignored_attrs [
      "id",
      "dir",
      "name",
      "form",
      "value",
      "data-value",
      "type",
      "readonly",
      "hidden",
      "autocomplete",
      "tabindex",
      "aria-hidden"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Error do
    @moduledoc false
    defstruct [:id, :index]

    @type t :: %__MODULE__{id: String.t(), index: non_neg_integer()}

    @ignored_attrs ["id", "data-scope", "data-part", "role", "aria-live"]
    def ignored_attrs, do: @ignored_attrs
  end
end
