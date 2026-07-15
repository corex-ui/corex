defmodule Mix.Tasks.Corex.Tableau.New do
  @moduledoc """
  Creates a new Tableau static site with Corex installed.

  Install archives:

      mix archive.install hex tableau_new
      mix archive.install hex corex_new

  `mix corex.tableau.new PATH` runs **`mix tableau.new PATH --template heex --js esbuild --css tailwind`**,
  then writes Corex-owned files and patches into that app.

  ## Corex-only options

  * **`--no-design`** - skip the `corex_design` dependency, token config, and Corex design `@import` blocks in `site.css`. Default is **`--design`** (design on).
  * **`--mode`** - theme/mode toggle head scripts for light/dark. Implies **`--design`**.
  * **`--theme`** - themes (Neo/Uno/Duo/Leo), theme toggle, layout bridge. Implies **`--design`**.
  * **`--lang`** - Gettext + Localize, permalink Locale helpers, `locale.js`, per-locale pages, language `<.select>`. Implies **`--design`**. Locales: `en`, `fr`, `ar`.
  * **`--mcp`** / **`--no-mcp`** - when **`--mcp`** (default), adds `{:corex_mcp, "~> 0.2", only: :dev}` and a Bandit MCP server in dev.
  * **`--dev PATH`** - `{:corex, path: PATH}`, `{:corex_design, path: PATH/design}`, and relative `corex.mjs` import when building JS.
  * **`--install`** / **`--no-install`** - whether Corex runs **`mix deps.get`** in the new project after generation (prompt if omitted).

  ## Examples

      mix corex.tableau.new my_blog
      mix corex.tableau.new my_blog --mode --theme
      mix corex.tableau.new my_blog --lang
      mix corex.tableau.new my_blog --mode --theme --lang
      mix corex.tableau.new my_blog --no-design
      mix corex.tableau.new my_blog --dev ../corex

  To update the generator before creating a project:

  ```bash
  mix local.corex
  mix corex.tableau.new my_blog
  ```
  """
  use Mix.Task

  alias Corex.New.{Cli, Tableau}
  alias Corex.New.Tableau.Wrapper

  @version Mix.Project.config()[:version]
  @shortdoc "Creates a new Tableau static site with Corex"

  @switches [
    dev: :string,
    design: :boolean,
    mode: :boolean,
    theme: :boolean,
    lang: :boolean,
    install: :boolean,
    mcp: :boolean
  ]

  @reserved_app_names ~W(server table)

  @impl true
  def run([version]) when version in ~W(-v --version) do
    Mix.shell().info("Corex installer v#{@version}")
  end

  def run(argv) do
    Cli.elixir_version_check!(@version)

    {opts, argv} = OptionParser.parse!(argv, strict: @switches)

    opts =
      opts
      |> Keyword.put_new(:mcp, true)
      |> Keyword.put_new(:theme, false)
      |> Keyword.put_new(:mode, false)
      |> Keyword.put_new(:lang, false)
      |> Keyword.put_new(:design, true)
      |> Cli.maybe_auto_enable_design()

    Cli.validate_corex_flags!(opts)

    case argv do
      [] ->
        Mix.Tasks.Help.run(["corex.tableau.new"])

      [base_path | _] ->
        run_with_path(base_path, opts)
    end
  end

  defp run_with_path(base_path, opts) do
    expanded = Path.expand(base_path)
    app = infer_app_name(expanded, opts)

    check_app_name!(app)
    Cli.confirm_install_path!(expanded)

    app_module = Module.concat([Macro.camelize(app)])
    check_module_name_validity!(app_module)

    Wrapper.ensure_tableau_new!()

    tableau_argv = Wrapper.build_tableau_new_argv(expanded)

    Mix.shell().info([
      :green,
      "* running ",
      :reset,
      "mix tableau.new #{Enum.join(tableau_argv, " ")}"
    ])

    Wrapper.tableau_new!(Path.dirname(expanded), tableau_argv)

    generate_opts =
      opts
      |> Keyword.put(:otp_app, String.to_atom(app))
      |> Keyword.put(:app_module, app_module)

    Mix.shell().info([:green, "* installing Corex into ", :reset, expanded])
    Tableau.Generate.run(expanded, generate_opts)

    Tableau.PostGenerate.run(expanded, generate_opts)
  end

  defp infer_app_name(expanded, _opts) do
    Path.basename(expanded)
  end

  defp check_app_name!(name) do
    if name in @reserved_app_names do
      Mix.raise("Application name cannot be #{inspect(name)} as it is reserved")
    end

    unless name =~ ~r/^[a-z][a-z0-9_]*$/ do
      Mix.raise(
        "Application name must start with a letter and have only lowercase " <>
          "letters, numbers and underscore, got: #{inspect(name)}"
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
end
