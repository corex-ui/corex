defmodule Corex.MCP.Tools.InstallationTest do
  use ExUnit.Case, async: true

  alias Corex.MCP.Tools.Installation

  test "installation_guide all returns both sections" do
    assert {:ok, json} = Installation.installation_guide(%{})
    decoded = Corex.Json.decode!(json)
    assert decoded["scenario"] == "all"
    assert is_map(decoded["new_project"])
    assert is_map(decoded["existing_project"])
    assert decoded["new_project"]["commands"]
    assert decoded["existing_project"]["commands"]
  end

  test "installation_guide new_project is scoped" do
    assert {:ok, json} = Installation.installation_guide(%{"scenario" => "new_project"})
    decoded = Corex.Json.decode!(json)
    assert decoded["scenario"] == "new_project"
    assert decoded["intent"]
    refute Map.has_key?(decoded, "existing_project")
  end

  test "installation_guide existing_project is scoped" do
    assert {:ok, json} = Installation.installation_guide(%{"scenario" => "existing_project"})
    decoded = Corex.Json.decode!(json)
    assert decoded["scenario"] == "existing_project"
    assert decoded["intent"]
    refute Map.has_key?(decoded, "new_project")
  end

  test "tools/0 includes corex_installation" do
    names = for t <- Installation.tools(), do: t.name
    assert "corex_installation" in names
  end
end
