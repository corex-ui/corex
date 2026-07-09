defmodule Corex.Design do
  @moduledoc """
  Optional config-driven token generation and static component CSS for Corex.

  Host configuration lives under `config :corex_design`. Run
  `mix corex.design.build` to emit the bundle into your app's assets tree.
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
      semantics: nil,
      variants: nil
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
