defmodule Corex.Design.Theme.Presets do
  @moduledoc """
  Built-in theme presets (neo, uno, duo, leo). Copy into host config or reference
  directly:

      config :corex_design,
        output: "assets/css/corex/tailwind.css"
  """

  alias Corex.Design.Theme
  alias Corex.Design.Theme.Presets.Duo
  alias Corex.Design.Theme.Presets.Leo
  alias Corex.Design.Theme.Presets.Neo
  alias Corex.Design.Theme.Presets.Uno

  def all do
    %{neo: neo(), uno: uno(), duo: duo(), leo: leo()}
  end

  def neo, do: Theme.normalize_input_spec(Neo.spec())
  def uno, do: Theme.normalize_input_spec(Uno.spec())
  def duo, do: Theme.normalize_input_spec(Duo.spec())
  def leo, do: Theme.normalize_input_spec(Leo.spec())
end
