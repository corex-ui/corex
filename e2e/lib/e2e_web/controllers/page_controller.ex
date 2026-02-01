defmodule E2eWeb.PageController do
  use E2eWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end

  def accordion_page(conn, _params) do
    render(conn, :accordion_page)
  end

  def switch_page(conn, _params) do
    render(conn, :switch_page)
  end

  def toggle_group_page(conn, _params) do
    render(conn, :toggle_group_page)
  end

  def combobox_page(conn, _params) do
    render(conn, :combobox_page)
  end

  def toast_page(conn, _params) do
    render(conn, :toast_page)
  end
end
