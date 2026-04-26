defmodule Corex.New.PostGenerate do
  @moduledoc false

  alias Corex.New.Cli

  def copy_cached_build(project_path) do
    case System.fetch_env("COREX_NEW_CACHE_DIR") do
      {:ok, cache_dir} ->
        if File.exists?(cache_dir) do
          Mix.shell().info("Copying cached build from #{cache_dir}")
          System.cmd("cp", ["-Rp", Path.join(cache_dir, "."), project_path])
        end

      :error ->
        :ok
    end
  end

  def seed_starter_gettext!(install_dir) do
    for name <- ~w(default.po errors.po) do
      en = Path.join([install_dir, "priv", "gettext", "en", "LC_MESSAGES", name])

      if File.exists?(en) do
        text = File.read!(en)

        for code <- ~w(fr ar) do
          out = Path.join([install_dir, "priv", "gettext", code, "LC_MESSAGES", name])
          File.mkdir_p!(Path.dirname(out))
          File.write!(out, String.replace(text, "Language: en", "Language: #{code}"))
        end
      end
    end

    :ok
  end

  def init_git(project_path) do
    if git_available?() and not inside_git_repo?(project_path) do
      Mix.shell().info([:green, "* initializing git repository", :reset])

      case System.cmd("git", ["init"], cd: project_path) do
        {_output, 0} ->
          :ok

        {output, _} ->
          Mix.shell().error("Failed to initialize git repository: #{output}")
      end
    end
  end

  def prompt_install(phx_root, install_dir, opts) do
    install? =
      Keyword.get_lazy(opts, :install, fn ->
        Mix.shell().yes?("\nFetch and install dependencies?")
      end)

    cd_hint = Cli.relative_to_cwd_hint(phx_root)

    if install? do
      Mix.shell().info([:green, "* running ", :reset, "mix deps.get"])
      {_, 0} = System.cmd("mix", ["deps.get"], cd: phx_root, stderr_to_stdout: true)

      Mix.shell().info([:green, "* running ", :reset, "mix assets.setup"])
      {_, 0} = System.cmd("mix", ["assets.setup"], cd: install_dir, stderr_to_stdout: true)
    else
      Mix.shell().info("""

      Next steps:

          $ cd #{cd_hint}
          $ mix deps.get
          $ cd #{Cli.relative_to_cwd_hint(install_dir)}
          $ mix assets.setup
      """)
    end

    Mix.shell().info("""

    Start the app:

        $ mix phx.server
    """)
  end

  defp git_available? do
    case System.find_executable("git") do
      nil -> false
      _path -> true
    end
  end

  defp inside_git_repo?(path) do
    case System.cmd("git", ["status"], cd: path, stderr_to_stdout: true) do
      {_output, 0} -> true
      _ -> false
    end
  rescue
    _ -> false
  end
end
