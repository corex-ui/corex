defmodule E2eWeb.Layouts do
  @moduledoc """
  This module holds layouts and related functionality
  used by your application.
  """
  use E2eWeb, :html
  import E2eWeb.App.{Footer, Header, Pagination, Aside}

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
    <div class="layout__wrapper">
      <.aside path={@path} />
      <main class="layout__main">
        <.pagination path={@path} />
        <div class="layout__content">
          <div class="layout__article">
            {render_slot(@inner_block)}
          </div>
        </div>
        <.pagination_bottom path={@path} />

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
          title={gettext("We lost the connection")}
          description={gettext("We're trying to reconnect you...")}
          type={:error}
          duration={:infinity}
        />
      </main>
    </div>
    <.footer />
    """
  end

  attr(:flash, :map, required: true)

  attr(:mode, :string, default: "light")

  attr(:theme, :string, default: "neo")

  attr(:path, :string, default: nil)

  slot(:inner_block, required: true)

  def marketing(assigns) do
    path = path_resolved(assigns)
    assigns = assign(assigns, :path, path)

    ~H"""
    <.header path={@path} theme={@theme} mode={@mode} />
    <div class="layout__wrapper">
      <main class="layout__main layout__main--marketing">
        <div class="layout__content--marketing">
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
          title={gettext("We lost the connection")}
          description={gettext("We're trying to reconnect you...")}
          type={:error}
          duration={:infinity}
        />
      </main>
    </div>
    <.footer />
    """
  end

  defp path_resolved(%{path: p}) when is_binary(p), do: p

  defp path_resolved(%{conn: %Plug.Conn{} = c}),
    do: E2eWeb.Path.strip_after_locale(c.request_path)

  defp path_resolved(_), do: ""
end
