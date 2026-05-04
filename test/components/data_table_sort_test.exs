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
        |> Sort.assign_for_sort(:users, default_sort_by: :id, default_sort_order: :asc)

      assert socket.assigns.sort_by == :id
      assert socket.assigns.sort_order == :asc
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
  end

  describe "handle_sort/3" do
    test "sorts by new column ascending" do
      socket =
        %Phoenix.LiveView.Socket{}
        |> assign(:users, rows())
        |> Sort.assign_for_sort(:users, default_sort_by: :id, default_sort_order: :asc)

      socket = Sort.handle_sort(socket, %{"sort_by" => "name"}, :users)

      assert socket.assigns.sort_by == :name
      assert socket.assigns.sort_order == :asc
      assert Enum.map(socket.assigns.users, & &1.name) == ["a", "b"]
    end

    test "toggles order when sorting same column" do
      socket =
        %Phoenix.LiveView.Socket{}
        |> assign(:users, rows())
        |> Sort.assign_for_sort(:users, default_sort_by: :name, default_sort_order: :asc)

      socket = Sort.handle_sort(socket, %{"sort_by" => "name"}, :users)

      assert socket.assigns.sort_order == :desc
    end
  end
end
