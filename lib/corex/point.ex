defmodule Corex.Point do
  @moduledoc """
  Two-dimensional point (`x`, `y`) for Zag.js layout.

  Used when a component needs a fixed pixel position instead of anchor-based
  placement—for example [`Corex.FloatingPanel`](Corex.FloatingPanel.html) `position`
  (`defaultPosition` / `data-default-position`).

  Pass either `%Corex.Point{x: 0, y: 0}` or a map `%{x: 0, y: 0}`.

  ## Example

      <.floating_panel
        id="my-floating-panel"
        class="floating-panel"
        position={%Corex.Point{x: 120, y: 80}}
      >
        <:trigger class="button button--variant-ghost button--sm">
          <span data-closed>Open panel</span>
          <span data-open>Close panel</span>
        </:trigger>
        <:title>Panel</:title>
        <:minimize_trigger>
          <.heroicon name="hero-arrow-down-left" class="icon" />
        </:minimize_trigger>
        <:maximize_trigger>
          <.heroicon name="hero-arrows-pointing-out" class="icon" />
        </:maximize_trigger>
        <:default_trigger>
          <.heroicon name="hero-rectangle-stack" class="icon" />
        </:default_trigger>
        <:close_trigger>
          <.heroicon name="hero-x-mark" class="icon" />
        </:close_trigger>
        <:content>
          <p>
            Congue molestie ipsum gravida a. Sed ac eros luctus, cursus turpis
            non, pellentesque elit. Pellentesque sagittis fermentum.
          </p>
        </:content>
      </.floating_panel>
  """

  @enforce_keys [:x, :y]
  defstruct [:x, :y]

  @type t :: %__MODULE__{x: number(), y: number()}

  @doc """
  Normalizes a point struct or map for JSON / data attributes.

  Returns `nil` when the argument is `nil`.

  ## Examples

      iex> Corex.Point.to_map(%Corex.Point{x: 1, y: 2})
      %{x: 1, y: 2}

      iex> Corex.Point.to_map(%{x: 0, y: 0})
      %{x: 0, y: 0}

      iex> Corex.Point.to_map(nil)
      nil
  """
  @spec to_map(t() | %{x: number(), y: number()} | nil) :: %{x: number(), y: number()} | nil
  def to_map(nil), do: nil

  def to_map(%__MODULE__{x: x, y: y}) when is_number(x) and is_number(y), do: %{x: x, y: y}

  def to_map(%{x: x, y: y}) when is_number(x) and is_number(y), do: %{x: x, y: y}

  def to_map(_), do: raise(ArgumentError, "expected %Corex.Point{} or %{x: _, y: _}")
end
