defmodule Corex.MCP.Tools.ComponentsTest do
  use ExUnit.Case, async: true

  alias Corex.MCP.Tools.Components

  test "tools/0 registers list and get" do
    names = for t <- Components.tools(), do: t.name
    assert "list_components" in names
    assert "get_component" in names
  end

  test "list_components returns encoded ids" do
    json =
      case Components.list_components(%{}) do
        {:ok, j} -> j
        other -> flunk("expected {:ok, json}, got #{inspect(other)}")
      end

    decoded = Corex.Json.decode!(json)
    assert is_list(decoded["components"])
    assert "accordion" in decoded["components"]
    assert decoded["components"] == Enum.map(Corex.component_ids(), &to_string/1)
  end

  test "get_component returns spec, docs, and source metadata for a known id" do
    json =
      case Components.get_component(%{"id" => "accordion"}) do
        {:ok, j} -> j
        other -> flunk("expected {:ok, json}, got #{inspect(other)}")
      end

    decoded = Corex.Json.decode!(json)
    assert decoded["id"] == "accordion"
    assert decoded["module"] =~ "Accordion"
    assert decoded["function_components"] != []
    assert is_binary(decoded["docs"])
    assert String.starts_with?(decoded["docs"], "# ")
    assert String.starts_with?(decoded["docs"], "# #{decoded["module"]}\n\n")
    assert is_nil(decoded["docs_note"])
    assert is_binary(decoded["source_path"])
    assert decoded["source_path"] =~ "accordion.ex"
    assert is_integer(decoded["source_line"])
  end

  test "get_component rejects unknown id with guidance" do
    assert {:error, msg} = Components.get_component(%{"id" => "not_a_real_component_zzz"})
    assert msg =~ "Unknown component id"
    assert msg =~ "list_components"
  end

  test "get_component rejects invalid arguments" do
    assert {:error, :invalid_arguments} = Components.get_component(%{})
    assert {:error, :invalid_arguments} = Components.get_component(%{"id" => 1})
  end
end
