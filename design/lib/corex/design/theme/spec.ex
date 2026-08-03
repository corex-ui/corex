defmodule Corex.Design.Theme.Spec do
  @moduledoc false

  alias Corex.Design.Theme.Spec.Dimensions
  alias Corex.Design.Theme.Spec.Mode

  @type t :: %__MODULE__{
          seeds: %{optional(String.t()) => String.t()},
          colors: %{light: Mode.t(), dark: Mode.t()},
          dimensions: Dimensions.t(),
          typography: %{optional(String.t()) => term()} | nil
        }

  defstruct seeds: %{},
            colors: %{light: nil, dark: nil},
            dimensions: nil,
            typography: nil

  defmodule Mode do
    @moduledoc false

    @type token :: map()

    @type t :: %__MODULE__{
            tokens: %{optional(String.t()) => token()}
          }

    defstruct tokens: %{}
  end

  defmodule Dimensions do
    @moduledoc false

    @type t :: %__MODULE__{
            scale: float() | nil,
            space_scale: float() | nil,
            size_scale: float() | nil,
            text_scale: float() | nil,
            radius_scale: float() | nil,
            container_scale: float() | nil,
            shadow_scale: float() | nil,
            blur_scale: float() | nil,
            ring_width: float() | nil,
            ring_offset: float() | nil,
            border_width: float() | nil,
            duration_fast: float() | nil,
            duration_normal: float() | nil,
            duration_slow: float() | nil,
            opacity_disabled: float() | nil,
            opacity_backdrop: float() | nil,
            radius: %{optional(atom()) => float()},
            font: %{optional(atom()) => [String.t()]} | nil
          }

    defstruct scale: nil,
              space_scale: nil,
              size_scale: nil,
              text_scale: nil,
              radius_scale: nil,
              container_scale: nil,
              shadow_scale: nil,
              blur_scale: nil,
              ring_width: nil,
              ring_offset: nil,
              border_width: nil,
              duration_fast: nil,
              duration_normal: nil,
              duration_slow: nil,
              opacity_disabled: nil,
              opacity_backdrop: nil,
              radius: %{},
              font: nil
  end
end
