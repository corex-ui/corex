defmodule Corex.MCP.Tools.ComponentsTest do
  use ExUnit.Case, async: true

  alias Corex.MCP.Tools.Components

  test "tools/0 registers list and get" do
    names = for t <- Components.tools(), do: t.name
    assert "list_components" in names
    assert "get_component" in names
  end

  test "list_components returns encoded ids and form_capable" do
    json =
      case Components.list_components(%{}) do
        {:ok, j} -> j
        other -> flunk("expected {:ok, json}, got #{inspect(other)}")
      end

    decoded = Corex.MCP.Json.decode!(json)
    assert is_list(decoded["components"])
    assert "accordion" in decoded["components"]
    assert decoded["components"] == Enum.map(Corex.component_ids(), &to_string/1)
    assert is_list(decoded["form_capable"])
    assert Enum.any?(decoded["form_capable"], &(&1["id"] == "select"))
  end

  test "list_components rejects non-empty arguments" do
    assert {:error, %{code: -32_602, data: %{tool: "list_components", expected: expected}}} =
             Components.list_components(%{"extra" => "x"})

    assert expected =~ "no arguments"
  end

  test "get_component rejects unknown keys" do
    assert {:error, %{code: -32_602, data: %{tool: "get_component"}}} =
             Components.get_component(%{"id" => "accordion", "extra" => "x"})
  end

  test "get_component rejects id longer than 64 bytes" do
    long_id = String.duplicate("a", 65)

    assert {:error, %{code: -32_602, data: %{tool: "get_component", expected: expected}}} =
             Components.get_component(%{"id" => long_id})

    assert expected =~ "64 bytes"
  end

  test "get_component returns structured metadata without docs by default" do
    json =
      case Components.get_component(%{"id" => "accordion"}) do
        {:ok, j} -> j
        other -> flunk("expected {:ok, json}, got #{inspect(other)}")
      end

    decoded = Corex.MCP.Json.decode!(json)
    assert decoded["id"] == "accordion"
    assert decoded["module"] =~ "Accordion"
    assert decoded["hook"] == "Accordion"
    assert is_map(decoded["events"])
    assert is_list(decoded["events"]["server"])
    assert is_list(decoded["api"])
    assert decoded["data_builders"] == ["Corex.Content.new/1"]
    assert is_map(decoded["form"])
    assert decoded["function_components"] != []
    assert is_list(decoded["attrs"])
    assert is_list(decoded["slots"])
    assert decoded["attrs"] != []
    assert decoded["slots"] != []
    assert decoded["design_available"] == true
    assert decoded["css_id"] == "accordion"
    assert is_map(decoded["modifiers"])
    assert is_nil(decoded["docs"])
    assert decoded["docs_note"] =~ "include_docs"
    assert is_binary(decoded["source_path"])
    assert decoded["source_path"] =~ "accordion.ex"
    refute String.starts_with?(decoded["source_path"], "/")
    assert is_integer(decoded["source_line"])
  end

  test "get_component include_docs true returns markdown" do
    json = ok_json!(Components.get_component(%{"id" => "accordion", "include_docs" => true}))
    decoded = Corex.MCP.Json.decode!(json)
    assert is_binary(decoded["docs"])
    assert String.starts_with?(decoded["docs"], "# ")
  end

  test "get_component accepts kebab-case ids" do
    json = ok_json!(Components.get_component(%{"id" => "date-picker"}))
    decoded = Corex.MCP.Json.decode!(json)
    assert decoded["id"] == "date_picker"
    assert decoded["hook"] == "DatePicker"
  end

  test "get_component rejects unknown id with guidance" do
    assert {:error, msg} = Components.get_component(%{"id" => "not_a_real_component_zzz"})
    assert msg =~ "Unknown component id"
    assert msg =~ "list_components"
  end

  test "get_component rejects invalid arguments" do
    assert {:error, %{code: -32_602, data: %{tool: "get_component"}}} =
             Components.get_component(%{})

    assert {:error, %{code: -32_602, data: %{tool: "get_component"}}} =
             Components.get_component(%{"id" => 1})
  end

  test "get_component returns spec for representative registry ids" do
    ids = [:accordion, :toast, :tree_view, :menu, :date_picker, :select, :dialog]

    for id <- ids do
      json = ok_json!(Components.get_component(%{"id" => to_string(id)}))
      decoded = Corex.MCP.Json.decode!(json)
      assert decoded["id"] == to_string(id)
      assert is_binary(decoded["module"])
      assert is_binary(decoded["hook"])
    end
  end

  defp ok_json!({:ok, json}), do: json

  defp ok_json!(other) do
    flunk("expected {:ok, json}, got #{inspect(other)}")
  end
end
