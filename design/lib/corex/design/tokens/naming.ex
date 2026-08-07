defmodule Corex.Design.Tokens.Naming do
  @moduledoc false

  @breakpoints [
    {"sm", "40rem"},
    {"md", "48rem"},
    {"lg", "64rem"},
    {"xl", "80rem"},
    {"2xl", "96rem"}
  ]

  @breakpoint_widths Map.new(@breakpoints)

  def breakpoints, do: @breakpoints

  def breakpoint?(name) when is_binary(name), do: Map.has_key?(@breakpoint_widths, name)

  def breakpoint_width!(name) when is_binary(name), do: Map.fetch!(@breakpoint_widths, name)

  @doc """
  Tailwind `@theme` declarations for the breakpoint ladder, one per line.
  """
  def breakpoint_theme_decls do
    Enum.map(@breakpoints, fn {name, width} ->
      Corex.Design.Emit.Css.declaration("breakpoint-#{name}", width)
    end)
  end

  @doc """
  Renders an axis step or token segment as its CSS spelling.
  """
  def dash(value), do: value |> to_string() |> String.replace("_", "-")

  @doc """
  Renders a text scale step as its token suffix.

  The `md` step is the unsuffixed base of the Tailwind text ladder, so it emits
  `base` rather than `md`.
  """
  def text_token_step(:md), do: "base"
  def text_token_step("md"), do: "base"
  def text_token_step(step), do: dash(step)
end
