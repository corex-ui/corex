defmodule Corex.MCP.JsonParityTest do
  use ExUnit.Case, async: true

  @fixtures [
    %{a: 1, b: nil, c: "x"},
    %{nested: %{list: [1, nil, "two", true, false]}},
    [],
    %{},
    %{unicode: "héllo · ünïcode", escaped: "quote\" backslash\\ newline\n"},
    %{atom_value: :accent, float: 1.5, big: 9_007_199_254_740_993}
  ]

  test "Corex.MCP.Json encodes exactly like Corex.Json" do
    for fixture <- @fixtures do
      assert Corex.MCP.Json.encode!(fixture) == Corex.Json.encode!(fixture),
             "encoding drift on #{inspect(fixture)}"
    end
  end

  test "Corex.MCP.Json decodes exactly like Corex.Json" do
    for fixture <- @fixtures do
      json = Corex.Json.encode!(fixture)

      assert Corex.MCP.Json.decode!(json) == Corex.Json.decode!(json),
             "decoding drift on #{json}"
    end
  end

  test "both round-trip null as nil" do
    assert Corex.MCP.Json.decode!(~s({"a":null})) == %{"a" => nil}
    assert Corex.Json.decode!(~s({"a":null})) == %{"a" => nil}
  end

  test "decode/1 wraps failures instead of raising" do
    assert {:error, _} = Corex.MCP.Json.decode("{not json")
    assert {:error, _} = Corex.Json.decode("{not json")
  end
end
