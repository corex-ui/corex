defmodule Corex.Integration.CorexPathDep do
  @moduledoc false

  @corex_hex_re ~r/\{:corex,\s*"~>[^"]+"\}/

  def inject(app_root_path, opts) when is_binary(app_root_path) and is_list(opts) do
    corex_root = Corex.Integration.Paths.corex_repo_root()

    mix_files =
      if "--umbrella" in opts do
        umbrella_root = Path.join(app_root_path, "apps")

        for app <- File.ls!(umbrella_root),
            mix_exs = Path.join([umbrella_root, app, "mix.exs"]),
            File.exists?(mix_exs),
            do: mix_exs
      else
        [Path.join(app_root_path, "mix.exs")]
      end

    for mix_exs <- mix_files do
      content = File.read!(mix_exs)

      if content =~ @corex_hex_re do
        rel = rel_path_dep(mix_exs, corex_root)
        corex_path_dep = ~s[{:corex, path: #{inspect(rel)}, override: true}]
        new_content = String.replace(content, @corex_hex_re, corex_path_dep)
        File.write!(mix_exs, new_content)
      end
    end

    umbrella_mix =
      if "--umbrella" in opts do
        Path.join(app_root_path, "mix.exs")
      else
        nil
      end

    if umbrella_mix && File.exists?(umbrella_mix) do
      content = File.read!(umbrella_mix)

      if content =~ @corex_hex_re do
        rel = rel_path_dep(umbrella_mix, corex_root)
        corex_path_dep = ~s[{:corex, path: #{inspect(rel)}, override: true}]
        new_content = String.replace(content, @corex_hex_re, corex_path_dep)
        File.write!(umbrella_mix, new_content)
      end
    end

    :ok
  end

  defp rel_path_dep(mix_exs_path, corex_root) do
    base = Path.dirname(Path.expand(mix_exs_path))
    Path.relative_to(base, Path.expand(corex_root))
  end
end
