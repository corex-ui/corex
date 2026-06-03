defmodule Corex.Assets.Manifest do
  @moduledoc false

  @doc "Absolute path of the manifest file for a named pipeline (e.g. `\"design\"`)."
  def path(name) when is_binary(name) do
    Path.join(manifest_root(), "corex_#{validate_name!(name)}.manifest")
  end

  @doc "Returns true when the output is missing or the inputs differ from the stored digest."
  def stale?(name, inputs, output) do
    not File.exists?(output) or read(name) != digest(inputs)
  end

  @doc "Persists the current input digest for a pipeline."
  def write(name, inputs) do
    validated = validate_name!(name)
    root = manifest_root()
    File.mkdir_p!(root)
    File.write!(Path.join(root, "corex_#{validated}.manifest"), digest(inputs))
  end

  defp read(name) do
    case read_project_file(path(name)) do
      {:ok, data} -> data
      _ -> nil
    end
  end

  @doc false
  def digest(inputs) do
    inputs
    |> Enum.map_join("\0", &input_binary/1)
    |> then(&:crypto.hash(:sha256, &1))
    |> Base.encode16(case: :lower)
  end

  defp input_binary({:file, path}) do
    case read_project_file(path) do
      {:ok, data} -> "file:" <> path <> ":" <> data
      _ -> "file:" <> path <> ":<missing>"
    end
  end

  defp input_binary({:term, term}) do
    "term:" <> :erlang.term_to_binary(term)
  end

  defp manifest_root, do: Mix.Project.manifest_path()

  defp validate_name!(name) when is_binary(name) do
    if name =~ ~r/^[a-z][a-z0-9_]*$/ do
      name
    else
      raise ArgumentError, "invalid manifest name: #{inspect(name)}"
    end
  end

  defp project_root, do: Path.expand(mix_root())

  defp mix_root do
    if Code.ensure_loaded?(Mix) and function_exported?(Mix.ProjectStack, :top_and_bottom, 0) do
      {_top, bottom} = Mix.ProjectStack.top_and_bottom()

      if is_map(bottom) and is_binary(bottom.file) do
        Path.dirname(bottom.file)
      else
        File.cwd!()
      end
    else
      File.cwd!()
    end
  end

  defp read_project_file(path) when is_binary(path) do
    expanded = Path.expand(path)
    root = project_root()

    if expanded == root or String.starts_with?(expanded, root <> "/") do
      File.read(expanded)
    else
      {:error, :invalid_path}
    end
  end
end
