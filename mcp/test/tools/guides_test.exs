defmodule Corex.MCP.Tools.GuidesTest do
  use ExUnit.Case, async: true

  alias Corex.MCP.Tools.Guides

  test "tools/0 registers search and navigation" do
    names = for t <- Guides.tools(), do: t.name
    assert "search_docs" in names
    assert "navigation_guide" in names
  end

  test "navigation_guide returns patterns" do
    case Guides.navigation_guide(%{}) do
      {:ok, json} ->
        decoded = Corex.MCP.Json.decode!(json)
        assert is_list(decoded["patterns"])
        assert Enum.any?(decoded["patterns"], &(&1["name"] == "redirect_on_select"))

      other ->
        flunk("unexpected result: #{inspect(other)}")
    end
  end

  test "search_docs finds usage-rules text" do
    case Guides.search_docs(%{"query" => "Corex.List"}) do
      {:ok, json} ->
        decoded = Corex.MCP.Json.decode!(json)
        assert decoded["query"] == "Corex.List"
        assert is_list(decoded["results"])

      other ->
        flunk("unexpected result: #{inspect(other)}")
    end
  end

  test "search_docs rejects empty query" do
    case Guides.search_docs(%{"query" => ""}) do
      {:error, %{code: -32_602}} -> :ok
      other -> flunk("unexpected result: #{inspect(other)}")
    end
  end
end
