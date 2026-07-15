defmodule Corex.New.Tableau.PostGenerate do
  @moduledoc false

  alias Corex.New.{Cli, PhxWrapper}

  def run(project_path, opts) do
    init_git(project_path)
    prompt_install(project_path, opts)
  end

  defp init_git(project_path) do
    if git_available?() and not inside_git_repo?(project_path) do
      Mix.shell().info([:green, "* initializing git repository", :reset])

      case System.cmd("git", ["init"], cd: project_path) do
        {_output, 0} -> :ok
        {output, _} -> Mix.shell().error("Failed to initialize git repository: #{output}")
      end
    end
  end

  defp prompt_install(project_path, opts) do
    install? =
      Keyword.get_lazy(opts, :install, fn ->
        Mix.shell().yes?("\nFetch and install dependencies?")
      end)

    cd_hint = Cli.relative_to_cwd_hint(project_path)

    if install? do
      PhxWrapper.run_deps_get!(project_path)

      if Keyword.get(opts, :design, false) do
        build_design_assets!(project_path)
      end
    end

    Mix.shell().info(next_steps_message(cd_hint, install?, opts))
  end

  defp build_design_assets!(project_path) do
    Mix.shell().info([:green, "* building ", :reset, "Corex design -> assets/corex/"])

    {_streamed, exit_code} =
      System.cmd(
        "mix",
        ["corex.design.build"],
        cd: project_path,
        stderr_to_stdout: true,
        into: PhxWrapper.mix_cmd_into()
      )

    if exit_code != 0 do
      Mix.raise("Failed to build Corex design assets (exit #{exit_code})")
    end

    :ok
  end

  defp next_steps_message(cd_hint, install?, opts) do
    indent = "    "
    design? = Keyword.get(opts, :design, true)

    initial =
      IO.iodata_to_binary([
        "\nWe are almost there! The following steps are missing:\n\n",
        "#{indent}$ cd #{cd_hint}\n",
        if(install?, do: "", else: "#{indent}$ mix deps.get\n")
      ])

    assets_block =
      IO.iodata_to_binary([
        "\nThen setup and build your assets:\n\n",
        "#{indent}$ mix setup\n",
        if(design? and not install?, do: "#{indent}$ mix corex.design.build\n", else: ""),
        "#{indent}$ mix assets.build\n"
      ])

    server_block =
      IO.iodata_to_binary([
        "\nStart the Tableau dev server with live reload:\n\n",
        "#{indent}$ mix tableau.server\n",
        "\nBuild the static site for production:\n\n",
        "#{indent}$ mix build\n"
      ])

    IO.iodata_to_binary([initial, assets_block, server_block])
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
