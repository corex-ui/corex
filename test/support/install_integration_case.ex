defmodule CorexTest.InstallIntegrationCase do
  @moduledoc false

  def run_phoenix_project(tmp_dir, app_name \\ "demo") when is_binary(app_name) do
    project_dir = Path.join(tmp_dir, app_name)
    cwd = File.cwd!()

    {_, 0} =
      System.cmd("mix", ["phx.new", project_dir, "--no-ecto", "--no-mailer", "--no-install"],
        cd: cwd
      )

    env = System.get_env() |> Map.put("MIX_ENV", "dev") |> Map.to_list()
    {_, 0} = System.cmd("mix", ["deps.get"], cd: project_dir, env: env)
    {_, 0} = System.cmd("mix", ["compile"], cd: project_dir, env: env)

    project_dir
  end

  def run_corex_install(project_dir, corex_path, args, opts \\ []) do
    env = Keyword.get(opts, :env, System.get_env() |> Map.put("MIX_ENV", "dev") |> Map.to_list())

    System.cmd(
      "mix",
      ["igniter.install", "corex@path:#{corex_path}", "--yes" | args],
      cd: project_dir,
      env: env
    )
  end

  def mix_run!(args, app_path, opts \\ [])
      when is_list(args) and is_binary(app_path) and is_list(opts) do
    case mix_run(args, app_path, opts) do
      {output, 0} ->
        output

      {output, exit_code} ->
        raise """
        mix command failed with exit code: #{inspect(exit_code)}

        mix #{Enum.join(args, " ")}

        #{output}

        Options:
          cd: #{Path.expand(app_path)}
          env: #{Keyword.get(opts, :env, []) |> inspect()}
        """
    end
  end

  def mix_run(args, app_path, opts \\ [])
      when is_list(args) and is_binary(app_path) and is_list(opts) do
    System.cmd("mix", args, [stderr_to_stdout: true, cd: Path.expand(app_path)] ++ opts)
  end

  def assert_tests_pass(app_path) do
    mix_run!(~w(test), app_path)
  end

  def assert_passes_formatter_check(app_path) do
    mix_run!(~w(format --check-formatted), app_path)
  end

  def format_project(app_path) do
    mix_run!(~w(format), app_path)
  end

  def assert_no_compilation_warnings(app_path) do
    mix_run!(["do", "clean", "compile", "--warnings-as-errors"], app_path)
  end
end
