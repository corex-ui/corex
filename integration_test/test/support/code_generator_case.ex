defmodule Corex.Integration.CodeGeneratorCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      import unquote(__MODULE__)
    end
  end

  def generate_corex_app(tmp_dir, app_name, opts \\ [])
      when is_binary(app_name) and is_list(opts) do
    app_path = Path.expand(app_name, tmp_dir)
    integration_test_root_path = Path.expand("../../", __DIR__)
    app_root_path = get_app_root_path(tmp_dir, app_name, opts)

    output =
      mix_run!(
        ["corex.new", app_path, "--no-install", "--no-version-check"] ++ opts,
        integration_test_root_path
      )

    for path <- ~w(mix.lock deps) do
      File.cp_r!(
        Path.join(integration_test_root_path, path),
        Path.join(app_root_path, path)
      )
    end

    inject_corex_path_dep(app_root_path, opts)
    mix_run!(["deps.get"], app_root_path)
    mix_run!(["compile"], app_root_path)

    {app_root_path, output}
  end

  def generate_phoenix_app(tmp_dir, app_name, opts \\ [])
      when is_binary(app_name) and is_list(opts) do
    generate_corex_app(tmp_dir, app_name, opts)
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

        Options
        cd: #{Path.expand(app_path)}
        env: #{opts |> Keyword.get(:env, []) |> inspect()}
        """
    end
  end

  def mix_run(args, app_path, opts \\ [])
      when is_list(args) and is_binary(app_path) and is_list(opts) do
    System.cmd("mix", args, [stderr_to_stdout: true, cd: Path.expand(app_path)] ++ opts)
  end

  def assert_dir(path) do
    assert File.dir?(path), "Expected #{path} to be a directory, but is not"
  end

  def assert_file(file) do
    assert File.regular?(file), "Expected #{file} to exist, but does not"
  end

  def refute_file(file) do
    refute File.regular?(file), "Expected #{file} to not exist, but it does"
  end

  def assert_file(file, match) do
    cond do
      is_list(match) ->
        assert_file(file, &Enum.each(match, fn m -> assert &1 =~ m end))

      is_binary(match) or is_struct(match, Regex) ->
        assert_file(file, &assert(&1 =~ match))

      is_function(match, 1) ->
        assert_file(file)
        match.(File.read!(file))

      true ->
        raise inspect({file, match})
    end
  end

  def assert_tests_pass(app_path) do
    mix_run!(~w(test), app_path)
  end

  def assert_passes_formatter_check(app_path) do
    mix_run!(~w(format --check-formatted), app_path)
  end

  def assert_no_compilation_warnings(app_path) do
    mix_run!(["do", "clean", "compile", "--warnings-as-errors"], app_path)
  end

  def drop_test_database(app_path) when is_binary(app_path) do
    mix_run!(["ecto.drop"], app_path, env: [{"MIX_ENV", "test"}])
  end

  def with_installer_tmp(name, opts \\ [], function)
      when is_list(opts) and is_function(function, 1) do
    autoremove? = Keyword.get(opts, :autoremove?, true)
    path = Path.join([installer_tmp_path(), random_string(10), to_string(name)])

    try do
      File.rm_rf!(path)
      File.mkdir_p!(path)
      function.(path)
    after
      if autoremove?, do: File.rm_rf!(path)
    end
  end

  defp installer_tmp_path do
    Path.expand("../../../installer/tmp", __DIR__)
  end

  def inject_before_final_end(code, code_to_inject)
      when is_binary(code) and is_binary(code_to_inject) do
    code
    |> String.trim_trailing()
    |> String.trim_trailing("end")
    |> Kernel.<>(code_to_inject)
    |> Kernel.<>("end\n")
  end

  def modify_file(path, function) when is_binary(path) and is_function(function, 1) do
    path
    |> File.read!()
    |> function.()
    |> write_file!(path)
  end

  defp write_file!(content, path) do
    File.write!(path, content)
  end

  defp inject_corex_path_dep(app_root_path, opts) do
    corex_hex_re = ~r/\{:corex,\s*"~>[^"]+"\}/
    rel_path_root = "../../../../../"

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

    rel_path_child = "../../../../../../../"

    for mix_exs <- mix_files do
      content = File.read!(mix_exs)
      if content =~ corex_hex_re do
        rel_path = if "--umbrella" in opts, do: rel_path_child, else: rel_path_root
        corex_path_dep = ~s[{:corex, path: #{inspect(rel_path)}, override: true}]
        new_content = String.replace(content, corex_hex_re, corex_path_dep)
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
      if content =~ corex_hex_re do
        corex_path_dep = ~s[{:corex, path: #{inspect(rel_path_root)}, override: true}]
        new_content = String.replace(content, corex_hex_re, corex_path_dep)
        File.write!(umbrella_mix, new_content)
      end
    end
  end

  defp get_app_root_path(tmp_dir, app_name, opts) do
    app_root_dir =
      if "--umbrella" in opts do
        app_name <> "_umbrella"
      else
        app_name
      end

    Path.expand(app_root_dir, tmp_dir)
  end

  defp random_string(len) do
    len |> :crypto.strong_rand_bytes() |> Base.url_encode64() |> binary_part(0, len)
  end

  def run_phx_server(app_root_path, port \\ nil) do
    port =
      port ||
        case :gen_tcp.listen(0, []) do
          {:ok, socket} ->
            {:ok, port} = :inet.port(socket)
            :gen_tcp.close(socket)
            port

          {:error, _} ->
            45000 + :rand.uniform(5000)
        end

    port_str = to_string(port)

    _pid =
      spawn_link(fn ->
        {_output, _exit} =
          System.cmd(
            "elixir",
            [
              "--no-halt",
              "-e",
              "spawn fn -> IO.gets([]) && System.halt(0) end",
              "-S",
              "mix",
              "phx.server"
            ],
            cd: Path.expand(app_root_path),
            env: [{"PORT", port_str}]
          )
      end)

    Process.sleep(3_000)
    port
  end

  def request_with_retries(url, retries)

  def request_with_retries(_url, 0), do: {:error, :out_of_retries}

  def request_with_retries(url, retries) do
    case url |> to_charlist() |> :httpc.request() do
      {:ok, {{_, status_code, _}, raw_headers, body}} when status_code >= 500 ->
        if retries > 1 do
          Process.sleep(2_000)
          request_with_retries(url, retries - 1)
        else
          {:ok,
           %{
             status_code: status_code,
             headers: for({k, v} <- raw_headers, do: {to_string(k), to_string(v)}),
             body: to_string(body)
           }}
        end

      {:ok, httpc_response} ->
        {{_, status_code, _}, raw_headers, body} = httpc_response

        {:ok,
         %{
           status_code: status_code,
           headers: for({k, v} <- raw_headers, do: {to_string(k), to_string(v)}),
           body: to_string(body)
         }}

      {:error, {:failed_connect, _}} ->
        Process.sleep(2_000)
        request_with_retries(url, retries - 1)

      {:error, reason} ->
        {:error, reason}
    end
  end
end
