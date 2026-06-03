defmodule E2eWeb.Layouts do
  @moduledoc """
  This module holds layouts and related functionality
  used by your application.
  """
  use E2eWeb, :html
  import E2eWeb.SEO, only: [head: 1]
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
    assigns = assign(assigns, :path, path_resolved(assigns))

    ~H"""
    <.stack width="full" min_height="dvh" class="shell-app">
      <.header path={@path} theme={@theme} mode={@mode} />
      <.row grow="fill" width="full" wrap="nowrap" align="stretch">
        <.aside path={@path} theme={@theme} mode={@mode} />
        <.stack tag="main" id="main-content" grow="fill" width="full" padding_inline="xl">
          <.docs_pagination path={@path} />
          <.stack width="full" align="stretch" gap="xl" padding_block="xl">
            <.container size="6xl">
              {render_slot(@inner_block)}
            </.container>
          </.stack>
          <.docs_pagination_bottom path={@path} />

          <.toast_group
            id="layout-toast"
            class="toast"
            phx-update="ignore"
            flash={@flash}
          >
            <:loading>
              <.heroicon name="hero-arrow-path" />
            </:loading>
          </.toast_group>
          <.toast_client_error
            toast_group_id="layout-toast"
            title={~t"We lost the connection"}
            description={~t"We're trying to reconnect you..."}
            toast_type={:error}
            visible_duration={:infinity}
          />
        </.stack>
      </.row>
      <.footer path={@path} />
    </.stack>
    """
  end

  attr(:flash, :map, required: true)

  attr(:mode, :string, default: "light")

  attr(:theme, :string, default: "neo")

  attr(:path, :string, default: nil)

  slot(:inner_block, required: true)

  def blog(assigns) do
    assigns = assign(assigns, :path, path_resolved(assigns))

    ~H"""
    <.stack width="full" min_height="dvh">
      <.header path={@path} theme={@theme} mode={@mode} />
      <.row grow="fill" width="full">
        <.stack tag="main" id="main-content" grow="fill" width="full">
          <.stack width="full" align="stretch" class="shell-content--blog">
            {render_slot(@inner_block)}
          </.stack>
          <.toast_group
            id="layout-toast"
            class="toast"
            phx-update="ignore"
            flash={@flash}
          >
            <:loading>
              <.heroicon name="hero-arrow-path" />
            </:loading>
          </.toast_group>
          <.toast_client_error
            toast_group_id="layout-toast"
            title={~t"We lost the connection"}
            description={~t"We're trying to reconnect you..."}
            toast_type={:error}
            visible_duration={:infinity}
          />
        </.stack>
      </.row>
      <.footer path={@path} />
    </.stack>
    """
  end

  def marketing(assigns) do
    assigns = assign(assigns, :path, path_resolved(assigns))

    ~H"""
    <.stack width="full" min_height="dvh">
      <.header path={@path} theme={@theme} mode={@mode} />
      <.row grow="fill" width="full">
        <.stack tag="main" id="main-content" grow="fill" width="full">
          <.stack width="full" align="stretch" class="shell-content--marketing">
            {render_slot(@inner_block)}
          </.stack>
          <.toast_group
            id="layout-toast"
            class="toast"
            phx-update="ignore"
            flash={@flash}
          >
            <:loading>
              <.heroicon name="hero-arrow-path" />
            </:loading>
          </.toast_group>
          <.toast_client_error
            toast_group_id="layout-toast"
            title={~t"We lost the connection"}
            description={~t"We're trying to reconnect you..."}
            toast_type={:error}
            visible_duration={:infinity}
          />
        </.stack>
      </.row>
      <.footer path={@path} />
    </.stack>
    """
  end

  defp path_resolved(%{path: p}) when is_binary(p), do: p

  defp path_resolved(%{conn: %Plug.Conn{} = c}),
    do: E2eWeb.Path.strip_after_locale(c.request_path)

  defp path_resolved(_), do: ""
end
