defmodule Mix.Tasks.Corex.New do
  @moduledoc """
  Creates a new Phoenix application with Corex installed.

  Requires the **`phx_new`** archive. Install it first:

      mix archive.install hex phx_new

  `mix corex.new my_app` runs **`mix phx.new my_app --no-install`** with any
  forwarded Phoenix flags, then renders Corex-owned files from templates
  directly into the generated app. No Igniter. No nested generator.

  ## 1) Phoenix (forwarded to `phx.new`)

  Matches **`mix help phx.new`**: for example **`--no-ecto`**, **`--no-version-check`**,
  and **`--database sqlite3`**.

  **`phx.new --dev`** (install Phoenix from a local clone) is **not** forwarded — the
  Corex CLI reserves **`--dev`** for local Corex development. To scaffold with a
  Phoenix Git checkout, run **`mix phx.new`** yourself, then follow the manual-install guide.

  Notes:

  * `--no-tailwind`, `--no-assets`, `--no-esbuild`, `--no-html` are not supported by Corex and will fail validation.
  * `--no-gettext` is forbidden when `--lang` is set (Gettext is required for `--lang`).
  * `--umbrella` is not currently supported; generate manually with `mix phx.new --umbrella ...` and follow the manual-install guide.

  ## 2) Corex flags (never forwarded to `phx.new`)

  * **`--dev PATH`** — installs `corex` as a path dep at `PATH` instead of Hex; copies design from that checkout when `--design` is on; generates **`import ...`** from `assets/js/app.js` to **`PATH/priv/static/corex.mjs`** (relative path). Path is relative to the generated app (for a sibling clone, use `../corex`).
  * `--design` / **`--no-design`** — copy consumer assets from `priv/design/corex` into `assets/corex/` (no `assets/corex/design/`); write the Corex `app.css`. **Default: on**.
  * `--designex` — copy `priv/design/design` into `assets/corex/design/`, add `{:designex, …}`, `config :designex`, and `designex corex` in asset aliases; implies `--design`.
  * `--mode` — generate `Plugs.Mode`, mode toggle, and `data-mode` bridge in the root layout. Implies `--design`.
  * `--theme` — enable themes (Neo/Uno/Duo/Leo), `Plugs.Theme`, theme toggle, and `data-theme` bridge. Implies `--design`.
  * `--lang` — set up Localize + Gettext: `Plugs.Path`, locale-aware router helpers, layout `lang/dir` and `language_switch` component.
  * `--install` / **`--no-install`** — control whether to run the final `mix deps.get` / `mix assets.setup` step (prompt if omitted).

  ## Examples

      mix corex.new hello_world
      mix corex.new my_app --mode --theme --lang
      mix corex.new my_app --dev ../corex
  """
  use Mix.Task

  alias Corex.New.{Cli, Generate, PhxWrapper, PostGenerate}

  @version Mix.Project.config()[:version]
  @shortdoc "Creates a new Phoenix app and installs Corex"

  @switches [
    dev: :string,
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
    mcp: :boolean
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
      `mix corex.new --umbrella` is not supported yet.

      Generate the umbrella manually, then follow `guides/manual_installation.md`:

          mix phx.new --umbrella #{base_path}
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

    web_module =
      cond do
        is_binary(opts[:web_module]) -> Module.concat([opts[:web_module]])
        true -> Module.concat([Macro.camelize(app) <> "Web"])
      end

    install_dir = PhxWrapper.web_project_path(phx_root, opts)

    PhxWrapper.ensure_phx_new!()

    phx_argv = PhxWrapper.build_phx_new_argv(opts, expanded)

    Mix.shell().info([
      :green,
      "* running ",
      :reset,
      "mix phx.new #{Enum.join(phx_argv, " ")} in #{Path.dirname(phx_root)}"
    ])

    PhxWrapper.phx_new!(Path.dirname(phx_root), phx_argv)

    generate_opts =
      opts
      |> Keyword.put(:otp_app, String.to_atom(app))
      |> Keyword.put(:app_module, root_mod)
      |> Keyword.put(:web_module, web_module)

    Mix.shell().info([:green, "* installing Corex into ", :reset, install_dir])
    Generate.run(install_dir, generate_opts)

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
