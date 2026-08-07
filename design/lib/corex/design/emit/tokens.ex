defmodule Corex.Design.Emit.Tokens do
  @moduledoc false

  alias Corex.Design.Theme
  alias Corex.Design.Tokens.Scales

  def font_stacks_for(theme) when is_atom(theme) do
    base = Scales.font()

    case Theme.font_stacks(theme) do
      nil -> base
      overrides when is_map(overrides) -> merge_stacks(base, overrides)
      overrides when is_list(overrides) -> merge_stacks(base, Map.new(overrides))
    end
  end

  defp merge_stacks(base, overrides) do
    base
    |> Map.new()
    |> Map.merge(overrides)
    |> Scales.in_ladder_order(Keyword.keys(base))
  end
end
