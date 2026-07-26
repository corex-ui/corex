defmodule Corex.Design.Emit.Css do
  @moduledoc """
  The CSS shapes every emitter writes: the generated-file banner, a custom
  property declaration, and a block of them under a selector.

  Each emitter used to spell these out with `<>` and `Enum.map_join/3`, which
  copies the whole document once per join and had the two-space indent and the
  `\\n}\\n` terminator repeated at a dozen call sites. These return iodata, which
  `Corex.Design.Write.atomic!/2` writes without flattening.
  """

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

      iex> Corex.Design.Emit.Css.forward("radius-md", "theme-radius-md") |> IO.iodata_to_binary()
      "  --radius-md: var(--theme-radius-md);"
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
