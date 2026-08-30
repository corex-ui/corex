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
  and **per-resource** LiveViews (`live:` on the resource, or the generic
  `CorexAdmin.Live.*` modules).

  Routes are declared with `alias: false` so they keep the `CorexAdmin.Live.*`
  modules even inside `scope "/", MyAppWeb`.

  `POST /:resource/export` is mounted in the same scope (outside `live_session`)
  so the picker can stream CSV/JSON through `CorexAdmin.ExportController`.
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

          for resource <- config.resources do
            spec = resource.__corex_admin_resource__()
            lives = spec.live
            index_mod = lives[:index] || CorexAdmin.Live.Index
            form_mod = lives[:form] || CorexAdmin.Live.Form
            show_mod = lives[:show] || CorexAdmin.Live.Show

            live("/#{spec.slug}", index_mod, :index)
            live("/#{spec.slug}/new", form_mod, :new)
            live("/#{spec.slug}/:id", show_mod, :show)
            live("/#{spec.slug}/:id/edit", form_mod, :edit)
          end
        end

        post("/:resource/export", CorexAdmin.ExportController, :create)
      end
    end
  end

  @doc "Resolves `home:` to `{module, live_action}` (default action `:index`)."
  def home_live({mod, action}) when is_atom(mod) and is_atom(action), do: {mod, action}
  def home_live(mod) when is_atom(mod), do: {mod, :index}

  @doc "Index/form/show modules for a resource spec, including `live:` overrides."
  def live_modules(%{live: live}) when is_map(live) do
    %{
      index: live[:index] || CorexAdmin.Live.Index,
      form: live[:form] || CorexAdmin.Live.Form,
      show: live[:show] || CorexAdmin.Live.Show
    }
  end
end
