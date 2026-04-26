defmodule E2e.ThemeGenerator.Build do
  @moduledoc false

  def run(config) when is_map(config) do
    workspace = E2e.ThemeGenerator.Workspace.create!()

    try do
      with :ok <- E2e.DesignPalette.Metadata.write!(workspace.design_dir, config),
           :ok <-
             E2e.DesignPalette.run(design_dir: workspace.design_dir, config: config, quiet: true),
           {:ok, log} <- run_style_dictionary(workspace) do
        {:ok, Map.put(workspace, :build_log, log)}
      else
        {:error, _} = err ->
          E2e.ThemeGenerator.Workspace.delete!(workspace)
          err

        other ->
          E2e.ThemeGenerator.Workspace.delete!(workspace)
          {:error, inspect(other)}
      end
    rescue
      e ->
        E2e.ThemeGenerator.Workspace.delete!(workspace)
        {:error, Exception.message(e)}
    end
  end

  defp run_style_dictionary(%{design_dir: design_dir, e2e_root: e2e_root}) do
    node = System.find_executable("node")

    cond do
      is_nil(node) ->
        {:error, "node executable not found"}

      true ->
        node_modules = Path.join(e2e_root, "node_modules")
        env = Map.put(System.get_env(), "NODE_PATH", node_modules)

        {out, status} =
          System.cmd(node, ["build.mjs"],
            cd: design_dir,
            env: env,
            stderr_to_stdout: true
          )

        if status == 0 do
          {:ok, out}
        else
          {:error, "style dictionary exited #{status}: #{out}"}
        end
    end
  end

  def preview_css_snippet(%{tokens_out: out}) do
    paths = [
      Path.join(out, "semantic/color-scope.css"),
      Path.join(out, "themes/neo/color/light.css")
    ]

    paths
    |> Enum.filter(&File.exists?/1)
    |> Enum.map_join("\n", &File.read!/1)
  end

  def collect_json_files(%{design_dir: dir}) do
    walk(Path.join(dir, "tokens"), &String.ends_with?(&1, ".json"))
  end

  def collect_css_files(%{tokens_out: out}) do
    if File.exists?(out), do: walk(out, &String.ends_with?(&1, ".css")), else: []
  end

  defp walk(root, pred) do
    if File.exists?(root) do
      walk_impl(root, root, pred, [])
    else
      []
    end
  end

  defp walk_impl(current, root, pred, acc) do
    cond do
      File.regular?(current) ->
        if pred.(current) do
          [{Path.relative_to(current, root), File.read!(current)} | acc]
        else
          acc
        end

      File.dir?(current) ->
        Enum.reduce(File.ls!(current), acc, fn name, a ->
          walk_impl(Path.join(current, name), root, pred, a)
        end)

      true ->
        acc
    end
  end
end
