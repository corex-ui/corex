defmodule Mix.Tasks.Corex.Admin.Gen.Admin do
  @shortdoc "Copies the admin chrome into your app so you own the markup"

  @moduledoc """
  Copies `CorexAdmin.UI` blocks into your application.

  This is tier three, and the only tier that costs you maintenance. Prefer
  `mix corex.admin.gen.live --render` first: composing the package's blocks
  covers reordering, wrapping, and inserting content, and keeps receiving
  upstream fixes.

  Reach for this task when you need to change the **markup** of a block itself.

      $ mix corex.admin.gen.admin
      $ mix corex.admin.gen.admin --only index,filters

  ## What it writes

    * `lib/my_app_web/admin/components/*.ex` — the copied blocks, renamed into
      `MyAppWeb.Admin.Components`
    * `priv/corex_admin/ejected.exs` — which blocks were copied, and from which
      version

  Configuration is **not** copied. The ejected blocks still receive the same
  assigns, still read `@spec`, and still delegate events to the package
  controllers. Fields, filters, policy, and the context contract stay in your
  resource modules, so ejection changes composition and markup — never
  behaviour.

  ## Staying in sync

  A copied block stops tracking upstream. Run `mix corex.admin.doctor` to list
  which copies have fallen behind the installed package; it reports drift so you
  can diff and decide, which is the best any tool can do here.

  See the [eject](eject.html) guide for when to eject, the manifest, CI, and the
  upgrade workflow.
  """

  use Mix.Task

  import Mix.Phoenix, only: [otp_app: 0, base: 0, web_module: 1, web_path: 1]

  alias CorexAdmin.Eject

  @switches [only: :string]

  @impl Mix.Task
  def run(args) do
    {opts, _} = OptionParser.parse!(args, strict: @switches)
    Mix.Task.run("compile")

    blocks = selected_blocks(opts[:only])
    app = otp_app()
    web = web_module(base())
    namespace = Module.concat([web, "Admin", "Components"])
    dir = Path.join([web_path(app), "admin", "components"])

    Mix.Generator.create_directory(dir)

    manifest =
      blocks
      |> Enum.reduce(Eject.read_manifest(), fn mod, acc ->
        eject_block(mod, namespace, dir, acc)
      end)

    write_manifest(manifest)

    Mix.shell().info("""

    Ejected #{length(blocks)} block(s) into #{inspect(namespace)}.

    Point your LiveViews at them, for example:

        def render(assigns) do
          ~H"<#{inspect(namespace)}.Index.page {assigns} />"
        end

    You now own this markup. Run `mix corex.admin.doctor` after upgrading
    corex_admin to see which copies have fallen behind.
    """)
  end

  defp selected_blocks(nil), do: Eject.ejectable()

  defp selected_blocks(only) do
    wanted =
      only
      |> String.split(",", trim: true)
      |> Enum.map(&String.trim/1)
      |> Enum.map(&String.downcase/1)
      |> MapSet.new()

    blocks =
      Enum.filter(Eject.ejectable(), fn mod ->
        MapSet.member?(wanted, String.downcase(Eject.block_name(mod)))
      end)

    if blocks == [] do
      Mix.raise("""
      no matching blocks for --only #{only}

      Available: #{Enum.map_join(Eject.ejectable(), ", ", &String.downcase(Eject.block_name(&1)))}
      """)
    end

    blocks
  end

  defp eject_block(mod, namespace, dir, manifest) do
    case Eject.source_path(mod) do
      {:ok, path} ->
        contents = path |> File.read!() |> Eject.rewrite(namespace)
        Mix.Generator.create_file(Path.join(dir, Eject.file_name(mod)), contents)

        Map.put(manifest, inspect(mod), %{
          version: Eject.version(),
          sha256: Eject.digest(path)
        })

      {:error, reason} ->
        Mix.shell().error("skipped #{inspect(mod)}: #{reason}")
        manifest
    end
  end

  defp write_manifest(manifest) do
    path = Eject.manifest_path()
    Mix.Generator.create_directory(Path.dirname(path))
    File.write!(path, Eject.render_manifest(manifest))
    Mix.shell().info([:green, "* updated ", :reset, path])
  end
end
