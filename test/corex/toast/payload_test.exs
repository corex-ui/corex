defmodule Corex.Toast.PayloadTest do
  use ExUnit.Case, async: true

  alias Corex.Toast.Payload

  describe "create_detail/4" do
    test "builds detail map with optional id" do
      detail = Payload.create_detail("Hi", "Body", :info, id: "t1")

      assert detail.title == "Hi"
      assert detail.description == "Body"
      assert detail.id == "t1"
    end

    test "omits nil optional fields" do
      detail = Payload.create_detail("Hi", nil, :info, id: nil)

      refute Map.has_key?(detail, :id)
    end
  end

  describe "create_server_data/5" do
    test "includes groupId" do
      detail = Payload.create_server_data("g1", "Hi", "Body", :info, [])

      assert detail.groupId == "g1"
      assert detail.title == "Hi"
    end
  end

  describe "update_detail/2" do
    test "merges attrs onto id" do
      assert Payload.update_detail("t1", %{title: "New"}) == %{id: "t1", title: "New"}
    end
  end

  describe "type_string/1" do
    test "maps atoms and unknown values" do
      assert Payload.type_string(:success) == "success"
      assert Payload.type_string("error") == "error"
      assert Payload.type_string(:other) == "info"
    end
  end
end
