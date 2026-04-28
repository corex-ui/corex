defmodule Corex.New.PhxWrapper do
  @moduledoc false

  def ensure_phx_new! do
    unless Mix.Task.get("phx.new") do
      Mix.raise("""
      Phoenix installer is not available. Install it with:

          mix archive.install hex phx_new
      """)
    end
  end

  def ensure_phx_new_web! do
    unless Mix.Task.get("phx.new.web") do
      Mix.raise("""
      Phoenix web installer is not available. Install it with:

          mix archive.install hex phx_new
      """)
    end
  end

  def ensure_igniter_new! do
    case System.cmd("mix", ["help", "igniter.new"], stderr_to_stdout: true) do
      {_, 0} ->
        :ok

      {out, _} ->
        Mix.raise("""
        Igniter is not available. Install it with:

            mix archive.install hex igniter_new

        #{out}
        """)
    end
  end

  def ensure_igniter_install! do
    unless Mix.Task.get("igniter.install") do
      Mix.raise("""
      Igniter is not available. Install it with:

          mix archive.install hex igniter_new
      """)
    end
  end

  @doc false
  def igniter_install_yes_argv do
    if interactive_yes?() do
      []
    else
      ["--yes", "--yes-to-deps"]
    end
  end

  @doc """
  Yes-flag argv to pass to `mix igniter.new`. `igniter.new` auto-forwards
  `--yes-to-deps` to its inner `igniter.install`, so we only need `--yes`.
  """
  def igniter_new_yes_argv do
    if interactive_yes?() do
      []
    else
      ["--yes"]
    end
  end

  defp interactive_yes? do
    System.get_env("MIX_COREX_IGNITER_INTERACTIVE") == "1" and is_nil(System.get_env("CI"))
  end

  @doc """
  Runs `mix igniter.new APP --install <pkg> --with <task> --with-args="<args>" ...`
  through a PTY shim (when available) so spinners and ANSI cursor moves
  render correctly. Falls back to a piped `Port.open` call on Windows or
  when `script` is unavailable.
  """
  def igniter_new_install!(parent_dir, app_path, pkg, with_task, with_args_str, igniter_extra)
      when is_binary(parent_dir) and is_binary(app_path) and is_binary(pkg) and
             is_binary(with_task) and is_binary(with_args_str) and is_list(igniter_extra) do
    argv = build_igniter_new_argv(app_path, pkg, with_task, with_args_str, igniter_extra)
    pty_cmd_stream!(argv, parent_dir)
  end

  @doc false
  def build_igniter_new_argv(app_path, pkg, with_task, with_args_str, igniter_extra)
      when is_binary(app_path) and is_binary(pkg) and is_binary(with_task) and
             is_binary(with_args_str) and is_list(igniter_extra) do
    base = ["igniter.new", app_path, "--install", pkg, "--with", with_task]

    base =
      if with_args_str == "" do
        base
      else
        base ++ ["--with-args", with_args_str]
      end

    base ++ igniter_new_yes_argv() ++ ["--no-installer-version-check"] ++ igniter_extra
  end

  @doc """
  Joins phx.new flags into a single string suitable for `--with-args`.
  Igniter.new uses `OptionParser.split/1` to parse this string, so plain
  space-separated flags work; values containing whitespace, quotes, or
  shell-significant characters are POSIX-quoted.
  """
  def build_with_args_string(args) when is_list(args), do: Enum.map_join(args, " ", &shell_quote/1)

  @doc false
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

  @doc false
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

  @doc false
  def shell_join(args) when is_list(args), do: Enum.map_join(args, " ", &shell_quote/1)

  @doc false
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

  def in_umbrella?(app_path) do
    umbrella = Path.expand(Path.join([app_path, "..", ".."]))
    mix_path = Path.join(umbrella, "mix.exs")
    apps_path = Path.join(umbrella, "apps")

    File.exists?(mix_path) && File.exists?(apps_path)
  end

  def build_phx_new_argv(opts, base_path) do
    path = phx_project_path(base_path, opts)

    []
    |> Kernel.++(if opts[:umbrella], do: ["--umbrella"], else: [])
    |> Kernel.++(if opts[:app], do: ["--app", opts[:app]], else: [])
    |> Kernel.++(if opts[:module], do: ["--module", opts[:module]], else: [])
    |> Kernel.++(if opts[:web_module], do: ["--web-module", opts[:web_module]], else: [])
    |> Kernel.++(if opts[:database], do: ["--database", opts[:database]], else: [])
    |> Kernel.++(if opts[:binary_id], do: ["--binary-id"], else: [])
    |> Kernel.++(if opts[:verbose], do: ["--verbose"], else: [])
    |> Kernel.++(if opts[:dashboard] == false, do: ["--no-dashboard"], else: [])
    |> Kernel.++(if opts[:install] == false, do: ["--no-install"], else: [])
    |> Kernel.++(if opts[:prefix], do: ["--prefix", opts[:prefix]], else: [])
    |> Kernel.++(if opts[:mailer] == false, do: ["--no-mailer"], else: [])
    |> Kernel.++(if opts[:adapter], do: ["--adapter", opts[:adapter]], else: [])
    |> Kernel.++(if opts[:inside_docker_env], do: ["--inside-docker-env"], else: [])
    |> Kernel.++(if opts[:ecto] == false, do: ["--no-ecto"], else: [])
    |> Kernel.++(if opts[:live] == false, do: ["--no-live"], else: [])
    |> Kernel.++(if opts[:dev], do: ["--dev"], else: [])
    |> then(&(&1 ++ phx_new_content_flags(opts)))
    |> Kernel.++([path])
  end

  def build_phx_new_with_args(opts) do
    opts
    |> build_phx_new_argv("__corex_new__")
    |> List.delete_at(-1)
  end

  @doc false
  def phx_new_content_flags(opts) when is_list(opts) do
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

  def build_phx_new_web_argv(opts, app_name) do
    []
    |> Kernel.++(if opts[:app], do: ["--app", opts[:app]], else: [])
    |> Kernel.++(if opts[:module], do: ["--module", opts[:module]], else: [])
    |> Kernel.++(if opts[:web_module], do: ["--web-module", opts[:web_module]], else: [])
    |> Kernel.++(if opts[:database], do: ["--database", opts[:database]], else: [])
    |> Kernel.++(if opts[:binary_id], do: ["--binary-id"], else: [])
    |> Kernel.++(if opts[:verbose], do: ["--verbose"], else: [])
    |> Kernel.++(if opts[:dashboard] == false, do: ["--no-dashboard"], else: [])
    |> Kernel.++(if opts[:install] == false, do: ["--no-install"], else: [])
    |> Kernel.++(if opts[:prefix], do: ["--prefix", opts[:prefix]], else: [])
    |> Kernel.++(if opts[:mailer] == false, do: ["--no-mailer"], else: [])
    |> Kernel.++(if opts[:adapter], do: ["--adapter", opts[:adapter]], else: [])
    |> Kernel.++(if opts[:inside_docker_env], do: ["--inside-docker-env"], else: [])
    |> Kernel.++(if opts[:ecto] == false, do: ["--no-ecto"], else: [])
    |> Kernel.++(if opts[:live] == false, do: ["--no-live"], else: [])
    |> Kernel.++(if opts[:dev], do: ["--dev"], else: [])
    |> then(&(&1 ++ phx_new_content_flags(opts)))
    |> Kernel.++([app_name])
  end

  def build_phx_new_web_with_args(opts) do
    opts
    |> build_phx_new_web_argv("__corex_new__")
    |> List.delete_at(-1)
  end

  def corex_igniter_install_target(opts) do
    case igniter_dev_corex_path(opts) do
      {:ok, rel} ->
        "corex@path:#{normalize_mix_path(rel)}"

      :no_path ->
        "corex"
    end
  end

  defp igniter_dev_corex_path(opts) do
    v = opts[:dev_corex]

    if is_binary(v) and String.trim(v) != "" do
      {:ok, String.trim(v)}
    else
      :no_path
    end
  end

  defp normalize_mix_path(p), do: String.replace(p, "\\", "/")

  def run_deps_get!(install_dir) do
    Mix.shell().info([
      :green,
      "* running ",
      :reset,
      "mix deps.get in #{install_dir}"
    ])

    pty_cmd_stream!(["deps.get"], install_dir)
    :ok
  end

  def run_format!(install_dir) do
    Mix.shell().info([
      :green,
      "* running ",
      :reset,
      "mix format in #{install_dir}"
    ])

    pty_cmd_stream!(["format"], install_dir)
    :ok
  end
end
