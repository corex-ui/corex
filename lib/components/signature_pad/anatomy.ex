defmodule Corex.SignaturePad.Anatomy do
  @moduledoc false

  defmodule Props do
    @moduledoc false
    @enforce_keys [:id]

    defstruct [
      :id,
      drawing_fill: "black",
      drawing_size: 2,
      drawing_simulate_pressure: false,
      dir: "ltr",
      on_draw_end: nil,
      on_draw_end_client: nil
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            drawing_fill: String.t(),
            drawing_size: integer(),
            drawing_simulate_pressure: boolean(),
            dir: String.t(),
            on_draw_end: String.t() | nil,
            on_draw_end_client: String.t() | nil
          }
  end

  defmodule Root do
    @moduledoc false
    defstruct [:id, :dir, changed: false]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            changed: boolean()
          }
  end

  defmodule Label do
    @moduledoc false
    defstruct [:id, :dir, changed: false]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            changed: boolean()
          }
  end

  defmodule Control do
    @moduledoc false
    defstruct [:id, :dir, changed: false]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            changed: boolean()
          }
  end

  defmodule Segment do
    @moduledoc false
    defstruct [:id, :dir, changed: false]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            changed: boolean()
          }
  end

  defmodule Guide do
    @moduledoc false
    defstruct [:id, :dir, changed: false]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            changed: boolean()
          }
  end

  defmodule ClearTrigger do
    @moduledoc false
    defstruct [:id, :dir, changed: false, aria_label: nil]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            changed: boolean(),
            aria_label: String.t() | nil
          }
  end

  defmodule HiddenInput do
    @moduledoc false
    defstruct [:id, :dir, changed: false]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            changed: boolean()
          }
  end
end
