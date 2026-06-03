defmodule Corex.Design do
  @design_source_dir Path.join(__DIR__, "design")
  require Logger

  @moduledoc ~S'''
  Corex's Elixir design pipeline: token generation and component recipe
  compilation into the Tailwind CSS bundle under `assets/css/`.

  Components merge BEM modifiers into `class` from style attrs or explicit classes
  (see `Corex.Variants`); this module produces the stylesheets that target those
  BEM selectors.

  All design-pipeline configuration lives under the `:corex_design` application
  namespace. The data-markup vocabulary (`scales`, `semantics`, `appearances`)
  stays under `:corex` and is read via `Corex.Scales` / `Corex.Appearances`.

  ## Themes (colors + dimensions)

  Define themes in host config; the `:corex_design` compiler regenerates
  `corex.tailwind.css` on `mix compile`:

      import Config

      config :corex_design,
        default_theme: :neo,
        default_mode: :light,
        accessibility_level: :aa,
        themes: %{
          neo: Corex.Design.Theme.Presets.neo(),
          uno: Corex.Design.Theme.Presets.uno(),
          acme: %{
            extends: :neo,
            seeds: %{"brand" => "#E11D48"},
            colors: %{light: %{semantic: %{brand: %{lightness: 42}}}, dark: %{}},
            dimensions: %{radius_scale: 1.2},
            accessibility: %{level: :aa, dark: :a}
          }
        }

  `accessibility_level` sets the default for token contrast floors and reports.
  Per-theme `:accessibility` can set `level` and optional `:light` / `:dark` overrides.

  Omit `:themes` to use the built-in neo / uno / duo / leo presets. Keep
  `config :my_app, :themes` (theme picker ids) in sync with the keys above.

  Add `:corex_design`, set `output` on your app profile, and run `mix compile` to
  regenerate after config changes. `:corex_design` requires **OTP 27+** (Elixir 1.18+ recommended).
  '''

  @compile {:no_warn_undefined, [Corex.Design.Watch]}

  @doc false
  def design_config, do: Application.get_all_env(:corex_design)

  @doc false
  def design_source_dir, do: @design_source_dir

  @doc "The absolute output path for the generated `corex.tailwind.css` shim."
  def output_path(profile \\ nil) do
    case resolve_output(design_config(), profile) do
      nil -> nil
      output -> Path.expand(output, mix_root())
    end
  end

  @doc false
  def mix_root do
    if Code.ensure_loaded?(Mix) and function_exported?(Mix.ProjectStack, :top_and_bottom, 0) do
      {_top, bottom} = Mix.ProjectStack.top_and_bottom()

      if is_map(bottom) and is_binary(bottom.file) do
        Path.dirname(bottom.file)
      else
        File.cwd!()
      end
    else
      File.cwd!()
    end
  end

  defp resolve_output(config, nil) do
    infer_app_output(config)
  end

  defp resolve_output(config, profile) do
    config
    |> Keyword.get(profile, [])
    |> Keyword.get(:output)
  end

  defp infer_app_output(config) do
    case mix_app() do
      nil -> nil
      :corex -> nil
      app -> config |> Keyword.get(app, []) |> Keyword.get(:output)
    end
  end

  defp mix_app do
    if Code.ensure_loaded?(Mix) and Mix.Project.get() do
      Mix.Project.config()[:app]
    end
  end

  @doc "Whether the design compiler should run (host has Corex design configuration)."
  def configured?, do: Application.get_all_env(:corex_design) != []

  @doc """
  Declarative inputs used to detect when generated CSS is stale:

    * the design DSL source files (tokens, recipes, fragments, emitters), so
      editing a recipe or token regenerates the stylesheet, and
    * the resolved design-affecting host config (`:corex_design` plus the
      `:corex` `scales` / `semantics` data-markup the compiler reads), so a
      config edit triggers a rebuild on the next `mix compile`.
  """
  def compile_inputs do
    files =
      @design_source_dir
      |> Path.join("**/*.ex")
      |> Path.wildcard()
      |> Enum.sort()

    [
      {:term, :corex_design_v2},
      {:term, config_digest()}
      | Enum.map(files, &{:file, &1})
    ]
  end

  defp config_digest do
    alias Corex.Design.Recipes

    [
      design: Enum.sort(design_config()),
      scales: Enum.sort(Application.get_env(:corex, :scales, [])),
      semantics: Application.get_env(:corex, :semantics),
      recipes: Recipes.host_recipes()
    ]
  end

  @doc "Writes the compiled Tailwind bundle for the given profile."
  def compile(opts \\ []) do
    profile = Keyword.get(opts, :profile)
    write_tailwind_bundle!(profile)
    log_compile(Keyword.get(opts, :log, :info))
    :ok
  end

  @doc false
  def compile_tailwind_theme_css do
    alias Corex.Design.Emit.Theme

    Theme.bridge_css()
  end

  @doc false
  def compile_tailwind_recipes_css do
    alias Corex.Design.Compiler

    Compiler.tailwind_recipes_css()
  end

  @doc false
  def compile_tailwind_tokens_css do
    alias Corex.Design.Emit.Tokens

    Tokens.css()
  end

  @doc false
  def compile_tailwind_base_css do
    alias Corex.Design.Compiler

    Compiler.tailwind_base_css()
  end

  defp write_tailwind_bundle!(profile) do
    case output_path(profile) do
      nil ->
        :ok

      _output ->
        dir = output_path(profile) |> Path.dirname()
        alias Corex.Design.Compiler

        Compiler.write_tailwind_modular!(dir)
    end
  end

  def config_for!(profile) when is_atom(profile) do
    case Keyword.get(design_config(), profile) do
      nil ->
        raise ArgumentError, """
        unknown Corex design profile #{inspect(profile)}. Define it in config/config.exs, for example:

            config :corex_design,
              my_app: [output: "assets/css/corex.tailwind.css"]
        """

      profile_config ->
        profile_config
    end
  end

  def run(profile, args) when is_list(args) do
    alias Corex.Design.Watch

    if "--watch" in args do
      Watch.start(profile)
    else
      compile(profile: profile, log: :info)
      0
    end
  end

  def install_and_run(profile, args) when is_atom(profile) and is_list(args) do
    if profile, do: config_for!(profile)
    run(profile, args)
  end

  require Logger

  defp log_compile(false), do: :ok
  defp log_compile(:info), do: Logger.info("Corex design compiled")
  defp log_compile(:watch_rebuild), do: IO.puts("[watch] Corex design rebuilt")
end
