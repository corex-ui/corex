defmodule Mix.Tasks.Corex.Admin.Install do
  @shortdoc "Generates a deny-all Corex Admin hub and policy"

  @moduledoc """
  Generates a Corex Admin hub and a **deny-all** policy.

  Authentication is not generated. Point `on_mount` at your existing
  `phx.gen.auth` hooks (or equivalent), then allow actions explicitly in the
  policy.

      $ mix corex.admin.install

  Then add to your browser pipeline scope:

      import CorexAdmin.Router
      live_corex_admin "/admin", MyAppWeb.Admin

  See the [installation](installation.html) and [security](security.html) guides.
  """

  use Mix.Task

  import Mix.Phoenix, only: [otp_app: 0, base: 0, web_module: 1, web_path: 1]

  @impl Mix.Task
  def run(_args) do
    if Mix.Project.umbrella?() do
      Mix.raise(
        "mix corex.admin.install must be invoked inside your Phoenix application directory"
      )
    end

    Mix.Task.run("compile")

    app = otp_app()
    web = web_module(base())
    path = web_path(app)
    binding = [otp_app: app, web_module: web]

    Mix.Generator.create_file(
      Path.join(path, "admin_policy.ex"),
      EEx.eval_file(template("policy.ex"), binding)
    )

    Mix.Generator.create_file(
      Path.join(path, "admin.ex"),
      EEx.eval_file(template("admin.ex"), binding)
    )

    Mix.shell().info("""

    Next steps:

    1. Point `on_mount` in #{inspect(web)}.Admin at your auth hooks
       (for example `{#{inspect(web)}.UserAuth, :ensure_authenticated}`).

    2. Allow actions in #{inspect(web)}.AdminPolicy. The generated
       policy denies everything.

    3. Add resources with `mix corex.admin.gen.resource Context Schema`.

    4. Mount routes in #{path}/router.ex inside your :browser scope:

        import CorexAdmin.Router
        live_corex_admin "/admin", #{inspect(web)}.Admin

    5. Expand :filter_parameters to include admin secrets (passwords, tokens).
    """)
  end

  defp template(name) do
    Path.join([
      Application.app_dir(:corex_admin, "priv/templates/corex.admin.install"),
      name
    ])
  end
end
