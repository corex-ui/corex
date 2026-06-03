defmodule Mix.Tasks.Corex.Design.Tailwind do
  use Mix.Task

  @shortdoc "Deprecated alias for mix corex.design.build"

  @moduledoc false

  @impl Mix.Task
  def run(argv) do
    Mix.shell().info([
      :yellow,
      "* ",
      :reset,
      "mix corex.design.tailwind is deprecated. Use mix corex.design.build"
    ])

    Mix.Tasks.Corex.Design.Build.run(argv)
  end
end
