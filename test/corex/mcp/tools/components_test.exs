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

  test "list_components rejects non-empty arguments" do
    assert {:error, :invalid_arguments} = Components.list_components(%{"extra" => "x"})
  end

  test "get_component rejects unknown keys" do
    assert {:error, :invalid_arguments} =
             Components.get_component(%{"id" => "accordion", "extra" => "x"})
  end

  test "get_component rejects id longer than 64 bytes" do
    long_id = String.duplicate("a", 65)
    assert {:error, :invalid_arguments} = Components.get_component(%{"id" => long_id})
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
    refute String.starts_with?(decoded["source_path"], "/")
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

  test "get_component includes markdown docs and source metadata when available" do
    for id <- ["accordion", "code", "marquee"] do
      json = ok_json!(Components.get_component(%{"id" => id}))
      decoded = Corex.Json.decode!(json)
      assert decoded["id"] == id
      assert is_binary(decoded["docs"])
      assert decoded["docs"] =~ "# "
      assert is_binary(decoded["source_path"])
      assert is_integer(decoded["source_line"])
    end
  end

  test "get_component returns spec for representative registry ids" do
    ids = [:accordion, :toast, :tree_view, :menu, :date_picker, :select, :dialog]

    for id <- ids do
      json = ok_json!(Components.get_component(%{"id" => to_string(id)}))
      decoded = Corex.Json.decode!(json)
      assert decoded["id"] == to_string(id)
      assert is_binary(decoded["module"])
    end
  end

  defp ok_json!({:ok, json}), do: json

  defp ok_json!(other) do
    flunk("expected {:ok, json}, got #{inspect(other)}")
  end
end
