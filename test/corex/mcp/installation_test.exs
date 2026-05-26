defmodule Corex.MCP.InstallationTest do
  use ExUnit.Case, async: true

  alias Corex.MCP.Tools.Installation

  test "installation_guide existing_project uses application version constraint" do
    json =
      case Installation.installation_guide(%{"scenario" => "existing_project"}) do
        {:ok, json} -> json
        other -> flunk("expected {:ok, _}, got #{inspect(other)}")
      end

    payload = Jason.decode!(json)

    expected =
      case Application.spec(:corex, :vsn) do
        v when is_list(v) -> List.to_string(v)
        v when is_binary(v) -> v
      end

    assert payload["corex_version_constraint"] == "~> #{expected}"
  end
end
