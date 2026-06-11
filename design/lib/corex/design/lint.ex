defmodule Corex.Design.Lint do
  @moduledoc false

  @axis_attrs ~w(semantic size variant radius text width height max_width max_height shape gap columns justify align hide_from hide_below)a

  @attr_pattern ~r/\b(#{Enum.join(@axis_attrs, "|")})="([^"]+)"/

  def run(paths, opts \\ []) do
    vocabulary = Keyword.get(opts, :vocabulary, vocabulary_from_config())
    files = expand_paths(paths)

    issues =
      Enum.flat_map(files, fn path ->
        lint_file(path, vocabulary)
      end)

    {:ok, issues}
  end

  defp vocabulary_from_config do
    export = Corex.Design.Config.export()

    scales =
      export
      |> get_in([:vocabulary, :scales])
      |> case do
        map when is_map(map) -> map
        _ -> %{}
      end

    semantic =
      export
      |> get_in([:vocabulary, :semantic_roles])
      |> List.wrap()
      |> MapSet.new()

    %{scales: scales, semantic: semantic}
  end

  defp expand_paths(paths) do
    paths
    |> List.wrap()
    |> Enum.flat_map(fn path ->
      if File.dir?(path) do
        path
        |> Path.join("**/*.{ex,heex,leex}")
        |> Path.wildcard()
      else
        [path]
      end
    end)
    |> Enum.uniq()
    |> Enum.filter(&File.regular?/1)
  end

  defp lint_file(path, %{scales: scales, semantic: semantic}) do
    content = File.read!(path)

    for [_, attr, value] <- Regex.scan(@attr_pattern, content),
        issue <- lint_attr(path, attr, value, scales, semantic) do
      issue
    end
  end

  defp lint_attr(path, "semantic", value, _scales, semantic) do
    if MapSet.member?(semantic, value) do
      []
    else
      [{path, :semantic, value, "unknown semantic role"}]
    end
  end

  defp lint_attr(path, attr, value, scales, _semantic) do
    axis = String.to_atom(attr)

    case Map.get(scales, axis) do
      nil ->
        []

      allowed when is_list(allowed) ->
        if value in allowed do
          []
        else
          [{path, axis, value, "value not in configured scale steps"}]
        end

      _ ->
        []
    end
  end
end
