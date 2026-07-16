defmodule Corex.Design.Bundle.Components do
  @moduledoc false

  alias Corex.Design.ComponentLayout
  alias Corex.Design.Write

  @entry_header "/* Corex generated components - do not edit */\n"
  @import_pattern ~r/@import\s+"\.\/([^"]+)\.css";/

  def resolve_ids(nil), do: ComponentLayout.ids()

  def resolve_ids(ids) when is_list(ids) do
    ids
    |> Enum.map(&to_string/1)
    |> Enum.flat_map(&expand_id/1)
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
    body =
      ids
      |> Enum.sort()
      |> Enum.map_join("\n", &"@import \"./components/#{&1}.css\";")

    Write.atomic!(Path.join(output_dir, "components.css"), @entry_header <> body <> "\n")
  end

  defp expand_id(id) do
    static_root =
      :corex_design
      |> :code.priv_dir()
      |> List.to_string()
      |> Path.join("css")

    path = Path.join([static_root, "components", "#{id}.css"])
    deps = import_deps(path)
    [id | deps]
  end

  defp import_deps(path) do
    if File.exists?(path) do
      path
      |> File.read!()
      |> parse_import_deps()
      |> Enum.flat_map(&expand_id/1)
    else
      []
    end
  end

  defp parse_import_deps(content) do
    @import_pattern
    |> Regex.scan(content)
    |> Enum.map(fn [_, dep] -> dep end)
    |> Enum.reject(&(&1 in ["../main"]))
  end
end
