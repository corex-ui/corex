defmodule CorexAdmin.Test.Layouts do
  @moduledoc false
  use Phoenix.Component

  def root(assigns) do
    ~H"""
    {@inner_content}
    """
  end

  def app(assigns) do
    ~H"""
    <html>
      <body>
        <main>
          {@inner_content}
        </main>
      </body>
    </html>
    """
  end
end
