defmodule Corex.Carousel.Anatomy do
  @moduledoc false

  defmodule Props do
    @moduledoc false
    @enforce_keys [:id]

    defstruct [
      :id,
      slide_count: 0,
      page: 0,
      controlled: false,
      dir: "ltr",
      orientation: "horizontal",
      slides_per_page: 1,
      loop: false,
      autoplay: false,
      allow_mouse_drag: false,
      spacing: "0px",
      on_page_change: nil,
      on_page_change_client: nil
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            slide_count: non_neg_integer(),
            page: non_neg_integer(),
            controlled: boolean(),
            dir: String.t(),
            orientation: String.t(),
            slides_per_page: non_neg_integer(),
            loop: boolean(),
            autoplay: boolean(),
            allow_mouse_drag: boolean(),
            spacing: String.t(),
            on_page_change: String.t() | nil,
            on_page_change_client: String.t() | nil
          }
  end

  defmodule Root do
    @moduledoc false
    defstruct [:id, :dir, :orientation, :slides_per_page, :spacing]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            orientation: String.t(),
            slides_per_page: non_neg_integer(),
            spacing: String.t()
          }
  end

  defmodule Control do
    @moduledoc false
    defstruct [:id, :orientation]

    @type t :: %__MODULE__{id: String.t(), orientation: String.t()}
  end

  defmodule ItemGroup do
    @moduledoc false
    defstruct [:id, :orientation, :dir]

    @type t :: %__MODULE__{id: String.t(), orientation: String.t(), dir: String.t()}
  end

  defmodule Item do
    @moduledoc false
    defstruct [:id, :index, :orientation, :slide_count]

    @type t :: %__MODULE__{
            id: String.t(),
            index: non_neg_integer(),
            orientation: String.t(),
            slide_count: non_neg_integer()
          }
  end

  defmodule PrevTrigger do
    @moduledoc false
    defstruct [:id, :disabled]

    @type t :: %__MODULE__{id: String.t(), disabled: boolean()}
  end

  defmodule NextTrigger do
    @moduledoc false
    defstruct [:id, :disabled]

    @type t :: %__MODULE__{id: String.t(), disabled: boolean()}
  end

  defmodule IndicatorGroup do
    @moduledoc false
    defstruct [:id, :orientation, :dir]

    @type t :: %__MODULE__{id: String.t(), orientation: String.t(), dir: String.t()}
  end

  defmodule Indicator do
    @moduledoc false
    defstruct [:id, :index, :orientation, :dir, :page]

    @type t :: %__MODULE__{
            id: String.t(),
            index: non_neg_integer(),
            orientation: String.t(),
            dir: String.t(),
            page: non_neg_integer()
          }
  end
end
