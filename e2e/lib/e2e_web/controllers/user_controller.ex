defmodule E2eWeb.UserController do
  use E2eWeb, :controller

  import Phoenix.Component, only: [to_form: 2]

  alias E2e.Accounts
  alias E2e.Accounts.User

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, :index, users: users)
  end

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, :new, form: to_form(changeset, as: :user, id: "e2e-user-form"))
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: ~p"/users/#{user}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, form: to_form(changeset, as: :user, id: "e2e-user-form"))
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, :show, user: user)
  end

  def edit(conn, %{"id" => id} = params) do
    user = Accounts.get_user!(id)
    changeset = Accounts.change_user(user)
    return_to = if params["return_to"] == "show", do: "show", else: "index"

    render(conn, :edit,
      user: user,
      form: to_form(changeset, as: :user, id: "e2e-user-form"),
      return_to: return_to
    )
  end

  def update(conn, %{"id" => id, "user" => user_params} = params) do
    user = Accounts.get_user!(id)
    return_to = if params["return_to"] == "show", do: "show", else: "index"

    case Accounts.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: ~p"/users/#{user}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit,
          user: user,
          form: to_form(changeset, as: :user, id: "e2e-user-form"),
          return_to: return_to
        )
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    {:ok, _user} = Accounts.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: ~p"/users")
  end
end
