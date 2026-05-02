defmodule Mix.Tasks.Corex.New do
  @moduledoc """
  Creates a new Phoenix application with Corex installed.

  Install archives:

      mix archive.install hex phx_new
      mix archive.install hex corex_new

  `mix corex.new PATH` runs **`mix phx.new PATH --no-install`** with forwarded Phoenix flags,
  then writes Corex-owned files and patches into that app. **`--no-install`** is always passed to
  Phoenix so dependency fetching stays under Corex control.

  LiveView, HTML, esbuild, and the default Phoenix asset setup are **always on** — Corex does not
  forward **`--no-live`**, **`--no-html`**, **`--no-esbuild`**, or **`--no-assets`**.

  **`mix phx.new --dev`** (Phoenix from a Git checkout) is **not** forwarded. **`--dev`** on this task
  means a **Corex** path dependency only.

  ## Corex-only options

  * **`--no-design`** — skip copying consumer design assets into `assets/corex/` and omit Corex design `@import` blocks in `app.css`. Default is **`--design`** (design on).
  * **`--tailwind`** / **`--no-tailwind`** — Tailwind in the generated Phoenix app defaults **on**. **`--no-tailwind`** is forwarded to **`phx.new`** only together with **`--no-design`**. If **`--design`** is on, **`--no-tailwind` is ignored** (Corex design CSS expects Tailwind).
  * **`--mode`** — plugs, mode toggle, root-layout bridge for light/dark. Implies **`--design`**.
  * **`--theme`** — themes (Neo/Uno/Duo/Leo), plugs, theme toggle, layout bridge. Implies **`--design`**.
  * **`--lang`** — Localize + Gettext, path plug, locale scope helpers, `language_switch`.
  * **`--designex`** — copy token sources into `assets/corex/design/`, add `:designex`, asset aliases. Implies **`--design`**.
  * **`--mcp`** / **`--no-mcp`** — when **`--mcp`** (default), `plug Corex.MCP` is added to the endpoint in `:dev` / `:test` after `Plug.Static`.
  * **`--dev PATH`** — `{:corex, path: PATH}` and relative `corex.mjs` import when building JS; design copies from that checkout when **`--design`** is on.
  * **`--install`** / **`--no-install`** — whether Corex runs **`mix deps.get`** in the new project after generation (prompt if omitted). Does **not** change Phoenix’s **`--no-install`** step.

  ## Options forwarded to **`mix phx.new`**

  Same semantics as Phoenix’s installer — see **`mix help phx.new`** on [Hexdocs](https://hexdocs.pm/phx_new/Mix.Tasks.Phx.New.html).

  Supported switches include for example:

  * **`--database`** (`postgres`, `mysql`, `sqlite3`, `mssql`, …)
  * **`--adapter`** (`bandit`, `cowboy`)
  * **`--app`**, **`--module`**, **`--web-module`**, **`--prefix`**
  * **`--binary-id`**, **`--verbose`**, **`--inside-docker-env`**
  * **`--no-dashboard`**, **`--no-mailer`**, **`--no-gettext`**, **`--no-version-check`**

  **`--no-ecto`** is rejected (Corex expects Ecto in generated apps).

  **`--no-gettext`** is incompatible with **`--lang`**.

  **`--umbrella`** is not supported here yet; use **`mix phx.new --umbrella`** and **`guides/manual_installation.md`**.

  ## After generation

  The installer prints Phoenix-style follow-up steps (**`cd`**, **`mix deps.get`** when dependencies were not fetched, database setup when Ecto is enabled, **`mix assets.setup`** / **`mix assets.build`**, optional **`mix localize.download_locales`** with **`--lang`**, then **`mix phx.server`** / **`iex -S mix phx.server`**).

  ## Examples

      mix corex.new hello_world
      mix corex.new my_app --mode --theme --lang
      mix corex.new my_app --no-design --no-tailwind
      mix corex.new my_app --dev ../corex

  To update the generator before creating a project:

  ```bash
  mix local.corex
  mix corex.new my_app
  ```
  """
  use Mix.Task

  alias Corex.New.{Cli, Generate, PhxWrapper, PostGenerate}

  @version Mix.Project.config()[:version]
  @shortdoc "Creates a new Phoenix app and installs Corex"

  @switches [
    dev: :string,
    design: :boolean,
    designex: :boolean,
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
    tailwind: :boolean,
    gettext: :boolean,
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
      |> Keyword.put_new(:tailwind, true)
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
