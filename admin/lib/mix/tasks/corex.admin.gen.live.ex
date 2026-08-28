defmodule Mix.Tasks.Corex.Admin.Gen.Live do
  @shortdoc "Generates host LiveViews that use CorexAdmin.Live"

  @moduledoc """
  Writes host LiveViews for a resource's index, show, and form pages.

  This is tier two of three. The generated modules `use CorexAdmin.Live, :index`
  (and friends), so behaviour — auth, URL state, events — stays in the package
  and keeps receiving fixes. You own only what you choose to override.

      $ mix corex.admin.gen.live PostResource
      $ mix corex.admin.gen.live PostResource --render

  Without `--render`, each file is a four-line wrapper: override a callback and
  call `super` when you need to.

  With `--render`, each file also gets a `render/1` that **composes public
  `CorexAdmin.UI` blocks**. Reorder them, delete one, wrap one, or fill a slot.
  The blocks stay in the package, so this is customization you do not have to
  maintain against upstream changes.

  When even that is not enough, `mix corex.admin.gen.admin` copies the block
  markup into your app. That is tier three, and it is the only tier where you
  take on maintenance.

  Then point the resource at the generated modules:

      use CorexAdmin.Resource,
        live: [
          index: MyAppWeb.Admin.PostLive.Index,
          show: MyAppWeb.Admin.PostLive.Show,
          form: MyAppWeb.Admin.PostLive.Form
        ]
  """

  use Mix.Task

  import Mix.Phoenix, only: [otp_app: 0, base: 0, web_module: 1, web_path: 1]

  @switches [render: :boolean]

  @impl Mix.Task
  def run(args) do
    {opts, positional} = OptionParser.parse!(args, strict: @switches)

    case positional do
      [resource] ->
        Mix.Task.run("compile")
        generate(resource, Keyword.get(opts, :render, false))

      _ ->
        Mix.raise("expected mix corex.admin.gen.live ResourceModule [--render]")
    end
  end

  defp generate(resource_name, render?) do
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

    suffix = if render?, do: "_render", else: ""

    for page <- ~w(index show form) do
      Mix.Generator.create_file(
        Path.join(dir, "#{page}.ex"),
        EEx.eval_file(template("#{page}#{suffix}.ex"), binding)
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

    if render? do
      Mix.shell().info("""
      These pages compose CorexAdmin.UI blocks. The block markup stays in the
      package, so upstream fixes still reach them.
      """)
    end
  end

  defp template(name) do
    Path.join([
      Application.app_dir(:corex_admin, "priv/templates/corex.admin.gen.live"),
      name
    ])
  end
end
