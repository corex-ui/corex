defmodule Corex.Connect.ItemNav do
  @moduledoc false

  @spec put_item_nav_attrs(map(), map() | struct()) :: map()
  def put_item_nav_attrs(attrs, assigns) when is_map(attrs) do
    attrs
    |> Corex.Url.put_data_to(Map.get(assigns, :to))
    |> put_redirect(Map.get(assigns, :redirect))
    |> put_new_tab(Map.get(assigns, :new_tab))
  end

  defp put_redirect(attrs, false), do: Map.put(attrs, "data-redirect", "false")

  defp put_redirect(attrs, mode) when mode in [:href, :patch, :navigate] do
    Map.put(attrs, "data-redirect", Atom.to_string(mode))
  end

  defp put_redirect(attrs, _), do: attrs

  defp put_new_tab(attrs, true), do: Map.put(attrs, "data-new-tab", "")
  defp put_new_tab(attrs, _), do: attrs
end
