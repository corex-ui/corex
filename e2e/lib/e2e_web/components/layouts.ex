defmodule E2eWeb.Layouts do
  @moduledoc """
  This module holds layouts and related functionality
  used by your application.
  """
  use E2eWeb, :html
  import E2eWeb.SEO, only: [head: 1]
  import E2eWeb.App.{Footer, Header, Pagination, Aside}
  alias CorexAdmin.UI.Nav, as: AdminNav
  alias E2eWeb.App.Shell

  import E2eWeb.{ModeToggle, ThemeToggle}

  embed_templates("layouts/*")

  @doc """
  Renders your app layout.

  ## Examples

      <Layouts.app flash={@flash} mode={@mode} theme={@theme} path={@path}>
        <h1>Content</h1>
      </Layouts.app>
  """
  attr(:flash, :map, required: true, doc: "the map of flash messages")

  attr(:mode, :string, default: "light", doc: "the mode (dark or light) from cookie/session")

  attr(:theme, :string, default: "neo", doc: "the theme (neo, uno, duo, leo) from cookie/session")

  attr(:path, :string,
    default: nil,
    doc: "path after `/:locale` (from `Plugs.Path` on HTTP, `PathLive` on LiveView)"
  )

  slot(:inner_block, required: true)

  def app(assigns) do
    path = path_resolved(assigns)
    assigns = assign(assigns, :path, path)

    ~H"""
    <.header path={@path} theme={@theme} mode={@mode} />
    <div class={Shell.wrapper()}>
      <.aside path={@path} theme={@theme} mode={@mode} />
      <main id="main-content" class={Shell.main()}>
        <div class={Shell.docs_body()}>
          <.docs_pagination path={@path} />
          <div class={Shell.content()}>
            <div class={Shell.article()}>
              {render_slot(@inner_block)}
            </div>
          </div>
          <.docs_pagination_bottom path={@path} />

          <.toast_group
            id="layout-toast"
            class="toast"
            phx-update="ignore"
            flash={@flash}
          >
            <:loading>
              <.heroicon name="hero-arrow-path" class="icon" />
            </:loading>
          </.toast_group>
          <.toast_client_error
            toast_group_id="layout-toast"
            title={~t"We lost the connection"}
            description={~t"We're trying to reconnect you..."}
            type={:error}
            duration={:infinity}
          />
        </div>
        <.footer path={@path} />
      </main>
    </div>
    """
  end

  attr(:flash, :map, required: true)

  attr(:mode, :string, default: "light")

  attr(:theme, :string, default: "neo")

  attr(:path, :string, default: nil)

  slot(:inner_block, required: true)

  def blog(assigns) do
    path = path_resolved(assigns)
    assigns = assign(assigns, :path, path)

    ~H"""
    <.header path={@path} theme={@theme} mode={@mode} />
    <div class={Shell.wrapper() <> " shell-blog-wrapper"}>
      <main id="main-content" class={Shell.main() <> " shell-blog-main w-full"}>
        <div class={Shell.content_blog() <> " shell-blog-content items-stretch"}>
          {render_slot(@inner_block)}
        </div>
        <.toast_group
          id="layout-toast"
          class="toast"
          phx-update="ignore"
          flash={@flash}
        >
          <:loading>
            <.heroicon name="hero-arrow-path" class="icon" />
          </:loading>
        </.toast_group>
        <.toast_client_error
          toast_group_id="layout-toast"
          title={~t"We lost the connection"}
          description={~t"We're trying to reconnect you..."}
          type={:error}
          duration={:infinity}
        />
      </main>
    </div>
    <.footer path={@path} />
    """
  end

  # LiveView layout (`live_session layout:` / hub `layout:`). Uses `@inner_content`.
  def admin(assigns) do
    path = path_resolved(assigns)
    assigns = assign(assigns, :path, path)

    ~H"""
    <.header path={@path} theme={@theme} mode={@mode} />
    <div class={"admin " <> Shell.wrapper()} data-scope="admin">
      <aside class={Shell.side()} aria-label="Admin">
        <AdminNav.tree
          :if={assigns[:corex_admin]}
          socket={assigns}
          id="admin-nav-tree"
          class={Shell.aside_tree()}
        />
      </aside>
      <main id="main-content" class={"admin-main " <> Shell.main()}>
        <nav class="admin-mobile-nav" aria-label="Admin resources">
          <AdminNav.mobile :if={assigns[:corex_admin]} socket={assigns} />
        </nav>
        <div class={Shell.admin_content()}>
          {@inner_content}
        </div>
        <.toast_group
          id="layout-toast"
          class="toast"
          phx-update="ignore"
          flash={@flash}
        >
          <:loading>
            <.heroicon name="hero-arrow-path" class="icon" />
          </:loading>
        </.toast_group>
        <.toast_client_error
          toast_group_id="layout-toast"
          title={~t"We lost the connection"}
          description={~t"We're trying to reconnect you..."}
          type={:error}
          duration={:infinity}
        />
        <.footer path={@path} />
      </main>
    </div>
    """
  end

  def marketing(assigns) do
    path = path_resolved(assigns)
    assigns = assign(assigns, :path, path)

    ~H"""
    <.header id="home-header" path={@path} theme={@theme} mode={@mode} />
    <div class={Shell.wrapper()}>
      <main id="main-content" class={Shell.main() <> " w-full"}>
        <div class={Shell.content_marketing()}>
          {render_slot(@inner_block)}
        </div>
        <.toast_group
          id="layout-toast"
          class="toast"
          phx-update="ignore"
          flash={@flash}
        >
          <:loading>
            <.heroicon name="hero-arrow-path" class="icon" />
          </:loading>
        </.toast_group>
        <.toast_client_error
          toast_group_id="layout-toast"
          title={~t"We lost the connection"}
          description={~t"We're trying to reconnect you..."}
          type={:error}
          duration={:infinity}
        />
      </main>
    </div>
    <.footer id="home-footer" path={@path} />
    """
  end

  defp path_resolved(%{path: p}) when is_binary(p), do: p

  defp path_resolved(%{conn: %Plug.Conn{} = c}),
    do: E2eWeb.Path.strip_after_locale(c.request_path)

  defp path_resolved(_), do: ""

  defp a11y_data_attrs(nil), do: a11y_data_attrs(%{})

  defp a11y_data_attrs(a11y) when is_map(a11y) do
    a11y
    |> Corex.Design.Accessibility.sanitize()
    |> Map.new(fn {key, value} -> {"data-#{key}", value} end)
  end
end
