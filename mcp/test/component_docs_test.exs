defmodule Corex.MCP.ComponentDocsTest do
  use ExUnit.Case, async: true

  alias Corex.MCP.ComponentDocs

  test "enrich/2 adds markdown docs and source metadata for component modules" do
    spec = %{id: :heroicon, module: "Corex.Heroicon", function_components: []}

    enriched = ComponentDocs.enrich(spec, Corex.Heroicon)

    assert enriched.docs =~ "# Corex.Heroicon"
    assert enriched.docs =~ "Heroicon"
    assert enriched.docs_note == nil
    assert is_binary(enriched.source_path)
    assert enriched.source_path =~ "heroicon.ex"
    refute String.starts_with?(enriched.source_path, "/")
    assert is_integer(enriched.source_line)
  end

  test "enrich/2 reports hidden moduledoc" do
    spec = %{id: :anatomy, module: "Corex.RadioGroup.Anatomy", function_components: []}

    enriched = ComponentDocs.enrich(spec, Corex.RadioGroup.Anatomy)

    assert enriched.docs == nil
    assert enriched.docs_note =~ "hidden"
  end

  test "enrich/2 handles modules without docs bundle" do
    spec = %{id: :atom, module: "Atom", function_components: []}
    enriched = ComponentDocs.enrich(spec, :atom)

    assert enriched.docs == nil
    assert enriched.docs_note =~ "Code.fetch_docs"
    assert enriched.source_path == nil
    assert enriched.source_line == nil
  end
end
