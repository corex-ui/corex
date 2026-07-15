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

  @default_output "assets/corex"

  @doc false
  def design_config do
    defaults = default_config()
    env = Application.get_all_env(:corex_design) |> Map.new()
    Map.merge(defaults, env)
  end

  @doc false
  def default_config do
    %{
      output: @default_output,
      default_theme: :neo,
      default_mode: :light,
      themes: nil,
      scales: [],
      components: nil,
      semantics: nil
    }
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

  @doc false
  def output_path do
    case Corex.Design.Config.output() do
      nil -> Path.join(mix_root(), @default_output)
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
