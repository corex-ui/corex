defmodule MyAppWeb.CorexPageController do
  use MyAppWeb, :controller

  def index(conn, _params) do
    render(conn, :index, layout: {MyAppWeb.Layouts, :corex})
  end
end
