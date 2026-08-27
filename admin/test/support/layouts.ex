defmodule CorexAdmin.Test.Layouts do
  @moduledoc false
  use Phoenix.Component
  use Corex

  alias CorexAdmin.Live.Components

  def root(assigns) do
    ~H"""
    {@inner_content}
    """
  end

  def app(assigns) do
    ~H"""
    <html>
      <body>
        <div class="admin">
          <aside aria-label="Admin">
            <Components.nav_tree :if={assigns[:corex_admin]} socket={assigns} id="admin-nav-tree" />
          </aside>
          <nav class="admin-mobile-nav" aria-label="Admin resources">
            <Components.mobile_nav :if={assigns[:corex_admin]} socket={assigns} />
          </nav>
          {@inner_content}
        </div>
      </body>
    </html>
    """
  end
end
