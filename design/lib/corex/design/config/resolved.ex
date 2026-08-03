defmodule Corex.Design.Config.Resolved do
  @moduledoc """
  The `config :corex_design` entry after defaults are applied.
  """

  alias Corex.Design.Keys

  @type t :: %__MODULE__{
          output: String.t() | nil,
          default_theme: atom(),
          default_mode: atom(),
          themes: term() | nil,
          modes: term() | nil,
          scales: keyword(),
          components: [String.t()] | nil,
          semantics: [atom() | String.t()] | nil,
          accessibility: false | true | [atom()]
        }

  defstruct output: nil,
            default_theme: :uno,
            default_mode: :light,
            themes: nil,
            modes: nil,
            scales: [],
            components: nil,
            semantics: nil,
            accessibility: false

  @doc """
  Builds the resolved config from a keyword list or map.
  """
  @spec new(keyword() | map()) :: t()
  def new(config) when is_list(config), do: config |> Map.new() |> new()

  def new(config) when is_map(config) do
    %__MODULE__{
      output: Keys.get(config, :output),
      default_theme: Keys.get(config, :default_theme, :uno),
      default_mode: Keys.get(config, :default_mode, :light),
      themes: Keys.get(config, :themes),
      modes: Keys.get(config, :modes),
      scales: Keys.get(config, :scales) || [],
      components: Keys.get(config, :components),
      semantics: Keys.get(config, :semantics),
      accessibility: Keys.get(config, :accessibility, false)
    }
  end
end
