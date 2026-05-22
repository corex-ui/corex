defmodule E2eWeb.ComponentSourceLinksTest do
  use ExUnit.Case, async: true

  alias E2eWeb.ComponentSourceLinks

  test "links_for_path/1 for accordion" do
    links = ComponentSourceLinks.links_for_path("/accordion/anatomy")
    labels = Enum.map(links, & &1.label)

    assert "Hex doc" in labels
    assert "Phoenix" in labels
    assert "Design" in labels
    assert "TypeScript" in labels

    phoenix = Enum.find(links, &(&1.label == "Phoenix"))
    assert phoenix.to =~ "lib/components/accordion.ex"
  end

  test "links_for_path/1 for layout-heading" do
    links = ComponentSourceLinks.links_for_path("/layout-heading/anatomy")
    phoenix = Enum.find(links, &(&1.label == "Phoenix"))

    assert phoenix.to =~ "layout/heading.ex"

    hex = Enum.find(links, &(&1.label == "Hex doc"))
    assert hex.to =~ "Corex.Layout.Heading"
  end

  test "links_for_path/1 for action omits TypeScript" do
    links = ComponentSourceLinks.links_for_path("/action/anatomy")
    labels = Enum.map(links, & &1.label)

    refute "TypeScript" in labels
    assert "Phoenix" in labels
  end

  test "links_for_path/1 returns nil for showcases" do
    assert ComponentSourceLinks.links_for_path("/showcases") == nil
  end
end
