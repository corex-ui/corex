defmodule Corex.MCP.Tools.DegradedTest do
  use ExUnit.Case, async: true

  alias Corex.MCP.CorexAvailable
  alias Corex.MCP.DesignAvailable
  alias Corex.MCP.ToolError
  alias Corex.MCP.Tools.Design

  describe "CorexAvailable" do
    test "corex_available? returns true when Corex is loaded" do
      assert CorexAvailable.corex_available?()
    end

    test "ensure_corex returns :ok when Corex is loaded" do
      assert :ok = CorexAvailable.ensure_corex()
    end

    test "call/2 delegates to the Corex module" do
      ids = CorexAvailable.call(:component_ids)
      assert is_list(ids)
      assert :accordion in ids
    end
  end

  describe "DesignAvailable" do
    test "design_available? returns true when design modules are loaded" do
      assert DesignAvailable.design_available?()
    end

    test "ensure_design returns :ok when design is loaded" do
      assert :ok = DesignAvailable.ensure_design()
    end

    test "component_ids returns a list of css ids" do
      ids = DesignAvailable.component_ids()
      assert is_list(ids)
      assert "accordion" in ids
    end

    test "fetch_css_id resolves snake_case to kebab-case" do
      assert DesignAvailable.fetch_css_id("date_picker") == {:ok, "date-picker"}
    end

    test "fetch_css_id returns :error for unknown id" do
      assert :error = DesignAvailable.fetch_css_id("nonexistent_component_xyz")
    end
  end

  describe "ToolError constructors" do
    test "invalid_arguments returns protocol error tuple" do
      assert {:error, %{code: -32_602, message: msg, data: data}} =
               ToolError.invalid_arguments("my_tool", "required id: string")

      assert msg =~ "my_tool"
      assert data.tool == "my_tool"
      assert data.expected =~ "required id"
    end

    test "unknown_value returns protocol error tuple with allowed list" do
      assert {:error, %{code: -32_602, message: msg, data: data}} =
               ToolError.unknown_value("my_tool", "axis", ["a", "b"])

      assert msg =~ "axis"
      assert data.allowed == ["a", "b"]
    end

    test "unknown_id returns tool error with discovery hint" do
      assert {:error, msg} = ToolError.unknown_id("get_component", "xyz", "list_components")
      assert msg =~ "xyz"
      assert msg =~ "list_components"
    end

    test "unavailable returns tool error with remedy" do
      assert {:error, msg} = ToolError.unavailable("list_themes", "Install corex_design.")
      assert msg =~ "list_themes"
      assert msg =~ "Install corex_design."
    end
  end

  describe "Design tool input validation" do
    test "list_modifiers rejects extra arguments" do
      assert {:error, %{code: -32_602}} =
               Design.list_modifiers(%{"axis" => "size", "extra" => true})
    end

    test "list_modifiers accepts nil arguments" do
      assert match?({:ok, _json}, Design.list_modifiers(nil))
    end

    test "get_component_style rejects missing id" do
      assert {:error, %{code: -32_602}} = Design.get_component_style(%{})
    end

    test "get_component_style rejects non-string id" do
      assert {:error, %{code: -32_602}} = Design.get_component_style(%{"id" => 42})
    end

    test "get_component_style rejects id over 64 bytes" do
      long = String.duplicate("x", 65)
      assert {:error, %{code: -32_602}} = Design.get_component_style(%{"id" => long})
    end

    test "get_component_style rejects extra keys" do
      assert {:error, %{code: -32_602}} =
               Design.get_component_style(%{"id" => "accordion", "extra" => 1})
    end

    test "list_themes rejects non-empty arguments" do
      assert {:error, %{code: -32_602}} = Design.list_themes(%{"extra" => 1})
    end

    test "design_guide rejects unknown topic" do
      assert {:error, %{code: -32_602, data: %{param: "topic"}}} =
               Design.design_guide(%{"topic" => "invalid_topic"})
    end

    test "design_guide accepts nil arguments" do
      assert match?({:ok, _json}, Design.design_guide(nil))
    end

    test "design_guide accepts specific topic" do
      for topic <- ~w(setup modifiers theming dark_mode accessibility) do
        case Design.design_guide(%{"topic" => topic}) do
          {:ok, json} ->
            decoded = Corex.MCP.Json.decode!(json)
            assert decoded["topic"] == topic

          other ->
            flunk("expected {:ok, json}, got: #{inspect(other)}")
        end
      end
    end
  end

  describe "Design.design_enrichment/1 degraded" do
    test "returns note for component with no styled host" do
      result = Design.design_enrichment("hidden_input")
      assert result.design_available == true
      assert result.css_id == nil
      assert result.note =~ "no styled host"
    end
  end
end
