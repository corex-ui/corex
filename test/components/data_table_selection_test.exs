defmodule Corex.DataTable.SelectionTest do
  use ExUnit.Case, async: true

  import Phoenix.Component

  alias Corex.DataTable.Selection

  defp base_socket do
    %Phoenix.LiveView.Socket{}
    |> assign(:users, [%{id: 1}, %{id: 2}])
    |> Selection.assign_for_selection(:users,
      table_id: "tbl",
      row_id: &"#{&1.id}"
    )
  end

  describe "assign_for_selection/3" do
    test "sets selection assigns" do
      socket = base_socket()
      assert socket.assigns.selected == []
      assert socket.assigns.selection_table_id == "tbl"
      assert socket.assigns.selection_row_id.(%{id: 5}) == "5"
    end
  end

  describe "handle_select/3" do
    test "selects and deselects row ids" do
      socket = base_socket()

      socket =
        Selection.handle_select(socket, %{"id" => "tbl-select-1", "checked" => true}, :users)

      assert socket.assigns.selected == ["1"]

      socket =
        Selection.handle_select(socket, %{"id" => "tbl-select-1", "checked" => false}, :users)

      assert socket.assigns.selected == []
    end

    test "treats string checked values like booleans" do
      socket = base_socket()

      socket =
        Selection.handle_select(socket, %{"id" => "tbl-select-1", "checked" => "true"}, :users)

      assert socket.assigns.selected == ["1"]

      socket =
        Selection.handle_select(socket, %{"id" => "tbl-select-1", "checked" => "false"}, :users)

      assert socket.assigns.selected == []
    end

    test "does not select when checked is the string false" do
      socket = base_socket()

      socket =
        Selection.handle_select(socket, %{"id" => "tbl-select-1", "checked" => "false"}, :users)

      assert socket.assigns.selected == []
    end

    test "aggregates multiple selections and updates select-all state" do
      socket = base_socket()

      socket =
        Selection.handle_select(socket, %{"id" => "tbl-select-1", "checked" => true}, :users)

      socket =
        Selection.handle_select(socket, %{"id" => "tbl-select-2", "checked" => true}, :users)

      assert Enum.sort(socket.assigns.selected) == ["1", "2"]
    end

    test "ignores forged row id when checking" do
      socket = base_socket()

      socket =
        Selection.handle_select(socket, %{"id" => "tbl-select-forged", "checked" => true}, :users)

      assert socket.assigns.selected == []
    end

    test "drops stale selected ids not in current rows" do
      socket =
        base_socket()
        |> assign(:selected, ["1", "stale"])

      socket =
        Selection.handle_select(socket, %{"id" => "tbl-select-2", "checked" => true}, :users)

      assert Enum.sort(socket.assigns.selected) == ["1", "2"]
    end
  end

  describe "handle_select_all/3" do
    test "checks all rows when checked true" do
      socket = base_socket()

      socket =
        Selection.handle_select_all(socket, %{"checked" => true}, :users)

      assert Enum.sort(socket.assigns.selected) == ["1", "2"]

      events = get_in(socket.private, [:live_temp, :push_events]) || []

      assert ["checkbox_set_checked_many", %{"checked" => true, "ids" => ids}] =
               Enum.find(events, &match?(["checkbox_set_checked_many", _], &1))

      assert Enum.sort(ids) == ["tbl-select-1", "tbl-select-2"]
    end

    test "does not select when checked is the string false" do
      socket =
        base_socket()
        |> Selection.handle_select_all(%{"checked" => "false"}, :users)

      assert socket.assigns.selected == []
    end

    test "clears selection when checked false" do
      socket =
        base_socket()
        |> Selection.handle_select_all(%{"checked" => true}, :users)
        |> Selection.handle_select_all(%{"checked" => false}, :users)

      assert socket.assigns.selected == []
    end
  end
end
