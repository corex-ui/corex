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

  def checkbox_page(conn, _params) do
    render(conn, :checkbox_page)
  end

  def toast_page(conn, params) do
    initial_values = %{
      message: params["message"] || "Hello, World!",
      type: params["type"] || "info"
    }

    changeset =
      {%{}, %{message: :string, type: :string}}
      |> Ecto.Changeset.change(initial_values)

    render(conn, :toast_page, changeset: changeset)
  end

  def create_toast(conn, %{"toast" => toast_params}) do
    changeset =
      {%{}, %{message: :string, type: :string}}
      |> Ecto.Changeset.change(%{})
      |> Ecto.Changeset.cast(toast_params, [:message, :type])
      |> Ecto.Changeset.validate_required([:message, :type])

    if changeset.valid? do
      flash_type = String.to_existing_atom(toast_params["type"])

      conn
      |> put_flash(flash_type, toast_params["message"])
      |> redirect(to: ~p"/toast?message=#{toast_params["message"]}&type=#{toast_params["type"]}")
    else
      render(conn, :toast_page, changeset: changeset)
    end
  end

  def select_page(conn, _params) do
    render(conn, :select_page)
  end

  def tabs_page(conn, _params) do
    render(conn, :tabs_page)
  end
end
