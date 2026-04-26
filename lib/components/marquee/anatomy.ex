defmodule Corex.Marquee.Anatomy do
  @moduledoc false

  defmodule Props do
    @moduledoc false
    @enforce_keys [:id, :duration]

    defstruct [
      :id,
      :aria_label,
      :duration,
      :on_pause_change,
      :on_pause_change_client,
      :on_loop_complete,
      :on_loop_complete_client,
      :on_complete,
      :on_complete_client,
      items_count: 0,
      content_count: 2,
      side: "end",
      speed: 50,
      spacing: "1rem",
      auto_fill: true,
      pause_on_interaction: false,
      default_paused: false,
      delay: 0,
      loop_count: 0,
      respect_reduced_motion: true,
      reverse: false,
      dir: "ltr",
      orientation: "horizontal"
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            duration: number(),
            items_count: non_neg_integer(),
            content_count: non_neg_integer(),
            side: String.t(),
            speed: number(),
            spacing: String.t(),
            auto_fill: boolean(),
            pause_on_interaction: boolean(),
            default_paused: boolean(),
            delay: number(),
            loop_count: non_neg_integer(),
            reverse: boolean(),
            dir: String.t(),
            orientation: String.t()
          }
  end

  defmodule Root do
    @moduledoc false
    defstruct [
      :id,
      :aria_label,
      :dir,
      :orientation,
      :duration,
      :spacing,
      :delay,
      :loop_count,
      :translate,
      :respect_reduced_motion,
      default_paused: false
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            aria_label: String.t() | nil,
            dir: String.t(),
            orientation: String.t(),
            duration: number(),
            spacing: String.t(),
            delay: number(),
            loop_count: non_neg_integer(),
            translate: String.t(),
            respect_reduced_motion: boolean(),
            default_paused: boolean()
          }
  end

  defmodule Edge do
    @moduledoc false
    defstruct [:side, :orientation]

    @type t :: %__MODULE__{side: String.t(), orientation: String.t()}
  end

  defmodule Viewport do
    @moduledoc false
    defstruct [:id, :orientation, :side]

    @type t :: %__MODULE__{id: String.t(), orientation: String.t(), side: String.t()}
  end

  defmodule Content do
    @moduledoc false
    defstruct [:root_id, :index, :orientation, :side, :reverse, :dir]

    @type t :: %__MODULE__{
            root_id: String.t(),
            index: non_neg_integer(),
            orientation: String.t(),
            side: String.t(),
            reverse: boolean(),
            dir: String.t() | nil
          }
  end

  defmodule Item do
    @moduledoc false
    defstruct [:orientation, :dir]

    @type t :: %__MODULE__{orientation: String.t(), dir: String.t() | nil}
  end
end
