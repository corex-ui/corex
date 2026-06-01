defmodule Corex.ApiModulesContractTest do
  use ExUnit.Case, async: true

  @components_root Path.expand("../../lib/components", __DIR__)

  @extracted_api_modules [
    {Corex.Checkbox, Corex.Checkbox.Api, "checkbox.ex", "checkbox"},
    {Corex.TreeView, Corex.TreeView.Api, "tree_view.ex", "tree-view"}
  ]

  test "imperative API docs use api_doc macros" do
    for path <- component_ex_files() do
      content = File.read!(path)

      refute Regex.match?(~r/@doc type: :api\s*\n\s*@doc/, content),
             "#{path} must use api_doc/1 instead of raw @doc type: :api"
    end
  end

  test "modules with imperative API import Corex.Api.Doc or use Corex.Api.Imports" do
    for path <- component_ex_files() do
      content = File.read!(path)

      if content =~ "api_doc(" or (content =~ "defdelegate" and content =~ ", to: Api") do
        assert content =~ "import Corex.Api.Doc" or content =~ "use Corex.Api.Imports",
               "#{path} must import Corex.Api.Doc or use Corex.Api.Imports"
      end
    end
  end

  test "extracted Api modules delegate from component module" do
    for {_mod, _api, file, slug} <- @extracted_api_modules do
      path = Path.join(@components_root, file)
      content = File.read!(path)

      assert content =~ "use Corex.Api.Imports"
      assert content =~ "defdelegate"

      refute content =~ ~s|JS.dispatch("corex:#{slug}:set-|,
             "#{path} must delegate set_* API to Api module"
    end
  end

  defp component_ex_files do
    @components_root
    |> Path.join("**/*.ex")
    |> Path.wildcard()
    |> Enum.reject(fn path ->
      String.ends_with?(path, "/connect.ex") or
        String.ends_with?(path, "/api.ex") or
        String.contains?(path, "/anatomy/")
    end)
  end
end
