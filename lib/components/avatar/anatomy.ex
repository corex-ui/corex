defmodule Corex.Avatar.Anatomy do
  @moduledoc false

  defmodule Props do
    @moduledoc false
    @enforce_keys [:id]

    defstruct [
      :id,
      dir: nil,
      on_status_change: nil,
      on_status_change_client: nil
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t() | nil,
            on_status_change: String.t() | nil,
            on_status_change_client: String.t() | nil
          }
  end

  defmodule Root do
    @moduledoc false
    defstruct [:id, dir: nil]

    @type t :: %__MODULE__{id: String.t(), dir: String.t() | nil}

    def ignored_attrs do
      ["id", "dir", "data-state", "data-scope", "data-part", "data-focus", "style"]
    end
  end

  defmodule Image do
    @moduledoc false
    defstruct [:id, :src, dir: nil]

    @type t :: %__MODULE__{id: String.t(), src: String.t() | nil, dir: String.t() | nil}

    def ignored_attrs do
      ["id", "dir", "hidden", "data-state", "src", "alt", "style"]
    end
  end

  defmodule Fallback do
    @moduledoc false
    defstruct [:id, dir: nil]

    @type t :: %__MODULE__{id: String.t(), dir: String.t() | nil}

    def ignored_attrs do
      ["id", "dir", "hidden", "data-state", "style"]
    end
  end

  defmodule Skeleton do
    @moduledoc false
    defstruct [:id]

    @type t :: %__MODULE__{id: String.t()}

    def ignored_attrs do
      ["id", "hidden", "data-state", "style"]
    end
  end
end
