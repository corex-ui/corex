defmodule Mix.Tasks.Corex.New do
  @moduledoc """
  Creates a new Phoenix application and installs Corex using Igniter.

  Requires the **`igniter_new`** archive so `mix igniter.install` is available, and typically **`phx_new`** for `mix phx.new`. Install both, then the Corex new archive.

      mix archive.install hex phx_new
      mix archive.install hex igniter_new
      mix archive.install hex corex_new

  `corex.new` is two steps: (1) **`mix phx.new` / `phx.new.web` arguments only**; (2) **`mix igniter.install corex`** with Corex-only options (the same as `Mix.Tasks.Corex.Install` — use **`mix help igniter.install`**.)

  For flags not listed for either step, generate with **`mix phx.new`**, `cd` into the project, then run **`mix igniter.install corex`**.

  ## 1) Phoenix (forwarded to `phx.new` or `phx.new.web` only)

  These match **`mix help phx.new`** / **`mix help phx.new.web`**: for example **`--no-ecto`**, **`--no-version-check`**, **`--umbrella`**, and **`--dev`** (Phoenix’s local dev deps; not Corex).

  ## 2) Corex / Igniter (not passed to `phx.new`)

  * **`--dev_corex PATH`** — `mix igniter.install corex@path:PATH` instead of Hex. Path is from the **web** app (e.g. sibling **`../corex`**, umbrella **`../../corex`**). Use with Phoenix **`--dev`** when you need both.

  * `--no-design` / `--design` — skip or enable design generation after install; **`--designex`** for `corex.design --designex`
  * `--mode`, `--theme`, `--lang` — forwarded as **`--corex.…`** to **`mix igniter.install corex`** (see `Mix.Tasks.Corex.Install`); **`--theme`** turns on all four themes; plain **`--mode`**, **`--replace`**, etc.
  * `--replace` / **`--no-replace`** — forwarded as **`--corex.replace`**. Default is **on**: stock **`home.html.heex` is wrapped in `Layouts.app` (Corex layout), the stock `Layouts.app` is fully switched to Corex, stock-only layout functions like **`flash_group` / `theme_toggle` are removed**, and **no** `GET /home` or `Layouts.corex` is added. **`--no-replace`** keeps the default Phoenix home at `/` and **adds** the separate `/home` route with `Layouts.corex` and `def corex` instead.
  * **`--no-mcp`** — as in `Mix.Tasks.Corex.Install`

  See `Mix.Tasks.Corex.Install` for the full list of what gets patched in the app.

  ## Examples

      mix corex.new hello_world
      mix corex.new my_app --mode --theme
      mix corex.new hello --umbrella
      mix corex.new my_app --dev --dev_corex ../corex
  """
  use Mix.Task

  alias Corex.New.{Cli, Flags, IgniterArgv, PhxWrapper, PostGenerate}

  @version Mix.Project.config()[:version]
  @shortdoc "Creates a new Phoenix app and installs Corex via Igniter"

  @switches [
    dev: :boolean,
    dev_corex: :string,
    design: :boolean,
    designex: :boolean,
    live: :boolean,
    mode: :boolean,
    theme: :boolean,
    lang: :boolean,
    ecto: :boolean,
    app: :string,
    module: :string,
    web_module: :string,
    database: :string,
    binary_id: :boolean,
    umbrella: :boolean,
    verbose: :boolean,
    dashboard: :boolean,
    install: :boolean,
    prefix: :string,
    mailer: :boolean,
    adapter: :string,
    inside_docker_env: :boolean,
    no_version_check: :boolean,
    assets: :boolean,
    esbuild: :boolean,
    tailwind: :boolean,
    gettext: :boolean,
    html: :boolean,
    mcp: :boolean,
    replace: :boolean
  ]

  @reserved_app_names ~w(server table)

  @impl true
  def run([version]) when version in ~w(-v --version) do
    Mix.shell().info("Corex installer v#{@version}")
  end

  def run(argv) do
    Cli.elixir_version_check!(@version)

    {opts, argv} = OptionParser.parse!(argv, strict: @switches)

    opts =
      opts
      |> Keyword.put_new(:lang, false)
      |> Keyword.put_new(:replace, true)
      |> Keyword.put_new(:mcp, true)
      |> Keyword.put_new(:theme, false)
      |> Keyword.put_new(:design, true)

    Cli.validate_corex_flags!(opts)
    Cli.validate_phx_new_flags!(opts)

    version_task =
      unless opts[:no_version_check] do
        get_latest_version("corex_new")
      end

    result =
      case argv do
        [] ->
          Mix.Tasks.Help.run(["corex.new"])

        [base_path | _] ->
          run_with_path(base_path, opts)
      end

    if version_task do
      try do
        %Version{} = latest_version = Task.await(version_task, 3_000)
        maybe_warn_outdated(latest_version)
      rescue
        _ -> :ok
      catch
        :exit, _ -> :ok
      end
    end

    result
  end

  defp run_with_path(base_path, opts) do
    expanded = Path.expand(base_path)
    phx_root = PhxWrapper.phx_project_path(expanded, opts)
    app = infer_app_name(expanded, opts)

    check_app_name!(app, !!opts[:app])
    Cli.confirm_install_path!(phx_root)

    root_mod =
      (opts[:module] && Module.concat([opts[:module]])) || Module.concat([Macro.camelize(app)])

    check_module_name_validity!(root_mod)
    check_module_name_availability!(root_mod)

    install_dir = PhxWrapper.web_project_path(phx_root, opts)

    igniter_extra = opts |> then(&Flags.igniter_install_opts/1) |> IgniterArgv.to_argv()
    PhxWrapper.ensure_igniter_new!()

    phx_opts =
      opts
      |> Flags.phx_new_cli_opts()
      |> Keyword.put(:install, false)
      |> Keyword.put(:dev, false)

    pkg = PhxWrapper.corex_igniter_install_target(opts)

    Mix.shell().info([
      :green,
      "* running ",
      :reset,
      "mix phx.new in #{Path.dirname(phx_root)} (then igniter: #{pkg})"
    ])

    phx_argv = ["phx.new"] ++ PhxWrapper.build_phx_new_argv(phx_opts, expanded)

    PhxWrapper.phx_new_then_igniter_install!(
      Path.dirname(phx_root),
      install_dir,
      phx_argv,
      pkg,
      igniter_extra,
      "phx-new"
    )

    PhxWrapper.run_format!(install_dir)

    PostGenerate.copy_cached_build(phx_root)
    PostGenerate.init_git(phx_root)
    PostGenerate.prompt_install(phx_root, install_dir, opts)
  end

  defp infer_app_name(expanded, opts) do
    opts[:app] ||
      expanded
      |> Path.basename()
      |> String.replace_suffix("_umbrella", "")
  end

  defp check_app_name!(name, from_app_flag) do
    with :ok <- validate_not_reserved(name),
         :ok <- validate_app_name_format(name, from_app_flag) do
      :ok
    end
  end

  defp validate_not_reserved(name) when name in @reserved_app_names do
    Mix.raise("Application name cannot be #{inspect(name)} as it is reserved")
  end

  defp validate_not_reserved(_name), do: :ok

  defp validate_app_name_format(name, from_app_flag) do
    if name =~ ~r/^[a-z][a-z0-9_]*$/ do
      :ok
    else
      extra =
        if !from_app_flag do
          ". The application name is inferred from the path, if you'd like to " <>
            "explicitly name the application then use the `--app APP` option."
        else
          ""
        end

      Mix.raise(
        "Application name must start with a letter and have only lowercase " <>
          "letters, numbers and underscore, got: #{inspect(name)}" <> extra
      )
    end
  end

  defp check_module_name_validity!(name) do
    unless inspect(name) =~ Regex.recompile!(~r/^[A-Z]\w*(\.[A-Z]\w*)*$/) do
      Mix.raise(
        "Module name must be a valid Elixir alias (for example: Foo.Bar), got: #{inspect(name)}"
      )
    end
  end

  defp check_module_name_availability!(name) do
    [name]
    |> Module.concat()
    |> Module.split()
    |> Enum.reduce([], fn name, acc ->
      mod = Module.concat([Elixir, name | acc])

      if Code.ensure_loaded?(mod) do
        Mix.raise("Module name #{inspect(mod)} is already taken, please choose another name")
      else
        [name | acc]
      end
    end)
  end

  defp maybe_warn_outdated(latest_version) do
    if Version.compare(@version, latest_version) == :lt do
      Mix.shell().info([
        :yellow,
        "A new version of corex.new is available:",
        :green,
        " v#{latest_version}",
        :reset,
        ".",
        "\n",
        "You are currently running ",
        :red,
        "v#{@version}",
        :reset,
        ".\n",
        "To update, run:\n\n",
        "    $ mix local.corex\n"
      ])
    end
  end

  if Version.match?(System.version(), "~> 1.18") do
    defp get_latest_version(package) do
      Task.async(fn ->
        try do
          with {:ok, package} <- get_package(package) do
            versions =
              for release <- package["releases"],
                  version = Version.parse!(release["version"]),
                  version.pre == [] do
                version
              end

            Enum.max(versions, Version)
          end
        rescue
          e -> {:error, e}
        catch
          :exit, _ -> {:error, :exit}
        end
      end)
    end

    defp get_package(name) do
      http_options = [
        ssl: [
          verify: :verify_peer,
          cacerts: :public_key.cacerts_get(),
          depth: 2,
          customize_hostname_check: [
            match_fun: :public_key.pkix_verify_hostname_match_fun(:https)
          ],
          versions: [:"tlsv1.2", :"tlsv1.3"]
        ]
      ]

      options = [body_format: :binary]

      case :httpc.request(
             :get,
             {~c"https://hex.pm/api/packages/#{name}",
              [{~c"user-agent", ~c"Mix.Tasks.Corex.New/#{@version}"}]},
             http_options,
             options
           ) do
        {:ok, {{_, 200, _}, _headers, body}} ->
          {:ok, Jason.decode!(body)}

        {:ok, {{_, status, _}, _, _}} ->
          {:error, status}

        {:error, reason} ->
          {:error, reason}
      end
    end
  else
    defp get_latest_version(_), do: nil
  end
end
