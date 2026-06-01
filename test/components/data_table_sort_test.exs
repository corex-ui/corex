defmodule Corex.DataTable.SortTest do
  use ExUnit.Case, async: true

  import Phoenix.Component

  alias Corex.DataTable.Sort

  defp rows do
    [%{id: 2, name: "b"}, %{id: 1, name: "a"}]
  end

  describe "assign_for_sort/3" do
    test "sorts rows by default column and order" do
      socket =
        %Phoenix.LiveView.Socket{}
        |> assign(:users, rows())
        |> Sort.assign_for_sort(:users,
          default_sort_by: :id,
          default_sort_order: :asc,
          sort_columns: [:id, :name]
        )

      assert socket.assigns.sort_by == :id
      assert socket.assigns.sort_order == :asc
      assert socket.assigns.sort_columns == [:id, :name]
      assert Enum.map(socket.assigns.users, & &1.id) == [1, 2]
    end

    test "leaves rows unchanged when sort_by is nil" do
      original = rows()

      socket =
        %Phoenix.LiveView.Socket{}
        |> assign(:users, original)
        |> Sort.assign_for_sort(:users, default_sort_by: nil, default_sort_order: :asc)

      assert socket.assigns.users == original
    end

    test "infers sort_columns from rows when omitted" do
      socket =
        %Phoenix.LiveView.Socket{}
        |> assign(:users, rows())
        |> Sort.assign_for_sort(:users, default_sort_by: :id, default_sort_order: :asc)

      assert socket.assigns.sort_columns == [:id, :name]
    end

    test "infers default_sort_by only when rows empty" do
      socket =
        %Phoenix.LiveView.Socket{}
        |> assign(:users, [])
        |> Sort.assign_for_sort(:users, default_sort_by: :id, default_sort_order: :asc)

      assert socket.assigns.sort_columns == [:id]
    end
  end

  describe "handle_sort/3" do
    defp sorted_socket(opts \\ []) do
      defaults = [default_sort_by: :id, default_sort_order: :asc, sort_columns: [:id, :name]]

      %Phoenix.LiveView.Socket{}
      |> assign(:users, rows())
      |> Sort.assign_for_sort(:users, Keyword.merge(defaults, opts))
    end

    test "sorts by new column ascending" do
      socket = sorted_socket()

      socket = Sort.handle_sort(socket, %{"sort_by" => "name"}, :users)

      assert socket.assigns.sort_by == :name
      assert socket.assigns.sort_order == :asc
      assert Enum.map(socket.assigns.users, & &1.name) == ["a", "b"]
    end

    test "toggles order when sorting same column" do
      socket = sorted_socket(default_sort_by: :name)

      socket = Sort.handle_sort(socket, %{"sort_by" => "name"}, :users)

      assert socket.assigns.sort_order == :desc
    end

    test "ignores unknown sort_by atom" do
      socket = sorted_socket()

      assert socket == Sort.handle_sort(socket, %{"sort_by" => "not_a_column"}, :users)
    end

    test "ignores sort_by not in sort_columns whitelist" do
      socket = sorted_socket(sort_columns: [:id])

      before = socket.assigns
      socket = Sort.handle_sort(socket, %{"sort_by" => "name"}, :users)

      assert socket.assigns.sort_by == before.sort_by
      assert socket.assigns.sort_order == before.sort_order
      assert socket.assigns.users == before.users
    end

    test "infers sort_columns from rows when omitted and sorts" do
      socket =
        %Phoenix.LiveView.Socket{}
        |> assign(:users, rows())
        |> Sort.assign_for_sort(:users, default_sort_by: :id, default_sort_order: :asc)

      socket = Sort.handle_sort(socket, %{"sort_by" => "name"}, :users)

      assert socket.assigns.sort_by == :name
      assert socket.assigns.sort_order == :asc
      assert Enum.map(socket.assigns.users, & &1.name) == ["a", "b"]
    end

    test "rejects forged sort_by not in inferred columns" do
      rows = [%{id: 1}]

      socket =
        %Phoenix.LiveView.Socket{}
        |> assign(:users, rows)
        |> Sort.assign_for_sort(:users, default_sort_by: :id, default_sort_order: :asc)

      before = socket.assigns
      socket = Sort.handle_sort(socket, %{"sort_by" => "name"}, :users)

      assert socket.assigns.sort_by == before.sort_by
      assert socket.assigns.sort_order == before.sort_order
      assert socket.assigns.users == before.users
    end

    test "ignores sort_by when sort_columns is explicitly nil" do
      socket =
        %Phoenix.LiveView.Socket{}
        |> assign(:users, rows())
        |> Sort.assign_for_sort(:users,
          default_sort_by: :id,
          default_sort_order: :asc,
          sort_columns: nil
        )

      before = socket.assigns
      socket = Sort.handle_sort(socket, %{"sort_by" => "name"}, :users)

      assert socket.assigns.sort_by == before.sort_by
      assert socket.assigns.sort_order == before.sort_order
      assert socket.assigns.users == before.users
    end
  end

  describe "parse_sort_by/2" do
    test "rejects when sort_columns is nil" do
      assert Sort.parse_sort_by("id", nil) == :error
    end

    test "accepts whitelisted column" do
      assert Sort.parse_sort_by("name", [:id, :name]) == {:ok, :name}
    end

    test "rejects column not in whitelist" do
      assert Sort.parse_sort_by("name", [:id]) == :error
    end
  end
end
