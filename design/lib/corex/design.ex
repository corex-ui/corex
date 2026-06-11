defmodule Corex.Design do
  @design_source_dir Path.join(__DIR__, "design")
  require Logger

  @moduledoc ~S'''
  Corex's Elixir design pipeline: token generation and component recipe
  compilation into the Tailwind CSS bundle under `assets/css/`.

  Components merge BEM modifiers into `class` from style attrs (see `Corex.Bem.Variants`);
  this module produces the stylesheets that target those BEM selectors.

  Host configuration lives under `config :corex, Corex.Design`. Only `output` is required;
  optional keys customize themes, scales, recipes, and aliases at compile time.

      config :corex, Corex.Design,
        output: "assets/css/corex.tailwind.css"

  `:corex_design` requires OTP 27+.
  '''

  @compile {:no_warn_undefined, [Corex.Design.Watch]}

  @doc false
  def design_config do
    case Application.get_env(:corex, Corex.Design) do
      config when is_list(config) ->
        Map.new(config)

      _ ->
        %{}
    end
  end

  @doc false
  def design_source_dir, do: @design_source_dir

  @doc "The absolute output path for the generated `corex.tailwind.css` shim."
  def output_path do
    case Corex.Design.Config.output() do
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

  @doc "Whether the design compiler should run (host has Corex design configuration)."
  def configured?, do: map_size(design_config()) > 0

  @doc """
  Declarative inputs used to detect when generated CSS is stale:

    * the design DSL source files (tokens, recipes, fragments, emitters), so
      editing a recipe or token regenerates the stylesheet, and
    * the resolved design-affecting host config (`config :corex, Corex.Design`), so a
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
    alias Corex.Design.Config
    alias Corex.Design.Recipes

    resolved = Config.resolved_options()

    [
      design: Enum.sort(design_config()),
      resolved: Enum.sort(resolved),
      recipes: Recipes.host_recipes()
    ]
  end

  @doc "Writes the compiled Tailwind bundle."
  def compile(opts \\ []) do
    write_tailwind_bundle!()
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

  defp write_tailwind_bundle! do
    case output_path() do
      nil ->
        :ok

      _output ->
        dir = output_path() |> Path.dirname()
        alias Corex.Design.Compiler

        Compiler.write_tailwind_modular!(dir)
    end
  end

  def run(args) when is_list(args) do
    alias Corex.Design.Watch

    if "--watch" in args do
      Watch.start()
    else
      compile(log: :info)
      0
    end
  end

  def install_and_run(args) when is_list(args) do
    ensure_output!()
    run(args)
  end

  defp ensure_output! do
    case output_path() do
      nil ->
        raise ArgumentError, """
        config :corex, Corex.Design, output: is required. For example:

            config :corex, Corex.Design,
              output: "assets/css/corex.tailwind.css"
        """

      _ ->
        :ok
    end
  end

  require Logger

  defp log_compile(false), do: :ok
  defp log_compile(:info), do: Logger.info("Corex design compiled")
  defp log_compile(:watch_rebuild), do: IO.puts("[watch] Corex design rebuilt")
end
