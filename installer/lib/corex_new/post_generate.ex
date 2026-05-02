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

    Mix.shell().info(next_steps_message(cd_hint, install?, opts))
  end

  defp next_steps_message(cd_hint, install?, opts) do
    indent = "    "
    ecto? = Keyword.get(opts, :ecto, true)
    lang? = Keyword.get(opts, :lang, false)

    initial =
      IO.iodata_to_binary([
        "\nWe are almost there! The following steps are missing:\n\n",
        "#{indent}$ cd #{cd_hint}\n",
        if(install?, do: "", else: "#{indent}$ mix deps.get\n")
      ])

    database_block =
      if ecto? do
        IO.iodata_to_binary([
          "\nThen configure your database in config/dev.exs and run:\n\n",
          "#{indent}$ mix ecto.create\n"
        ])
      else
        ""
      end

    assets_block =
      IO.iodata_to_binary([
        "\nThen setup and build your assets:\n\n",
        "#{indent}$ mix assets.setup\n",
        "#{indent}$ mix assets.build\n"
      ])

    localize_block =
      if lang? do
        IO.iodata_to_binary([
          "\nOptionally you can download Localize locales:\n\n",
          "#{indent}$ mix localize.download_locales\n"
        ])
      else
        ""
      end

    server_block =
      IO.iodata_to_binary([
        "\nStart your Phoenix app with:\n\n",
        "#{indent}$ mix phx.server\n",
        "\nYou can also run your app inside IEx (Interactive Elixir) as:\n\n",
        "#{indent}$ iex -S mix phx.server\n"
      ])

    IO.iodata_to_binary([
      initial,
      database_block,
      assets_block,
      localize_block,
      server_block
    ])
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
