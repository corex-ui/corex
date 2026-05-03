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
    local_corex = Path.expand("../../..", __DIR__)

    dev_argv =
      if "--dev_corex" in opts or "--dev-corex" in opts do
        []
      else
        ["--dev", local_corex]
      end

    output =
      mix_run!(
        ["corex.new", app_path, "--no-install", "--no-version-check"] ++
          dev_argv ++ opts,
        integration_test_root_path
      )

    mix_lock_src = Path.join(integration_test_root_path, "mix.lock")
    mix_lock_dst = Path.join(app_root_path, "mix.lock")
    File.cp!(mix_lock_src, mix_lock_dst)

    inject_corex_path_dep(app_root_path, opts)
    mix_run!(["deps.get"], app_root_path)
    mix_run!(["compile"], app_root_path)
    mix_run!(["format"], app_root_path)

    {app_root_path, output}
  end

  def generate_corex_app_dev_corex(tmp_dir, app_name, opts \\ [])
      when is_binary(app_name) and is_list(opts) do
    app_path = Path.expand(app_name, tmp_dir)
    integration_test_root_path = Path.expand("../../", __DIR__)
    app_root_path = get_app_root_path(tmp_dir, app_name, opts)
    corex_root = Path.expand("../../..", __DIR__)

    mix_exs = Path.join(corex_root, "mix.exs")

    unless File.exists?(mix_exs) and File.read!(mix_exs) =~ ~r/\bapp:\s*:corex\b/ do
      raise "expected Corex repo at #{corex_root} (mix.exs with app: :corex)"
    end

    output =
      mix_run!(
        [
          "corex.new",
          app_path,
          "--no-install",
          "--no-version-check",
          "--no-design",
          "--dev",
          corex_root
        ] ++ opts,
        integration_test_root_path
      )

    unless output =~ "mix phx.new" and output =~ "installing Corex" do
      raise "expected corex.new to run phx.new and install Corex, but output did not include it"
    end

    inject_corex_path_dep(app_root_path, opts)
    mix_run!(["deps.get"], app_root_path)
    mix_run!(["compile"], app_root_path)
    mix_run!(["format"], app_root_path)

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

  def refute_dir(path) do
    refute File.dir?(path), "Expected #{path} to not be a directory, but it exists"
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
    port = 45000 + :rand.uniform(5000)

    mix_run!(
      ~w(test --timeout 600000),
      app_path,
      env: [{"PORT", to_string(port)}]
    )
  end

  def assert_passes_formatter_check(app_path) do
    mix_run!(~w(format --check-formatted), app_path)
  end

  def assert_assets_build_pass(app_path) do
    mix_run!(["assets.build"], app_path, env: [{"MIX_ENV", "dev"}])
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

  @home_route_anchor "get \"/\", PageController, :home\n"
  @example_live_line "live \"/live\", ExampleLive\n"

  def inject_live_routes(router_path, live_routes, opts \\ []) do
    content = File.read!(router_path)

    if Keyword.get(opts, :locale_scope) do
      new_content =
        cond do
          String.contains?(content, @home_route_anchor) ->
            String.replace(content, @home_route_anchor, @home_route_anchor <> live_routes,
              global: true
            )

          String.contains?(content, @example_live_line) ->
            String.replace(content, @example_live_line, @example_live_line <> live_routes,
              global: false
            )

          true ->
            inject_before_final_end(content, live_routes)
        end

      File.write!(router_path, new_content)
    else
      new_content = inject_before_final_end(content, live_routes)
      File.write!(router_path, new_content)
    end
  end

  def inject_resources(router_path, resources_routes, opts \\ []) do
    content = File.read!(router_path)

    if Keyword.get(opts, :locale_scope) do
      new_content =
        if String.contains?(content, @home_route_anchor) do
          String.replace(content, @home_route_anchor, @home_route_anchor <> resources_routes,
            global: true
          )
        else
          parts = String.split(content, ~r/scope "\/:locale"/, parts: 2)

          if length(parts) == 2 do
            [head, locale_block] = parts
            get_pattern = @home_route_anchor
            locale_parts = String.split(locale_block, get_pattern, parts: 2)

            if length(locale_parts) == 2 do
              [before_get, after_get] = locale_parts
              new_locale_block = before_get <> get_pattern <> resources_routes <> after_get
              head <> "scope \"/:locale\"" <> new_locale_block
            else
              inject_before_final_end(content, resources_routes)
            end
          else
            inject_before_final_end(content, resources_routes)
          end
        end

      File.write!(router_path, new_content)
    else
      new_content = inject_before_final_end(content, resources_routes)
      File.write!(router_path, new_content)
    end
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
    dev_env = [{"MIX_ENV", "dev"} | dev_database_env_from_system()]

    mix_run!(["ecto.create"], app_root_path, env: dev_env)
    mix_run!(["ecto.migrate"], app_root_path, env: dev_env)

    server_env = [{"PORT", port_str} | dev_env]

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
            env: server_env
          )
      end)

    Process.sleep(10_000)
    port
  end

  defp dev_database_env_from_system do
    Enum.flat_map(
      ~w(DATABASE_URL PGHOST PGUSER PGPASSWORD PGPORT PGDATABASE),
      fn key ->
        case System.get_env(key) do
          nil -> []
          val -> [{key, val}]
        end
      end
    )
  end

  def request_with_retries(_url, 0), do: {:error, :out_of_retries}

  def request_with_retries(url, retries) do
    url = String.replace(url, "://localhost", "://127.0.0.1")

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

  @doc """
  `mix corex.new` default (replace on, design on): JS hooks, design assets, home wrapped in
  `Layouts.app`, generator-related Corex component imports (including `select.css`), no mode
  toggle import, and Phoenix daisyUI plugins stripped from `app.css`.
  """
  def assert_corex_greenfield_file_invariants!(app_root, app_name, opts \\ [])
      when is_binary(app_root) and is_binary(app_name) and is_list(opts) do
    base = app_base_path(app_root, app_name, opts)
    web = "#{app_name}_web"

    app_js = Path.join([base, "assets", "js", "app.js"])

    assert_file(app_js, fn c ->
      assert c =~ ~r/import corex from /
      assert c =~ ~r/"corex"|corex\.mjs/
    end)

    assert_file(app_js, fn c -> assert c =~ ~r/\.\.\.corex/ end)

    app_css = Path.join([base, "assets", "css", "app.css"])

    assert_file(app_css, fn c ->
      assert c =~ ~s(@import "../corex/main.css";)
      assert c =~ ~s(@import "../corex/theme/neo.css";)
      refute c =~ "toggle-group.css"
      assert c =~ ~s(@import "../corex/components/select.css";)
      assert c =~ ~s(@import "../corex/components/data-table.css";)
    end)

    assert_file(app_css, fn c ->
      refute c =~ ~r/@plugin\s+["'][^"']*vendor\/daisyui/
    end)

    design_dir = Path.join([base, "assets", "corex"])
    assert_dir(design_dir)
    refute_dir(Path.join(design_dir, "design"))

    home = Path.join([base, "lib", web, "controllers", "page_html", "home.html.heex"])

    assert_file(home, fn c ->
      assert c =~ ~r/<Layouts\.app[\s\n]/
      refute c =~ "Layouts.flash_group"
      refute c =~ "Layouts.theme_toggle"
    end)
  end

  def assert_corex_lang_path_plug_invariants!(app_root, app_name, opts \\ [])
      when is_binary(app_root) and is_binary(app_name) and is_list(opts) do
    base = app_base_path(app_root, app_name, opts)
    web = "#{app_name}_web"
    router = Path.join([base, "lib", web, "router.ex"])

    assert_file(router, fn c ->
      assert c =~ "Localize.Plug.PutLocale"
      assert c =~ ~s(scope "/:locale")
    end)

    assert_file(Path.join([base, "lib", web, "locale.ex"]))
    assert_file(Path.join([base, "lib", web, "hooks", "layout.ex"]))
  end

  @doc """
  `mix corex.new …` with design off (`--no-design`, i.e. `design: false`): no copied design tree from `mix corex.design`.
  """
  def assert_corex_no_design_skipped!(app_root, app_name, opts \\ [])
      when is_binary(app_root) and is_binary(app_name) and is_list(opts) do
    base = app_base_path(app_root, app_name, opts)
    design_dir = Path.join([base, "assets", "corex"])
    refute_dir(design_dir)
  end

  @doc """
  Replace mode with design off (`--no-design`): ESM hooks + wrapped home, no
  `assets/corex` and no Corex design `@import` block in `app.css`.
  """
  def assert_corex_no_design_replace_invariants!(app_root, app_name, opts \\ [])
      when is_binary(app_root) and is_binary(app_name) and is_list(opts) do
    assert_corex_no_design_skipped!(app_root, app_name, opts)

    base = app_base_path(app_root, app_name, opts)
    web = "#{app_name}_web"

    app_js = Path.join([base, "assets", "js", "app.js"])

    assert_file(app_js, fn c ->
      assert c =~ ~r/import corex from /
      assert c =~ ~r/"corex"|corex\.mjs/
    end)

    assert_file(app_js, fn c -> assert c =~ ~r/\.\.\.corex/ end)

    app_css = Path.join([base, "assets", "css", "app.css"])
    assert_file(app_css, fn c -> refute c =~ ~s(@import "../corex/main.css") end)

    home = Path.join([base, "lib", web, "controllers", "page_html", "home.html.heex"])

    assert_file(home, fn c ->
      assert c =~ ~r/<Layouts\.app[\s\n]/
      refute c =~ "Layouts.flash_group"
    end)
  end

  defp app_base_path(app_root, app_name, opts) do
    if "--umbrella" in opts do
      Path.join([app_root, "apps", app_name])
    else
      app_root
    end
  end

  @doc """
  Asserts that when design is enabled, the generated `Layouts` module includes the design
  layout primitives (`layout__header`, `layout__header__content`, `layout__footer`) in `Layouts.app/1`.
  """
  def assert_corex_design_layout_classes_present!(app_root, app_name, opts \\ [])
      when is_binary(app_root) and is_binary(app_name) and is_list(opts) do
    base = app_base_path(app_root, app_name, opts)
    web = "#{app_name}_web"

    layouts = Path.join([base, "lib", web, "components", "layouts.ex"])

    assert_file(layouts, fn c ->
      assert c =~ ~r/def\s+app\b[\s\S]*?class="layout__header"/,
             "Layouts.app missing layout__header"

      assert c =~ ~r/def\s+app\b[\s\S]*?class="layout__header__content"/,
             "Layouts.app missing layout__header__content"

      assert c =~ ~r/def\s+app\b[\s\S]*?class="layout__footer"/,
             "Layouts.app missing layout__footer"
    end)
  end
end
