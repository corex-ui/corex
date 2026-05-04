defmodule Mix.Tasks.E2e.Palette do
  use Mix.Task

  @shortdoc "Generate theme color JSON from E2e.DesignPalette.Config (exports palette_config.json for diff)"

  @impl Mix.Task
  def run(_args) do
    Mix.Task.run("compile")
    root = File.cwd!()
    design = Path.join(root, "assets/corex/design")
    cfg = E2e.DesignPalette.Config.defaults()

    File.write!(
      Path.join(design, "palette_config.json"),
      Jason.encode!(cfg, pretty: true) <> "\n"
    )

    E2e.DesignPalette.run(design_dir: design, config: cfg)
  end
end
