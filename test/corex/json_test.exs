defmodule Corex.JsonTest do
  use ExUnit.Case, async: true

  alias Corex.Json

  describe "encoder/0" do
    test "returns default Jason when not configured" do
      Application.delete_env(:corex, :json_library)
      assert Json.encoder() == Jason
    end

    test "returns configured library when set" do
      Application.put_env(:corex, :json_library, Jason)
      assert Json.encoder() == Jason
      Application.delete_env(:corex, :json_library)
    end
  end

  describe "encode!/1" do
    test "encodes map to JSON string" do
      encoded = Json.encode!(%{a: 1, b: 2})
      assert is_binary(encoded)
      assert Jason.decode!(encoded) == %{"a" => 1, "b" => 2}
    end

    test "encodes list to JSON string" do
      assert Json.encode!([1, 2, 3]) == "[1,2,3]"
    end

    test "encodes string" do
      assert Json.encode!("hello") == "\"hello\""
    end
  end
end
