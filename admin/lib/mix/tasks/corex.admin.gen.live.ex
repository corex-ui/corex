defmodule Mix.Tasks.Corex.Admin.Gen.Live do
  @shortdoc "Generates thin host LiveViews that use CorexAdmin.Live"

  @moduledoc """
  Writes ~40-line wrappers for a resource's index/show/form pages.

  Like `phx.gen.auth`, this is an escape hatch — not a copy of package
  internals. The generated modules `use CorexAdmin.Live, :index` (etc) so they
  keep receiving library fixes. Override callbacks and call `super` when a page
  must diverge.

      $ mix corex.admin.gen.live PostResource

  Then set `live:` on the resource:

      use CorexAdmin.Resource,
        live: [
          index: MyAppWeb.Admin.PostLive.Index,
          show: MyAppWeb.Admin.PostLive.Show,
          form: MyAppWeb.Admin.PostLive.Form
        ]
  """

  use Mix.Task

  import Mix.Phoenix, only: [otp_app: 0, base: 0, web_module: 1, web_path: 1]

  @impl Mix.Task
  def run(args) do
    case args do
      [resource] ->
        Mix.Task.run("compile")
        generate(resource)

      _ ->
        Mix.raise("expected mix corex.admin.gen.live ResourceModule")
    end
  end

  defp generate(resource_name) do
    app = otp_app()
    app_base = base()
    web = web_module(app_base)
    path = web_path(app)

    resource_mod = Module.concat([web, "Admin", resource_name])
    basename = resource_name |> Macro.underscore() |> String.replace_suffix("_resource", "")
    live_ns = Module.concat([web, "Admin", Macro.camelize(basename) <> "Live"])

    binding = [
      index_module: Module.concat(live_ns, "Index"),
      show_module: Module.concat(live_ns, "Show"),
      form_module: Module.concat(live_ns, "Form"),
      resource_module: resource_mod
    ]

    dir = Path.join([path, "admin", "#{basename}_live"])
    Mix.Generator.create_directory(dir)

    for {file, template} <- [
          {"index.ex", "index.ex"},
          {"show.ex", "show.ex"},
          {"form.ex", "form.ex"}
        ] do
      Mix.Generator.create_file(
        Path.join(dir, file),
        EEx.eval_file(template(template), binding)
      )
    end

    Mix.shell().info("""

    Add to #{inspect(resource_mod)}:

        live: [
          index: #{inspect(binding[:index_module])},
          show: #{inspect(binding[:show_module])},
          form: #{inspect(binding[:form_module])}
        ]
    """)
  end

  defp template(name) do
    Path.join([
      Application.app_dir(:corex_admin, "priv/templates/corex.admin.gen.live"),
      name
    ])
  end
end
