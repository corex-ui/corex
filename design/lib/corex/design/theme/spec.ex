defmodule Corex.Design.Theme.Spec do
  @moduledoc """
  The normalized shape of one theme, as the emitters read it.

  A theme is authored as a nested map with atom or string keys and any subset of
  the keys present, so before normalization every reader guessed at the shape with
  `Map.get(spec, :dimensions, %{})`. The guess made two failures look alike: a key
  the author genuinely omitted, and a key a normalization bug dropped. These
  structs make the shape total, so an omitted key reads as `nil` or an empty map
  by construction and a wrong key raises at the point it is written.

  `Corex.Design.Theme.normalize_input_spec/1` is the only way in.
  """

  alias Corex.Design.Theme.Spec.Dimensions
  alias Corex.Design.Theme.Spec.Mode

  @type t :: %__MODULE__{
          palette: %{optional(String.t()) => String.t()},
          colors: %{light: Mode.t(), dark: Mode.t()},
          dimensions: Dimensions.t(),
          typography: %{optional(String.t()) => term()} | nil
        }

  defstruct palette: %{},
            colors: %{light: nil, dark: nil},
            dimensions: nil,
            typography: nil

  defmodule Mode do
    @moduledoc """
    One color mode of a theme spec: the surfaces, roles and on-colors it defines,
    plus the three flat tokens that are replaced rather than merged.
    """

    @type token :: %{optional(atom()) => term()} | nil

    @type t :: %__MODULE__{
            surface: %{optional(atom()) => term()},
            roles: %{optional(atom()) => term()},
            on: %{optional(atom()) => term()},
            border: token(),
            focus: token(),
            shadow: token()
          }

    defstruct surface: %{}, roles: %{}, on: %{}, border: nil, focus: nil, shadow: nil
  end

  defmodule Dimensions do
    @moduledoc """
    The per-theme scale multipliers, radius overrides and font stacks.

    Every scale defaults to `nil` rather than `1.0`: `nil` means "inherit from
    `:scale`", which is not the same as an explicit `1.0` when `:scale` is set.
    """

    @type t :: %__MODULE__{
            scale: float() | nil,
            space_scale: float() | nil,
            size_scale: float() | nil,
            text_scale: float() | nil,
            radius_scale: float() | nil,
            container_scale: float() | nil,
            shadow_scale: float() | nil,
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
              radius: %{},
              font: nil
  end
end
