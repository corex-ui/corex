defmodule Corex.New.PostGenerate do
  @moduledoc false

  alias Corex.New.{Cli, PhxWrapper}

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

  def prompt_install(phx_root, _install_dir, opts) do
    install? =
      Keyword.get_lazy(opts, :install, fn ->
        Mix.shell().yes?("\nFetch and install dependencies?")
      end)

    cd_hint = Cli.relative_to_cwd_hint(phx_root)

    if install? do
      PhxWrapper.run_deps_get!(phx_root)
    end

    next_steps =
      if install? do
        """

        Next steps:

            $ cd #{cd_hint}
            $ mix assets.setup
        """
      else
        """

        Next steps:

            $ cd #{cd_hint}
            $ mix deps.get
            $ mix assets.setup
        """
      end

    Mix.shell().info(next_steps)

    Mix.shell().info("""

    Start the app:

        $ cd #{cd_hint}
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
