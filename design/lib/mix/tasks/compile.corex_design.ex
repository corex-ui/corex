defmodule Mix.Tasks.Compile.CorexDesign do
  @moduledoc false
  use Mix.Task.Compiler

  alias Corex.Assets.Manifest

  @manifest "design"

  @impl true
  def run(_args) do
    if Corex.Design.configured?() do
      Corex.Design.Config.validate!()

      inputs = Corex.Design.compile_inputs()
      outputs = compile_outputs()

      if Enum.any?(outputs, &Manifest.stale?(@manifest, inputs, &1)) do
        Corex.Design.compile(log: :info)
        Manifest.write(@manifest, inputs)
      end
    end

    {:noop, []}
  end

  defp compile_outputs do
    case Corex.Design.output_path() do
      nil -> []
      path -> [path]
    end
  end
end
