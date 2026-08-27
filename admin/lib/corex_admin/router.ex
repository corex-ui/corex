defmodule CorexAdmin.Router do
  @moduledoc """
  Router helpers for mounting Corex Admin.

      defmodule MyAppWeb.Router do
        use MyAppWeb, :router
        import CorexAdmin.Router

        scope "/", MyAppWeb do
          pipe_through :browser
          live_corex_admin "/admin", MyAppWeb.Admin
        end
      end

  This expands to a dedicated `live_session` using the hub's `on_mount`, `layout`,
  and generic LiveViews dispatched by resource slug.

  Routes are declared with `alias: false` so they keep the `CorexAdmin.Live.*`
  modules even inside `scope "/", MyAppWeb`.
  """

  @doc """
  Mounts the admin LiveViews under `path` for the given hub module.
  """
  defmacro live_corex_admin(path, admin, opts \\ []) do
    quote bind_quoted: [path: path, admin: admin, opts: opts] do
      config = admin.__corex_admin__()
      session_name = Keyword.get(opts, :live_session, config.live_session)

      on_mount =
        List.wrap(config.on_mount) ++ [{CorexAdmin.Live.Hook, {:init, admin, path}}]

      {home_mod, home_action} = CorexAdmin.Router.home_live(config.home)

      scope path, alias: false, as: false do
        live_session session_name,
          on_mount: on_mount,
          layout: config.layout do
          live("/", home_mod, home_action)

          for {page_path, page_mod} <- config.pages do
            live(page_path, page_mod, :index)
          end

          live("/:resource", CorexAdmin.Live.Index, :index)
          live("/:resource/new", CorexAdmin.Live.Form, :new)
          live("/:resource/:id", CorexAdmin.Live.Show, :show)
          live("/:resource/:id/edit", CorexAdmin.Live.Form, :edit)
        end
      end
    end
  end

  @doc false
  def home_live({mod, action}) when is_atom(mod) and is_atom(action), do: {mod, action}
  def home_live(mod) when is_atom(mod), do: {mod, :index}
end
