defmodule Mix.Tasks.Corex.Heroicon do
  @shortdoc "Add the Heroicons Tailwind v4 plugin to assets/vendor"

  @moduledoc """
  Copies the Heroicons Tailwind plugin into your project so the `Corex.Heroicon`
  component works. Creates `assets/vendor/heroicons.js` (or per-app in umbrella)
  and instructs adding `@plugin "../vendor/heroicons";` to your main CSS.

  Requires the `:heroicons` dependency in mix.exs, e.g.:

      {:heroicons, github: "tailwindlabs/heroicons"}

  ## Examples

      mix corex.heroicon
      mix corex.heroicon --force

  ## Options

    * `--force` - overwrite existing heroicons.js

  """

  use Mix.Task

  @plugin_line ~s|@plugin "../vendor/heroicons";|

  @impl Mix.Task
  def run(args) do
    Mix.Task.run("app.start")

    {opts, _} = OptionParser.parse!(args, strict: [force: :boolean])
    force = Keyword.get(opts, :force, false)

    in_umbrella = Mix.Project.umbrella?()
    target_infos = target_paths(in_umbrella)

    if target_infos == [] do
      Mix.raise("No assets directory found. Run this task from your project root.")
    end

    template_path = Application.app_dir(:corex, "priv/templates/corex.heroicon/heroicons.js.eex")
    template = File.read!(template_path)

    for %{path: target_path, in_umbrella: in_umb} <- target_infos do
      if File.exists?(target_path) and not force do
        Mix.shell().info("Skipping #{target_path} (exists). Use --force to overwrite.")
      else
        dir = Path.dirname(target_path)
        File.mkdir_p!(dir)
        rendered = EEx.eval_string(template, assigns: [in_umbrella: in_umb])
        File.write!(target_path, rendered)
        Mix.shell().info("Created #{target_path}")
      end
    end

    print_css_instructions(target_infos)
    print_dep_reminder()
  end

  defp target_paths(false) do
    root = File.cwd!()
    assets = Path.join(root, "assets")

    if File.exists?(assets) and File.dir?(assets) do
      [
        %{
          path: Path.join(assets, "vendor/heroicons.js"),
          in_umbrella: false,
          css_path: Path.join(assets, "css/app.css")
        }
      ]
    else
      []
    end
  end

  defp target_paths(true) do
    apps_paths = Mix.Project.apps_paths() || %{}
    root = File.cwd!()

    for {_app, app_path} <- apps_paths,
        full_app_path = Path.join(root, app_path),
        assets = Path.join(full_app_path, "assets"),
        File.exists?(assets) and File.dir?(assets) do
      %{
        path: Path.join(assets, "vendor/heroicons.js"),
        in_umbrella: true,
        css_path: Path.join(assets, "css/app.css")
      }
    end
  end

  defp print_css_instructions(target_infos) do
    Mix.shell().info("")
    Mix.shell().info("Add the plugin to your main CSS (e.g. assets/css/app.css):")
    Mix.shell().info("")
    Mix.shell().info("  " <> @plugin_line)
    Mix.shell().info("")

    Enum.each(target_infos, &print_css_path_status/1)
  end

  defp print_css_path_status(%{css_path: css_path}) do
    if File.exists?(css_path) do
      content = File.read!(css_path)

      if String.contains?(content, "vendor/heroicons") do
        Mix.shell().info("  (#{Path.relative_to_cwd(css_path)} already contains the plugin)")
      end
    end
  end

  defp print_dep_reminder do
    Mix.shell().info("Ensure :heroicons is in your mix.exs deps:")
    Mix.shell().info("  {:heroicons, github: \"tailwindlabs/heroicons\"}")
    Mix.shell().info("")
  end
end
