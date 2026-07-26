defmodule Corex.Design.Bundle do
  @moduledoc false

  alias Corex.Design.Bundle.Components
  alias Corex.Design.Emit.Css
  alias Corex.Design.Emit.Recipes
  alias Corex.Design.Filter
  alias Corex.Design.Theme
  alias Corex.Design.Tokens.Publish
  alias Corex.Design.Write

  @header "/* Corex generated design - do not edit */\n"

  @infra_files ~w(main.css tokens.css)

  @doc false
  def write!(output_dir) do
    output_dir = Path.expand(output_dir)
    static_root = Path.join(:code.priv_dir(:corex_design), "css") |> Path.expand()

    refuse_same_static_root!(static_root, output_dir)

    File.mkdir_p!(output_dir)
    copy_infrastructure!(static_root, output_dir)
    write_utilities!(static_root, output_dir)

    requested = Filter.components()

    if requested do
      Filter.validate_component_ids!(requested)
    end

    component_ids = Components.resolve_ids!(requested)
    Components.copy!(static_root, output_dir, component_ids)
    Publish.write_theme_tokens!(output_dir)
    Recipes.write!(output_dir, component_ids)
    Components.write_entry!(output_dir, component_ids)
    write_corex_entry!(output_dir)

    write_manifest!(output_dir)

    report!(component_ids)

    :ok
  end

  @manifest_file "GENERATED"

  defp write_manifest!(output_dir) do
    path = Path.join(output_dir, @manifest_file)

    Write.atomic!(path, @header <> "content_hash=#{content_hash(output_dir, path)}\n")
  end

  defp content_hash(output_dir, manifest_path) do
    output_dir
    |> Path.join("**/*")
    |> Path.wildcard(match_dot: false)
    |> Enum.reject(&(&1 == manifest_path))
    |> Enum.filter(&File.regular?/1)
    |> Enum.sort()
    |> Enum.reduce(:crypto.hash_init(:sha256), fn path, acc ->
      relative = Path.relative_to(path, output_dir)
      :crypto.hash_update(acc, [relative, 0, File.read!(path)])
    end)
    |> :crypto.hash_final()
    |> Base.encode16(case: :lower)
  end

  defp report!(component_ids) do
    themes = Theme.themes()
    modes = Theme.modes()
    semantics = Filter.semantic_strings()

    IO.puts([
      "corex_design: components=",
      inspect(component_ids),
      " themes=",
      inspect(themes),
      " modes=",
      inspect(modes),
      " semantics=",
      inspect(semantics)
    ])
  end

  defp copy_infrastructure!(static_root, output_dir) do
    Enum.each(@infra_files, fn file ->
      copy_file!(Path.join(static_root, file), Path.join(output_dir, file))
    end)
  end

  defp write_utilities!(static_root, output_dir) do
    source = Path.join(static_root, "utilities.css")

    css =
      source
      |> File.read!()
      |> Filter.apply_utilities_semantics(Filter.semantic_strings())

    Write.atomic!(Path.join(output_dir, "utilities.css"), css)
  end

  defp refuse_same_static_root!(static_root, output_dir) do
    if same_tree?(static_root, output_dir) do
      raise ArgumentError,
            "corex.design.build refuses --output=#{output_dir}: it resolves to the static CSS root (#{static_root}). Writing there truncates anatomy files because File.cp! onto the same inode empties the source."
    end
  end

  defp same_tree?(a, b) do
    real_path(a) == real_path(b) or same_inode?(a, b)
  end

  defp copy_file!(source, dest) do
    File.mkdir_p!(Path.dirname(dest))

    unless same_file_path?(source, dest) do
      File.cp!(source, dest)
    end
  end

  defp same_file_path?(source, dest) do
    Path.expand(source) == Path.expand(dest) or same_inode?(source, dest)
  end

  defp same_inode?(a, b) do
    with {:ok, sa} <- File.stat(a),
         {:ok, sb} <- File.stat(b) do
      sa.major_device == sb.major_device and sa.minor_device == sb.minor_device and
        sa.inode == sb.inode
    else
      _ -> false
    end
  end

  defp real_path(path) do
    abs = Path.expand(path)
    resolve_symlinks(abs, %{})
  end

  defp resolve_symlinks(path, seen) when is_map_key(seen, path), do: path

  defp resolve_symlinks(path, seen) do
    seen = Map.put(seen, path, true)

    case File.read_link(path) do
      {:ok, target} ->
        resolve_symlinks(Path.expand(target, Path.dirname(path)), seen)

      {:error, _reason} ->
        resolve_symlink_parent(path, Path.dirname(path), seen)
    end
  end

  defp resolve_symlink_parent(path, path, _seen), do: path

  defp resolve_symlink_parent(path, parent, seen) do
    Path.join(resolve_symlinks(parent, seen), Path.basename(path))
  end

  defp write_corex_entry!(output_dir) do
    paths =
      ["./main.css"] ++
        Enum.map(Theme.themes(), &"./theme/#{&1}.css") ++
        ["./recipes.css", "./components.css"]

    Write.atomic!(Path.join(output_dir, "corex.css"), [@header, Css.imports(paths)])
  end
end
