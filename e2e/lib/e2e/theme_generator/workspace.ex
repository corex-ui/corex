defmodule E2e.ThemeGenerator.Workspace do
  @moduledoc false

  def create! do
    tg = Application.fetch_env!(:corex_web, :theme_generator)
    e2e_root = Keyword.fetch!(tg, :e2e_root)
    src = Keyword.fetch!(tg, :source_design)

    id =
      :crypto.strong_rand_bytes(16)
      |> Base.url_encode64(padding: false)
      |> String.replace("/", "_")

    root = Path.join(System.tmp_dir!(), "e2e_theme_gen_" <> id)
    design_dir = Path.join(root, "design")
    File.mkdir_p!(design_dir)
    File.cp_r!(Path.join(src, "tokens"), Path.join(design_dir, "tokens"))
    File.cp!(Path.join(src, "build.mjs"), Path.join(design_dir, "build.mjs"))
    link_node_modules(design_dir, e2e_root)
    tokens_out = Path.join(root, "tokens")

    %{
      id: id,
      root: root,
      design_dir: design_dir,
      tokens_out: tokens_out,
      e2e_root: e2e_root
    }
  end

  def delete!(%{root: root}) when is_binary(root) do
    base = Path.basename(root)

    if String.starts_with?(base, "e2e_theme_gen_") and File.exists?(root) do
      File.rm_rf(root)
    end

    :ok
  end

  def delete!(_), do: :ok

  defp link_node_modules(design_dir, e2e_root) do
    nm = Path.expand(Path.join(e2e_root, "node_modules"))
    link = Path.join(design_dir, "node_modules")

    case :os.type() do
      {:win32, _} ->
        File.cp_r!(nm, link)

      _ ->
        File.ln_s(nm, link)
    end
  end
end
