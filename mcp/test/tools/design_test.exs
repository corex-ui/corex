defmodule Corex.MCP.Tools.DesignTest do
  use ExUnit.Case, async: true

  alias Corex.MCP.Tools.Design

  test "tools/0 registers design tools" do
    names = for t <- Design.tools(), do: t.name
    assert "list_modifiers" in names
    assert "get_component_style" in names
    assert "list_themes" in names
    assert "design_guide" in names
  end

  test "list_modifiers returns vocabulary" do
    json = ok_json!(Design.list_modifiers(%{}))
    decoded = Corex.MCP.Json.decode!(json)
    assert decoded["pattern"] =~ "ui-"
    assert is_list(decoded["semantic"]["roles"])
    assert "accent" in decoded["semantic"]["roles"]
    assert is_list(decoded["anti_patterns"])
  end

  test "list_modifiers filters by axis" do
    json = ok_json!(Design.list_modifiers(%{"axis" => "size"}))
    decoded = Corex.MCP.Json.decode!(json)
    assert decoded["axis"] == "size"
    assert is_list(decoded["size"]["steps"])
    refute Map.has_key?(decoded, "semantic")
  end

  test "get_component_style returns layout for accordion" do
    json = ok_json!(Design.get_component_style(%{"id" => "accordion"}))
    decoded = Corex.MCP.Json.decode!(json)
    assert decoded["css_id"] == "accordion"
    assert decoded["root_class"] == "accordion"
    assert is_list(decoded["examples"])
    assert is_map(decoded["layout"])
  end

  test "get_component_style accepts elixir snake id" do
    json = ok_json!(Design.get_component_style(%{"id" => "date_picker"}))
    decoded = Corex.MCP.Json.decode!(json)
    assert decoded["css_id"] == "date-picker"
  end

  test "list_themes returns presets" do
    json = ok_json!(Design.list_themes(%{}))
    decoded = Corex.MCP.Json.decode!(json)
    assert "neo" in decoded["presets"]
    assert "light" in decoded["modes"]
  end

  test "design_guide returns all topics by default" do
    json = ok_json!(Design.design_guide(%{}))
    decoded = Corex.MCP.Json.decode!(json)
    assert decoded["topic"] == "all"
    assert is_map(decoded["setup"])
    assert is_map(decoded["modifiers"])
  end

  test "design_guide rejects unknown topic" do
    assert {:error, :invalid_arguments} = Design.design_guide(%{"topic" => "nope"})
  end

  defp ok_json!({:ok, json}), do: json
  defp ok_json!(other), do: flunk("expected {:ok, json}, got #{inspect(other)}")
end
