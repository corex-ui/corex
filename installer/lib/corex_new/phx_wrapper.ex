defmodule Corex.New.PhxWrapper do
  @moduledoc false

  alias Corex.New.ManualInstall

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

  @doc false
  def igniter_install_yes_argv do
    if System.get_env("MIX_COREX_IGNITER_INTERACTIVE") == "1" and
         is_nil(System.get_env("CI")) do
      []
    else
      ["--yes", "--yes-to-deps"]
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

  @igniter_dep_version ~S("~> 0.6")

  def phx_new_then_igniter_install!(parent_dir, install_dir, phx_new_argv, pkg, igniter_extra, new_with)
      when is_binary(parent_dir) and is_binary(install_dir) and is_list(phx_new_argv) and
             is_binary(pkg) and is_list(igniter_extra) and is_binary(new_with) do
    mix_cmd_stream!(phx_new_argv, parent_dir)
    add_igniter_to_mix_exs!(install_dir)
    inst = ["igniter.install", pkg] ++ igniter_trailing_for_new(new_with, igniter_extra)
    mix_cmd_stream!(inst, install_dir)
  end

  def igniter_trailing_for_new(new_with, igniter_extra)
      when is_binary(new_with) and is_list(igniter_extra) do
    from_new = from_igniter_new(new_with)
    igniter_install_yes_argv() ++ from_new ++ igniter_extra
  end

  defp from_igniter_new(new_with) when is_binary(new_with) do
    ["--from-igniter-new", "--new-with", new_with]
  end

  def add_igniter_to_mix_exs!(dir) when is_binary(dir) do
    path = Path.join(dir, "mix.exs")
    contents = File.read!(path)

    if String.contains?(contents, "{:igniter") do
      :ok
    else
      new =
        if String.contains?(contents, "defp deps do\n []") do
          String.replace(
            contents,
            "defp deps do\n []",
            "defp deps do\n [{:igniter, #{@igniter_dep_version}, only: [:dev, :test]}]"
          )
        else
          String.replace(
            contents,
            "defp deps do\n [\n",
            "defp deps do\n [\n {:igniter, #{@igniter_dep_version}, only: [:dev, :test]},\n"
          )
        end

      File.write!(path, new |> Code.format_string!())
    end
  end

  def mix_cmd_stream!(args, cd) when is_list(args) and is_binary(cd) do
    port =
      Port.open({:spawn_executable, System.find_executable("mix")}, [
        :binary,
        :exit_status,
        :use_stdio,
        {:cd, cd},
        {:args, args}
      ])

    output =
      receive_port_output(port, args, [])
      |> IO.iodata_to_binary()

    output
  end

  defp receive_port_output(port, args, acc) do
    receive do
      {^port, {:data, data}} ->
        Mix.shell().info(data)
        receive_port_output(port, args, [acc, data])

      {^port, {:exit_status, 0}} ->
        acc

      {^port, {:exit_status, code}} ->
        output = IO.iodata_to_binary(acc)
        Mix.raise("mix #{Enum.join(args, " ")} failed (exit #{code})\n\n#{output}")
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
          {Keyword.get(opts, :html) == false, "--no-html"},
          {Keyword.get(opts, :skills) == false, "--no-agents-md"}
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

  def verify_corex_esbuild_after_igniter!(install_dir, igniter_output) do
    if igniter_corex_install_failed?(igniter_output) do
      Mix.raise("""
      mix igniter.install finished but `corex.install` failed (see Igniter output below). Fix that before checking esbuild flags.

      #{igniter_output}
      #{ManualInstall.hint()}
      """)
    end

    config_path = Path.join(install_dir, "config/config.exs")

    if File.exists?(config_path) do
      case File.read(config_path) do
        {:ok, body} ->
          if String.contains?(body, "config :esbuild") and
               not String.contains?(body, "--format=esm") do
            Mix.raise("""
            mix igniter.install corex exited successfully but did not add esbuild ESM flags (`--format=esm`).

            This usually means the `corex` Hex release in the new app is too old to ship `Mix.Tasks.Corex.Install` (the Igniter installer was missing from the package). Upgrade `corex` in the generated project to at least **0.1.0-beta.1**, then from the project directory run:

                mix igniter.install corex --yes

            If you are testing locally, regenerate with `mix corex.new ... --dev_corex ../corex` (or another path) or run `mix igniter.install corex@path:../corex --yes` from the project.

            Igniter output (for reference):

            #{igniter_output}
            #{ManualInstall.hint()}
            """)
          end

        _ ->
          :ok
      end
    end

    :ok
  end

  defp igniter_corex_install_failed?(out) when is_binary(out) do
    plain = Regex.replace(~r/\e\[[0-9;]*m/, out, "")

    String.contains?(plain, "`corex.install` x") or
      (String.contains?(plain, "Issues:") and String.contains?(plain, "* Required") and
         String.contains?(plain, "did not exist"))
  end

  defp igniter_corex_install_failed?(_), do: false

  def run_deps_get!(install_dir) do
    Mix.shell().info([
      :green,
      "* running ",
      :reset,
      "mix deps.get in #{install_dir}"
    ])

    mix_cmd_stream!(["deps.get"], install_dir)
    :ok
  end

  def run_format!(install_dir) do
    Mix.shell().info([
      :green,
      "* running ",
      :reset,
      "mix format in #{install_dir}"
    ])

    mix_cmd_stream!(["format"], install_dir)
    :ok
  end

  # This used to call a standalone Mix task, but patching is now handled by the installer.
end
