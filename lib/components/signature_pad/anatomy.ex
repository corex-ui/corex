defmodule Corex.SignaturePad.Anatomy do
  @moduledoc false

  defmodule Props do
    @moduledoc false
    @enforce_keys [:id]

    defstruct [
      :id,
      controlled: false,
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
      name: nil
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            controlled: boolean(),
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
            name: String.t() | nil
          }
  end

  defmodule Root do
    @moduledoc false
    defstruct [:id, :dir]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t()
          }
  end

  defmodule Label do
    @moduledoc false
    defstruct [:id, :dir]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t()
          }
  end

  defmodule Control do
    @moduledoc false
    defstruct [:id, :dir]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t()
          }
  end

  defmodule Segment do
    @moduledoc false
    defstruct [:id, :dir]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t()
          }
  end

  defmodule Guide do
    @moduledoc false
    defstruct [:id, :dir]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t()
          }
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
  end

  defmodule HiddenInput do
    @moduledoc false
    defstruct [:id, :dir, :name]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            name: String.t() | nil
          }
  end
end
