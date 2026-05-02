defmodule Corex.New.PhxWrapper do
  @moduledoc false

  def ensure_phx_new! do
    case System.cmd("mix", ["help", "phx.new"], stderr_to_stdout: true) do
      {_, 0} ->
        :ok

      {out, _} ->
        Mix.raise("""
        Phoenix installer is not available. Install it with:

            mix archive.install hex phx_new

        #{out}
        """)
    end
  end

  @doc """
  Runs `mix phx.new <argv>` in `parent_dir` through a PTY shim (when available)
  so spinners and ANSI cursor moves render correctly. Falls back to a piped
  `Port.open` call on Windows or when `script` is unavailable.
  """
  def phx_new!(parent_dir, phx_argv) when is_binary(parent_dir) and is_list(phx_argv) do
    argv = ["phx.new" | phx_argv]
    pty_cmd_stream!(argv, parent_dir)
  end

  def run_deps_get!(install_dir) do
    Mix.shell().info([:green, "* running ", :reset, "mix deps.get in #{install_dir}"])
    pty_cmd_stream!(["deps.get"], install_dir)
    :ok
  end

  def run_assets_setup!(install_dir) do
    Mix.shell().info([:green, "* running ", :reset, "mix assets.setup in #{install_dir}"])
    pty_cmd_stream!(["assets.setup"], install_dir)
    :ok
  end

  def run_format!(install_dir) do
    Mix.shell().info([:green, "* running ", :reset, "mix format in #{install_dir}"])
    pty_cmd_stream!(["format"], install_dir)
    :ok
  end

  @doc """
  Computes the `phx.new` argv from the parsed CLI opts. `--no-install` is
  always appended (Phoenix must not fetch deps at generation time; Corex
  controls that step itself).
  """
  def build_phx_new_argv(opts, path) do
    []
    |> Kernel.++(if opts[:umbrella], do: ["--umbrella"], else: [])
    |> Kernel.++(if opts[:app], do: ["--app", opts[:app]], else: [])
    |> Kernel.++(if opts[:module], do: ["--module", opts[:module]], else: [])
    |> Kernel.++(if opts[:web_module], do: ["--web-module", opts[:web_module]], else: [])
    |> Kernel.++(if opts[:database], do: ["--database", opts[:database]], else: [])
    |> Kernel.++(if opts[:binary_id], do: ["--binary-id"], else: [])
    |> Kernel.++(if opts[:verbose], do: ["--verbose"], else: [])
    |> Kernel.++(if opts[:dashboard] == false, do: ["--no-dashboard"], else: [])
    |> Kernel.++(if opts[:prefix], do: ["--prefix", opts[:prefix]], else: [])
    |> Kernel.++(if opts[:mailer] == false, do: ["--no-mailer"], else: [])
    |> Kernel.++(if opts[:adapter], do: ["--adapter", opts[:adapter]], else: [])
    |> Kernel.++(if opts[:inside_docker_env], do: ["--inside-docker-env"], else: [])
    |> Kernel.++(if opts[:ecto] == false, do: ["--no-ecto"], else: [])
    |> Kernel.++(if opts[:live] == false, do: ["--no-live"], else: [])
    |> Kernel.++(phx_new_content_flags(opts))
    |> Kernel.++(["--no-install"])
    |> Kernel.++([path])
  end

  def pty_cmd_stream!(argv, cd) when is_list(argv) and is_binary(cd) do
    cond do
      System.find_executable("script") == nil ->
        port_cmd_stream!(argv, cd)

      :os.type() == {:unix, :darwin} ->
        run_via_system_cmd!("script", ["-q", "/dev/null", "mix" | argv], cd, argv)

      match?({:unix, _}, :os.type()) ->
        cmd = shell_join(["mix" | argv])
        run_via_system_cmd!("script", ["-qfec", cmd, "/dev/null"], cd, argv)

      true ->
        port_cmd_stream!(argv, cd)
    end
  end

  defp run_via_system_cmd!(bin, args, cd, original_argv) do
    {_, code} =
      System.cmd(bin, args,
        cd: cd,
        env: pty_subprocess_env(),
        into: IO.binstream(:stdio, 16_384),
        stderr_to_stdout: true
      )

    if code == 0 do
      :ok
    else
      Mix.raise("mix #{Enum.join(original_argv, " ")} failed (exit #{code})")
    end
  end

  defp pty_subprocess_env do
    base = System.get_env() || %{}

    base
    |> Map.put("LANG", Map.get(base, "LANG", "C.UTF-8"))
    |> Map.put("LC_ALL", Map.get(base, "LC_ALL", "C.UTF-8"))
    |> Enum.to_list()
  end

  def port_cmd_stream!(argv, cd) when is_list(argv) and is_binary(cd) do
    port =
      Port.open({:spawn_executable, System.find_executable("mix")}, [
        :binary,
        :exit_status,
        :use_stdio,
        {:cd, cd},
        {:args, argv}
      ])

    receive_port_output(port, argv)
  end

  defp receive_port_output(port, argv) do
    receive do
      {^port, {:data, data}} ->
        IO.binwrite(data)
        receive_port_output(port, argv)

      {^port, {:exit_status, 0}} ->
        :ok

      {^port, {:exit_status, code}} ->
        Mix.raise("mix #{Enum.join(argv, " ")} failed (exit #{code})")
    end
  end

  def shell_join(args) when is_list(args), do: Enum.map_join(args, " ", &shell_quote/1)

  def shell_quote(arg) when is_binary(arg) do
    if String.match?(arg, ~r/\A[A-Za-z0-9_\/.\-:=,@]+\z/) do
      arg
    else
      "'" <> String.replace(arg, "'", "'\\''") <> "'"
    end
  end

  def phx_project_path(base_path, opts) do
    expanded = Path.expand(base_path)

    if opts[:umbrella] do
      dir = Path.dirname(expanded)
      base = Path.basename(expanded)
      Path.join(dir, base <> "_umbrella")
    else
      expanded
    end
  end

  def web_project_path(phx_project_path, opts) do
    if opts[:umbrella] do
      inner =
        phx_project_path
        |> Path.basename()
        |> String.replace_suffix("_umbrella", "")

      Path.join([phx_project_path, "apps", inner <> "_web"])
    else
      phx_project_path
    end
  end

  defp phx_new_content_flags(opts) when is_list(opts) do
    for {on?, flag} <- [
          {Keyword.get(opts, :no_version_check) == true, "--no-version-check"},
          {Keyword.get(opts, :assets) == false, "--no-assets"},
          {Keyword.get(opts, :esbuild) == false, "--no-esbuild"},
          {Keyword.get(opts, :tailwind) == false, "--no-tailwind"},
          {Keyword.get(opts, :gettext) == false, "--no-gettext"},
          {Keyword.get(opts, :html) == false, "--no-html"}
        ],
        on? do
      flag
    end
  end
end
