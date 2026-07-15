defmodule Corex.Design.Options do
  @moduledoc false

  alias Corex.Design.Axes
  alias Corex.Design.ComponentLayout
  alias Corex.Design.Config
  alias Corex.Design.Filter
  alias Corex.Design.Theme
  alias Corex.Design.Theme.Options, as: ThemeOptions

  @doc false
  def report do
    [
      "config :corex_design options",
      "",
      "Keys:",
      indent_lines(Config.options_docs()),
      "",
      "Allowed components: (components:)",
      format_atoms(ComponentLayout.ids()),
      "Current components: #{format_current_components(Filter.components())}",
      "",
      "Allowed semantics: (semantics:)",
      format_atoms(Filter.default_semantics()),
      "Current semantics: #{format_list(Filter.semantics())}",
      "",
      "Allowed themes: (themes:, default_theme:)",
      format_atoms(ThemeOptions.preset_ids()),
      "Current default_theme: #{Theme.default_theme()}",
      "",
      "Allowed modes: (default_mode:)",
      format_atoms(Theme.modes()),
      "Current default_mode: #{Theme.default_mode()}",
      "",
      "Size steps: (scales / ui-size-*)",
      format_list(Axes.sizes()),
      "",
      "Radius steps: (scales / ui-rounded-*)",
      format_list(Axes.radii())
    ]
    |> Enum.join("\n")
  end

  defp format_current_components(nil), do: "all"
  defp format_current_components(list), do: format_list(list)

  defp format_atoms(list) do
    list
    |> Enum.map(&to_string/1)
    |> Enum.sort()
    |> format_list()
  end

  defp format_list(list) when is_list(list) do
    list
    |> Enum.map(&to_string/1)
    |> Enum.join(" ")
  end

  defp indent_lines(text) when is_binary(text) do
    text
    |> String.trim()
    |> String.split("\n")
    |> Enum.map_join("\n", fn
      "" -> ""
      line -> "  " <> line
    end)
  end
end
