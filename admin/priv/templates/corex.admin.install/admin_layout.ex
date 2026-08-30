defmodule <%= inspect web_module %>.AdminLayout do
  @moduledoc false

  use <%= inspect web_module %>, :html

  alias CorexAdmin.UI.Nav

  # LiveView layout (`live_session layout:` / hub `layout:`). Uses `{@inner_content}`.
  def admin(assigns) do
    ~H"""
    <div class="admin flex min-h-dvh min-w-0 flex-1 flex-col bg-root text-ink" data-scope="admin">
      <header class="sticky top-0 z-20 flex h-size-lg items-center border-b border-border bg-surface">
        <div class="mx-auto flex h-size-lg w-full max-w-9xl items-center px-space-xl">
          <span class="font-semibold uppercase">{CorexAdmin.Live.Helpers.hub_title(assigns)}</span>
        </div>
      </header>
      <div class="relative mx-auto flex min-h-0 min-w-0 w-full flex-1 bg-root">
        <aside
          class="sticky top-0 hidden h-dvh w-full max-w-2xs flex-col gap-size self-start overflow-y-auto border-r border-border py-size scrollbar scrollbar--sm lg:flex [scrollbar-gutter:stable]"
          aria-label="Admin"
        >
          <Nav.tree :if={assigns[:corex_admin]} socket={assigns} id="admin-nav-tree" />
        </aside>
        <main
          id="main-content"
          class="admin-main relative mx-auto flex min-w-0 w-full flex-1 flex-col"
        >
          <nav class="admin-mobile-nav" aria-label="Admin resources">
            <Nav.mobile :if={assigns[:corex_admin]} socket={assigns} />
          </nav>
          <div class="admin-content mx-auto flex w-full min-w-0 max-w-7xl flex-1 flex-col gap-size px-space-xl py-size">
            {@inner_content}
          </div>
          <.toast_group id="layout-toast" class="toast" phx-update="ignore" flash={@flash}>
            <:loading>
              <.heroicon name="hero-arrow-path" class="icon" />
            </:loading>
          </.toast_group>
        </main>
      </div>
    </div>
    """
  end
end
