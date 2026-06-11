defmodule Corex.Integration.CodeGeneratorCase do
  @moduledoc false
  use ExUnit.CaseTemplate

  using do
    quote do
      import unquote(__MODULE__)
    end
  end

  def generate_corex_app(tmp_dir, app_name, opts \\ [])
      when is_binary(app_name) and is_list(opts) do
    app_path = Path.expand(app_name, tmp_dir)
    integration_root = Corex.Integration.Paths.integration_root()
    app_root_path = get_app_root_path(tmp_dir, app_name, opts)
    local_corex = Corex.Integration.Paths.corex_repo_root()

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
        integration_root
      )

    Corex.Integration.CorexPathDep.inject(app_root_path, opts)

    Corex.Integration.ArtifactSync.copy_hex_artifacts_from_integration!(
      integration_root,
      app_root_path
    )

    mix_run!(["deps.get"], app_root_path)
    mix_run!(["compile"], app_root_path)
    mix_run!(["format"], app_root_path)

    {app_root_path, output}
  end

  def generate_corex_app_dev_corex(tmp_dir, app_name, opts \\ [])
      when is_binary(app_name) and is_list(opts) do
    app_path = Path.expand(app_name, tmp_dir)
    integration_root = Corex.Integration.Paths.integration_root()
    app_root_path = get_app_root_path(tmp_dir, app_name, opts)
    corex_root = Corex.Integration.Paths.corex_repo_root()

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
        integration_root
      )

    unless output =~ "mix phx.new" and output =~ "installing Corex" do
      raise "expected corex.new to run phx.new and install Corex, but output did not include it"
    end

    Corex.Integration.CorexPathDep.inject(app_root_path, opts)

    Corex.Integration.ArtifactSync.copy_hex_artifacts_from_integration!(
      integration_root,
      app_root_path
    )

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
    env = opts |> Keyword.get(:env, []) |> merge_hex_home_env()

    System.cmd(
      "mix",
      args,
      [stderr_to_stdout: true, cd: Path.expand(app_path), env: env] ++
        Keyword.delete(opts, :env)
    )
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
    refute File.regular?(file), "Expected #{file} to not exist, but it exists"
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
    mix_run!(
      ~w(test --timeout 600000),
      app_path,
      env: test_env(app_path)
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
    if ecto_app?(app_path) do
      mix_run!(["ecto.drop"], app_path, env: test_env(app_path))
    end
  end

  defp test_env(app_path) when is_binary(app_path) do
    port = 45_000 + :rand.uniform(5000)
    partition = app_path |> :erlang.phash2() |> Integer.to_string()

    [
      {"PORT", to_string(port)},
      {"MIX_ENV", "test"},
      {"MIX_TEST_PARTITION", partition}
    ]
    |> Kernel.++(Corex.Integration.HttpSmoke.dev_database_env_from_system())
  end

  def with_installer_tmp(name, opts \\ [], function)
      when is_list(opts) and is_function(function, 1) do
    autoremove? = Keyword.get(opts, :autoremove?, true)

    path =
      Path.join([
        Corex.Integration.Paths.installer_tmp_root(),
        random_string(10),
        to_string(name)
      ])

    hex_home = Path.join(path, ".hex")
    previous_hex_home = Process.get(:corex_integration_hex_home)

    try do
      File.rm_rf!(path)
      File.mkdir_p!(hex_home)
      Process.put(:corex_integration_hex_home, hex_home)
      function.(path)
    after
      case previous_hex_home do
        nil -> Process.delete(:corex_integration_hex_home)
        prev -> Process.put(:corex_integration_hex_home, prev)
      end

      if autoremove?, do: File.rm_rf!(path)
    end
  end

  def inject_before_final_end(code, code_to_inject) do
    Corex.Integration.RouterPatch.inject_before_final_end(code, code_to_inject)
  end

  def inject_live_routes(router_path, live_routes, opts \\ []) do
    Corex.Integration.RouterPatch.inject_live_routes(router_path, live_routes, opts)
  end

  def inject_resources(router_path, resources_routes, opts \\ []) do
    Corex.Integration.RouterPatch.inject_resources(router_path, resources_routes, opts)
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

  defp get_app_root_path(tmp_dir, app_name, opts) do
    app_root_dir =
      if "--umbrella" in opts do
        app_name <> "_umbrella"
      else
        app_name
      end

    Path.expand(app_root_dir, tmp_dir)
  end

  defp merge_hex_home_env(env) do
    case Process.get(:corex_integration_hex_home) do
      hex when is_binary(hex) -> [{"HEX_HOME", hex} | env]
      _ -> env
    end
  end

  defp random_string(len) do
    len |> :crypto.strong_rand_bytes() |> Base.url_encode64() |> binary_part(0, len)
  end

  def run_phx_server(app_root_path, port \\ nil) do
    port =
      port ||
        case :gen_tcp.listen(0, []) do
          {:ok, socket} ->
            listen_port =
              case :inet.port(socket) do
                {:ok, port} -> port
                {:error, _} -> 45_000 + :rand.uniform(5000)
              end

            :gen_tcp.close(socket)
            listen_port

          {:error, _} ->
            45_000 + :rand.uniform(5000)
        end

    port_str = to_string(port)
    dev_env = [{"MIX_ENV", "dev"} | Corex.Integration.HttpSmoke.dev_database_env_from_system()]

    if ecto_app?(app_root_path) do
      mix_run!(["ecto.create"], app_root_path, env: dev_env)
      mix_run!(["ecto.migrate"], app_root_path, env: dev_env)
    end

    server_env =
      [{"PORT", port_str} | dev_env]
      |> merge_hex_home_env()

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

  def request_with_retries(url, retries) do
    Corex.Integration.HttpSmoke.request_with_retries(url, retries)
  end

  def assert_corex_design_compiler_invariants!(app_root, app_name, opts \\ [])
      when is_binary(app_root) and is_binary(app_name) and is_list(opts) do
    base = app_base_path(app_root, app_name, opts)
    css_dir = Path.join([base, "assets", "css"])

    assert_file(Path.join(base, "mix.exs"), fn c ->
      assert c =~ "{:corex_design,"
      assert c =~ ":corex_design"
    end)

    assert_file(Path.join([base, "config", "config.exs"]), fn c ->
      assert c =~ "config :corex, Corex.Design"
      assert c =~ "emit_style_classes: true"
      assert c =~ "output: \"assets/css/corex.tailwind.css\""
    end)

    assert_file(Path.join([css_dir, "app.css"]), fn c ->
      assert c =~ ~s(@import "./corex.tailwind.css")
      refute c =~ "../corex/main.css"
      refute c =~ ~r/@plugin\s+["'][^"']*vendor\/daisyui/
    end)

    refute File.exists?(Path.join([base, "assets", "corex", "main.css"]))

    assert File.exists?(Path.join([css_dir, "corex.tailwind.css"]))
    assert File.exists?(Path.join([css_dir, "layers", "theme.css"]))
    assert File.exists?(Path.join([css_dir, "recipes", "button.css"]))
    assert File.exists?(Path.join([css_dir, "aggregates", "recipes.css"]))
    refute File.exists?(Path.join([css_dir, "recipes", "class"]))
    refute File.exists?(Path.join([css_dir, "recipes", "data"]))
  end

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

    assert_corex_design_compiler_invariants!(app_root, app_name, opts)

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
    web_module = Macro.camelize(web)
    router = Path.join([base, "lib", web, "router.ex"])
    web_ex = Path.join([base, "lib", web <> ".ex"])

    assert_file(router, fn c ->
      assert c =~ "Localize.Plug.PutLocale"
      assert c =~ ~s(scope "/:locale")
    end)

    assert_file(web_ex, fn c ->
      assert c =~ "path_prefixes: [{#{web_module}.Locale, :current, []}]"
    end)

    assert_file(Path.join([base, "lib", web, "locale.ex"]))
    assert_file(Path.join([base, "lib", web, "hooks", "layout.ex"]))
  end

  def assert_corex_lang_i18n_invariants!(app_root, app_name, opts \\ [])
      when is_binary(app_root) and is_binary(app_name) and is_list(opts) do
    base = app_base_path(app_root, app_name, opts)
    web = "#{app_name}_web"

    assert_file(Path.join(base, "mix.exs"), "gettext_sigils")
    assert_file(Path.join(base, "config/config.exs"), "supported_locales: [:en, :fr, :ar]")

    assert_file(Path.join(base, "config/config.exs"), fn c ->
      assert c =~ "config :corex"
      assert c =~ "gettext: :sigils"
      assert c =~ "layout: ["
      assert c =~ "locale: true"
    end)

    assert_file(Path.join(base, "lib/#{web}.ex"), "GettextSigils")
    assert_file(Path.join(base, "lib/#{web}/gettext.ex"), "locales: ~w(en fr ar)")

    assert_file(Path.join([base, "priv/gettext/fr/LC_MESSAGES/default.po"]))

    home = Path.join([base, "lib", web, "controllers", "page_html", "home.html.heex"])
    assert_file(home, ~s(~t"Corex for Phoenix"))

    layouts = Path.join([base, "lib", web, "components", "layouts.ex"])
    assert_file(layouts, ~s(~t"Language"))
  end

  def assert_corex_no_design_skipped!(app_root, app_name, opts \\ [])
      when is_binary(app_root) and is_binary(app_name) and is_list(opts) do
    base = app_base_path(app_root, app_name, opts)
    design_dir = Path.join([base, "assets", "corex"])
    refute_dir(design_dir)
  end

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
    assert_file(app_css, fn c -> refute c =~ "corex.tailwind.css" end)

    assert_file(Path.join(base, "mix.exs"), fn c -> refute c =~ "{:corex_design," end)

    assert_file(Path.join([base, "config", "config.exs"]), fn c ->
      refute c =~ "config :corex, Corex.Design"
    end)

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

  defp ecto_app?(app_root_path) when is_binary(app_root_path) do
    config_path = Path.join(app_root_path, "config/config.exs")

    File.exists?(config_path) and File.read!(config_path) =~ ~r/ecto_repos:\s*\[/
  end

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
