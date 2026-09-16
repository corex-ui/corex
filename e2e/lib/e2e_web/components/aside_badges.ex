defmodule E2eWeb.AsideBadges do
  @moduledoc false

  @no_zag ~W(action navigate data-list data-table layout-heading code native-input file-upload-live)
  @navigation ~W(select tree-view menu navigate)

  def for_component(%{id: id} = cfg) do
    []
    |> maybe_add(match?([_ | _], Map.get(cfg, :forms, [])), :form)
    |> maybe_add(id in @navigation, :navigation)
    |> maybe_add(id not in @no_zag, :zagjs)
  end

  defp maybe_add(list, true, badge), do: list ++ [badge]
  defp maybe_add(list, false, _badge), do: list
end
