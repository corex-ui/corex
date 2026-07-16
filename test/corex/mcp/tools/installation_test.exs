defmodule Corex.MCP.Tools.InstallationTest do
  use ExUnit.Case, async: true

  alias Corex.MCP.Tools.Installation

  test "installation_guide all returns both sections" do
    json =
      case Installation.installation_guide(%{}) do
        {:ok, j} -> j
        other -> flunk("expected {:ok, json}, got #{inspect(other)}")
      end

    decoded = Corex.Json.decode!(json)
    assert decoded["scenario"] == "all"
    assert is_map(decoded["new_project"])
    assert is_map(decoded["existing_project"])
    assert decoded["new_project"]["commands"]
    assert is_list(decoded["existing_project"]["minimal_steps"])
    assert length(decoded["existing_project"]["minimal_steps"]) >= 7

    assert decoded["existing_project"]["mcp_mount_optional_dev"]["routes"]["mcp_rpc"] =~
             "corex/mcp"
  end

  test "installation_guide new_project is scoped" do
    json =
      case Installation.installation_guide(%{"scenario" => "new_project"}) do
        {:ok, j} -> j
        other -> flunk("expected {:ok, json}, got #{inspect(other)}")
      end

    decoded = Corex.Json.decode!(json)
    assert decoded["scenario"] == "new_project"
    assert decoded["intent"]
    refute Map.has_key?(decoded, "existing_project")
  end

  test "installation_guide existing_project is scoped" do
    json =
      case Installation.installation_guide(%{"scenario" => "existing_project"}) do
        {:ok, j} -> j
        other -> flunk("expected {:ok, json}, got #{inspect(other)}")
      end

    decoded = Corex.Json.decode!(json)
    assert decoded["scenario"] == "existing_project"
    assert decoded["intent"]
    refute Map.has_key?(decoded, "new_project")
    assert decoded["corex_version_constraint"] =~ "~>"

    titles =
      decoded["minimal_steps"]
      |> Enum.map(& &1["title"])

    assert Enum.any?(titles, &(&1 =~ "dependency"))
    assert Enum.any?(titles, &(&1 =~ "MCP"))
  end

  test "installation_guide rejects invalid scenario" do
    assert {:error, :invalid_arguments} =
             Installation.installation_guide(%{"scenario" => "bogus"})
  end

  test "installation_guide rejects unknown keys" do
    assert {:error, :invalid_arguments} =
             Installation.installation_guide(%{"scenario" => "all", "extra" => "x"})
  end

  test "tools/0 includes installation_guide" do
    names = for t <- Installation.tools(), do: t.name
    assert "installation_guide" in names
  end
end
