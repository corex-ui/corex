defmodule Corex.Design.Emit.Tokens do
  @moduledoc false

  alias Corex.Design.Theme
  alias Corex.Design.Tokens.Scales

  def font_stacks_for(theme) when is_atom(theme) do
    base = Scales.font()

    case Theme.font_stacks(theme) do
      nil -> base
      %{} = overrides -> Keyword.merge(base, Map.to_list(overrides))
      overrides when is_list(overrides) -> Keyword.merge(base, overrides)
    end
  end
end
