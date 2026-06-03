defmodule Corex.Appearances do
  @moduledoc false

  @sizing_axes [
    width: :width,
    max_width: :max_width,
    height: :height,
    max_height: :max_height
  ]

  @surface_axes [
    semantic: :semantic,
    size: :size,
    text: :text,
    radius: :radius
  ]

  @defaults [
    button: %{
      base: "button",
      axes:
        @surface_axes ++
          [
            variant: :visual,
            shape: :shape
          ] ++ @sizing_axes
    },
    link: %{
      base: "link",
      axes:
        @surface_axes ++
          [
            variant: :visual,
            shape: :shape
          ] ++ @sizing_axes
    },
    treeview: %{
      base: "tree-view",
      axes: @surface_axes ++ @sizing_axes
    },
    navigation: %{
      base: "tree-navigation",
      axes: @surface_axes ++ @sizing_axes
    },
    modal: %{
      base: "dialog-modal",
      axes: @surface_axes ++ @sizing_axes
    },
    side: %{
      base: "dialog-side",
      axes: @surface_axes ++ @sizing_axes ++ [side: ~w(start end top bottom)]
    }
  ]

  @doc false
  def all do
    overrides =
      Application.get_env(:corex, :recipe_looks) ||
        Application.get_env(:corex, :appearances, [])

    Keyword.merge(@defaults, overrides)
  end

  @doc false
  def fetch!(name) when is_atom(name) do
    case Keyword.fetch(all(), name) do
      {:ok, look} -> look
      :error -> raise ArgumentError, "unknown Corex recipe look #{inspect(name)}"
    end
  end

  @doc false
  def names, do: Keyword.keys(all())

  @doc false
  def button, do: fetch!(:button)

  @doc false
  def link, do: fetch!(:link)

  @doc false
  def treeview, do: fetch!(:treeview)

  @doc false
  def navigation, do: fetch!(:navigation)

  @doc false
  def modal, do: fetch!(:modal)

  @doc false
  def side, do: fetch!(:side)
end
