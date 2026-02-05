defmodule E2e.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `E2e.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        country: "some country",
        name: "some name",
        terms: true
      })
      |> E2e.Accounts.create_user()

    user
  end

  @doc """
  Generate a admin.
  """
  def admin_fixture(attrs \\ %{}) do
    {:ok, admin} =
      attrs
      |> Enum.into(%{
        country: "bel",
        name: "some name",
        terms: true
      })
      |> E2e.Accounts.create_admin()

    admin
  end
end
