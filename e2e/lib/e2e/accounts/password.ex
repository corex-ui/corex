defmodule E2e.Accounts.Password do
  @moduledoc false

  import Ecto.Changeset

  @spec hash(String.t()) :: String.t()
  def hash(password) when is_binary(password), do: Bcrypt.hash_pwd_salt(password)

  @spec verify(String.t(), String.t() | nil) :: boolean()
  def verify(password, hash) when is_binary(password) and is_binary(hash) do
    Bcrypt.verify_pass(password, hash)
  end

  def verify(_password, _hash), do: Bcrypt.no_user_verify()

  @spec put_hash(Ecto.Changeset.t()) :: Ecto.Changeset.t()
  def put_hash(changeset) do
    case get_change(changeset, :password) do
      password when is_binary(password) and password != "" ->
        changeset
        |> put_change(:hashed_password, hash(password))
        |> put_change(:password, nil)

      _ ->
        changeset
    end
  end

  @spec validate(Ecto.Changeset.t()) :: Ecto.Changeset.t()
  def validate(changeset) do
    password = get_change(changeset, :password)
    hashed = get_field(changeset, :hashed_password)

    cond do
      is_binary(password) and password != "" ->
        validate_length(changeset, :password, min: 8)

      is_binary(hashed) and hashed != "" ->
        changeset

      true ->
        add_error(changeset, :password, "can't be blank")
    end
    |> put_hash()
  end
end
