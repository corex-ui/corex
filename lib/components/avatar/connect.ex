defmodule Corex.Avatar.Connect do
  @moduledoc false
  alias Corex.Avatar.Anatomy.{Props, Root, Image, Fallback}

  @spec props(Props.t()) :: map()
  def props(assigns) do
    %{
      "id" => assigns.id,
      "data-on-status-change" => assigns.on_status_change,
      "data-on-status-change-client" => assigns.on_status_change_client
    }
  end

  @spec root(Root.t()) :: map()
  def root(assigns) do
    %{
      "data-scope" => "avatar",
      "data-part" => "root",
      "id" => "avatar:#{assigns.id}"
    }
  end

  @spec image(Image.t()) :: map()
  def image(assigns) do
    %{
      "data-scope" => "avatar",
      "data-part" => "image",
      "id" => "avatar:#{assigns.id}:image"
    }
    |> maybe_put("src", assigns.src)
  end

  @spec fallback(Fallback.t()) :: map()
  def fallback(assigns) do
    %{
      "data-scope" => "avatar",
      "data-part" => "fallback",
      "id" => "avatar:#{assigns.id}:fallback"
    }
  end

  defp maybe_put(map, _key, nil), do: map
  defp maybe_put(map, key, value), do: Map.put(map, key, value)
end
