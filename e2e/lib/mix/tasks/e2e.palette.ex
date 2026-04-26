defmodule Mix.Tasks.E2e.Palette do
  use Mix.Task

  @shortdoc "Generate theme color JSON from assets/corex/design/palette_config.json"

  @impl Mix.Task
  def run(_args) do
    Mix.Task.run("compile")
    root = File.cwd!()
    design = Path.join(root, "assets/corex/design")
    E2e.DesignPalette.run(design_dir: design)
  end
end
