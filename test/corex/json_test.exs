defmodule Corex.JsonTest do
  use ExUnit.Case, async: true

  alias Corex.Json

  describe "encoder/0" do
    test "uses Phoenix.json_library when Phoenix is available" do
      Application.delete_env(:corex, :json_library)
      assert Json.encoder() == Phoenix.json_library()
    end
  end

  describe "encode!/1" do
    test "encodes map to JSON string" do
      encoded = Json.encode!(%{a: 1, b: 2})
      assert is_binary(encoded)
      assert Json.decode!(encoded) == %{"a" => 1, "b" => 2}
    end

    test "encodes list to JSON string" do
      assert Json.encode!([1, 2, 3]) == "[1,2,3]"
    end

    test "encodes string" do
      assert Json.encode!("hello") == "\"hello\""
    end
  end

  describe "encode_to_iodata!/1" do
    test "produces iodata" do
      out = Json.encode_to_iodata!(%{a: 1})
      assert is_binary(out) or is_list(out)
      assert Json.decode!(out) == %{"a" => 1}
    end
  end

  describe "decode/1 and decode!/1" do
    test "decode returns ok tuple" do
      assert Json.decode("{\"a\":1}") == {:ok, %{"a" => 1}}
    end

    test "decode! returns term" do
      assert Json.decode!("{\"a\":1}") == %{"a" => 1}
    end
  end
end
