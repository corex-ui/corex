defmodule Corex.Design.Bundle.Components do
  @moduledoc false

  alias Corex.Design.Components, as: Registry
  alias Corex.Design.Emit.Css
  alias Corex.Design.Write

  @entry_header "/* Corex generated components - do not edit */\n"
  @import_pattern ~r/@import\s+"\.\/([^"]+)\.css";/
  @apply_pattern ~r/@apply\s+([^;]+);/

  @utility_deps %{
    "scrollbar" => "scrollbar",
    "scrollbar--sm" => "scrollbar",
    "scrollbar--md" => "scrollbar",
    "scrollbar--lg" => "scrollbar"
  }

  def resolve_ids!(nil), do: Registry.ids()

  def resolve_ids!(ids) when is_list(ids) do
    ids
    |> Enum.map(&to_string/1)
    |> Enum.flat_map(&expand_id!/1)
    |> Enum.uniq()
  end

  def copy!(static_root, output_dir, ids) do
    components_root = Path.join(static_root, "components")
    dest_root = Path.join(output_dir, "components")
    File.mkdir_p!(dest_root)

    for id <- ids do
      source = Path.join(components_root, "#{id}.css")
      dest = Path.join(dest_root, "#{id}.css")

      if File.exists?(source) do
        File.mkdir_p!(Path.dirname(dest))
        File.cp!(source, dest)
      end
    end

    keyframes = Path.join(components_root, "keyframes.css")

    if File.exists?(keyframes) do
      File.cp!(keyframes, Path.join(dest_root, "keyframes.css"))
    end

    :ok
  end

  def write_entry!(output_dir, ids) do
    paths = ids |> Enum.sort() |> Enum.map(&"./components/#{&1}.css")

    Write.atomic!(Path.join(output_dir, "components.css"), [@entry_header, Css.imports(paths)])
  end

  defp expand_id!(id) do
    case expand_id_result(id) do
      {:ok, ids} ->
        ids

      {:error, missing} ->
        raise ArgumentError,
              "config :corex_design, components: #{id} requires #{missing}, but design/priv/css/components/#{missing}.css is missing"
    end
  end

  defp expand_id_result(id) do
    static_root =
      :corex_design
      |> :code.priv_dir()
      |> List.to_string()
      |> Path.join("css")

    path = Path.join([static_root, "components", "#{id}.css"])

    if File.exists?(path) do
      content = File.read!(path)
      deps = parse_import_deps(content) ++ parse_apply_deps(content)

      Enum.reduce_while(deps, {:ok, [id]}, fn dep, {:ok, acc} ->
        case expand_id_result(dep) do
          {:ok, nested} -> {:cont, {:ok, acc ++ nested}}
          {:error, _} = err -> {:halt, err}
        end
      end)
    else
      {:error, id}
    end
  end

  defp parse_import_deps(content) do
    @import_pattern
    |> Regex.scan(content)
    |> Enum.map(fn [_, dep] -> dep end)
    |> Enum.reject(&(&1 in ["../main"]))
  end

  defp parse_apply_deps(content) do
    @apply_pattern
    |> Regex.scan(content)
    |> Enum.flat_map(fn [_, names] -> String.split(names) end)
    |> Enum.map(&Map.get(@utility_deps, &1))
    |> Enum.reject(&is_nil/1)
    |> Enum.uniq()
  end
end
