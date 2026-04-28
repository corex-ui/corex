defmodule Mix.Tasks.Corex.New do
  @moduledoc """
  Creates a new Phoenix application and installs Corex using Igniter.

  Requires the **`igniter_new`** archive so `mix igniter.install` is available, and typically **`phx_new`** for `mix phx.new`. Install both, then the Corex new archive.

      mix archive.install hex phx_new
      mix archive.install hex igniter_new
      mix archive.install hex corex_new

  `corex.new` runs in two steps: (1) **`mix phx.new` / `phx.new.web` arguments only**; (2) **`mix igniter.install corex`** with Corex-only options (the same as `Mix.Tasks.Corex.Install` — use **`mix help igniter.install`**).

  For flags not listed below, generate with **`mix phx.new`**, `cd` into the project, then run **`mix igniter.install corex`**.

  ## 1) Phoenix (forwarded to `phx.new` or `phx.new.web` only)

  These match **`mix help phx.new`**: for example **`--no-ecto`**, **`--no-version-check`**, **`--database sqlite3`**, and **`--dev`** (uses Phoenix from a sibling clone — needed when developing Phoenix locally).

  Note: **`--umbrella`** is **not supported** by `corex.new` because the underlying `mix igniter.new` task explicitly rejects umbrella generation. Generate the umbrella manually with `mix phx.new --umbrella …`, then `cd` into the web app and run `mix igniter.install corex`.

  Notes:

  * `--no-tailwind`, `--no-assets`, `--no-esbuild`, `--no-html` are not supported by Corex and will fail validation.
  * `--no-gettext` is forbidden when `--lang` is set (Localize/Gettext is required for `--lang`).

  ## 2) Corex / Igniter (not passed to `phx.new`)

  Corex flags are unique and **do not conflict** with `phx.new` / Igniter flags, so pass them bare:

  * **`--dev_corex PATH`** — installs `corex@path:PATH` instead of Hex. Path is relative to the **web** app (sibling **`../corex`**, umbrella **`../../corex`**).
  * `--design` / **`--no-design`** — install the Corex design system (`mix corex.design`). **Default: on**. `--no-design` keeps the stock Phoenix Tailwind/daisy assets.
  * **`--designex`** — also install token tooling (`mix corex.design --designex`); implies `--design`.
  * **`--mode`** — generate `Plugs.Mode`, mode toggle, and `data-mode` bridge in the root layout. **Implies `--design`** (with a notice).
  * **`--theme`** — enable themes (Neo/Uno/Duo/Leo), `Plugs.Theme`, theme toggle, and `data-theme` bridge. **Implies `--design`** (with a notice).
  * **`--lang`** — set up Localize + Gettext: `Plugs.Path`, locale-aware router helpers, layout `lang/dir` and `language_switch` component. Does **not** imply `--design`.
  * **`--replace`** / `--no-replace` — wrap the stock `home.html.heex` in `Layouts.app` (Corex layout), strip stock helpers (`flash_group`, `theme_toggle`), and keep `/` as the entry route. **Default: on for `corex.new`**. `--no-replace` leaves the default Phoenix home at `/` and adds a demo `/home` route with `Layouts.corex` instead.
  * `--mcp` / **`--no-mcp`** — install the Corex MCP plug under `Mix.env() == :dev` on the web endpoint. **Default: on**.

  ## Idempotency

  Re-running `mix igniter.install corex` (or `mix corex.new` followed by `mix igniter.install corex --yes`) with the same flags makes no diffs to the project. Re-running with new UI flags (e.g. add `--lang`) only adds the new bits.

  ## Examples

      mix corex.new hello_world
      mix corex.new my_app --mode --theme --lang
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
      |> Cli.maybe_auto_enable_design()

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
    if opts[:umbrella] do
      Mix.raise("""
      `mix corex.new --umbrella` is not supported because `igniter.new` cannot
      generate umbrella projects (it always exits with a hard error on
      `--umbrella`).

      Generate the umbrella manually, then install Corex into the web app:

          mix phx.new --umbrella #{base_path}
          cd #{base_path}_umbrella/apps/<app>_web
          mix igniter.install corex
      """)
    end

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

    phx_opts = Flags.phx_new_cli_opts(opts)

    pkg = PhxWrapper.corex_igniter_install_target(opts)

    with_args =
      phx_opts
      |> PhxWrapper.build_phx_new_with_args()
      |> PhxWrapper.build_with_args_string()

    Mix.shell().info([
      :green,
      "* running ",
      :reset,
      "mix igniter.new --install #{pkg} --with phx.new in #{Path.dirname(phx_root)}"
    ])

    PhxWrapper.igniter_new_install!(
      Path.dirname(phx_root),
      expanded,
      pkg,
      "phx.new",
      with_args,
      igniter_extra
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
