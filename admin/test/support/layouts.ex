defmodule CorexAdmin.Test.Layouts do
  @moduledoc false
  use Phoenix.Component
  use Corex

  alias CorexAdmin.UI.Nav

  def root(assigns) do
    ~H"""
    {@inner_content}
    """
  end

  def app(assigns) do
    ~H"""
    <html>
      <body>
        <div id="flash" role="status">
          <p :if={Phoenix.Flash.get(assigns[:flash] || %{}, :info)}>
            {Phoenix.Flash.get(@flash, :info)}
          </p>
          <p :if={Phoenix.Flash.get(assigns[:flash] || %{}, :error)}>
            {Phoenix.Flash.get(@flash, :error)}
          </p>
        </div>
        <div class="admin" data-scope="admin">
          <aside aria-label="Admin">
            <Nav.tree :if={assigns[:corex_admin]} socket={assigns} id="admin-nav-tree" />
          </aside>
          <nav class="admin-mobile-nav" aria-label="Admin resources">
            <Nav.mobile :if={assigns[:corex_admin]} socket={assigns} />
          </nav>
          {@inner_content}
        </div>
      </body>
    </html>
    """
  end
end
