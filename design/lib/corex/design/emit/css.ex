defmodule Corex.Design.Emit.Css do
  @moduledoc false

  @header "/**\n * Do not edit directly, this file was auto-generated.\n */\n\n"

  @doc """
  The banner that marks a file as generated.
  """
  @spec header() :: String.t()
  def header, do: @header

  @doc """
  A custom property declaration, indented one level.

      iex> Corex.Design.Emit.Css.declaration("color-ink", "#111827") |> IO.iodata_to_binary()
      "  --color-ink: #111827;"
  """
  @spec declaration(String.t(), String.t() | number()) :: iolist()
  def declaration(name, value), do: ["  --", name, ": ", to_string(value), ";"]

  @doc """
  A custom property that forwards to another one, as the semantic bridges do.

      iex> Corex.Design.Emit.Css.forward("radius-md", "radius-md") |> IO.iodata_to_binary()
      "  --radius-md: var(--radius-md);"
  """
  @spec forward(String.t(), String.t()) :: iolist()
  def forward(name, target), do: ["  --", name, ": var(--", target, ");"]

  @doc """
  A plain property declaration, indented by `pad`.

      iex> Corex.Design.Emit.Css.property("font-weight", "600") |> IO.iodata_to_binary()
      "  font-weight: 600;"
  """
  @spec property(String.t(), iodata(), String.t()) :: iolist()
  def property(name, value, pad \\ "  "), do: [pad, name, ": ", value, ";"]

  @doc """
  A selector wrapping newline-separated declarations.
  """
  @spec block(iodata(), [iodata()]) :: iolist()
  def block(selector, declarations) do
    [selector, " {\n", Enum.intersperse(declarations, "\n"), "\n}\n"]
  end

  @doc """
  A `@theme` block. Utilities keep live `var(--*)` references (not inlined).
  """
  @spec theme([iodata()]) :: iolist()
  def theme(declarations), do: block("@theme", declarations)

  @doc """
  A `@theme inline` block, the Tailwind entry point for semantic tokens.
  """
  @spec theme_inline([iodata()]) :: iolist()
  def theme_inline(declarations), do: block("@theme inline", declarations)

  @doc """
  A banner followed by the given blocks.
  """
  @spec document([iodata()]) :: iolist()
  def document(blocks), do: [header() | blocks]

  @doc """
  Newline-terminated `@import` lines for the given relative paths.
  """
  @spec imports([String.t()]) :: iolist()
  def imports(paths), do: Enum.map(paths, &[~s(@import "), &1, ~s(";\n)])
end
