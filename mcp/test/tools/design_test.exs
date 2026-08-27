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
    assert is_map(decoded["accessibility"])
    assert decoded["reference_urls"]["accessibility"] =~ "accessibility.html"
  end

  test "design_guide accessibility topic documents preference CSS and mix release load" do
    json = ok_json!(Design.design_guide(%{"topic" => "accessibility"}))
    decoded = Corex.MCP.Json.decode!(json)
    assert decoded["topic"] == "accessibility"
    assert decoded["flags"] =~ "--a11y"
    assert decoded["config"] =~ "accessibility: true"
    assert decoded["tip"] =~ "mix corex.design.build"
    assert decoded["tip"] =~ "corex_design: :load"
  end

  test "design_guide rejects unknown topic and lists the allowed values" do
    assert {:error,
            %{code: -32_602, data: %{tool: "design_guide", param: "topic", allowed: allowed}}} =
             Design.design_guide(%{"topic" => "nope"})

    assert "dark_mode" in allowed
  end

  test "list_modifiers serves the real max_height and width ladders" do
    json = ok_json!(Design.list_modifiers(%{"axis" => "max_height"}))
    decoded = Corex.MCP.Json.decode!(json)

    assert decoded["max_height"]["steps"] == Corex.Design.Scales.steps(:max_height)
    assert "ui-max-height-9xl" in decoded["max_height"]["classes"]

    widths = ok_json!(Design.list_modifiers(%{"axis" => "width"})) |> Corex.MCP.Json.decode!()
    assert widths["width"]["steps"] == Corex.Design.Scales.steps(:width)
    assert "ui-width-auto" in widths["width"]["classes"]
  end

  test "list_modifiers rejects an unknown axis" do
    assert {:error,
            %{code: -32_602, data: %{tool: "list_modifiers", param: "axis", allowed: allowed}}} =
             Design.list_modifiers(%{"axis" => "colour"})

    assert "radius" in allowed
  end

  describe "component ids whose css host has a different name" do
    test "get_component_style resolves them through the design registry" do
      for {id, css_id} <- [
            {"action", "button"},
            {"navigate", "link"},
            {"heroicon", "icon"},
            {"file_upload_live", "file-upload"}
          ] do
        decoded =
          %{"id" => id}
          |> Design.get_component_style()
          |> ok_json!()
          |> Corex.MCP.Json.decode!()

        assert decoded["css_id"] == css_id, "expected #{id} to resolve to #{css_id}"
        assert decoded["root_class"] == css_id
      end
    end

    test "design_enrichment carries the same css_id" do
      assert %{design_available: true, css_id: "link", root_class: "link"} =
               Design.design_enrichment("navigate")
    end
  end

  test "design_enrichment says so when a component renders no styled host" do
    assert %{design_available: true, css_id: nil, note: note} =
             Design.design_enrichment("hidden_input")

    assert note =~ "no styled host"
  end

  test "get_component_style rejects an unknown id with a discovery hint" do
    assert {:error, message} = Design.get_component_style(%{"id" => "not_a_component"})
    assert message =~ "list_components"
  end

  defp ok_json!({:ok, json}), do: json
  defp ok_json!(other), do: flunk("expected {:ok, json}, got #{inspect(other)}")
end
