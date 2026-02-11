defmodule E2e.AccountsTest do
  use E2e.DataCase

  alias E2e.Accounts

  describe "users" do
    alias E2e.Accounts.User

    import E2e.AccountsFixtures

    @invalid_attrs %{name: nil, country: nil, birth_date: nil, terms: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{
        name: "some name",
        country: "some country",
        birth_date: "1990-01-15",
        signature:
          "[\"M153.45,56.79 Q152.46,57.28 150.62,57.98 T148.61,58.72 148.29,58.71 147.99,58.61 147.74,58.41 147.56,58.14 147.48,57.84 147.50,57.52 147.62,57.22 147.83,56.98 148.11,56.82 148.42,56.75 148.74,56.79 149.03,56.93 149.25,57.15 149.40,57.44 149.45,57.75 149.39,58.07 149.24,58.35 149.01,58.56 148.72,58.69 148.40,58.73 148.09,58.65 147.82,58.49 147.61,58.24 147.50,57.94 147.48,57.62 147.57,57.32 147.75,57.05 148.01,56.86 148.15,56.79 149.87,56.14 152.07,55.24 152.67,54.96 152.90,54.90 153.14,54.91 153.37,54.97 153.58,55.08 153.76,55.25 153.89,55.45 153.97,55.67 153.99,55.91 153.96,56.15 153.87,56.37 153.73,56.56 153.55,56.72 Z\"]",
        terms: true
      }

      assert {:ok, %User{} = user} = Accounts.create_user(valid_attrs)
      assert user.name == "some name"
      assert user.country == "some country"
      assert user.birth_date == ~D[1990-01-15]
      assert user.terms == true
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()

      update_attrs = %{
        name: "some updated name",
        country: "some updated country",
        birth_date: "1995-06-20",
        terms: true
      }

      assert {:ok, %User{} = user} = Accounts.update_user(user, update_attrs)
      assert user.name == "some updated name"
      assert user.country == "some updated country"
      assert user.birth_date == ~D[1995-06-20]
      assert user.terms == true
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end

  describe "admins" do
    alias E2e.Accounts.Admin

    import E2e.AccountsFixtures

    @invalid_attrs %{name: nil, country: nil, birth_date: nil, terms: nil}

    test "list_admins/0 returns all admins" do
      admin = admin_fixture()
      assert Accounts.list_admins() == [admin]
    end

    test "get_admin!/1 returns the admin with given id" do
      admin = admin_fixture()
      assert Accounts.get_admin!(admin.id) == admin
    end

    test "create_admin/1 with valid data creates a admin" do
      valid_attrs = %{
        name: "some name",
        country: :fra,
        birth_date: "1990-01-15",
        signature:
          "[\"M153.45,56.79 Q152.46,57.28 150.62,57.98 T148.61,58.72 148.29,58.71 147.99,58.61 147.74,58.41 147.56,58.14 147.48,57.84 147.50,57.52 147.62,57.22 147.83,56.98 148.11,56.82 148.42,56.75 148.74,56.79 149.03,56.93 149.25,57.15 149.40,57.44 149.45,57.75 149.39,58.07 149.24,58.35 149.01,58.56 148.72,58.69 148.40,58.73 148.09,58.65 147.82,58.49 147.61,58.24 147.50,57.94 147.48,57.62 147.57,57.32 147.75,57.05 148.01,56.86 148.15,56.79 149.87,56.14 152.07,55.24 152.67,54.96 152.90,54.90 153.14,54.91 153.37,54.97 153.58,55.08 153.76,55.25 153.89,55.45 153.97,55.67 153.99,55.91 153.96,56.15 153.87,56.37 153.73,56.56 153.55,56.72 Z\"]",
        terms: true
      }

      assert {:ok, %Admin{} = admin} = Accounts.create_admin(valid_attrs)
      assert admin.name == "some name"
      assert admin.country == :fra
      assert admin.birth_date == ~D[1990-01-15]
      assert admin.terms == true
    end

    test "create_admin/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_admin(@invalid_attrs)
    end

    test "update_admin/2 with valid data updates the admin" do
      admin = admin_fixture()

      update_attrs = %{
        name: "some updated name",
        country: :deu,
        birth_date: "1995-06-20",
        terms: true
      }

      assert {:ok, %Admin{} = admin} = Accounts.update_admin(admin, update_attrs)
      assert admin.name == "some updated name"
      assert admin.country == :deu
      assert admin.birth_date == ~D[1995-06-20]
      assert admin.terms == true
    end

    test "update_admin/2 with invalid data returns error changeset" do
      admin = admin_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_admin(admin, @invalid_attrs)
      assert admin == Accounts.get_admin!(admin.id)
    end

    test "delete_admin/1 deletes the admin" do
      admin = admin_fixture()
      assert {:ok, %Admin{}} = Accounts.delete_admin(admin)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_admin!(admin.id) end
    end

    test "change_admin/1 returns a admin changeset" do
      admin = admin_fixture()
      assert %Ecto.Changeset{} = Accounts.change_admin(admin)
    end
  end
end
