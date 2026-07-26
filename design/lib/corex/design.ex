defmodule Corex.Design do
  @moduledoc """
  Optional config-driven tokens, themes, and component CSS for Corex.

  1. Add `{:corex_design, "~> 0.2", runtime: false}` and `config :corex_design` (see `Corex.Design.Config`).
  2. Run `mix corex.design.build` (or add `:corex_design` to `compilers`).
  3. Import `@import "../corex/corex.css"` in `app.css`.

  Package docs: [corex_design](https://hexdocs.pm/corex_design). App wiring:
  [Design](https://hexdocs.pm/corex/design.html), [Theming](https://hexdocs.pm/corex/theming.html),
  [Dark mode](https://hexdocs.pm/corex/dark_mode.html), [Modifiers](https://hexdocs.pm/corex/modifiers.html).
  """

  @doc false
  def design_config do
    defaults = default_config()
    env = Application.get_all_env(:corex_design) |> Map.new()
    Map.merge(defaults, env)
  end

  @doc false
  def default_config do
    %{
      output: Corex.Design.Config.default_output(),
      default_theme: :uno,
      default_mode: :light,
      themes: nil,
      modes: [:light, :dark],
      scales: [],
      components: nil,
      semantics: nil
    }
  end

  @doc false
  def mix_root do
    case bottom_project() do
      %{file: file} when is_binary(file) -> Path.dirname(file)
      _no_project_file -> File.cwd!()
    end
  end

  defp bottom_project do
    if Code.ensure_loaded?(Mix) and function_exported?(Mix.ProjectStack, :top_and_bottom, 0) do
      with {_top, bottom} <- Mix.ProjectStack.top_and_bottom(), do: bottom
    end
  end

  @doc false
  def output_path do
    case Corex.Design.Config.output() do
      nil -> Path.join(mix_root(), Corex.Design.Config.default_output())
      output -> Path.expand(output, mix_root())
    end
  end

  @doc false
  def compile(opts \\ []) do
    Corex.Design.Bundle.write!(output_path())
    log_compile(Keyword.get(opts, :log, :info))
    :ok
  end

  defp log_compile(false), do: :ok
  defp log_compile(:info), do: Mix.shell().info("Corex design compiled")
end
