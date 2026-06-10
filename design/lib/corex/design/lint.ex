defmodule Corex.Design.Lint do
  @moduledoc false

  alias Corex.Design.Tokens.Scales
  alias Corex.Design.Vocabulary

  @axis_pattern ~r/\b(semantic|size|text|radius|variant|shape|width|max_width|height|max_height|padding|gap|side|orientation|direction|columns|justify|align|wrap|grow|shrink|weight|visual|min_height)="([^"]+)"/

  @side_steps ~w(start end top bottom)

  @doc """
  Scans `lib/` templates for style axis literals not in the resolved vocabulary.
  Returns a list of `{file, line, axis, value, message}` tuples.
  """
  def scan(root \\ File.cwd!()) do
    lib = Path.join(root, "lib")

    if File.dir?(lib) do
      lib
      |> then(fn root ->
        Path.wildcard(Path.join(root, "**/*.ex")) ++
          Path.wildcard(Path.join(root, "**/*.heex"))
      end)
      |> Enum.flat_map(&scan_file/1)
    else
      []
    end
  end

  @doc false
  def run!(root \\ File.cwd!()) do
    case scan(root) do
      [] ->
        :ok

      issues ->
        message =
          issues
          |> Enum.map(fn {file, line, axis, value, _} ->
            "#{file}:#{line} #{axis}=#{inspect(value)}"
          end)
          |> Enum.join("\n")

        raise """
        mix corex.design.lint found #{length(issues)} issue(s):

        #{message}
        """
    end
  end

  defp scan_file(path) do
    path
    |> File.read!()
    |> String.split("\n")
    |> Enum.with_index(1)
    |> Enum.flat_map(fn {line, line_no} ->
      for [_, axis, value] <- Regex.scan(@axis_pattern, line) do
        case validate_literal(axis, value) do
          :ok -> nil
          {:error, message} -> {path, line_no, axis, value, message}
        end
      end
      |> Enum.reject(&is_nil/1)
    end)
  end

  defp validate_literal("semantic", value) do
    allowed = Vocabulary.semantic_strings()

    if value in allowed do
      :ok
    else
      {:error, "semantic role #{inspect(value)} not in theme catalog (#{inspect(allowed)})"}
    end
  end

  defp validate_literal("side", value) do
    if value in @side_steps, do: :ok, else: {:error, "side=#{inspect(value)} not in #{inspect(@side_steps)}"}
  end

  defp validate_literal(axis, value) do
    with {:ok, scale} <- fetch_scale_axis(axis),
         allowed <- scale_steps(scale) do
      if value in allowed do
        :ok
      else
        {:error, "#{axis}=#{inspect(value)} not in resolved scale steps #{inspect(allowed)}"}
      end
    else
      :unknown -> :ok
    end
  end

  defp fetch_scale_axis("variant"), do: {:ok, :visual}
  defp fetch_scale_axis("padding"), do: {:ok, :space}
  defp fetch_scale_axis("gap"), do: {:ok, :space}
  defp fetch_scale_axis("justify"), do: {:ok, :justify}
  defp fetch_scale_axis("align"), do: {:ok, :align}
  defp fetch_scale_axis("direction"), do: {:ok, :direction}
  defp fetch_scale_axis("columns"), do: {:ok, :columns}
  defp fetch_scale_axis("orientation"), do: {:ok, :orientation}
  defp fetch_scale_axis("wrap"), do: {:ok, :wrap}
  defp fetch_scale_axis("grow"), do: {:ok, :grow}
  defp fetch_scale_axis("shrink"), do: {:ok, :shrink}
  defp fetch_scale_axis("min_height"), do: {:ok, :min_height}

  defp fetch_scale_axis(axis) do
    {:ok, String.to_existing_atom(axis)}
  rescue
    ArgumentError -> :unknown
  end

  defp scale_steps(scale) do
    Enum.map(Scales.axis_steps(scale), fn
      step when is_binary(step) -> step
      step when is_atom(step) -> Atom.to_string(step)
    end)
  end
end
