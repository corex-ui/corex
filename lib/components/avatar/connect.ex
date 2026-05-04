defmodule Corex.Avatar.Connect do
  @moduledoc false
  alias Corex.Avatar.Anatomy.{Fallback, Image, Props, Root, Skeleton}
  alias Corex.Selectors
  alias Phoenix.LiveView.JS

  @spec props(Props.t()) :: map()
  def props(assigns) do
    %{
      "id" => assigns.id,
      "data-on-status-change" => assigns.on_status_change,
      "data-on-status-change-client" => assigns.on_status_change_client,
      "data-dir" => assigns.dir
    }
    |> drop_nil("data-dir")
  end

  @spec root(Root.t()) :: map()
  def root(assigns) do
    %{
      "data-scope" => "avatar",
      "data-part" => "root",
      "id" => "avatar:#{assigns.id}",
      "dir" => Map.get(assigns, :dir)
    }
    |> drop_nil("dir")
  end

  @spec image(Image.t()) :: map()
  def image(assigns) do
    %{
      "data-scope" => "avatar",
      "data-part" => "image",
      "id" => "avatar:#{assigns.id}:image",
      "dir" => Map.get(assigns, :dir)
    }
    |> drop_nil("dir")
    |> maybe_put("src", assigns.src)
  end

  @spec fallback(Fallback.t()) :: map()
  def fallback(assigns) do
    %{
      "data-scope" => "avatar",
      "data-part" => "fallback",
      "id" => "avatar:#{assigns.id}:fallback",
      "dir" => Map.get(assigns, :dir)
    }
    |> drop_nil("dir")
  end

  @spec skeleton(Skeleton.t()) :: map()
  def skeleton(assigns) do
    %{
      "data-scope" => "avatar",
      "data-part" => "skeleton",
      "id" => "avatar:#{assigns.id}:skeleton"
    }
  end

  def ignore_root(%Root{} = assigns) do
    JS.ignore_attributes(Root.ignored_attrs(),
      to: Selectors.css_id("avatar:#{assigns.id}")
    )
  end

  def ignore_image(%Image{} = assigns) do
    JS.ignore_attributes(Image.ignored_attrs(),
      to: Selectors.css_id("avatar:#{assigns.id}:image")
    )
  end

  def ignore_fallback(%Fallback{} = assigns) do
    JS.ignore_attributes(Fallback.ignored_attrs(),
      to: Selectors.css_id("avatar:#{assigns.id}:fallback")
    )
  end

  def ignore_skeleton(%Skeleton{} = assigns) do
    JS.ignore_attributes(Skeleton.ignored_attrs(),
      to: Selectors.css_id("avatar:#{assigns.id}:skeleton")
    )
  end

  defp maybe_put(map, _key, nil), do: map
  defp maybe_put(map, key, value), do: Map.put(map, key, value)

  defp drop_nil(map, key) do
    case Map.get(map, key) do
      nil -> Map.delete(map, key)
      _ -> map
    end
  end
end
