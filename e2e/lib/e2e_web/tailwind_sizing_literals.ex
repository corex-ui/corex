defmodule E2eWeb.TailwindSizingLiterals do
  @moduledoc false

  @max_width_literals ~W(
    max-w-none max-w-full
    max-w-9xs max-w-8xs max-w-7xs max-w-6xs max-w-5xs max-w-4xs
    max-w-3xs max-w-2xs max-w-xs max-w-sm max-w-md max-w-lg max-w-xl
    max-w-2xl max-w-3xl max-w-4xl max-w-5xl max-w-6xl max-w-7xl max-w-8xl max-w-9xl
  )

  @min_width_literals ~W(
    min-w-full
    min-w-9xs min-w-8xs min-w-7xs min-w-6xs min-w-5xs min-w-4xs
    min-w-3xs min-w-2xs min-w-xs min-w-sm min-w-md min-w-lg min-w-xl
    min-w-2xl min-w-3xl min-w-4xl min-w-5xl min-w-6xl min-w-7xl min-w-8xl min-w-9xl
  )

  @width_literals ~W(
    w-auto w-full w-fit
    w-9xs w-8xs w-7xs w-6xs w-5xs w-4xs
    w-3xs w-2xs w-xs w-sm w-md w-lg w-xl
    w-2xl w-3xl w-4xl w-5xl w-6xl w-7xl w-8xl w-9xl
  )

  @max_height_literals ~W(
    max-h-none max-h-full max-h-screen max-h-dvh
    max-h-9xs max-h-8xs max-h-7xs max-h-6xs max-h-5xs max-h-4xs
    max-h-3xs max-h-2xs max-h-xs max-h-sm max-h-md max-h-lg max-h-xl
    max-h-2xl max-h-3xl max-h-4xl max-h-5xl max-h-6xl max-h-7xl max-h-8xl max-h-9xl
  )

  @min_height_literals ~W(
    min-h-full min-h-screen min-h-dvh
    min-h-9xs min-h-8xs min-h-7xs min-h-6xs min-h-5xs min-h-4xs
    min-h-3xs min-h-2xs min-h-xs min-h-sm min-h-md min-h-lg min-h-xl
    min-h-2xl min-h-3xl min-h-4xl min-h-5xl min-h-6xl min-h-7xl min-h-8xl min-h-9xl
  )

  @max_width_map %{
    "none" => "max-w-none",
    "full" => "max-w-full",
    "9xs" => "max-w-9xs",
    "8xs" => "max-w-8xs",
    "7xs" => "max-w-7xs",
    "6xs" => "max-w-6xs",
    "5xs" => "max-w-5xs",
    "4xs" => "max-w-4xs",
    "3xs" => "max-w-3xs",
    "2xs" => "max-w-2xs",
    "xs" => "max-w-xs",
    "sm" => "max-w-sm",
    "md" => "max-w-md",
    "lg" => "max-w-lg",
    "xl" => "max-w-xl",
    "2xl" => "max-w-2xl",
    "3xl" => "max-w-3xl",
    "4xl" => "max-w-4xl",
    "5xl" => "max-w-5xl",
    "6xl" => "max-w-6xl",
    "7xl" => "max-w-7xl",
    "8xl" => "max-w-8xl",
    "9xl" => "max-w-9xl"
  }

  @min_width_map %{
    "full" => "min-w-full",
    "9xs" => "min-w-9xs",
    "8xs" => "min-w-8xs",
    "7xs" => "min-w-7xs",
    "6xs" => "min-w-6xs",
    "5xs" => "min-w-5xs",
    "4xs" => "min-w-4xs",
    "3xs" => "min-w-3xs",
    "2xs" => "min-w-2xs",
    "xs" => "min-w-xs",
    "sm" => "min-w-sm",
    "md" => "min-w-md",
    "lg" => "min-w-lg",
    "xl" => "min-w-xl",
    "2xl" => "min-w-2xl",
    "3xl" => "min-w-3xl",
    "4xl" => "min-w-4xl",
    "5xl" => "min-w-5xl",
    "6xl" => "min-w-6xl",
    "7xl" => "min-w-7xl",
    "8xl" => "min-w-8xl",
    "9xl" => "min-w-9xl"
  }

  @width_map %{
    "auto" => "w-auto",
    "full" => "w-full",
    "fit" => "w-fit",
    "9xs" => "w-9xs",
    "8xs" => "w-8xs",
    "7xs" => "w-7xs",
    "6xs" => "w-6xs",
    "5xs" => "w-5xs",
    "4xs" => "w-4xs",
    "3xs" => "w-3xs",
    "2xs" => "w-2xs",
    "xs" => "w-xs",
    "sm" => "w-sm",
    "md" => "w-md",
    "lg" => "w-lg",
    "xl" => "w-xl",
    "2xl" => "w-2xl",
    "3xl" => "w-3xl",
    "4xl" => "w-4xl",
    "5xl" => "w-5xl",
    "6xl" => "w-6xl",
    "7xl" => "w-7xl",
    "8xl" => "w-8xl",
    "9xl" => "w-9xl"
  }

  @max_height_map %{
    "none" => "max-h-none",
    "full" => "max-h-full",
    "screen" => "max-h-screen",
    "dvh" => "max-h-dvh",
    "9xs" => "max-h-9xs",
    "8xs" => "max-h-8xs",
    "7xs" => "max-h-7xs",
    "6xs" => "max-h-6xs",
    "5xs" => "max-h-5xs",
    "4xs" => "max-h-4xs",
    "3xs" => "max-h-3xs",
    "2xs" => "max-h-2xs",
    "xs" => "max-h-xs",
    "sm" => "max-h-sm",
    "md" => "max-h-md",
    "lg" => "max-h-lg",
    "xl" => "max-h-xl",
    "2xl" => "max-h-2xl",
    "3xl" => "max-h-3xl",
    "4xl" => "max-h-4xl",
    "5xl" => "max-h-5xl",
    "6xl" => "max-h-6xl",
    "7xl" => "max-h-7xl",
    "8xl" => "max-h-8xl",
    "9xl" => "max-h-9xl"
  }

  @min_height_map %{
    "full" => "min-h-full",
    "screen" => "min-h-screen",
    "dvh" => "min-h-dvh",
    "9xs" => "min-h-9xs",
    "8xs" => "min-h-8xs",
    "7xs" => "min-h-7xs",
    "6xs" => "min-h-6xs",
    "5xs" => "min-h-5xs",
    "4xs" => "min-h-4xs",
    "3xs" => "min-h-3xs",
    "2xs" => "min-h-2xs",
    "xs" => "min-h-xs",
    "sm" => "min-h-sm",
    "md" => "min-h-md",
    "lg" => "min-h-lg",
    "xl" => "min-h-xl",
    "2xl" => "min-h-2xl",
    "3xl" => "min-h-3xl",
    "4xl" => "min-h-4xl",
    "5xl" => "min-h-5xl",
    "6xl" => "min-h-6xl",
    "7xl" => "min-h-7xl",
    "8xl" => "min-h-8xl",
    "9xl" => "min-h-9xl"
  }

  def max_width_literals, do: @max_width_literals
  def min_width_literals, do: @min_width_literals
  def width_literals, do: @width_literals
  def max_height_literals, do: @max_height_literals
  def min_height_literals, do: @min_height_literals

  def max_width(step), do: Map.fetch!(@max_width_map, step)
  def min_width(step), do: Map.fetch!(@min_width_map, step)
  def width(step), do: Map.fetch!(@width_map, step)
  def max_height(step), do: Map.fetch!(@max_height_map, step)
  def min_height(step), do: Map.fetch!(@min_height_map, step)
end
