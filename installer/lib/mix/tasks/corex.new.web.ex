defmodule Mix.Tasks.Corex.New.Web do
  @moduledoc """
  Creates a new Phoenix **web** app in an **umbrella** and installs Corex via Igniter. Run from the umbrella **`apps/`** directory.

  ## 1) Phoenix

  See **`mix help phx.new.web`**. `corex.new.web` forwards only those options to `mix phx.new.web`.

  ## 2) Corex (Igniter)

  Same as **`mix corex.new`**: plain Corex flags (as in **`mix igniter.install corex -- …`**), plus **`--dev_corex PATH`**. **`phx.new.web`** is always invoked with **`--no-install`** so Phoenix does not fetch during scaffolding; the Corex end prompt for **`deps.get`** / **`assets.setup`** behaves like **`mix corex.new`**. For details see `mix help corex.new` or `Mix.Tasks.Corex.Install`.

  Set **`MIX_COREX_IGNITER_INTERACTIVE=1`** to omit non-interactive `--yes` on nested `igniter.install` in some environments.
  """

  @shortdoc "Creates a new Phoenix web app in an umbrella and installs Corex via Igniter"

  use Mix.Task

  alias Corex.New.{Cli, Flags, IgniterArgv, PhxWrapper, PostGenerate}

  @version Mix.Project.config()[:version]

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
    no_version_check: :boolean,
    app: :string,
    module: :string,
    web_module: :string,
    database: :string,
    binary_id: :boolean,
    verbose: :boolean,
    dashboard: :boolean,
    install: :boolean,
    prefix: :string,
    mailer: :boolean,
    adapter: :string,
    inside_docker_env: :boolean,
    assets: :boolean,
    esbuild: :boolean,
    tailwind: :boolean,
    gettext: :boolean,
    html: :boolean,
    mcp: :boolean
  ]

  @impl true
  def run(argv) do
    Cli.elixir_version_check!(@version)

    {opts, argv} = OptionParser.parse!(argv, strict: @switches)

    opts =
      opts
      |> Keyword.put_new(:lang, false)
      |> Keyword.put_new(:mcp, true)
      |> Keyword.put_new(:theme, false)
      |> Keyword.put_new(:design, true)

    Cli.validate_corex_flags!(opts)
    Cli.validate_phx_new_flags!(opts)

    case argv do
      [] ->
        Mix.Tasks.Help.run(["corex.new.web"])

      [app_name | _] ->
        run_with_app_name(app_name, opts)
    end
  end

  defp run_with_app_name(app_name, opts) do
    unless PhxWrapper.in_umbrella?(app_name) do
      Mix.raise("The web task can only be run within an umbrella's apps directory")
    end

    install_dir = Path.expand(app_name)
    umbrella_root = Path.expand(Path.join([install_dir, "..", ".."]))

    Cli.confirm_install_path!(install_dir)

    igniter_extra = opts |> then(&Flags.igniter_install_opts/1) |> IgniterArgv.to_argv()
    PhxWrapper.ensure_igniter_new!()

    pkg = PhxWrapper.corex_igniter_install_target(opts)

    phx_opts =
      opts
      |> Flags.phx_new_cli_opts()
      |> Keyword.put(:dev, false)
      |> Keyword.put(:install, false)

    with_args =
      phx_opts
      |> PhxWrapper.build_phx_new_web_with_args()
      |> PhxWrapper.build_with_args_string()

    Mix.shell().info([
      :green,
      "* running ",
      :reset,
      "mix igniter.new --install #{pkg} --with phx.new.web in #{Path.dirname(install_dir)}"
    ])

    PhxWrapper.igniter_new_install!(
      Path.dirname(install_dir),
      app_name,
      pkg,
      "phx.new.web",
      with_args,
      igniter_extra
    )

    PhxWrapper.run_format!(install_dir)

    PostGenerate.copy_cached_build(umbrella_root)
    PostGenerate.init_git(umbrella_root)
    PostGenerate.prompt_install(umbrella_root, install_dir, opts)
  end
end
